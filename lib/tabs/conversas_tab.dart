import 'package:flutter/material.dart';
import 'package:whatsapp_clone/model/conversa.dart';

class TabConversas extends StatefulWidget {
  const TabConversas({super.key});

  @override
  State<TabConversas> createState() => _TabConversasState();
}

class _TabConversasState extends State<TabConversas> {

  List<Conversa> listaConversas = [

    Conversa(
      "Ana Clara",
      "Olá, tudo bem?",
      "https://firebasestorage.googleapis.com/v0/b/whatsapp-8864e.appspot.com/o/perfil%2Fperfil1.jpg?alt=media&token=70ba76c0-7c7d-44e8-81d2-21a960ef9a6e"
    ),

    Conversa(
      "Pedro Silva",
      "Me manda o nome daquela série",
      "https://firebasestorage.googleapis.com/v0/b/whatsapp-8864e.appspot.com/o/perfil%2Fperfil2.jpg?alt=media&token=0016ddad-1bd1-4454-a2e7-e77209c95783"
    ),

    Conversa(
      "Marcela Almeida",
      "Vamos sair hoje?",
      "https://firebasestorage.googleapis.com/v0/b/whatsapp-8864e.appspot.com/o/perfil%2Fperfil3.jpg?alt=media&token=74eb48d4-0e9d-42e2-b871-b4be4e5e2683"
    ),

    Conversa(
      "José Renato",
      "Não vai acreditar no que tenho para te contar ...",
      "https://firebasestorage.googleapis.com/v0/b/whatsapp-8864e.appspot.com/o/perfil%2Fperfil4.jpg?alt=media&token=b2fd2f96-394e-4d50-905f-977a00af612a"
    ),

    Conversa(
      "Jamilton Damasceno",
      "Curso novo!! Depois dá uma olhada",
      "https://firebasestorage.googleapis.com/v0/b/whatsapp-8864e.appspot.com/o/perfil%2Fperfil5.jpg?alt=media&token=62f61fa1-5a3a-4d9f-a91e-5344c28beb31"
    )

  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listaConversas.length,
      itemBuilder: (context, index) {

        Conversa conversa = listaConversas[index];

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