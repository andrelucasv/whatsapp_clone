class Usuario {

  String? nome;
  String? email;
  String? senha;
  String? urlImagem;

  Usuario({this.nome, this.email, this.senha, this.urlImagem});

  Map<String, dynamic> toMap() {

    Map<String, dynamic> map = {
      "nome" : nome,
      "email" : email
    };

    return map;

  }

}