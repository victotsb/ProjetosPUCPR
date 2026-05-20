// ============================================================
// APP MM — Fauna Amazônica: Conhecer para Preservar
// Código base em Processing
// ============================================================
// ESTRUTURA:
//   - Classe Animal (dados de cada espécie)
//   - Classe Pergunta (banco de quiz)
//   - Sistema de telas (currentScreen)
//   - Mapa interativo, Fichas, Quiz, Missão Verde, Selos
// ============================================================

// --- TELAS ---
// 0 = Início | 1 = Mapa | 2 = Ficha | 3 = Quiz | 4 = Missão Verde | 5 = Selos
int currentScreen = 0;
int animalSelecionado = 0;
int perguntaAtual = 0;
int tentativasErro = 0;
boolean mostrarDica = false;

// --- CORES ---
color COR_FUNDO     = color(34, 85, 34);
color COR_PAINEL    = color(245, 240, 220);
color COR_TITULO    = color(20, 60, 20);
color COR_DESTAQUE  = color(255, 165, 0);
color COR_CERTO     = color(60, 180, 60);
color COR_ERRADO    = color(200, 50, 50);
color COR_BOTAO     = color(30, 120, 60);
color COR_TEXTO_BTN = color(255);

// --- FONTES ---
PFont fonteTitulo, fonteTexto;

// --- DADOS: ANIMAIS ---
Animal[] animais;
boolean[] fichasVisitadas;

// --- DADOS: QUIZ ---
Pergunta[] perguntas;
int[] ordemPerguntas;
int acertos = 0;
int totalRespondidas = 0;
int respostaSelecionada = -1;
boolean respondida = false;

// --- GAMIFICAÇÃO ---
boolean[] selosDesbloqueados; // um selo por animal (12 total) + selos especiais
int[] acertosPorGrupo = new int[5]; // índices: 0=mamiferos 1=aves 2=repteis 3=peixes 4=invertebrados
int[] totalPorGrupo   = new int[5];

// ============================================================
// SETUP
// ============================================================
void setup() {
  size(800, 600);
  smooth();

  fonteTitulo = createFont("Arial Bold", 28, true);
  fonteTexto  = createFont("Arial", 16, true);

  inicializarAnimais();
  inicializarPerguntas();
  inicializarSelos();
}

// ============================================================
// DRAW — roteador de telas
// ============================================================
void draw() {
  background(COR_FUNDO);

  switch (currentScreen) {
    case 0: drawTelaInicial();    break;
    case 1: drawMapa();           break;
    case 2: drawFichaAnimal();    break;
    case 3: drawQuiz();           break;
    case 4: drawMissaoVerde();    break;
    case 5: drawSelos();          break;
  }

  // Botão voltar (visível em todas as telas exceto inicial)
  if (currentScreen != 0) {
    drawBotaoVoltar();
  }
}

// ============================================================
// TELA 0 — INICIAL
// ============================================================
void drawTelaInicial() {
  // Fundo com gradiente simulado
  for (int i = 0; i < height; i++) {
    float t = map(i, 0, height, 0, 1);
    stroke(lerp(34, 10, t), lerp(85, 50, t), lerp(34, 10, t));
    line(0, i, width, i);
  }

  // Título
  textFont(fonteTitulo);
  fill(255, 220, 50);
  textAlign(CENTER, CENTER);
  textSize(32);
  text("APP MM", width/2, 100);

  fill(255);
  textSize(20);
  text("Fauna Amazônica", width/2, 145);
  textSize(14);
  fill(200, 240, 200);
  text("Conhecer para Preservar", width/2, 175);

  // Botões principais
  drawBotao("🗺  Explorar o Mapa",    width/2 - 120, 240, 240, 52, 1);
  drawBotao("❓  Quiz",               width/2 - 120, 310, 240, 52, 3);
  drawBotao("🌿  Missão Verde",        width/2 - 120, 380, 240, 52, 4);
  drawBotao("🏅  Meus Selos",         width/2 - 120, 450, 240, 52, 5);

  // Progresso geral
  textFont(fonteTexto);
  textSize(13);
  fill(200, 240, 200);
  int fichasVistas = contarFichasVisitadas();
  float pctAcertos = totalRespondidas > 0 ? (float)acertos / totalRespondidas * 100 : 0;
  text("Fichas vistas: " + fichasVistas + "/12   |   Acertos no Quiz: " + nf(pctAcertos, 0, 0) + "%", width/2, 535);
}

