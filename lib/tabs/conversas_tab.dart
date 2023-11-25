import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/model/conversa.dart';

class TabConversas extends StatefulWidget {
  const TabConversas({super.key});

  @override
  State<TabConversas> createState() => _TabConversasState();
}

class _TabConversasState extends State<TabConversas> {

  final List<Conversa> _listaConversas = [];
  final _controller = StreamController<QuerySnapshot>.broadcast();
  FirebaseFirestore db = FirebaseFirestore.instance;
  late String _idUsuarioLogado;

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();

    Conversa conversa = Conversa();
    conversa.nome = "Ana Clara";
    conversa.mensagem = "Olá, tudo bem?";
    conversa.caminhoFoto = "https://firebasestorage.googleapis.com/v0/b/whatsapp-8864e.appspot.com/o/perfil%2Fperfil1.jpg?alt=media&token=70ba76c0-7c7d-44e8-81d2-21a960ef9a6e";

    _listaConversas.add(conversa);

  }

  Stream<QuerySnapshot>? _adicionarListenerConversas() {

    final stream = db.collection("conversas")
      .doc(_idUsuarioLogado)
      .collection("ultima_conversa")
      .snapshots();

      stream.listen((dados) {
        _controller.add(dados);
      });

  }

  _recuperarDadosUsuario() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    var usuarioLogado = auth.currentUser;
    _idUsuarioLogado = usuarioLogado!.uid;

    _adicionarListenerConversas();


  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
      stream: _controller.stream,
      builder: (context, snapshot) {
        switch(snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const Center(
              child: Column(
                children: [
                  Text("Carregando conversas ..."),
                  CircularProgressIndicator()
                ],
              ),
            );
          case ConnectionState.active:
          case ConnectionState.done:
            if(snapshot.hasError) {
              return const Text("Erro ao carregar dados");
            } else {

              QuerySnapshot? querySnapshot = snapshot.data;

              if(querySnapshot!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    "Você não tem nenhuma mensagem ainda ...",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                );
              }

              return ListView.builder(
                itemCount: _listaConversas.length,
                itemBuilder: (context, index) {

                  List<DocumentSnapshot> conversas = querySnapshot.docs.toList();
                  DocumentSnapshot item = conversas[index];

                  String? urlImagem = item["caminhoFoto"];
                  String? tipo = item["tipoMensagem"];
                  String? mensagem= item["mensagem"];
                  String? nome = item["nome"];

                  return ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    leading: CircleAvatar(
                      maxRadius: 30,
                      backgroundColor: Colors.grey,
                      backgroundImage: urlImagem != null
                        ? NetworkImage(urlImagem)
                        : null,
                    ),
                    title: Text(
                      nome!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      ),
                    ),
                    subtitle: Text(
                      tipo == "texto"
                        ? mensagem!
                        : "Imagem...",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey
                      ),
                    ),
                  );

                },
              );
            }
        }
      },
    );
  }
}