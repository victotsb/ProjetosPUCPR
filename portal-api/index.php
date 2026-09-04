<?php

$nome = "Victor";
$idade = 19;
$curso = "Ciência da Computação";
$semestre = 2;

echo "<h1>Portal de Ciência da Computação</h1>";
echo "<h3>Perfil do Desenvolvedor</h3>";
echo "<b>Nome:</b> " . $nome . "<br>";
echo "<b>Curso:</b> " . $curso . "<br>";
echo "<b>Idade:</b> " . $idade . " anos<br>";

echo "<hr>"; 

if ($idade >= 18) {
    echo "<strong>Status:</strong> Acesso Liberado (Maior de idade).";
} else {
    echo "<strong>Status:</strong> Acesso Restrito (Menor de idade).";
}

$anos_para_formar = 4 - ($semestre / 2); 
echo "<br><strong>Estimativa:</strong> Faltam aproximadamente " . $anos_para_formar . " anos para a graduação.";

echo "<hr>";
echo "<h4>Log de Cadastros (JSON):</h4>";
if(file_exists('dados.json')) {
    echo "<a href='dados.json' target='_blank'>Ver arquivo JSON gerado</a>";
} else {
    echo "Nenhum cadastro realizado ainda.";
}
?>