// ============================================================
// TELA 1 — MAPA INTERATIVO
// ============================================================
void drawMapa() {
  // Fundo verde escuro (substitua por loadImage para um mapa ilustrado)
  background(20, 80, 30);

  textFont(fonteTitulo);
  fill(255, 220, 50);
  textAlign(CENTER);
  textSize(22);
  text("Mapa da Amazônia", width/2, 40);

  textFont(fonteTexto);
  fill(200, 240, 200);
  textSize(13);
  text("Toque num animal para conhecê-lo!", width/2, 65);

  // Desenhar cada animal como um ícone clicável
  for (int i = 0; i < animais.length; i++) {
    Animal a = animais[i];
    boolean visitado = fichasVisitadas[i];

    // Círculo de fundo
    if (visitado) {
      fill(255, 200, 50, 200);  // dourado se já visitou
    } else {
      fill(255, 255, 255, 180); // branco se ainda não visitou
    }
    noStroke();
    ellipse(a.mapX, a.mapY, 44, 44);

    // Ícone (emoji como texto — alternativa: desenhar formas)
    textAlign(CENTER, CENTER);
    textSize(20);
    text(a.icone, a.mapX, a.mapY - 2);

    // Nome abaixo
    textSize(10);
    fill(255);
    text(a.nomePopular, a.mapX, a.mapY + 28);
  }
}

// ============================================================
// TELA 2 — FICHA DO ANIMAL
// ============================================================
void drawFichaAnimal() {
  Animal a = animais[animalSelecionado];

  // Painel central
  fill(COR_PAINEL);
  noStroke();
  rect(60, 30, width - 120, height - 60, 18);

  // Cabeçalho colorido por grupo
  fill(corGrupo(a.grupo));
  rect(60, 30, width - 120, 80, 18, 18, 0, 0);

  // Ícone grande
  textAlign(CENTER, CENTER);
  textSize(48);
  text(a.icone, 130, 70);

  // Nome
  fill(255);
  textFont(fonteTitulo);
  textSize(22);
  textAlign(LEFT, CENTER);
  text(a.nomePopular, 175, 55);

  fill(220, 240, 220);
  textFont(fonteTexto);
  textSize(13);
  text(a.nomeCientifico, 175, 85);

  // Conteúdo da ficha
  fill(COR_TITULO);
  textSize(14);
  int yBase = 140;
  int espacamento = 70;

  drawCampoFicha("🏠 Onde vive",     a.habitat,      80, yBase);
  drawCampoFicha("🍃 O que come",    a.alimentacao,  80, yBase + espacamento);
  drawCampoFicha("✨ Curiosidade",   a.curiosidade,  80, yBase + espacamento*2);
  drawCampoFicha("⚠ Conservação",   a.conservacao,  80, yBase + espacamento*3);

  // Tamanho e peso
  fill(120);
  textSize(12);
  textAlign(RIGHT);
  text("Tamanho: " + a.tamanho + "   Peso: " + a.peso, width - 80, yBase);
  textAlign(LEFT);

  // Marcar como visitada
  fichasVisitadas[animalSelecionado] = true;
  verificarSelos();
}

void drawCampoFicha(String rotulo, String valor, int x, int y) {
  fill(80, 120, 80);
  textFont(fonteTitulo);
  textSize(13);
  text(rotulo, x, y);

  fill(60);
  textFont(fonteTexto);
  textSize(14);
  // Quebra de linha simples (Processing não faz wrap automático)
  text(valor, x, y + 22, width - 160, 40);
}

