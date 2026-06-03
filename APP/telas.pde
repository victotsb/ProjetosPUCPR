// ============================================================
// TELA 0 — INICIAL
// ============================================================
void drawTelaInicial() {
  for (int i = 0; i < height; i++) {
    float t = map(i, 0, height, 0, 1);
    stroke(lerp(34, 10, t), lerp(85, 50, t), lerp(34, 10, t));
    line(0, i, width, i);
  }

  // Título
  textFont(fonteTitulo);
  fill(255, 220, 50);
  textAlign(CENTER, CENTER);
  textSize(42);
  text("APP MM", width/2, 130);
  fill(255);
  textSize(28);
  text("Fauna Amazônica", width/2, 185);
  textSize(18);
  fill(200, 240, 200);
  text("Conhecer para Preservar", width/2, 224);

  // Botões centralizados
  int bw = 320;
  int bh = 64;
  int bx = width/2 - bw/2;

  drawBotao("Explorar o Mapa", bx, 300, bw, bh, 1);
  drawBotao("Quiz",            bx, 384, bw, bh, 3);
  drawBotao("Missao Verde",    bx, 468, bw, bh, 4);
  drawBotao("Meus Selos",      bx, 552, bw, bh, 5);

  // Estatísticas
  textFont(fonteTexto);
  textSize(17);
  fill(200, 240, 200);
  int fichasVistas = contarFichasVisitadas();
  float pctAcertos = totalRespondidas > 0 ? (float)acertos / totalRespondidas * 100 : 0;
  text("Fichas vistas: " + fichasVistas + "/12   |   Acertos: " + nf(pctAcertos, 0, 0) + "%", width/2, 660);

  // Indicadores de selos especiais na tela inicial
  if (seloMapaDesbloqueado || nivelSeloQuiz > 0) {
    fill(255, 220, 50, 180);
    textSize(14);
    String conquistas = "";
    if (seloMapaDesbloqueado) conquistas += "🗺 Explorador  ";
    if (nivelSeloQuiz == 3) conquistas += "🥇 Mestre do Quiz";
    else if (nivelSeloQuiz == 2) conquistas += "🥈 Naturalista";
    else if (nivelSeloQuiz == 1) conquistas += "🥉 Aprendiz";
    text(conquistas.trim(), width/2, 700);
  }
}

void cliqueTelaInicial() {

  int bw = 320;
  int bh = 64;
  int bx = width/2 - bw/2;

  int[] telas = {1, 3, 4, 5};
  int[] ys    = {300, 384, 468, 552};

  for (int i = 0; i < telas.length; i++) {

    if (
      mouseX >= bx &&
      mouseX <= bx + bw &&
      mouseY >= ys[i] &&
      mouseY <= ys[i] + bh
    ) {

      currentScreen = telas[i];

      if (currentScreen == 3) {
        iniciarQuiz();
      }

      return;
    }
  }
}

// ============================================================
// CLIQUE NO MAPA
// ============================================================

void cliqueMapa() {

  for (int i = 0; i < animais.length; i++) {

    Animal a = animais[i];

    float distancia =
      dist(mouseX, mouseY, a.mapX, a.mapY);

    if (distancia < 36) {

      animalSelecionado = i;

      currentScreen = TELA_FICHA;

      return;
    }
  }
}

