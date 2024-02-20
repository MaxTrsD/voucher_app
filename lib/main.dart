import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:voucher_app/firebase_options.dart';
import 'package:voucher_app/telas/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
      options: DefaultFirebaseOptions
          .currentPlatform); // Inicialize o Firebase antes de executar o app
  runApp(MyApp());
}

final firebaseApp = Firebase.app();
FirebaseDatabase database = FirebaseDatabase.instance;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowMaterialGrid: false,
      home: TelaHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}
