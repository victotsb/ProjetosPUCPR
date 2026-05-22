// ============================================================
// SELOS
// ============================================================
void inicializarSelos() { selosDesbloqueados = new boolean[animais.length]; }

void verificarSelos() {
  for (int i = 0; i < animais.length; i++)
    if (fichasVisitadas[i]) selosDesbloqueados[i] = true;
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
}

int contarFichasVisitadas() {
  int c = 0;
  for (boolean v : fichasVisitadas) if (v) c++;
  return c;
}
