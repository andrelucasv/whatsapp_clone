import 'package:flutter/material.dart';
import 'package:whatsapp_clone/model/conversa.dart';

class TabConversas extends StatefulWidget {
  const TabConversas({super.key});

  @override
  State<TabConversas> createState() => _TabConversasState();
}

class _TabConversasState extends State<TabConversas> {

  final List<Conversa> _listaConversas = [];

  @override
  void initState() {
    super.initState();

    Conversa conversa = Conversa();
    conversa.nome = "Ana Clara";
    conversa.mensagem = "Olá, tudo bem?";
    conversa.caminhoFoto = "https://firebasestorage.googleapis.com/v0/b/whatsapp-8864e.appspot.com/o/perfil%2Fperfil1.jpg?alt=media&token=70ba76c0-7c7d-44e8-81d2-21a960ef9a6e";

    _listaConversas.add(conversa);

  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _listaConversas.length,
      itemBuilder: (context, index) {

        Conversa conversa = _listaConversas[index];

        return ListTile(
          contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          leading: CircleAvatar(
            maxRadius: 30,
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(conversa.caminhoFoto!),
          ),
          title: Text(
            conversa.nome!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16
            ),
          ),
          subtitle: Text(
            conversa.mensagem!,
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