// ============================================================
// TELA 3 — QUIZ
// ============================================================
void drawQuiz() {
  if (perguntas.length == 0) return;

  Pergunta p = perguntas[ordemPerguntas[perguntaAtual]];

  // Painel
  fill(COR_PAINEL);
  noStroke();
  rect(40, 30, width - 80, height - 60, 14);

  // Cabeçalho
  fill(COR_BOTAO);
  rect(40, 30, width - 80, 60, 14, 14, 0, 0);

  fill(255);
  textFont(fonteTitulo);
  textSize(16);
  textAlign(CENTER, CENTER);
  text("Quiz — Pergunta " + (perguntaAtual + 1) + " de " + perguntas.length, width/2, 60);

  // Pergunta
  fill(COR_TITULO);
  textFont(fonteTexto);
  textSize(16);
  textAlign(CENTER, TOP);
  text(p.enunciado, 70, 115, width - 140, 80);

  // Dica (aparece após 2 erros)
  if (mostrarDica) {
    fill(200, 120, 0);
    textSize(13);
    text("💡 Dica: " + p.dica, 70, 185, width - 140, 40);
  }

  // Opções de resposta
  for (int i = 0; i < p.opcoes.length; i++) {
    int bx = 70;
    int by = 230 + i * 72;
    int bw = width - 140;
    int bh = 60;

    color corOpcao = color(220, 235, 220);
    if (respondida) {
      if (i == p.respostaCorreta) corOpcao = COR_CERTO;
      else if (i == respostaSelecionada) corOpcao = COR_ERRADO;
    } else if (i == respostaSelecionada) {
      corOpcao = COR_DESTAQUE;
    }

    fill(corOpcao);
    stroke(180);
    strokeWeight(1);
    rect(bx, by, bw, bh, 10);
    noStroke();

    fill(respondida && i == p.respostaCorreta ? 255 : COR_TITULO);
    textFont(fonteTexto);
    textSize(14);
    textAlign(CENTER, CENTER);
    text(p.opcoes[i], bx + bw/2, by + bh/2);
  }

  // Feedback pós-resposta
  if (respondida) {
    boolean certo = (respostaSelecionada == p.respostaCorreta);
    fill(certo ? COR_CERTO : COR_ERRADO);
    textSize(15);
    textAlign(CENTER);
    text(certo ? "✓ Correto! Parabéns!" : "✗ Ops! Veja a ficha do animal.", width/2, 540);

    // Botão próxima
    drawBotao("Próxima →", width/2 - 80, 555, 160, 40, -1); // -1 = ação especial
  }
}

// ============================================================
// TELA 4 — MISSÃO VERDE
// ============================================================
void drawMissaoVerde() {
  // Estrutura similar ao Quiz, mas com visual diferente
  for (int i = 0; i < height; i++) {
    float t = map(i, 0, height, 0, 1);
    stroke(lerp(20, 50, t), lerp(100, 130, t), lerp(20, 50, t));
    line(0, i, width, i);
  }

  fill(255, 220, 50);
  textFont(fonteTitulo);
  textSize(24);
  textAlign(CENTER);
  text("🌿 Missão Verde", width/2, 60);

  fill(200, 255, 200);
  textFont(fonteTexto);
  textSize(15);
  text("O que você pode fazer para ajudar a Amazônia?", width/2, 95);

  // Aqui você coloca as perguntas de missão (array separado)
  // Estrutura igual ao Quiz — omitida para brevidade
  fill(255);
  textSize(14);
  textAlign(CENTER, CENTER);
  text("(Implemente as perguntas de missão aqui\nseguindo o mesmo padrão do Quiz)", width/2, height/2);
}

// ============================================================
// TELA 5 — SELOS
// ============================================================
void drawSelos() {
  fill(COR_PAINEL);
  noStroke();
  rect(40, 30, width - 80, height - 60, 14);

  fill(80, 40, 120);
  rect(40, 30, width - 80, 60, 14, 14, 0, 0);

  fill(255);
  textFont(fonteTitulo);
  textSize(20);
  textAlign(CENTER, CENTER);
  text("🏅 Meus Selos de Guardião", width/2, 60);

  int colunas = 4;
  int tamanho = 110;
  int margem  = 20;
  int xInicio = (width - (colunas * (tamanho + margem))) / 2 + margem;

  for (int i = 0; i < animais.length; i++) {
    int col = i % colunas;
    int row = i / colunas;
    int sx  = xInicio + col * (tamanho + margem);
    int sy  = 110 + row * (tamanho + margem);

    if (selosDesbloqueados[i]) {
      fill(255, 210, 50);
      stroke(200, 150, 0);
    } else {
      fill(180);
      stroke(130);
    }
    strokeWeight(2);
    rect(sx, sy, tamanho, tamanho, 12);
    noStroke();

    textAlign(CENTER, CENTER);
    textSize(30);
    text(animais[i].icone, sx + tamanho/2, sy + tamanho/2 - 10);

    fill(selosDesbloqueados[i] ? color(80, 40, 0) : color(100));
    textFont(fonteTexto);
    textSize(11);
    text(animais[i].nomePopular, sx + tamanho/2, sy + tamanho - 18);
  }
}

