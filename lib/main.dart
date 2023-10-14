import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:whatsapp_clone/login_page.dart';
import 'firebase_options.dart';

void main() async {

  //Inicializar o Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // - Instância do Firestore
  //FirebaseFirestore db = FirebaseFirestore.instance;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Login(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xff075E54),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: const MaterialColor(
            0xff075E54,
            {
              50: Color(0xff06554c),
              100: Color(0xff064b43),
              200: Color(0xff05423b),
              300: Color(0xff043832),
              400: Color(0xff042f2a),
              500: Color(0xff032622),
              600: Color(0xff021c19),
              700: Color(0xff011311),
              800: Color(0xff010908),
              900: Color(0xff000000),
            },
          )
        ).copyWith(
          secondary: const Color(0xff25D366)
        )
      ),
    );
  }
}