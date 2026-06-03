// ============================================================
// QUIZ
// ============================================================

// ------------------------------------------------------------
// INICIAR QUIZ
// ------------------------------------------------------------
void iniciarQuiz() {
  perguntaAtual = 0;
  respostaSelecionada = -1;
  respondida = false;
  tentativasErro = 0;
  mostrarDica = false;
  acertos = 0;
  totalRespondidas = 0;
  ordemPerguntas = new int[perguntas.length];
  for (int i = 0; i < perguntas.length; i++) {
    ordemPerguntas[i] = i;
  }
  embaralhar(ordemPerguntas);
}

// ------------------------------------------------------------
// PRÓXIMA PERGUNTA
// ------------------------------------------------------------
void proximaPergunta() {
  perguntaAtual++;
  respostaSelecionada = -1;
  respondida = false;
  if (!mostrarDica) {
    tentativasErro = 0;
  }
  if (perguntaAtual >= perguntas.length) {
    finalizarQuiz();
  }
}

// ------------------------------------------------------------
// FINALIZAR QUIZ
// ------------------------------------------------------------
void finalizarQuiz() {
  verificarSeloQuiz();
  currentScreen = TELA_INICIAL;
  perguntaAtual = 0;
}

// ------------------------------------------------------------
// CLIQUES DO QUIZ
// ------------------------------------------------------------
void cliqueQuiz() {
  // botão próxima pergunta
  if (respondida) {
    boolean clicouProximo =
      mouseX >= width - 200 &&
      mouseX <= width - 50 &&
      mouseY >= height - 38 &&
      mouseY <= height - 6;
    if (clicouProximo) {
      proximaPergunta();
    }
    return;
  }
  Pergunta p = perguntas[ordemPerguntas[perguntaAtual]];
  for (int i = 0; i < p.opcoes.length; i++) {
    int col = i % 2;
    int row = i / 2;
    int bx = 60 + col * (width / 2 - 45);
    int by = 260 + row * 100;
    int bw = width / 2 - 60;
    int bh = 84;
    boolean clicou =
      mouseX >= bx &&
      mouseX <= bx + bw &&
      mouseY >= by &&
      mouseY <= by + bh;
    if (clicou) {
      responderPergunta(i);
      return;
    }
  }
}

// ------------------------------------------------------------
// RESPONDER
// ------------------------------------------------------------
void responderPergunta(int resposta) {
  Pergunta p = perguntas[ordemPerguntas[perguntaAtual]];
  respostaSelecionada = resposta;
  respondida = true;
  totalRespondidas++;
  totalPorGrupo[p.grupoAnimal]++;
  if (resposta == p.respostaCorreta) {
    acertos++;
    acertosPorGrupo[p.grupoAnimal]++;
    tentativasErro = 0;
    mostrarDica = false;
  } else {
    tentativasErro++;
    if (tentativasErro >= 2) {
      mostrarDica = true;
    }
  }
  verificarSelos();
}

// ------------------------------------------------------------
// EMBARALHAR
// ------------------------------------------------------------
void embaralhar(int[] arr) {
  for (int i = arr.length - 1; i > 0; i--) {
    int j = (int) random(i + 1);
    int temp = arr[i];
    arr[i] = arr[j];
    arr[j] = temp;
  }
}
