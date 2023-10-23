import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Configuracoes extends StatefulWidget {
  const Configuracoes({super.key});

  @override
  State<Configuracoes> createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> {

  final TextEditingController _controllerNome = TextEditingController();
  File? _imagem;
  String? _idUsuarioLogado = "";
  bool _subindoImagem = false;
  String? _urlImagemRecuperada;

  Future _recuperarImagem(String origemImagem) async {

    XFile? imagemSelecionada;
    switch(origemImagem) {
      case "camera" :
        imagemSelecionada = await ImagePicker().pickImage(source: ImageSource.camera);
        break;
      case "galeria" :
        imagemSelecionada = await ImagePicker().pickImage(source: ImageSource.gallery);
        break;
    }

    setState(() {
      _imagem = File(imagemSelecionada!.path);
      if(_imagem != null) {
        _subindoImagem = true;
        _uploadImagem();
      }
    });

  }

  Future _uploadImagem() async {

    FirebaseStorage storage = FirebaseStorage.instance;
    Reference pastaRaiz = storage.ref();
    Reference arquivo = 
      pastaRaiz.child("perfil")
      .child("$_idUsuarioLogado.jpg");

    //Upload da imagem
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
    _atualizarUrlImagemFirestore(url);

    setState(() {
      _urlImagemRecuperada = url;
    });

  }
  _atualizarNomeFirestore() {
    
    String nome = _controllerNome.text;
    FirebaseFirestore db = FirebaseFirestore.instance;

    Map<String, dynamic> dadosAtualizar = {
      "nome" : nome
    };

    db.collection("usuarios")
      .doc(_idUsuarioLogado)
      .update(dadosAtualizar);

  }

  _atualizarUrlImagemFirestore(String url) {
    
    FirebaseFirestore db = FirebaseFirestore.instance;

    Map<String, dynamic> dadosAtualizar = {
      "urlImagem" : url
    };

    db.collection("usuarios")
      .doc(_idUsuarioLogado)
      .update(dadosAtualizar);

  }

  _recuperarDadosUsuario() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    var usuarioLogado = auth.currentUser;
    _idUsuarioLogado = usuarioLogado!.uid;

    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot snapshot = await db.collection("usuarios")
      .doc(_idUsuarioLogado)
      .get();

      dynamic dadosUsuarioRecuperado = snapshot.data();
      _controllerNome.text = dadosUsuarioRecuperado["nome"];

      if(dadosUsuarioRecuperado["urlImagem"] != null ) {
        setState(() {
          _urlImagemRecuperada = dadosUsuarioRecuperado["urlImagem"];
        });
      }

  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text ("Configurações"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: 
                    _subindoImagem
                      ? const CircularProgressIndicator()
                      : Container(),
                ),
                CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.grey,
                  backgroundImage: 
                  _urlImagemRecuperada == null
                  ? null
                  : NetworkImage(_urlImagemRecuperada!),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        _recuperarImagem("camera");
                      }, 
                      child: const Text("Câmera")
                    ),
                    TextButton(
                      onPressed: () {
                        _recuperarImagem("galeria");
                      }, 
                      child: const Text("Galeria")
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerNome,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(fontSize: 20),
                    /*onChanged: (texto) {
                      _atualizarNomeFirestore(texto);
                    },*/
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Nome",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32)
                      )
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      _atualizarNomeFirestore();
                    },
                    style: ButtonStyle(
                      backgroundColor: const MaterialStatePropertyAll(Colors.green),
                      padding: const MaterialStatePropertyAll(
                        EdgeInsets.fromLTRB(32, 16, 32, 16
                      )),
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)
                      ))
                    ),
                    child: const Text(
                      "Salvar",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}