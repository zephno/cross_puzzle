import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

// All level IDs to pick from randomly
const _allLevelIds = [
  'easy_1', 'easy_2', 'easy_3', 'easy_4',
  'medium_1', 'medium_2', 'medium_3', 'medium_4',
  'hard_1', 'hard_2', 'hard_3', 'hard_4',
];

class MatchmakingService {
  static final _db = FirebaseFirestore.instance;

  // ── Get current username from SharedPreferences ────────────────
  static Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? 'Guest';
  }

  // ── Join the waiting pool and wait for a match ─────────────────
  // Returns the roomId once matched, or throws on timeout/error.
  static Future<String> findMatch({
    required String username,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final waitingRef = _db.collection('waitingPool').doc(username);
    final Completer<String> completer = Completer();
    StreamSubscription? sub;
    Timer? timeoutTimer;

    // Write ourselves into the waiting pool
    await waitingRef.set({
      'username': username,
      'joinedAt': FieldValue.serverTimestamp(),
      'roomId': null,
    });

    // Watch our own waiting doc — when roomId gets filled in, we're matched
    sub = waitingRef.snapshots().listen((snap) async {
      if (!snap.exists) return;
      final roomId = snap.data()?['roomId'] as String?;
      if (roomId != null && !completer.isCompleted) {
        sub?.cancel();
        timeoutTimer?.cancel();
        completer.complete(roomId);
      }
    });

    // Also try to match with someone already waiting
    _tryMatch(username);

    timeoutTimer = Timer(timeout, () async {
      if (!completer.isCompleted) {
        sub?.cancel();
        await waitingRef.delete();
        completer.completeError('No opponent found. Please try again.');
      }
    });

    return completer.future;
  }
  
  static Future<void> _tryMatch(String myUsername) async {
    final snap = await _db
        .collection('waitingPool')
        .where('roomId', isNull: true)
        .orderBy('joinedAt')
        .limit(5)
        .get();

    // Find a doc that isn't ours
    final others = snap.docs.where((d) => d.id != myUsername).toList();
    if (others.isEmpty) return;

    final opponent = others.first;
    final opponentUsername = opponent.id;

    // Pick a random puzzle sequence for 3 rounds
    final allLevels = List<String>.from(_allLevelIds)..shuffle();
    final roundLevels = allLevels.take(3).toList();

    // Create the room
    final roomRef = _db.collection('rooms').doc();
    final roomId = roomRef.id;

    await _db.runTransaction((tx) async {
      // Re-read opponent doc inside transaction to avoid double-matching
      final opponentSnap = await tx.get(opponent.reference);
      if (!opponentSnap.exists) return;
      if (opponentSnap.data()?['roomId'] != null) return;

      tx.set(roomRef, {
        'player1': myUsername,
        'player2': opponentUsername,
        'status': 'playing',
        'currentRound': 1,
        'roundLevels': roundLevels,
        'roundWinners': ['', '', ''],
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Tell both players about the room
      tx.update(
        _db.collection('waitingPool').doc(myUsername),
        {'roomId': roomId},
      );
      tx.update(opponent.reference, {'roomId': roomId});
    });
  }

  // ── Leave the waiting pool (called on cancel) ─────────────────
  static Future<void> cancelSearch(String username) async {
    await _db.collection('waitingPool').doc(username).delete();
  }

  // ── Save a player's letter entries for a round ────────────────
  static Future<void> saveEntries({
    required String roomId,
    required String username,
    required int round,
    required Map<String, String> entries,
  }) async {
    final encoded = entries.entries
        .map((e) => '${e.key}=${e.value}')
        .join(';');
    await _db
        .collection('rooms')
        .doc(roomId)
        .collection('players')
        .doc(username)
        .set({
      'round_${round}_entries': encoded,
    }, SetOptions(merge: true));
  }

  // ── Mark a player as having completed a round ─────────────────
  static Future<void> markRoundComplete({
    required String roomId,
    required String username,
    required int round,
  }) async {
    final roomRef = _db.collection('rooms').doc(roomId);

    await _db.runTransaction((tx) async {
      final snap = await tx.get(roomRef);
      if (!snap.exists) return;

      final winners = List<String>.from(snap.data()?['roundWinners'] ?? ['', '', '']);
      // Only set winner if not already set for this round
      if (winners[round - 1].isEmpty) {
        winners[round - 1] = username;
        tx.update(roomRef, {'roundWinners': winners});
      }
    });
  }

  // ── Advance to the next round ─────────────────────────────────
  static Future<void> advanceRound({
    required String roomId,
    required int nextRound,
  }) async {
    await _db.collection('rooms').doc(roomId).update({
      'currentRound': nextRound,
    });
  }

  // ── Mark the entire match as finished ─────────────────────────
  static Future<void> finishMatch(String roomId) async {
    await _db.collection('rooms').doc(roomId).update({
      'status': 'finished',
    });
  }

  // ── Stream the room doc ────────────────────────────────────────
  static Stream<DocumentSnapshot> roomStream(String roomId) {
    return _db.collection('rooms').doc(roomId).snapshots();
  }

  // ── Increment multiplayer count in SharedPreferences ──────────
  static Future<void> incrementMultiplayerCount() async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt('stat_multiplayer_count') ?? 0;
    await prefs.setInt('stat_multiplayer_count', current + 1);
  }
}