// ============================================================
// INTERAÇÃO — MOUSE
// ============================================================
void mouseClicked() {
  // Botão voltar
  if (currentScreen != 0 && mouseX >= 10 && mouseX <= 80 && mouseY >= 10 && mouseY <= 45) {
    if (currentScreen == 2) currentScreen = 1;
    else currentScreen = 0;
    return;
  }

  switch (currentScreen) {
    case 0: cliqueTelaInicial();  break;
    case 1: cliqueMapa();         break;
    case 2: cliqueFicha();        break;
    case 3: cliqueQuiz();         break;
  }
}

void cliqueTelaInicial() {
  // Detectar clique nos botões da tela inicial
  int bx = width/2 - 120;
  int bw = 240;
  int bh = 52;
  int[] telas = {1, 3, 4, 5};
  int[] ys    = {240, 310, 380, 450};

  for (int i = 0; i < telas.length; i++) {
    if (mouseX >= bx && mouseX <= bx + bw && mouseY >= ys[i] && mouseY <= ys[i] + bh) {
      currentScreen = telas[i];
      if (currentScreen == 3) iniciarQuiz();
      return;
    }
  }
}

void cliqueMapa() {
  for (int i = 0; i < animais.length; i++) {
    float d = dist(mouseX, mouseY, animais[i].mapX, animais[i].mapY);
    if (d < 26) {
      animalSelecionado = i;
      currentScreen = 2;
      return;
    }
  }
}

void cliqueFicha() {
  // Clique em qualquer lugar da ficha vai para o quiz daquele animal
  // (você pode adicionar botão específico aqui)
}

void cliqueQuiz() {
  if (respondida) {
    // Botão "Próxima"
    if (mouseX >= width/2 - 80 && mouseX <= width/2 + 80 && mouseY >= 555 && mouseY <= 595) {
      proximaPergunta();
    }
    return;
  }

  Pergunta p = perguntas[ordemPerguntas[perguntaAtual]];

  for (int i = 0; i < p.opcoes.length; i++) {
    int by = 230 + i * 72;
    if (mouseX >= 70 && mouseX <= width - 70 && mouseY >= by && mouseY <= by + 60) {
      respostaSelecionada = i;
      respondida = true;

      if (i == p.respostaCorreta) {
        acertos++;
        acertosPorGrupo[p.grupoAnimal]++;
        tentativasErro = 0;
        mostrarDica = false;
      } else {
        tentativasErro++;
        if (tentativasErro >= 2) mostrarDica = true;
      }
      totalRespondidas++;
      totalPorGrupo[p.grupoAnimal]++;
      verificarSelos();
      return;
    }
  }
}

// ============================================================
// LÓGICA DO QUIZ
// ============================================================
void iniciarQuiz() {
  perguntaAtual = 0;
  respostaSelecionada = -1;
  respondida = false;
  tentativasErro = 0;
  mostrarDica = false;

  // Embaralhar ordem das perguntas
  ordemPerguntas = new int[perguntas.length];
  for (int i = 0; i < perguntas.length; i++) ordemPerguntas[i] = i;
  embaralhar(ordemPerguntas);
}

void proximaPergunta() {
  perguntaAtual++;
  respostaSelecionada = -1;
  respondida = false;

  if (!mostrarDica) tentativasErro = 0;

  if (perguntaAtual >= perguntas.length) {
    // Fim do quiz — volta para tela inicial com resultado
    currentScreen = 0;
    perguntaAtual = 0;
  }
}

void embaralhar(int[] arr) {
  for (int i = arr.length - 1; i > 0; i--) {
    int j = (int) random(i + 1);
    int tmp = arr[i];
    arr[i] = arr[j];
    arr[j] = tmp;
  }
}

// ============================================================
// SELOS E GAMIFICAÇÃO
// ============================================================
void inicializarSelos() {
  selosDesbloqueados = new boolean[animais.length];
}

void verificarSelos() {
  for (int i = 0; i < animais.length; i++) {
    if (fichasVisitadas[i]) {
      selosDesbloqueados[i] = true;
    }
  }
  // Aqui você pode adicionar selos especiais por desempenho no quiz
}