// ============================================================
// TELA 1 — MAPA INTERATIVO
// ============================================================
void drawMapa() {
  if (imgMapa != null) {
    image(imgMapa, 0, 0, width, height);
  } else {
    background(20, 80, 30);
    fill(255);
    textAlign(CENTER, CENTER);
    text("Coloque mapa_amazonia.png na pasta /data/", width/2, height/2);
  }

  fill(0, 0, 0, 120);
  noStroke();
  rect(0, 0, width, 48);
  fill(255, 230, 80);
  textFont(fonteTexto);
  textSize(17);
  textAlign(CENTER, CENTER);
  text("Clique nos animais para conhece-los!", width/2, 24);

  for (int i = 0; i < animais.length; i++) {
    Animal a = animais[i];
    boolean visitado = fichasVisitadas[i];
    float raio = 30;
    float d = dist(mouseX, mouseY, a.mapX, a.mapY);
    boolean hover = (d < raio + 12);

    if (hover) {
      float halo = 22 + sin(pulsoTick * 3) * 5;
      fill(255, 240, 100, 80);
      noStroke();
      ellipse(a.mapX, a.mapY, (raio + halo) * 2, (raio + halo) * 2);
      fill(255, 240, 100, 40);
      ellipse(a.mapX, a.mapY, (raio + halo + 12) * 2, (raio + halo + 12) * 2);

      textFont(fonteTexto);
      textSize(16);
      String rotulo = a.nomePopular;
      float tw = textWidth(rotulo) + 24;
      float tx = a.mapX - tw / 2;
      float ty = a.mapY - raio - 38;
      tx = constrain(tx, 4, width - tw - 4);
      ty = max(ty, 52);

      fill(0, 0, 0, 100);
      rect(tx + 2, ty + 2, tw, 28, 6);
      fill(20, 20, 20, 210);
      rect(tx, ty, tw, 28, 6);
      fill(255, 240, 160);
      textAlign(CENTER, CENTER);
      text(rotulo, tx + tw/2, ty + 14);
    }

    if (visitado) {
      fill(255, 200, 30, 220);
      noStroke();
      ellipse(a.mapX + 18, a.mapY - 18, 22, 22);
      fill(80, 40, 0);
      textAlign(CENTER, CENTER);
      textSize(13);
      text("✓", a.mapX + 18, a.mapY - 18);
    } else {
      float brilho = (sin(pulsoTick * 2 + i * 1.2) + 1) / 2;
      fill(255, 255, 255, lerp(40, 110, brilho));
      noStroke();
      ellipse(a.mapX, a.mapY, 13, 13);
    }
  }
  strokeWeight(1);
}

// ============================================================
// TELA 2 — FICHA DO ANIMAL
// ============================================================
void drawFichaAnimal() {
  Animal a = animais[animalSelecionado];

  fill(0, 0, 0, 60);
  noStroke();
  rect(80, 44, width - 160, height - 72, 18);
  fill(COR_PAINEL);
  rect(74, 38, width - 148, height - 72, 18);

  fill(corGrupo(a.grupo));
  rect(74, 38, width - 148, 100, 18, 18, 0, 0);

  textAlign(CENTER, CENTER);
  textSize(60);
  text(a.icone, 148, 88);

  fill(255);
  textFont(fonteTitulo);
  textSize(26);
  textAlign(LEFT, CENTER);
  text(a.nomePopular, 200, 62);

  fill(220, 240, 220);
  textFont(fonteTexto);
  textSize(16);
  text(a.nomeCientifico, 200, 94);

  // painel imagem
  fill(255, 255, 255, 30);
  rect(width - 310, 150, 190, 190, 14);
  fill(255, 255, 255, 15);
  rect(width - 304, 156, 178, 178, 12);
  if (imagensAnimais[animalSelecionado] != null) {
    imageMode(CENTER);
    PImage img = imagensAnimais[animalSelecionado];
    float maxSize = 165;
    float proporcao = min(maxSize / img.width, maxSize / img.height);
    float w = img.width * proporcao;
    float h = img.height * proporcao;
    image(img, width - 215, 245, w, h);
    imageMode(CORNER);
  } else {
    fill(220);
    textAlign(CENTER, CENTER);
    textSize(15);
    text("Imagem do animal", width - 215, 245);
  }

  String[] nomeGrupo = {"Mamifero", "Ave", "Reptil/Anfibio", "Peixe", "Invertebrado"};
  fill(255, 255, 255, 60);
  rect(width - 240, 48, 140, 30, 10);
  fill(255);
  textSize(14);
  textAlign(CENTER, CENTER);
  text(nomeGrupo[constrain(a.grupo, 0, 4)], width - 170, 63);

  int yBase = 170;
  int espaco = 88;
  drawCampoFicha("Onde vive",   a.habitat,     100, yBase);
  drawCampoFicha("O que come",  a.alimentacao, 100, yBase + espaco);
  drawCampoFicha("Curiosidade", a.curiosidade, 100, yBase + espaco*2);
  drawCampoFicha("Conservacao", a.conservacao, 100, yBase + espaco*3);

  fill(140);
  textFont(fonteTexto);
  textSize(14);
  textAlign(RIGHT, CENTER);
  text("Tamanho: " + a.tamanho + "   Peso: " + a.peso, width - 100, 140);
  textAlign(LEFT);

  drawBotao("Responder Quiz!", width/2 - 110, height - 72, 220, 46, 3);

  fichasVisitadas[animalSelecionado] = true;
  verificarSelos();
}

