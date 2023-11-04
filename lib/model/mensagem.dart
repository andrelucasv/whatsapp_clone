class Mensagem {

  String? idUsuario;
  String? mensagem;
  String? urlImagem;

  //Define o tipo da mensagem, que pode ser "texto" ou "imagem"
  String? tipo;

  Mensagem({this.idUsuario, this.mensagem, this.urlImagem, this.tipo});

  Map<String, dynamic> toMap() {

    Map<String, dynamic> map = {
      "idUsuario" : idUsuario,
      "mensagemEnviada" : mensagem,
      "urlImagem" : urlImagem,
      "tipo" : tipo
    };

    return map;

  }


}