int contarFichasVisitadas() {
  int c = 0;
  for (boolean v : fichasVisitadas) if (v) c++;
  return c;
}

// ============================================================
// UTILITÁRIOS DE DESENHO
// ============================================================
void drawBotao(String label, int x, int y, int w, int h, int alvoTela) {
  boolean hover = (mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h);

  fill(hover ? color(50, 160, 80) : COR_BOTAO);
  noStroke();
  rect(x, y, w, h, 10);

  fill(COR_TEXTO_BTN);
  textFont(fonteTexto);
  textSize(15);
  textAlign(CENTER, CENTER);
  text(label, x + w/2, y + h/2);
}

void drawBotaoVoltar() {
  fill(0, 0, 0, 120);
  noStroke();
  rect(10, 10, 70, 34, 8);

  fill(255);
  textFont(fonteTexto);
  textSize(13);
  textAlign(CENTER, CENTER);
  text("← Voltar", 45, 27);
}

color corGrupo(int grupo) {
  color[] cores = {
    color(180, 80, 40),   // Mamíferos — terracota
    color(30, 120, 200),  // Aves — azul
    color(40, 160, 80),   // Répteis/anfíbios — verde
    color(20, 100, 160),  // Peixes — azul escuro
    color(120, 50, 150)   // Invertebrados — roxo
  };
  return cores[constrain(grupo, 0, 4)];
}

// ============================================================
// DADOS: INICIALIZAR ANIMAIS
// ============================================================
void inicializarAnimais() {
  animais = new Animal[] {
    // Mamíferos (grupo 0)
    new Animal("Onça-pintada",        "Panthera onca",             "🐆", 0, 200, 200,
               "Florestas densas e margens de rios", "Capivaras, queixadas, jacarés",
               "Nada muito bem e caça dentro da água!", "Em risco — ameaçada pelo desmatamento",
               "1,5–2 m", "60–100 kg"),
    new Animal("Boto cor de rosa",    "Inia geoffrensis",          "🐬", 0, 310, 280,
               "Rios e lagos da Amazônia", "Peixes e caranguejos",
               "Pode girar a cabeça 180°!", "Vulnerável — poluição e pesca acidental",
               "2–2,5 m", "90–160 kg"),
    new Animal("Ariranha",            "Pteronura brasiliensis",    "🦦", 0, 420, 220,
               "Rios e lagos de água doce", "Peixes, tartarugas, cobras d'água",
               "Vive em grupos familiares barulhentos", "Ameaçada — caça e destruição do habitat",
               "1,5–1,8 m", "26–32 kg"),
    new Animal("Preguiça-de-três-dedos","Bradypus tridactylus",   "🦥", 0, 540, 300,
               "Copas das árvores da floresta", "Folhas, brotos e flores",
               "Desce ao chão só uma vez por semana", "Pouco preocupante",
               "45–75 cm", "3–4,5 kg"),

    // Aves (grupo 1)
    new Animal("Arara azul",          "Anodorhynchus hyacinthinus","🦜", 1, 160, 350,
               "Florestas abertas e cerrado amazônico", "Nozes de palmeira",
               "Tem força de mordida de 70 kg!", "Vulnerável — tráfico de animais",
               "1 m", "1,2–1,7 kg"),
    new Animal("Tucano toco",         "Ramphastos toco",           "🦅", 1, 300, 400,
               "Florestas e áreas abertas", "Frutas, insetos, ovos de outras aves",
               "O bico enorme regula a temperatura do corpo", "Pouco preocupante",
               "55–65 cm", "500–900 g"),
    new Animal("Harpia",              "Harpia harpyja",            "🦅", 1, 450, 360,
               "Florestas densas de baixo dossel", "Macacos, preguiças, cobras",
               "Maior águia das Américas — garras do tamanho de patas de urso!", "Vulnerável — desmatamento",
               "86–107 cm", "4–9 kg"),

    // Répteis e anfíbios (grupo 2)
    new Animal("Jacaré-açu",          "Melanosuchus niger",        "🐊", 2, 200, 450,
               "Rios, lagos e pântanos amazônicos", "Peixes, capivaras, aves aquáticas",
               "Pode chegar a 6 m — o maior crocodiliano das Américas!", "Vulnerável",
               "3–6 m", "300–400 kg"),
    new Animal("Tartaruga-da-Amazônia","Podocnemis expansa",       "🐢", 2, 370, 480,
               "Rios de águas brancas e praias de areia", "Plantas aquáticas, frutas",
               "A fêmea bota até 130 ovos de uma vez!", "Vulnerável — caça e coleta de ovos",
               "70–90 cm", "60–90 kg"),

    // Peixes (grupo 3)
    new Animal("Pirarucu",            "Arapaima gigas",            "🐟", 3, 500, 430,
               "Lagos e rios de várzea amazônicos", "Peixes, crustáceos, aves pequenas",
               "Respira ar atmosférico — sobe a superfície a cada 10–20 min", "Dados insuficientes",
               "2–3 m", "150–200 kg"),
    new Animal("Piranha-vermelha",    "Pygocentrus nattereri",     "🐠", 3, 600, 380,
               "Rios e lagos da Bacia Amazônica", "Peixes, carniça, insetos",
               "Pode detectar sangue a quilômetros de distância", "Pouco preocupante",
               "25–33 cm", "1,8 kg"),

    // Invertebrados (grupo 4)
    new Animal("Aranha-caranguejeira","Theraphosa blondi",         "🕷", 4, 560, 280,
               "Solo da floresta e tocas no chão", "Insetos, lagartos, sapos, roedores",
               "A maior aranha do mundo — pernas de até 30 cm!", "Pouco preocupante",
               "13 cm (corpo)", "120–170 g")
  };

  fichasVisitadas = new boolean[animais.length];
}