void carregarImagensAnimais() {
  imagensAnimais = new PImage[animais.length];

  String[] arquivos = {
    "onca.png",
    "boto.png",
    "preguica.png",
    "harpia.png",
    "tucano.png",
    "arara.png",
    "sucuri.png",
    "jacare.png",
    "tartaruga.png",
    "pirarucu.png",
    "piranha.png",
    "aranha.png"
  };

  for (int i = 0; i < arquivos.length; i++) {
    imagensAnimais[i] = loadImage(arquivos[i]);
  }
}

void drawCampoFicha(String rotulo, String valor, int x, int y) {
  fill(100, 140, 100);
  textFont(fonteTitulo);
  textSize(13);
  textAlign(LEFT, TOP);
  text(rotulo.toUpperCase(), x, y);
  fill(65, 65, 65);
  textFont(fonteTexto);
  textSize(16);
  text(valor, x, y + 22, width - 370, 60);
}

// ============================================================
// TELA 3 — QUIZ (ajustada para 1152x928)
// ============================================================
void drawQuiz() {
  if (perguntas.length == 0) return;
  Pergunta p = perguntas[ordemPerguntas[perguntaAtual]];

  fill(COR_PAINEL);
  noStroke();
  rect(50, 30, width - 100, height - 55, 14);

  fill(COR_BOTAO);
  rect(50, 30, width - 100, 64, 14, 14, 0, 0);

  fill(255);
  textFont(fonteTitulo);
  textSize(18);
  textAlign(CENTER, CENTER);
  text("Quiz — Pergunta " + (perguntaAtual + 1) + " de " + perguntas.length, width/2, 62);

  // Barra de progresso
  float prog = (float)(perguntaAtual) / perguntas.length;
  fill(255, 255, 255, 50);
  rect(80, 88, width - 160, 8, 4);
  fill(255, 220, 50);
  rect(80, 88, (width - 160) * prog, 8, 4);

  // Pergunta
  fill(40, 60, 40);
  textFont(fonteTexto);
  textSize(20);
  textAlign(CENTER, TOP);
  text(p.enunciado, 90, 116, width - 180, 110);

  // Dica
  if (mostrarDica) {
    fill(180, 100, 0);
    textSize(16);
    textAlign(CENTER, TOP);
    text("Dica: " + p.dica, 80, 210, width - 160, 40);
  }

  // Opções — 2 colunas, 2 linhas
  for (int i = 0; i < p.opcoes.length; i++) {
    int col = i % 2;
    int row = i / 2;
    int bx = 80 + col * (width/2 - 55);
    int by = 260 + row * 100;
    int bw = width/2 - 70;
    int bh = 84;

    color corOpcao;
    if (respondida) {
      if (i == p.respostaCorreta)        corOpcao = color(80, 200, 80);
      else if (i == respostaSelecionada) corOpcao = color(220, 80, 80);
      else                               corOpcao = color(210, 225, 210);
    } else {
      boolean hov = (mouseX>=bx && mouseX<=bx+bw && mouseY>=by && mouseY<=by+bh);
      corOpcao = hov ? color(200, 230, 200) : color(220, 235, 220);
    }

    fill(corOpcao);
    stroke(160);
    strokeWeight(1);
    rect(bx, by, bw, bh, 12);
    noStroke();

    String letra = new String[]{"A","B","C","D"}[i];
    fill(respondida && i==p.respostaCorreta ? color(20,100,20) : color(80,120,80));
    textFont(fonteTitulo);
    textSize(18);
    textAlign(LEFT, CENTER);
    text(letra, bx + 24, by + bh/2 - 1);

    fill(respondida && i==p.respostaCorreta ? color(10,80,10) : COR_TITULO);
    textFont(fonteTexto);
    textSize(16);
    textAlign(LEFT, CENTER);
    text(p.opcoes[i], bx + 50, by + bh/2 - 2, bw - 60, bh - 10);
  }

  // Feedback
  if (respondida) {
    boolean certo = (respostaSelecionada == p.respostaCorreta);
    fill(certo ? color(30, 120, 30) : color(160, 40, 40));
    rect(80, height - 120, width - 160, 62, 12);
    fill(255);
    textFont(fonteTexto);
    textSize(16);
    textAlign(CENTER, CENTER);
    text(p.fato, 100, height - 118, width - 200, 58);
    drawBotao("Proxima ->", width - 240, height - 50, 180, 38, -99);
  }
}

