// ============================================================
// PERGUNTAS DO QUIZ
// ============================================================
void inicializarPerguntas() {
  perguntas = new Pergunta[] {

    new Pergunta("Qual animal tem o maior bico em relacao ao corpo entre as aves da Amazonia?",
      new String[]{"Harpia", "Tucano toco", "Arara azul", "Garca"},
      1, 4, "tucano", "Pense no pássaro colorido de bico bem comprido",
      "O bico do tucano e metade do tamanho do seu corpo!", 1),

    new Pergunta("O que a onca-pintada come?",
      new String[]{"Folhas e frutas", "Capivaras e jacarés", "Nozes de palmeira", "Peixes e algas"},
      1, 0, "onca", "Pense em um predador de topo!",
      "A onca e o maior felino das Americas", 0),

    new Pergunta("Onde o boto cor de rosa vive?",
      new String[]{"No oceano Atlantico", "Em rios e lagos da Amazonia", "Na floresta entre as arvores", "Em regioes frias do Sul"},
      1, 1, "boto", "E um animal aquatico de agua doce",
      "O boto e unico e so existe na America do Sul", 0),

    new Pergunta("Qual e o maior peixe de agua doce da Amazonia?",
      new String[]{"Piranha-vermelha", "Tucunare", "Pirarucu", "Tambaqui"},
      2, 9, "pirarucu", "Pode medir mais de 2 metros!",
      "O pirarucu pode pesar 200 kg", 3),

    new Pergunta("A preguica-de-tres-dedos come principalmente:",
      new String[]{"Insetos e frutas", "Folhas e brotos de arvores", "Peixes e ras", "Sementes e raizes"},
      1, 2, "preguica", "Pense no lugar onde ela passa a vida inteira",
      "A preguica raramente desce das arvores", 0),

    new Pergunta("Qual desses animais e uma ave da Amazonia?",
      new String[]{"Ariranha", "Jacare-acu", "Harpia", "Pirarucu"},
      2, 3, "harpia", "Tem asas e penas!",
      "A harpia caca macacos e preguicas", 1),

    new Pergunta("O jacare-acu pertence ao grupo dos:",
      new String[]{"Mamiferos", "Aves", "Repteis", "Peixes"},
      2, 7, "jacare", "E de sangue frio e tem escamas",
      "Crocodilos e jacarés sao répteis", 2),

    new Pergunta("Qual animal usa o bico para regular a temperatura do corpo?",
      new String[]{"Arara azul", "Harpia", "Tucano toco", "Jacamim"},
      2, 4, "tucano", "O bico tem vasos sanguineos que liberam calor",
      "E como um ar condicionado natural!", 1),

    new Pergunta("Por que o desmatamento e um problema para a harpia?",
      new String[]{"Ela nao gosta de calor", "Ela perde as arvores onde faz seu ninho gigante", "Ela come madeira", "Nao e um problema"},
      1, 3, "harpia", "Pense onde ela coloca seus ovos",
      "A harpia precisa de arvores enormes para ninhar", 1),

    new Pergunta("O boto cor de rosa esta ameacado principalmente por:",
      new String[]{"Predadores como tubaroes", "Poluicao dos rios e pesca acidental", "Falta de peixes no mar", "Mudancas climaticas no Artico"},
      1, 1, "boto", "Pense no que acontece com os rios quando o homem polui",
      "Redes de pesca capturam botos por acidente", 0),

    new Pergunta("O que podemos fazer para ajudar a onca-pintada?",
      new String[]{"Cacar animais que ela comeria", "Apoiar areas de protecao ambiental", "Derrubar florestas para ela ter espaco", "Nada — ela esta bem"},
      1, 0, "onca", "Pense em preservar o lugar onde ela vive",
      "Reservas e parques protegem a onca", 0),

    new Pergunta("Qual e a cobra mais pesada do mundo, encontrada na Amazonia?",
      new String[]{"Cobra-coral", "Jararaca", "Sucuri (Anaconda)", "Cascavel"},
      2, 6, "sucuri", "Ela vive em rios e pode medir 9 metros",
      "A sucuri e o maior reptil em massa corporal do planeta!", 2),

    new Pergunta("A tartaruga-da-Amazonia e importante para o ecossistema porque:",
      new String[]{"Come todos os outros animais", "Dispersa sementes ao se alimentar", "Produz oxigenio diretamente", "Nao tem importancia ecologica"},
      1, 8, "tartaruga", "Pense no que acontece depois que um animal come frutas...",
      "Animais que comem frutas espalham sementes e fazem a floresta crescer!", 2),

    new Pergunta("O pirarucu sobe a superficie da agua porque:",
      new String[]{"Gosta de tomar sol", "Precisa respirar ar atmosferico", "Come insetos na superficie", "Foge de predadores do fundo"},
      1, 9, "pirarucu", "Ele tem um orgao especial alem das guelras",
      "O pirarucu tem uma bexiga natatoria que funciona como pulmao!", 3),

    new Pergunta("Qual e o maior crocodiliano das Americas?",
      new String[]{"Jacare-do-pantanal", "Jacare-acu", "Caimao-de-oculos", "Crocodilo-do-nilo"},
      1, 7, "jacare", "Ele vive na Amazonia e pode medir 6 metros",
      "O jacare-acu pode pesar mais de 400 kg!", 2)
  };

  ordemPerguntas = new int[perguntas.length];
  for (int i = 0; i < perguntas.length; i++) ordemPerguntas[i] = i;
  embaralhar(ordemPerguntas);
}
