// ============================================================
// TELA 0 — INICIAL
// ============================================================
void drawTelaInicial() {
  for (int i = 0; i < height; i++) {
    float t = map(i, 0, height, 0, 1);
    stroke(lerp(34, 10, t), lerp(85, 50, t), lerp(34, 10, t));
    line(0, i, width, i);
  }
  textFont(fonteTitulo);
  fill(255, 220, 50);
  textAlign(CENTER, CENTER);
  textSize(32);
  text("APP MM", width/2, 100);
  fill(255);
  textSize(22);
  text("Fauna Amazônica", width/2, 145);
  textSize(14);
  fill(200, 240, 200);
  text("Conhecer para Preservar", width/2, 178);
  drawBotao("Explorar o Mapa", width/2 - 120, 240, 240, 52, 1);
  drawBotao("Quiz",            width/2 - 120, 310, 240, 52, 3);
  drawBotao("Missao Verde",    width/2 - 120, 380, 240, 52, 4);
  drawBotao("Meus Selos",      width/2 - 120, 450, 240, 52, 5);
  textFont(fonteTexto);
  textSize(14);
  fill(200, 240, 200);
  int fichasVistas = contarFichasVisitadas();
  float pctAcertos = totalRespondidas > 0 ? (float)acertos / totalRespondidas * 100 : 0;
  text("Fichas vistas: " + fichasVistas + "/12   |   Acertos: " + nf(pctAcertos, 0, 0) + "%", width/2, 535);
}

void cliqueTelaInicial() {

  int bx = width/2 - 120;
  int bw = 240;
  int bh = 52;

  int[] telas = {1, 3, 4, 5};
  int[] ys    = {240, 310, 380, 450};

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

    if (distancia < 28) {

      animalSelecionado = i;

      currentScreen = TELA_FICHA;

      return;
    }
  }
}