// ============================================================
// TELA 4 — MISSÃO VERDE
// ============================================================
void drawMissaoVerde() {
  for (int i = 0; i < height; i++) {
    float t = map(i, 0, height, 0, 1);
    stroke(lerp(20, 40, t), lerp(100, 130, t), lerp(20, 60, t));
    line(0, i, width, i);
  }
  fill(255, 220, 50);
  textFont(fonteTitulo);
  textSize(32);
  textAlign(CENTER, CENTER);
  text("Missao Verde", width/2, 70);
  fill(200, 255, 200);
  textFont(fonteTexto);
  textSize(17);
  text("O que voce pode fazer para ajudar a Amazonia?", width/2, 114);

  fill(255, 255, 255, 20);
  noStroke();
  rect(80, 144, width - 160, height - 190, 14);

  String[] missoes = {
    "Economize energia desligando luzes e aparelhos sem uso",
    "Evite desperdício de água durante o banho e na escovação",
    "Nunca descarte lixo em rios, ruas ou áreas verdes",
    "Aprenda sobre espécies ameaçadas e compartilhe conhecimento",
    "Prefira produtos com origem sustentável e certificada",
    "Plante árvores ou cuide de plantas para ajudar o meio ambiente"
  };

  for (int i = 0; i < missoes.length; i++) {
    int my = 175 + i * 88;
    fill(255, 255, 255, 35);
    rect(100, my, width - 200, 70, 14);
    fill(255, 255, 255, 15);
    rect(102, my + 2, width - 204, 22, 10);
    fill(220, 255, 220);
    textFont(fonteTexto);
    textSize(17);
    textAlign(LEFT, CENTER);
    text((i+1) + ".  " + missoes[i], 130, my + 36, width - 270, 54);
  }
}

// ============================================================
// TELA 5 — SELOS (REDESENHADA)
// ============================================================

// Scroll para selos
int selosScrollY = 0;

