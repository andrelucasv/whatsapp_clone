import 'package:flutter/material.dart';
import 'package:whatsapp_clone/model/user.dart';

class Mensagens extends StatefulWidget {

  final Usuario contato;
  const Mensagens(this.contato,{super.key});

  @override
  State<Mensagens> createState() => _MensagensState();
}

class _MensagensState extends State<Mensagens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contato.nome!),
      ),
      body: Container(),
    );
  }
}