import 'package:cloud_firestore/cloud_firestore.dart';

class Conversa {

  String? idRemetente;
  String? idDestinario;
  String? nome;
  String? mensagem;
  String? caminhoFoto;
  String? tipoMensagem;

  Conversa();

  salvar() async {

    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection("conversas")
      .doc(idRemetente)
      .collection("ultima_conversa")
      .doc(idDestinario)
      .set(toMap());

  }

  Map<String, dynamic> toMap() {

    Map<String, dynamic> map = {
      "idRemetente" : idRemetente,
      "idDestinario" : idDestinario,
      "nome" : nome,
      "mensagem" : mensagem,
      "caminhoFoto" : caminhoFoto, 
      "tipoMensagem" : tipoMensagem, 
    };

    return map;

  }

}