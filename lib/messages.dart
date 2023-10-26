import 'package:flutter/material.dart';
import 'package:whatsapp_clone/model/user.dart';

class Mensagens extends StatefulWidget {

  final Usuario contato;
  const Mensagens(this.contato,{super.key});

  @override
  State<Mensagens> createState() => _MensagensState();
}

class _MensagensState extends State<Mensagens> {

  final TextEditingController _controllerMensagem = TextEditingController();

  _enviarMensagem() {
    
  }

  _enviarFoto() {

  }

  @override
  Widget build(BuildContext context) {

  var caixaMensagem = Container(
    padding: const EdgeInsets.all(4),
    child: Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextField(
              controller: _controllerMensagem,
              keyboardType: TextInputType.text,
              style: const TextStyle(fontSize: 20),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                hintText: "Digite uma mensagem",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32)
                ),
                prefixIcon: IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: _enviarFoto,
                )
              ),
            ),
          )
        ),
        FloatingActionButton(
          backgroundColor: const Color(0xff075E54),
          mini: true,
          onPressed: _enviarMensagem,
          child: const Icon(Icons.send, color: Colors.white)
        )
      ],
    ),
  );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contato.nome!),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.cover
          )
        ),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                const Text("ListView"),
                caixaMensagem
                //ListView
                //TextField
              ],
            ),
          )
        ),
      ),
    );
  }
}