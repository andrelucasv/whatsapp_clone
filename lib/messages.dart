import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/model/mensagem.dart';
import 'package:whatsapp_clone/model/user.dart';

class Mensagens extends StatefulWidget {

  final Usuario contato;
  const Mensagens(this.contato,{super.key});

  @override
  State<Mensagens> createState() => _MensagensState();
}

class _MensagensState extends State<Mensagens> {

  String? _idUsuarioLogado;
  String? _idUsuarioDestinatario;
  List<String> listaMensagens = [
    "Fala comigo meu irmão, tudo tranquilo?",
    "Tudo traquilo, mano e contigo?",
    "Tô bem. Vamos para academia hoje",
    "Ainda não sei",
    "Se tu for, eu vou contigo ein",
    "Beleza, assim que sair do trabalho eu te aviso",
    "Vai treinar o que hoje, mano??",
    "Então irmão, na minha é um treino de costas",
    "Opa! Vou treinar costas hoje também",
    "Showw, vamos treinar juntos?",
    "Boraa manoo!!",
    "Massa, vou apressar aqui!!",
    "Beleza, manito!! Não esquece de avisar"

  ];
  final TextEditingController _controllerMensagem = TextEditingController();

  _enviarMensagem() {
    
    String textoMensagem = _controllerMensagem.text;
    if(textoMensagem.isNotEmpty) {

      Mensagem mensagem = Mensagem();
      mensagem.idUsuario = _idUsuarioLogado;
      mensagem.mensagem = textoMensagem;
      mensagem.urlImagem = "";
      mensagem.tipo = "texto";

      _salvarMensagem(_idUsuarioLogado!, _idUsuarioDestinatario!, mensagem);

    }

  }

  _salvarMensagem(String idRemetente, String idDestinario, Mensagem msg) async {

    FirebaseFirestore db = FirebaseFirestore.instance;

    await db.collection("mensagens")
      .doc(idRemetente)
      .collection(idDestinario)
      .add(msg.toMap());

      //Limpa texto
      _controllerMensagem.clear();

    /*

    +mensagens
      + usuarioRemetente
        + usuarioDestinatario
          +identificadorFirebase
            <Mensagem>

    */

  }

  _enviarFoto() {

  }

  _recuperarDadosUsuario() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    var usuarioLogado = auth.currentUser;
    _idUsuarioLogado = usuarioLogado!.uid;

    _idUsuarioDestinatario = widget.contato.idUsuario;

  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
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

  var listView = Expanded(
    child: ListView.builder(
      itemCount: listaMensagens.length,
      itemBuilder: (context, index) {

        double larguraContainer = MediaQuery.of(context).size.width * 0.8;

        //Define cores e alinhamentos por posição
        Alignment alinhamento = Alignment.centerRight;
        Color cor = const Color(0xffd2ffa5);
        if(index % 2 == 0) {
          cor = Colors.white;
          alinhamento = Alignment.centerLeft;
        }
        
        return Align(
          alignment: alinhamento,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Container(
              width: larguraContainer,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cor,
                borderRadius: const BorderRadius.all(Radius.circular(8))
              ),
              child: Text(
                listaMensagens[index],
                style: const TextStyle(
                  fontSize: 16
                ),
              ),
            ),
          ),
        );

      }
    )
  );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
                    maxRadius: 20,
                    backgroundColor: Colors.grey,
                    backgroundImage: 
                    widget.contato.urlImagem != null
                      ? NetworkImage(widget.contato.urlImagem!)
                      : null
                  ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(widget.contato.nome!),
            )
          ],
        ),
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
                listView,
                caixaMensagem
              ],
            ),
          )
        ),
      ),
    );
  }
}