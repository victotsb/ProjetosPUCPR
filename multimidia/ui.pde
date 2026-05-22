// ============================================================
// UTILITÁRIOS DE DESENHO
// ============================================================
void drawBotao(String label, int x, int y, int w, int h, int alvo) {
  boolean hov = (mouseX>=x && mouseX<=x+w && mouseY>=y && mouseY<=y+h);

  // sombra
  fill(0, 0, 0, 60);
  noStroke();
  rect(x + 3, y + 3, w, h, 12);

  // gradiente simples visual
  if (hov) {
    fill(55, 170, 90);
  } else {
    fill(35, 135, 70);
  }

  rect(x, y, w, h, 12);

  // brilho superior
  fill(255, 255, 255, hov ? 40 : 25);
  rect(x + 2, y + 2, w - 4, h/2, 10);

  // borda suave
  stroke(255, 255, 255, 50);
  noFill();
  rect(x, y, w, h, 12);
  noStroke();

  // texto
  fill(255);
  textFont(fonteTexto);
  textSize(15);
  textAlign(CENTER, CENTER);
  text(label, x + w/2, y + h/2 - 1);
}

void drawBotaoVoltar() {
  boolean hov = mouseX >= 10 && mouseX <= 90 && mouseY >= 10 && mouseY <= 46;

  fill(0, 0, 0, hov ? 190 : 150);
  noStroke();
  rect(10, 10, 80, 36, 10);

  fill(255);
  textFont(fonteTexto);
  textSize(13);
  textAlign(CENTER, CENTER);
  text("← Voltar", 50, 28);
}

color corGrupo(int g) {
  color[] c = {
    color(180, 80,  40),
    color(30,  120, 200),
    color(40,  160, 80),
    color(20,  100, 160),
    color(120, 50,  150)
  };
  return c[constrain(g, 0, 4)];
}
