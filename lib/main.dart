import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

var db = FirebaseFirestore.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        //
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String status = 'loading...';
  String loadingTime = DateTime.now().toString().substring(0, 19);

  loadData() {
    db.collection('new_users').get().then((event) {
      setState(() {
        loadingTime = DateTime.now().toString().substring(0, 19);
        if (event.docs.isNotEmpty) {
          status = event.docs.first.data()['name'];
        } else {
          status = 'no data';
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore'),
      ),
      body: Center(
        child: Text('$status\n\n$loadingTime', textAlign: TextAlign.center,),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: loadData,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
