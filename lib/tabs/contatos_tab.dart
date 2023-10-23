import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/model/user.dart';

class TabaContatos extends StatefulWidget {
  const TabaContatos({super.key});

  @override
  State<TabaContatos> createState() => _TabaContatosState();
}

class _TabaContatosState extends State<TabaContatos> {

  String? _idUsuarioLogado;
  String? _emailUsuarioLogado;

  Future<List<Usuario>> _recuperarContatos() async {
    
    FirebaseFirestore db = FirebaseFirestore.instance;

    QuerySnapshot querySnapshot = await db.collection("usuarios")
      .get();

    List<Usuario> listaUsuarios = [];

    for(DocumentSnapshot item in querySnapshot.docs) {

      dynamic dados = item.data();
      if(dados["email"] == _emailUsuarioLogado) continue;

      Usuario usuario = Usuario();
      usuario.email = dados["email"];
      usuario.nome = dados["nome"];
      usuario.urlImagem = dados["urlImagem"];

      listaUsuarios.add(usuario);

    }

    return listaUsuarios;

  }

  _recuperarDadosUsuario() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    var usuarioLogado = auth.currentUser;
    _emailUsuarioLogado = usuarioLogado!.email;
    _idUsuarioLogado = usuarioLogado.uid;
    

  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Usuario>>(
      future: _recuperarContatos(),
      builder: (context, snapshot) {
        switch(snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const Center(
              child: Column(
                children: [
                  Text("Carregando contatos ..."),
                  CircularProgressIndicator()
                ],
              ),
            );
            
          case ConnectionState.active:
          case ConnectionState.done:
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) {

                List<Usuario> listaItens = snapshot.data!;
                Usuario usuario = listaItens[index];

                return ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  leading: CircleAvatar(
                    maxRadius: 30,
                    backgroundColor: Colors.grey,
                    backgroundImage: 
                    usuario.urlImagem != null
                      ? NetworkImage(usuario.urlImagem!)
                      : null
                  ),
                  title: Text(
                    usuario.nome!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                  ),
                ),
              );
            },
          );
        }
      }
    );
  }
}