// ============================================================
// TELA 1 — MAPA INTERATIVO
// Marcadores INVISÍVEIS: a pessoa clica direto no bicho.
// Só aparece balão com nome no hover, e tick dourado se visitado.
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

  // Faixa escura só no topo — instrução para o usuário
  fill(0, 0, 0, 120);
  noStroke();
  rect(0, 0, width, 38);
  fill(255, 230, 80);
  textFont(fonteTexto);
  textSize(14);
  textAlign(CENTER, CENTER);
  text("Clique nos animais para conhece-los!", width/2, 19);

  // Loop dos animais
  for (int i = 0; i < animais.length; i++) {
    Animal a = animais[i];
    boolean visitado = fichasVisitadas[i];
    float raio = 24; // raio da área clicável (invisível)
    float d = dist(mouseX, mouseY, a.mapX, a.mapY);
    boolean hover = (d < raio + 10);

    // ── Marcador invisível por padrão ──────────────────────
    // Quando o mouse passa em cima: mostra um halo suave + balão com nome
    if (hover) {
      // Halo pulsante ao redor do animal
      float halo = 18 + sin(pulsoTick * 3) * 4;
      fill(255, 240, 100, 80);
      noStroke();
      ellipse(a.mapX, a.mapY, (raio + halo) * 2, (raio + halo) * 2);
      fill(255, 240, 100, 40);
      ellipse(a.mapX, a.mapY, (raio + halo + 10) * 2, (raio + halo + 10) * 2);

      // Balão com nome do animal
      textFont(fonteTexto);
      textSize(14);
      String rotulo = a.nomePopular;
      float tw = textWidth(rotulo) + 20;
      float tx = a.mapX - tw / 2;
      float ty = a.mapY - raio - 32;
      tx = constrain(tx, 4, width - tw - 4);
      ty = max(ty, 42);

      // Sombra do balão
      fill(0, 0, 0, 100);
      rect(tx + 2, ty + 2, tw, 24, 6);
      // Balão
      fill(20, 20, 20, 210);
      rect(tx, ty, tw, 24, 6);
      // Texto
      fill(255, 240, 160);
      textAlign(CENTER, CENTER);
      text(rotulo, tx + tw/2, ty + 12);
    }

    // ── Indicador de visitado: pequeno tick dourado no canto ──
    if (visitado) {
      // Círculo dourado pequeno — discreto, não cobre o bicho
      fill(255, 200, 30, 220);
      noStroke();
      ellipse(a.mapX + 14, a.mapY - 14, 18, 18);
      fill(80, 40, 0);
      textAlign(CENTER, CENTER);
      textSize(11);
      text("✓", a.mapX + 14, a.mapY - 14);
    } else {
      // Ponto bem pequenininho para indicar que há algo clicável
      // (apenas visível para quem não visitou — como uma "trilha" de pontos)
      float brilho = (sin(pulsoTick * 2 + i * 1.2) + 1) / 2; // 0..1
      fill(255, 255, 255, lerp(40, 100, brilho));
      noStroke();
      ellipse(a.mapX, a.mapY, 10, 10);
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
  rect(66, 36, width - 120, height - 60, 18);
  fill(COR_PAINEL);
  rect(60, 30, width - 120, height - 60, 18);

  // Cabeçalho colorido por grupo
  fill(corGrupo(a.grupo));
  rect(60, 30, width - 120, 85, 18, 18, 0, 0);

  // Ícone grande
  textAlign(CENTER, CENTER);
  textSize(50);
  text(a.icone, 120, 72);

  // Nome popular
  fill(255);
  textFont(fonteTitulo);
  textSize(22);
  textAlign(LEFT, CENTER);
  text(a.nomePopular, 165, 52);

  // Nome científico
  fill(220, 240, 220);
  textFont(fonteTexto);
  textSize(14);
  text(a.nomeCientifico, 165, 78);
  
  // painel da imagem
  fill(255, 255, 255, 30);
  rect(width - 250, 125, 150, 150, 14);
  fill(255, 255, 255, 15);
  rect(width - 245, 130, 140, 140, 12);
  if (imagensAnimais[animalSelecionado] != null) {
  imageMode(CENTER);

  PImage img = imagensAnimais[animalSelecionado];
  
  float maxSize = 130;
  
  float proporcao = min(
    maxSize / img.width,
    maxSize / img.height
  );
  
  float w = img.width * proporcao;
  float h = img.height * proporcao;
  
  image(img, width - 175, 200, w, h);
  
  imageMode(CORNER);
  } else {
  fill(220);
  textAlign(CENTER, CENTER);
  textSize(13);
  text("Imagem do animal", width - 175, 200);
}

  // Badge de grupo
  String[] nomeGrupo = {"Mamifero", "Ave", "Reptil/Anfibio", "Peixe", "Invertebrado"};
  fill(255, 255, 255, 60);
  rect(width - 195, 40, 120, 26, 10);
  fill(255);
  textSize(12);
  textAlign(CENTER, CENTER);
  text(nomeGrupo[constrain(a.grupo, 0, 4)], width - 135, 53);

  // Campos de conteúdo
  int yBase = 140;
  int espaco = 72;
  drawCampoFicha("Onde vive",   a.habitat,     80, yBase);
  drawCampoFicha("O que come",  a.alimentacao, 80, yBase + espaco);
  drawCampoFicha("Curiosidade", a.curiosidade, 80, yBase + espaco*2);
  drawCampoFicha("Conservacao", a.conservacao, 80, yBase + espaco*3);

  // Tamanho e peso
  fill(140);
  textFont(fonteTexto);
  textSize(12);
  textAlign(RIGHT, CENTER);
  text("Tamanho: " + a.tamanho + "   Peso: " + a.peso, width - 80, 118);
  textAlign(LEFT);

  // Botão quiz
  drawBotao("Responder Quiz!", width/2 - 90, height - 60, 180, 38, 3);

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
  textSize(11);
  textAlign(LEFT, TOP);
  text(rotulo.toUpperCase(), x, y);
  fill(65, 65, 65);
  textFont(fonteTexto);
  textSize(14);
  text(valor, x, y + 18, width - 300, 52);
}

// ============================================================
// TELA 3 — QUIZ
// ============================================================
void drawQuiz() {
  if (perguntas.length == 0) return;
  Pergunta p = perguntas[ordemPerguntas[perguntaAtual]];

  fill(COR_PAINEL);
  noStroke();
  rect(40, 25, width - 80, height - 45, 14);

  fill(COR_BOTAO);
  rect(40, 25, width - 80, 55, 14, 14, 0, 0);

  fill(255);
  textFont(fonteTitulo);
  textSize(15);
  textAlign(CENTER, CENTER);
  text("Quiz — Pergunta " + (perguntaAtual + 1) + " de " + perguntas.length, width/2, 52);

  // Barra de progresso
  float prog = (float)(perguntaAtual) / perguntas.length;
  fill(255, 255, 255, 50);
  rect(60, 72, width - 120, 6, 3);
  fill(255, 220, 50);
  rect(60, 72, (width - 120) * prog, 6, 3);

  // Pergunta
  fill(COR_TITULO);
  textFont(fonteTexto);
  textSize(15);
  textAlign(CENTER, TOP);
  textSize(17);
  fill(40, 60, 40);
  text(p.enunciado, 70, 100, width - 140, 90);

  // Dica
  if (mostrarDica) {
    fill(180, 100, 0);
    textSize(14);
    textAlign(CENTER, TOP);
    text("Dica: " + p.dica, 65, 162, width - 130, 35);
  }

  // Opções — 2 colunas
  for (int i = 0; i < p.opcoes.length; i++) {
    int col = i % 2;
    int row = i / 2;
    int bx = 60 + col * (width/2 - 45);
    int by = 205 + row * 80;
    int bw = width/2 - 60;
    int bh = 68;

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
    rect(bx, by, bw, bh, 10);
    noStroke();

    String letra = new String[]{"A","B","C","D"}[i];
    fill(respondida && i==p.respostaCorreta ? color(20,100,20) : color(80,120,80));
    textFont(fonteTitulo);
    textSize(16);
    textAlign(LEFT, CENTER);
    text(letra, bx + 20, by + bh/2 - 1);

    fill(respondida && i==p.respostaCorreta ? color(10,80,10) : COR_TITULO);
    textFont(fonteTexto);
    textSize(14);
    textAlign(LEFT, CENTER);
    textAlign(LEFT, CENTER);
    text(p.opcoes[i], bx + 42, by + bh/2 - 2);
  }

  // Feedback
  if (respondida) {
    boolean certo = (respostaSelecionada == p.respostaCorreta);
    fill(certo ? color(30, 120, 30) : color(160, 40, 40));
    rect(60, height - 95, width - 120, 50, 10);
    fill(255);
    textFont(fonteTexto);
    textSize(14);
    textAlign(CENTER, CENTER);
    textSize(13);
    text(p.fato, 75, height - 93, width - 150, 50);
    drawBotao("Proxima ->", width - 200, height - 38, 150, 32, -99);
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
  textSize(26);
  textAlign(CENTER, CENTER);
  text("Missao Verde", width/2, 55);
  fill(200, 255, 200);
  textFont(fonteTexto);
  textSize(14);
  text("O que voce pode fazer para ajudar a Amazonia?", width/2, 90);

  fill(255, 255, 255, 20);
  noStroke();
  rect(60, 115, width - 120, height - 155, 14);

  String[] missoes = {
    "Economize energia desligando luzes e aparelhos sem uso",
    "Evite desperdício de água durante o banho e na escovação",
    "Nunca descarte lixo em rios, ruas ou áreas verdes",
    "Aprenda sobre espécies ameaçadas e compartilhe conhecimento",
    "Prefira produtos com origem sustentável e certificada",
    "Plante árvores ou cuide de plantas para ajudar o meio ambiente"
};

  for (int i = 0; i < missoes.length; i++) {
    int my = 145 + i * 70;
    fill(255, 255, 255, 35);
    rect(75, my, width - 150, 56, 12);
    fill(255, 255, 255, 15);
    rect(77, my + 2, width - 154, 18, 8);
    fill(220, 255, 220);
    textFont(fonteTexto);
    textSize(14);
    textAlign(LEFT, CENTER);
    textAlign(LEFT, CENTER);
    text((i+1) + ".  " + missoes[i], 100, my + 29, width - 210, 40);
  }
}

// ============================================================
// TELA 5 — SELOS
// ============================================================

void drawSelos() {

  fill(COR_PAINEL);
  noStroke();
  rect(40, 25, width - 80, height - 45, 14);

  fill(80, 40, 130);
  rect(40, 25, width - 80, 58, 14, 14, 0, 0);

  fill(255);
  textFont(fonteTitulo);
  textSize(20);
  textAlign(CENTER, CENTER);
  text("Meus Selos de Guardiao", width/2, 54);

  // contador
  int totalSelos = 0;

  for (boolean s : selosDesbloqueados) {
    if (s) totalSelos++;
  }

  fill(220, 180, 255);
  textFont(fonteTexto);
  textSize(14);

  text(
    totalSelos + " de " + animais.length + " selos conquistados",
    width/2,
    78
  );

  // grade
  int cols = 4;
  int tam  = 105;
  int gap  = 16;

  int xIni =
    (width - (cols * (tam + gap) - gap)) / 2;

  for (int i = 0; i < animais.length; i++) {

    int col = i % cols;
    int row = i / cols;

    int sx = xIni + col * (tam + gap);
    int sy = 98 + row * (tam + gap);

    // fundo do selo
    if (selosDesbloqueados[i]) {

      fill(255, 210, 50);
      stroke(200, 150, 0);

    } else {

      fill(180);
      stroke(120);
    }

    strokeWeight(2);

    rect(sx, sy, tam, tam, 12);

    noStroke();

    // imagem do selo
    PImage selo;

    if (selosDesbloqueados[i]) {

      selo = selosAnimais[i];

    } else {

      selo = loadImage("selo_locked.png");
    }

    // desenhar imagem
    if (selo != null) {

      imageMode(CENTER);

      image(
        selo,
        sx + tam/2,
        sy + tam/2 - 8,
        tam - 12,
        tam - 12
      );

      imageMode(CORNER);
    }

    // nome do animal
    fill(40);

    textFont(fonteTexto);

    textSize(10);

    textAlign(CENTER, CENTER);

    text(
      animais[i].nomePopular,
      sx + tam/2,
      sy + tam - 14
    );
  }

  strokeWeight(1);
}