void drawSelos() {

  // Fundo gradiente escuro esverdeado
  for (int i = 0; i < height; i++) {
    float t = map(i, 0, height, 0, 1);
    stroke(lerp(15, 25, t), lerp(35, 55, t), lerp(15, 30, t));
    line(0, i, width, i);
  }

  // ── Cabeçalho ──────────────────────────────────────────────
  // Faixa roxa escura
  fill(45, 20, 80, 230);
  noStroke();
  rect(0, 0, width, 90);

  // Brilho sutil no topo
  fill(255, 255, 255, 15);
  rect(0, 0, width, 3);

  fill(255, 230, 100);
  textFont(fonteTitulo);
  textSize(28);
  textAlign(CENTER, CENTER);
  text("✦  Meus Selos de Guardião  ✦", width/2, 38);

  // Contadores
  int totalSelos = 0;
  for (boolean s : selosDesbloqueados) if (s) totalSelos++;
  if (seloMapaDesbloqueado) totalSelos++;
  if (nivelSeloQuiz > 0) totalSelos++;
  int totalGeral = animais.length + 2;

  fill(200, 180, 255);
  textFont(fonteTexto);
  textSize(16);
  text(totalSelos + " de " + totalGeral + " selos conquistados", width/2, 70);

  // ── Grid de selos dos animais ───────────────────────────────
  // Layout: 4 colunas, selos maiores e mais bonitos
  int cols    = 4;
  int tamW    = 218;  // largura do card
  int tamH    = 190;  // altura do card
  int gap     = 20;
  int totalW  = cols * tamW + (cols - 1) * gap;
  int xIni    = (width - totalW) / 2;
  int yIni    = 108;

  for (int i = 0; i < animais.length; i++) {

    int col = i % cols;
    int row = i / cols;

    int sx = xIni + col * (tamW + gap);
    int sy = yIni + row * (tamH + gap);

    desenharCardSelo(
      sx, sy, tamW, tamH,
      selosDesbloqueados[i],
      selosAnimais[i],
      animais[i].nomePopular,
      corGrupo(animais[i].grupo),
      false, 0
    );
  }

  // ── Selos especiais ─────────────────────────────────────────
  // Linha extra na base com os 2 selos especiais
  int rows = (int) ceil((float) animais.length / cols);
  int yEspecial = yIni + rows * (tamH + gap) + 12;

  // Largura dos selos especiais (maiores, destacados)
  int tamEW = 280;
  int tamEH = 200;
  int xEsp1 = width/2 - tamEW - 30;
  int xEsp2 = width/2 + 30;

  // Selo mapa
  desenharCardSeloEspecial(
    xEsp1, yEspecial, tamEW, tamEH,
    seloMapaDesbloqueado,
    null, // sem imagem png própria — usa emoji
    "Explorador",
    "Visite todas as fichas do mapa",
    color(200, 130, 30),
    "🗺"
  );

  // Selo quiz
  String labelQuiz = nivelSeloQuiz == 3 ? "Mestre do Quiz" :
                     nivelSeloQuiz == 2 ? "Naturalista"    :
                     nivelSeloQuiz == 1 ? "Aprendiz"       : "???";
  String descQuiz  = nivelSeloQuiz == 3 ? "≥ 80% de acertos no Quiz" :
                     nivelSeloQuiz == 2 ? "≥ 60% de acertos no Quiz" :
                     nivelSeloQuiz == 1 ? "≥ 40% de acertos no Quiz" :
                                          "Complete o quiz para desbloquear";
  color corQuiz    = nivelSeloQuiz == 3 ? color(210, 170, 20) :
                     nivelSeloQuiz == 2 ? color(160, 160, 160) :
                     nivelSeloQuiz == 1 ? color(160, 100, 50)  :
                                          color(80, 80, 80);
  String emojiQuiz = nivelSeloQuiz == 3 ? "🥇" :
                     nivelSeloQuiz == 2 ? "🥈" :
                     nivelSeloQuiz == 1 ? "🥉" : "🎯";

  desenharCardSeloEspecial(
    xEsp2, yEspecial, tamEW, tamEH,
    nivelSeloQuiz > 0,
    null,
    labelQuiz,
    descQuiz,
    corQuiz,
    emojiQuiz
  );

  // Porcentagem do quiz se disponível
  if (melhorPorcentagemQuiz > 0) {
    fill(200, 255, 200, 180);
    textSize(14);
    textAlign(CENTER, CENTER);
    text("Melhor resultado: " + nf(melhorPorcentagemQuiz, 0, 0) + "%",
         xEsp2 + tamEW/2, yEspecial + tamEH + 18);
  }
}

// ------------------------------------------------------------
// Desenha um card de selo de animal
// ------------------------------------------------------------
void desenharCardSelo(int sx, int sy, int tw, int th,
                      boolean desbloqueado, PImage imgSelo,
                      String nome, color corAcento,
                      boolean especial, int nivel) {

  // Sombra
  fill(0, 0, 0, 80);
  noStroke();
  rect(sx + 4, sy + 4, tw, th, 14);

  // Fundo do card
  if (desbloqueado) {
    // Gradiente dourado
    for (int i = 0; i < th; i++) {
      float t = map(i, 0, th, 0, 1);
      stroke(
        lerp(255, 200, t),
        lerp(240, 160, t),
        lerp(100, 30, t)
      );
      line(sx, sy + i, sx + tw, sy + i);
    }
    noStroke();
    // Borda dourada brilhante
    stroke(255, 200, 50);
    strokeWeight(2);
    noFill();
    rect(sx, sy, tw, th, 14);
    strokeWeight(1);
    noStroke();

    // Faixa colorida no topo (cor do grupo)
    fill(corAcento);
    rect(sx, sy, tw, 30, 14, 14, 0, 0);

    // Brilho interno topo
    fill(255, 255, 255, 40);
    rect(sx + 2, sy + 2, tw - 4, 14, 10);

  } else {
    // Locked: cinza escuro
    fill(40, 40, 40, 210);
    rect(sx, sy, tw, th, 14);
    stroke(70, 70, 70);
    strokeWeight(1);
    noFill();
    rect(sx, sy, tw, th, 14);
    noStroke();
    fill(60, 60, 60);
    rect(sx, sy, tw, 30, 14, 14, 0, 0);
  }

  // Imagem do selo
  if (desbloqueado && imgSelo != null) {
    imageMode(CENTER);
    float maxSize = th - 48;
    float prop = min(maxSize / imgSelo.width, maxSize / imgSelo.height);
    float iw = imgSelo.width  * prop;
    float ih = imgSelo.height * prop;
    image(imgSelo, sx + tw/2, sy + th/2 - 10, iw, ih);
    imageMode(CORNER);
  } else if (!desbloqueado) {
    // Cadeado
    fill(80, 80, 80, 180);
    textAlign(CENTER, CENTER);
    textSize(38);
    text("🔒", sx + tw/2, sy + th/2 - 10);
  }

  // Nome do animal
  if (desbloqueado) {
    fill(60, 30, 0);
  } else {
    fill(110, 110, 110);
  }
  textFont(fonteTexto);
  textSize(12);
  textAlign(CENTER, CENTER);
  text(nome, sx + tw/2, sy + th - 16);
}

