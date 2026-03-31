import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'choose_mode_page.dart';
import 'profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
  
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Cross Puzzle'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {  
    return Scaffold(
      appBar: AppBar(        
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SafeArea(
  child: Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 400, // Limits width like a mobile screen
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children:[
              Image.asset(
              'images/crossword_logo-removebg-preview.png',
              width: 150,
              height: 150,
              ),
              const Text(
                'Cross Puzzle',
                style: TextStyle(
                  fontSize: 32,
                  fontFamily: 'Atma',
                  fontWeight: FontWeight.bold
                )
              ),
              const SizedBox(height:40),
              ],
            ),
            
            FilledButton.tonal(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChooseModePage(),
                  ),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.play_arrow),
                  SizedBox(width: 8),
                  Text('Play'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            FilledButton.tonal(
              onPressed: () {

              },
               style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 47.5),
                    ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.event),
                  SizedBox(width: 8),
                  Text('Daily Puzzle'),
                ],
              ),  
            ),

            const SizedBox(height: 20),

            FilledButton.tonal(
              onPressed: () {
                
                Navigator.push(
              context,
              MaterialPageRoute(
              builder: (context) => const ProfilePage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 47.5),
                    ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                Icon(Icons.person),
                  SizedBox(width: 8),
                  Text('Profile'),
                ],
              ),  
            ),
            const SizedBox(height: 20),


            FilledButton.tonal(
              onPressed: () {
                
                SystemNavigator.pop(); // Exits the app
              },
              style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 47.5),
                    ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.exit_to_app),
                  SizedBox(width: 8),
                  Text('Exit'),
                ],
              ),
            ),
          ],
        ),
       ),
      ),
     ),
    ),
    );
  }
}