// ============================================================
// DADOS: INICIALIZAR PERGUNTAS DO QUIZ
// (Banco de 15 exemplos — expanda até 40!)
// ============================================================
void inicializarPerguntas() {
  perguntas = new Pergunta[] {
    // --- Identificação por imagem / nome ---
    new Pergunta("Qual animal é famoso por ter o maior bico em relação ao corpo entre as aves da Amazônia?",
      new String[]{"Harpia", "Tucano toco", "Arara azul", "Garça"},
      1, 0, "grupo 1", "Pense no animal que usamos para simbolizar a Amazônia colorida",
      "🦅 O bico do tucano é metade do tamanho do seu corpo!", 1),

    // --- Associação ---
    new Pergunta("O que a onça-pintada come?",
      new String[]{"Folhas e frutas", "Capivaras e jacarés", "Nozes de palmeira", "Peixes e algas"},
      1, 1, "onça-pintada", "Pense em um predador de topo!", "🐆 A onça é o maior felino das Américas", 0),

    new Pergunta("Onde o boto cor de rosa vive?",
      new String[]{"No oceano Atlântico", "Em rios e lagos da Amazônia", "Na floresta entre as árvores", "Em regiões frias do Sul"},
      1, 0, "boto", "É um animal aquático de água doce", "🐬 O boto é único e só existe na América do Sul", 0),

    new Pergunta("Qual é o maior peixe de água doce da Amazônia?",
      new String[]{"Piranha-vermelha", "Tucunaré", "Pirarucu", "Tambaqui"},
      2, 3, "pirarucu", "Pode medir mais de 2 metros!", "🐟 O pirarucu pode pesar 200 kg", 3),

    new Pergunta("A preguiça-de-três-dedos come principalmente:",
      new String[]{"Insetos e frutas", "Folhas e brotos de árvores", "Peixes e rãs", "Sementes e raízes"},
      1, 0, "preguiça", "Pense no lugar onde a preguiça passa a vida inteira", "🦥 A preguiça raramente desce das árvores", 0),

    new Pergunta("Qual desses animais é uma ave da Amazônia?",
      new String[]{"Ariranha", "Jacaré-açu", "Harpia", "Pirarucu"},
      2, 1, "harpia", "Tem asas e penas!", "🦅 A harpia caça macacos e preguiças", 1),

    new Pergunta("O jacaré-açu pertence ao grupo dos:",
      new String[]{"Mamíferos", "Aves", "Répteis", "Peixes"},
      2, 2, "jacaré", "É de sangue frio e tem escamas", "🐊 Crocodilos e jacarés são répteis", 2),

    new Pergunta("Qual animal usa o bico enorme para regular a temperatura do corpo?",
      new String[]{"Arara azul", "Harpia", "Tucano toco", "Jacamim"},
      2, 1, "tucano", "O bico tem vasos sanguíneos que liberam calor", "🦅 É como um ar condicionado natural!", 1),

    // --- Reflexão / conservação ---
    new Pergunta("Por que o desmatamento é um problema para a harpia?",
      new String[]{"Ela não gosta de calor", "Ela perde as árvores onde faz seu ninho gigante", "Ela come madeira", "Não é um problema"},
      1, 2, "harpia", "Pense onde ela coloca seus ovos", "🦅 A harpia precisa de árvores enormes para ninhar", 1),

    new Pergunta("O boto cor de rosa está ameaçado principalmente por:",
      new String[]{"Predadores naturais como tubarões", "Poluição dos rios e pesca acidental", "Falta de peixes no mar", "Mudanças climáticas no Ártico"},
      1, 1, "boto", "Pense no que acontece com os rios quando o homem polui", "🐬 Redes de pesca capturam botos por acidente", 0),

    new Pergunta("O que podemos fazer para ajudar a onça-pintada?",
      new String[]{"Caçar animais que ela comeria", "Apoiar a criação de áreas de proteção ambiental", "Derrubar florestas para ela ter mais espaço aberto", "Nada — ela está bem"},
      1, 1, "onça", "Pense em preservar o lugar onde ela vive", "🐆 Reservas e parques protegem a onça", 0),

    new Pergunta("Por que a ariranha está ameaçada?",
      new String[]{"Por ser muito barulhenta", "Pela caça e destruição do seu habitat aquático", "Por não se adaptar ao calor", "Por comer poucos peixes"},
      1, 1, "ariranha", "O que os humanos fazem com rios e florestas?", "🦦 A ariranha precisa de rios limpos e matas preservadas", 0),

    new Pergunta("Qual animal é chamado de 'Guardião dos Rios'?",
      new String[]{"Onça-pintada", "Boto cor de rosa", "Ariranha", "Jacaré-açu"},
      1, 2, "ariranha", "Ela vive nos rios e lagos e come peixes", "🦦 A ariranha mantém o equilíbrio dos peixes nos rios", 0),

    new Pergunta("A tartaruga-da-Amazônia é importante para o ecossistema porque:",
      new String[]{"Come todos os outros animais", "Dispersa sementes ao se alimentar e defecar em lugares distantes", "Produz oxigênio diretamente", "Não tem importância ecológica"},
      1, 1, "tartaruga", "Pense no que acontece depois que um animal come frutas...", "🐢 Animais que comem frutas espalham sementes e fazem a floresta crescer!", 2),

    new Pergunta("O pirarucu sobe à superfície da água porque:",
      new String[]{"Gosta de tomar sol", "Precisa respirar ar atmosférico", "Come insetos na superfície", "Foge de predadores do fundo"},
      1, 1, "pirarucu", "Ele tem um órgão especial além das guelras", "🐟 O pirarucu tem uma bexiga natatória que funciona como pulmão!", 3)
  };

  // Inicializar ordem aleatória
  ordemPerguntas = new int[perguntas.length];
  for (int i = 0; i < perguntas.length; i++) ordemPerguntas[i] = i;
  embaralhar(ordemPerguntas);
}

