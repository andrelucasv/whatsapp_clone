class Usuario {

  String? nome;
  String? idUsuario;
  String? email;
  String? senha;
  String? urlImagem;

  Usuario({this.nome, this.idUsuario, this.email, this.senha, this.urlImagem});

  Map<String, dynamic> toMap() {

    Map<String, dynamic> map = {
      "nome" : nome,
      "email" : email
    };

    return map;

  }

}