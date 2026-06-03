// ============================================================
// UTILITÁRIOS DE DESENHO
// ============================================================
void drawBotao(String label, int x, int y, int w, int h, int alvo) {
  boolean hov = (mouseX>=x && mouseX<=x+w && mouseY>=y && mouseY<=y+h);

  // sombra
  fill(0, 0, 0, 70);
  noStroke();
  rect(x + 4, y + 4, w, h, 14);

  if (hov) {
    fill(60, 185, 100);
  } else {
    fill(38, 148, 76);
  }

  rect(x, y, w, h, 14);

  // brilho superior
  fill(255, 255, 255, hov ? 50 : 30);
  rect(x + 2, y + 2, w - 4, h/2, 12);

  // borda suave
  stroke(255, 255, 255, 60);
  noFill();
  rect(x, y, w, h, 14);
  noStroke();

  // texto
  fill(255);
  textFont(fonteTexto);
  textSize(17);
  textAlign(CENTER, CENTER);
  text(label, x + w/2, y + h/2 - 1);
}

void drawBotaoVoltar() {
  boolean hov = mouseX >= 10 && mouseX <= 90 && mouseY >= 10 && mouseY <= 46;

  fill(0, 0, 0, hov ? 200 : 160);
  noStroke();
  rect(10, 10, 80, 36, 10);

  fill(255);
  textFont(fonteTexto);
  textSize(14);
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
