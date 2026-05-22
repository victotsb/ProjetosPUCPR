// ============================================================
// CLASSES
// ============================================================
class Animal {

  String nomePopular;
  String nomeCientifico;
  String icone;

  int grupo;

  int mapX;
  int mapY;

  String habitat;
  String alimentacao;
  String curiosidade;
  String conservacao;

  String tamanho;
  String peso;

  Animal(
    String nomePopular,
    String nomeCientifico,
    String icone,
    int grupo,
    int mapX,
    int mapY,
    String habitat,
    String alimentacao,
    String curiosidade,
    String conservacao,
    String tamanho,
    String peso
  ) {

    this.nomePopular = nomePopular;
    this.nomeCientifico = nomeCientifico;
    this.icone = icone;

    this.grupo = grupo;

    this.mapX = mapX;
    this.mapY = mapY;

    this.habitat = habitat;
    this.alimentacao = alimentacao;
    this.curiosidade = curiosidade;
    this.conservacao = conservacao;

    this.tamanho = tamanho;
    this.peso = peso;
  }
}

class Pergunta {
  String enunciado;
  String[] opcoes;
  int respostaCorreta, animalRef, grupoAnimal;
  String nomeAnimal, dica, fato;

  Pergunta(String en, String[] op, int rc, int ar, String na,
           String di, String fa, int ga) {
    enunciado = en; opcoes = op; respostaCorreta = rc;
    animalRef = ar; nomeAnimal = na; dica = di; fato = fa; grupoAnimal = ga;
  }
}
