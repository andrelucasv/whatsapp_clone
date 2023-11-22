import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp_clone/model/conversa.dart';
import 'package:whatsapp_clone/model/mensagem.dart';
import 'package:whatsapp_clone/model/user.dart';

class Mensagens extends StatefulWidget {

  final Usuario contato;
  const Mensagens(this.contato,{super.key});

  @override
  State<Mensagens> createState() => _MensagensState();
}

class _MensagensState extends State<Mensagens> {

  File? _imagem;
  bool _subindoImagem = false;
  String? _idUsuarioLogado;
  String? _idUsuarioDestinatario;
  FirebaseFirestore db = FirebaseFirestore.instance;
  final TextEditingController _controllerMensagem = TextEditingController();

  _enviarMensagem() {
    
    String textoMensagem = _controllerMensagem.text;
    if(textoMensagem.isNotEmpty) {

      Mensagem mensagem = Mensagem();
      mensagem.idUsuario = _idUsuarioLogado;
      mensagem.mensagem = textoMensagem;
      mensagem.urlImagem = "";
      mensagem.tipo = "texto";

      //Salvar mensaegem para remetente
      _salvarMensagem(_idUsuarioLogado!, _idUsuarioDestinatario!, mensagem);

      //Salvar mensagem para o destinatário
      _salvarMensagem(_idUsuarioDestinatario!, _idUsuarioLogado!, mensagem);

      //Salvar conversa
      _salvarConversa(mensagem);

    }

  }

  _salvarConversa(Mensagem msg) {
    
    //Salvar conversa remetente
    Conversa cRemetente = Conversa();
    cRemetente.idRemetente = _idUsuarioLogado;
    cRemetente.idDestinario = _idUsuarioDestinatario;
    cRemetente.mensagem = msg.mensagem;
    cRemetente.nome = widget.contato.nome;
    cRemetente.caminhoFoto = widget.contato.urlImagem;
    cRemetente.tipoMensagem = msg.tipo;
    cRemetente.salvar();

    //Salvar conversa destinatário
    Conversa cDestinatario = Conversa();
    cDestinatario.idRemetente = _idUsuarioDestinatario;
    cDestinatario.idDestinario = _idUsuarioLogado;
    cDestinatario.mensagem = msg.mensagem;
    cDestinatario.nome = widget.contato.nome;
    cDestinatario.caminhoFoto = widget.contato.urlImagem;
    cDestinatario.tipoMensagem = msg.tipo;
    cDestinatario.salvar();

  }

  _salvarMensagem(String idRemetente, String idDestinario, Mensagem msg) async {

    await db.collection("mensagens")
      .doc(idRemetente)
      .collection(idDestinario)
      .add(msg.toMap());

      //Limpa texto
      _controllerMensagem.clear();

  }

  _enviarFoto() async {

    XFile? imagemSelecionada;
    imagemSelecionada = await ImagePicker().pickImage(source: ImageSource.gallery);

    _subindoImagem = true;
    String nomeImagem = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference pastaRaiz = storage.ref();
    Reference arquivo = 
      pastaRaiz.child("mensagens")
      .child(_idUsuarioLogado!)
      .child("$nomeImagem.jpg");

    //Upload da imagem
    _imagem = File(imagemSelecionada!.path);
    UploadTask uploadTask = arquivo.putFile(File(_imagem!.path));

    //Controlar progresso do upload
    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {

      if(taskSnapshot.state == TaskState.running) {
        setState(() {
          _subindoImagem = true;
        });
      } else if(taskSnapshot.state == TaskState.success) {
        setState(() {
          _subindoImagem = false;
        });
      }

    });

    //Recuperar a url da imagem
    uploadTask.then((TaskSnapshot snapshot) {
      _recuperarUrlImagem(snapshot);
    });

  }

  Future _recuperarUrlImagem(TaskSnapshot snapshot) async {
     
    String url = await snapshot.ref.getDownloadURL();

    Mensagem mensagem = Mensagem();
    mensagem.idUsuario = _idUsuarioLogado;
    mensagem.mensagem = "";
    mensagem.urlImagem = url;
    mensagem.tipo = "imagem";

    //Salvar mensaegem para remetente
    _salvarMensagem(_idUsuarioLogado!, _idUsuarioDestinatario!, mensagem);

    //Salvar mensagem para o destinatário
    _salvarMensagem(_idUsuarioDestinatario!, _idUsuarioLogado!, mensagem);

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
                prefixIcon: 
                  _subindoImagem 
                    ? const CircularProgressIndicator()
                    : IconButton(icon: const Icon(Icons.camera_alt),onPressed: _enviarFoto)
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

  var stream = StreamBuilder(
    stream: db.collection("mensagens")
              .doc(_idUsuarioLogado)
              .collection(_idUsuarioDestinatario!)
              .snapshots(),
    builder: (context, snapshot) {
      switch(snapshot.connectionState) {
        case ConnectionState.none:
        case ConnectionState.waiting:
          return const Center(
            child: Column(
              children: [
                Text("Carregando mensagens ..."),
                CircularProgressIndicator()
              ],
            ),
          );
        case ConnectionState.active:
        case ConnectionState.done:
          QuerySnapshot<Map<String, dynamic>>? querySnapshot = snapshot.data;

          if(snapshot.hasError) {
            return const Expanded(
              child: Text("Erro ao carregar dados")
            );
          } else {

            return Expanded(
              child: ListView.builder(
                itemCount: querySnapshot!.docs.length,
                itemBuilder: (context, index) {

                  //Recuperar mensagem
                  List<DocumentSnapshot> mensagens = querySnapshot.docs.toList();
                  DocumentSnapshot item = mensagens[index];

                  double larguraContainer = MediaQuery.of(context).size.width * 0.8;

                  //Define cores e alinhamentos por posição
                  Alignment alinhamento = Alignment.centerRight;
                  Color cor = const Color(0xffd2ffa5);
                  if(_idUsuarioLogado != item["idUsuario"]) {
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
                        child: item["tipo"] == "texto"
                          ? Text(item["mensagemEnviada"],style: const TextStyle(fontSize: 16),)
                          : Image.network(item["urlImagem"])
                      ),
                    ),
                  );

                }
              )
            );

          }
      }
    }
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
                stream,
                caixaMensagem
              ],
            ),
          )
        ),
      ),
    );
  }
}