import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/tabs/contatos_tab.dart';
import 'package:whatsapp_clone/tabs/conversas_tab.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {

  late TabController _tabController;
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
    super.initState();

    _recuperarDadosUsuario();

  _tabController = TabController(
    length: 2, 
    vsync: this
  );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WhatsApp"),
        automaticallyImplyLeading: false,
         bottom: TabBar(
          indicatorWeight: 4,
          labelStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: "Conversas"),
            Tab(text: "Contatos")
          ]
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          TabConversas(),
          TabaContatos()
        ],
      ),
    );
  }
}