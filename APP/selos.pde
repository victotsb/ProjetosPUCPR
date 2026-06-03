// ============================================================
// SELOS
// ============================================================

void inicializarSelos() {
  selosDesbloqueados = new boolean[animais.length];
}

void verificarSelos() {
  // Selos por ficha visitada
  for (int i = 0; i < animais.length; i++) {
    if (fichasVisitadas[i]) selosDesbloqueados[i] = true;
  }

  // Selo especial: mapa completo (todas as fichas visitadas)
  boolean todasVisitadas = true;
  for (boolean v : fichasVisitadas) {
    if (!v) { todasVisitadas = false; break; }
  }
  if (todasVisitadas) seloMapaDesbloqueado = true;
}

void verificarSeloQuiz() {
  if (totalRespondidas == 0) return;
  float pct = (float) acertos / totalRespondidas * 100;
  if (pct > melhorPorcentagemQuiz) melhorPorcentagemQuiz = pct;

  if (melhorPorcentagemQuiz >= 80) {
    nivelSeloQuiz = 3; // ouro
  } else if (melhorPorcentagemQuiz >= 60) {
    nivelSeloQuiz = max(nivelSeloQuiz, 2); // prata
  } else if (melhorPorcentagemQuiz >= 40) {
    nivelSeloQuiz = max(nivelSeloQuiz, 1); // bronze
  }
  quizCompleto = true;
}

void carregarSelos() {
  selosAnimais = new PImage[animais.length];

  String[] arquivos = {
    "selo_onca.png",
    "selo_boto.png",
    "selo_preguica.png",
    "selo_harpia.png",
    "selo_tucano.png",
    "selo_arara.png",
    "selo_sucuri.png",
    "selo_jacare.png",
    "selo_tartaruga.png",
    "selo_pirarucu.png",
    "selo_piranha.png",
    "selo_aranha.png"
  };

  for (int i = 0; i < arquivos.length; i++) {
    selosAnimais[i] = loadImage(arquivos[i]);
  }

  seloLocked = loadImage("selo_locked.png");
}

int contarFichasVisitadas() {
  int c = 0;
  for (boolean v : fichasVisitadas) if (v) c++;
  return c;
}