// ============================================================
// CLASSES
// ============================================================

class Animal {
  String nomePopular, nomeCientifico, icone;
  int grupo;         // 0=mamiferos 1=aves 2=repteis 3=peixes 4=invertebrados
  float mapX, mapY;  // posição no mapa
  String habitat, alimentacao, curiosidade, conservacao, tamanho, peso;

  Animal(String np, String nc, String ic, int g, float mx, float my,
         String hab, String ali, String cur, String con, String tam, String pes) {
    nomePopular  = np;  nomeCientifico = nc; icone = ic; grupo = g;
    mapX = mx;  mapY = my;
    habitat = hab; alimentacao = ali; curiosidade = cur;
    conservacao = con; tamanho = tam; peso = pes;
  }
}

class Pergunta {
  String enunciado;
  String[] opcoes;
  int respostaCorreta;
  int animalRef;    // índice do animal associado (para redirecionar à ficha)
  String nomeAnimal;
  String dica;
  String fato;
  int grupoAnimal;  // para acertosPorGrupo[]

  Pergunta(String en, String[] op, int rc, int ar, String na, String di, String fa, int ga) {
    enunciado = en; opcoes = op; respostaCorreta = rc;
    animalRef = ar; nomeAnimal = na; dica = di; fato = fa; grupoAnimal = ga;
  }
}
