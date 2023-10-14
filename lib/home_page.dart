import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String? _emailUsuario = "";

  _recuperarDadosUsuario() {

    FirebaseAuth auth = FirebaseAuth.instance;

    var usuarioAtual = auth.currentUser;
    if(usuarioAtual != null) {
      _emailUsuario = usuarioAtual.email;
    }

  }

  @override
  void initState() {
    _recuperarDadosUsuario();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WhatsApp"),
        automaticallyImplyLeading: false
      ),
      body: Text(_emailUsuario!),
    );
  }
}