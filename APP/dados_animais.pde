void inicializarAnimais() {
  animais = new Animal[] {

    // ── MAMÍFEROS (grupo 0) ─────────────────────────────
    // Onça-pintada: esquerda, na mata baixa
    new Animal("Onca-pintada", "Panthera onca", "🐆", 0,
               140, 513,
               "Florestas densas e margens de rios",
               "Capivaras, queixadas, jacarés",
               "Nada muito bem e caca dentro da agua!",
               "Em risco — ameacada pelo desmatamento",
               "1,5–2 m", "60–100 kg"),

    // Boto cor de rosa: no rio, centro da cena
    new Animal("Boto cor de rosa", "Inia geoffrensis", "🐬", 0,
               455, 445,
               "Rios e lagos da Amazonia",
               "Peixes e caranguejos",
               "Pode girar a cabeca 180 graus!",
               "Vulneravel — poluicao e pesca acidental",
               "2–2,5 m", "90–160 kg"),

    // Preguiça: galho da árvore grande à direita
    new Animal("Preguica-de-tres-dedos", "Bradypus tridactylus", "🦥", 0,
               972, 293,
               "Copas das arvores da floresta",
               "Folhas, brotos e flores",
               "Desce ao chao so uma vez por semana",
               "Pouco preocupante",
               "45–75 cm", "3–4,5 kg"),

    // ── AVES (grupo 1) ───────────────────────────────────
    // Harpia: topo da árvore alta no centro-esquerda
    new Animal("Harpia", "Harpia harpyja", "🦅", 1,
               318, 68,
               "Florestas densas de dossel alto",
               "Macacos, preguicas, cobras",
               "Maior aguia das Americas — garras do tamanho de patas de urso!",
               "Vulneravel — desmatamento",
               "86–107 cm", "4–9 kg"),

    // Tucano: esquerda, no galho baixo
    new Animal("Tucano toco", "Ramphastos toco", "🦅", 1,
               95, 365,
               "Florestas e areas abertas",
               "Frutas, insetos, ovos de outras aves",
               "O bico enorme regula a temperatura do corpo",
               "Pouco preocupante",
               "55–65 cm", "500–900 g"),

    // Arara azul: palmeira esquerda, pássaro azul
    new Animal("Arara azul", "Anodorhynchus hyacinthinus", "🦜", 1,
               275, 323,
               "Florestas abertas e cerrado amazonico",
               "Nozes de palmeira",
               "Tem forca de mordida de 70 kg!",
               "Vulneravel — trafico de animais",
               "1 m", "1,2–1,7 kg"),

    // ── RÉPTEIS E ANFÍBIOS (grupo 2) ────────────────────
    // Sucuri: sobre as pedras no centro do rio
    new Animal("Sucuri (Anaconda)", "Eunectes murinus", "🐍", 2,
               565, 390,
               "Rios, lagos e areas alagadas",
               "Capivaras, jacarés, peixes grandes",
               "A maior cobra do mundo — pode medir 9 metros!",
               "Pouco preocupante",
               "4–9 m", "30–250 kg"),

    // Jacaré-açu: beira do rio, baixo esquerda
    new Animal("Jacare-acu", "Melanosuchus niger", "🐊", 2,
               235, 677,
               "Rios, lagos e pantanos amazonicos",
               "Peixes, capivaras, aves aquaticas",
               "Pode chegar a 6 m — o maior crocodiliano das Americas!",
               "Vulneravel",
               "3–6 m", "300–400 kg"),

    // Tartaruga: praia de areia, centro-baixo
    new Animal("Tartaruga-da-Amazonia", "Podocnemis expansa", "🐢", 2,
               527, 737,
               "Rios de aguas brancas e praias de areia",
               "Plantas aquaticas, frutas",
               "A femea bota ate 130 ovos de uma vez!",
               "Vulneravel — caca e coleta de ovos",
               "70–90 cm", "60–90 kg"),

    // ── PEIXES (grupo 3) ─────────────────────────────────
    // Pirarucu: lago direita, peixe grande vermelho/marrom
    new Animal("Pirarucu", "Arapaima gigas", "🐟", 3,
               700, 638,
               "Lagos e rios de varzea amazonicos",
               "Peixes, crustaceos, aves pequenas",
               "Respira ar atmosferico — sobe a superficie a cada 10–20 min",
               "Dados insuficientes",
               "2–3 m", "150–200 kg"),

    // Piranha: lago direita, peixe menor
    new Animal("Piranha-vermelha", "Pygocentrus nattereri", "🐠", 3,
               820, 673,
               "Rios e lagos da Bacia Amazonica",
               "Peixes, carnaca, insetos",
               "Pode detectar sangue a quilometros de distancia",
               "Pouco preocupante",
               "25–33 cm", "1,8 kg"),

    // ── INVERTEBRADOS (grupo 4) ──────────────────────────
    // Aranha-caranguejeira: tronco da árvore grande direita
    new Animal("Aranha-caranguejeira", "Theraphosa blondi", "🕷", 4,
               773, 445,
               "Solo da floresta e tocas no chao",
               "Insetos, lagartos, sapos, roedores",
               "A maior aranha do mundo — pernas de ate 30 cm!",
               "Pouco preocupante",
               "13 cm (corpo)", "120–170 g")
  };

  fichasVisitadas = new boolean[animais.length];
}
