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
  List<String> itensMenu = [
    "Configurações",
    "Deslogar"
  ];
  String? _emailUsuario = "";

  
  _recuperarDadosUsuario() {

    FirebaseAuth auth = FirebaseAuth.instance;

    var usuarioAtual = auth.currentUser;
    if(usuarioAtual != null) {
      _emailUsuario = usuarioAtual.email;
    }

  }

  Future _verificarUsuarioLogado() async {

    FirebaseAuth auth = FirebaseAuth.instance;

    auth.authStateChanges()
      .listen((User? user) async {
        if(user == null) {
          if (mounted) {
          await Navigator.pushReplacementNamed(context, "/login");
          }
        }
      });

  }
  

  @override
  void initState() {
    super.initState();

    _verificarUsuarioLogado();
    _recuperarDadosUsuario();
    _tabController = TabController(
      length: 2, 
      vsync: this
    );
  }

  _escolhaMenuItem(String itmeEscolhido) {

    switch(itmeEscolhido) {
      case "Configurações":
        Navigator.pushNamed(context, "/configuracoes");
        break;
      case "Deslogar":
        _deslogarUsuario();
        break;

    }

  }

  _deslogarUsuario() async {
    
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();

    if(context.mounted) {
      
      Navigator.pushReplacementNamed(context, "/login");

    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WhatsApp"),
        actions: [
          PopupMenuButton<String>(
            onSelected: _escolhaMenuItem,
            itemBuilder: (context) {
              return itensMenu.map((String item) {
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          )
        ],
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