// ------------------------------------------------------------
// Desenha um card de selo especial (mapa / quiz)
// ------------------------------------------------------------
void desenharCardSeloEspecial(int sx, int sy, int tw, int th,
                               boolean desbloqueado, PImage imgSelo,
                               String titulo, String desc,
                               color corAcento, String emoji) {

  // Sombra
  fill(0, 0, 0, 100);
  noStroke();
  rect(sx + 5, sy + 5, tw, th, 18);

  if (desbloqueado) {
    // Gradiente baseado na cor de acento
    for (int i = 0; i < th; i++) {
      float t = map(i, 0, th, 0, 1);
      float r = lerp(red(corAcento) * 1.1, red(corAcento) * 0.5, t);
      float g = lerp(green(corAcento) * 1.1, green(corAcento) * 0.5, t);
      float b = lerp(blue(corAcento) * 1.1, blue(corAcento) * 0.5, t);
      stroke(constrain(r, 0, 255), constrain(g, 0, 255), constrain(b, 0, 255));
      line(sx, sy + i, sx + tw, sy + i);
    }
    noStroke();

    // Borda brilhante
    stroke(constrain(red(corAcento) + 40, 0, 255),
           constrain(green(corAcento) + 40, 0, 255),
           constrain(blue(corAcento) + 40, 0, 255));
    strokeWeight(3);
    noFill();
    rect(sx, sy, tw, th, 18);
    strokeWeight(1);
    noStroke();

    // Brilho pulsante (aura)
    float aura = (sin(pulsoTick * 2.5) + 1) / 2;
    fill(red(corAcento), green(corAcento), blue(corAcento), lerp(20, 55, aura));
    rect(sx - 6, sy - 6, tw + 12, th + 12, 22);

    // Faixa topo
    fill(red(corAcento) * 0.7, green(corAcento) * 0.7, blue(corAcento) * 0.7);
    rect(sx, sy, tw, 36, 18, 18, 0, 0);

    // Brilho interno
    fill(255, 255, 255, 50);
    rect(sx + 3, sy + 3, tw - 6, 18, 12);

  } else {
    // Locked
    fill(30, 30, 30, 220);
    rect(sx, sy, tw, th, 18);
    stroke(60, 60, 60);
    strokeWeight(2);
    noFill();
    rect(sx, sy, tw, th, 18);
    strokeWeight(1);
    noStroke();
    fill(50, 50, 50);
    rect(sx, sy, tw, 36, 18, 18, 0, 0);
  }

  // Emoji grande no centro
  textAlign(CENTER, CENTER);
  textSize(52);
  if (!desbloqueado) {
    fill(70, 70, 70, 200);
    text("🔒", sx + tw/2, sy + th/2 - 18);
  } else {
    text(emoji, sx + tw/2, sy + th/2 - 18);
  }

  // Título
  if (desbloqueado) {
    fill(255, 240, 160);
  } else {
    fill(100, 100, 100);
  }
  textFont(fonteTitulo);
  textSize(16);
  textAlign(CENTER, CENTER);
  text(titulo, sx + tw/2, sy + th - 38);

  // Descrição
  if (desbloqueado) {
    fill(255, 220, 120);
  } else {
    fill(80, 80, 80);
  }
  textFont(fonteTexto);
  textSize(12);
  textAlign(CENTER, CENTER);
  text(desc, sx + tw/2, sy + th - 18, tw - 16, 28);
}
