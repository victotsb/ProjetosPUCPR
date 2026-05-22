// ============================================================
// APP MM — Arquivo Principal
// ============================================================

// ------------------------------------------------------------
// TELAS
// ------------------------------------------------------------

final int TELA_INICIAL = 0;
final int TELA_MAPA    = 1;
final int TELA_FICHA   = 2;
final int TELA_QUIZ    = 3;
final int TELA_MISSAO  = 4;
final int TELA_SELOS   = 5;

int currentScreen = TELA_INICIAL;

// ------------------------------------------------------------
// ESTADO GLOBAL
// ------------------------------------------------------------

int animalSelecionado = 0;

float pulsoTick = 0;

// ------------------------------------------------------------
// QUIZ
// ------------------------------------------------------------

int perguntaAtual = 0;
int tentativasErro = 0;

int acertos = 0;
int totalRespondidas = 0;

int respostaSelecionada = -1;

boolean mostrarDica = false;
boolean respondida = false;

// ------------------------------------------------------------
// IMAGENS
// ------------------------------------------------------------

PImage imgMapa;
PImage seloLocked;
PImage[] imagensAnimais;
PImage[] selosAnimais;

// ------------------------------------------------------------
// FONTES
// ------------------------------------------------------------

PFont fonteTitulo;
PFont fonteTexto;

// ------------------------------------------------------------
// CORES
// ------------------------------------------------------------

color COR_FUNDO     = color(34, 85, 34);
color COR_PAINEL    = color(245, 240, 220);

color COR_TITULO    = color(20, 60, 20);

color COR_DESTAQUE  = color(255, 165, 0);

color COR_CERTO     = color(60, 180, 60);
color COR_ERRADO    = color(200, 50, 50);

color COR_BOTAO     = color(30, 120, 60);
color COR_TEXTO_BTN = color(255);

// ------------------------------------------------------------
// DADOS
// ------------------------------------------------------------

Animal[] animais;
Pergunta[] perguntas;

boolean[] fichasVisitadas;
boolean[] selosDesbloqueados;

int[] ordemPerguntas;

int[] acertosPorGrupo = new int[5];
int[] totalPorGrupo   = new int[5];

// ============================================================
// SETUP
// ============================================================

void setup() {

  size(800, 600);

  smooth();

  // fontes
  inicializarFontes();

  // dados
  inicializarAnimais();

  inicializarPerguntas();

  inicializarSelos();

  // imagens
  carregarArquivos();

  // debug
  println("Animais: " + animais.length);
  println("Perguntas: " + perguntas.length);

  if (imagensAnimais != null) {
    println("Imagens: " + imagensAnimais.length);
  }

  println("Setup concluido!");
}

// ============================================================
// DRAW
// ============================================================

void draw() {

  atualizarSistema();

  renderizarTelaAtual();

  desenharUIFixa();
}

// ============================================================
// UPDATE GLOBAL
// ============================================================

void atualizarSistema() {

  pulsoTick += 0.05;

  background(COR_FUNDO);
}

// ============================================================
// RENDERIZAÇÃO
// ============================================================

void renderizarTelaAtual() {

  switch(currentScreen) {

    case TELA_INICIAL:
      drawTelaInicial();
      break;

    case TELA_MAPA:
      drawMapa();
      break;

    case TELA_FICHA:
      drawFichaAnimal();
      break;

    case TELA_QUIZ:
      drawQuiz();
      break;

    case TELA_MISSAO:
      drawMissaoVerde();
      break;

    case TELA_SELOS:
      drawSelos();
      break;
  }
}

// ============================================================
// UI FIXA
// ============================================================

void desenharUIFixa() {

  if(currentScreen != TELA_INICIAL) {
    drawBotaoVoltar();
  }
}

// ============================================================
// INPUT
// ============================================================

void mouseClicked() {

  // botão voltar
  if(cliqueBotaoVoltar()) {
    return;
  }

  // botão quiz na ficha
  if(currentScreen == TELA_FICHA) {

    int bx = width/2 - 90;
    int by = height - 60;
    int bw = 180;
    int bh = 38;

    if(
      mouseX >= bx &&
      mouseX <= bx + bw &&
      mouseY >= by &&
      mouseY <= by + bh
    ) {

      iniciarQuiz();

      currentScreen = TELA_QUIZ;

      return;
    }
  }

  // troca de telas
  switch(currentScreen) {

    case TELA_INICIAL:
      cliqueTelaInicial();
      break;

    case TELA_MAPA:
      cliqueMapa();
      break;

    case TELA_QUIZ:
      cliqueQuiz();
      break;
  }
}

// ============================================================
// BOTÃO VOLTAR
// ============================================================

boolean cliqueBotaoVoltar() {

  boolean clicou =
    currentScreen != TELA_INICIAL &&
    mouseX >= 10 &&
    mouseX <= 90 &&
    mouseY >= 10 &&
    mouseY <= 46;

  if(!clicou) {
    return false;
  }

  if(currentScreen == TELA_FICHA) {
    currentScreen = TELA_MAPA;
  }
  else {
    currentScreen = TELA_INICIAL;
  }

  return true;
}

// ============================================================
// FONTES
// ============================================================

void inicializarFontes() {

  fonteTitulo = createFont("Arial Bold", 28, true);

  fonteTexto = createFont("Arial", 16, true);
}

// ============================================================
// CARREGAMENTO GERAL
// ============================================================

void carregarArquivos() {

  // mapa
  imgMapa = loadImage("mapa_amazonia.png");

  if(imgMapa == null) {
    println("ERRO: mapa_amazonia.png nao encontrado");
  }

  // animais
  carregarImagensAnimais();

  // selos
  carregarSelos();
}
