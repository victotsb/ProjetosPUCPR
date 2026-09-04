const btnEnviar = document.getElementById("btnEnviar");
const lblRes = document.getElementById("lblResultado");

const ENDERECO_API = 'http://localhost/portal-api/salvar.php';

btnEnviar.onclick = async () => {
    const payload = {
        nome: document.getElementById("nome").value,
        email: document.getElementById("email").value,
        idade: document.getElementById("idade").value,
        area: document.getElementById("area-interesse").value,
        bio: document.getElementById("bio").value
    };

    if (!payload.nome || !payload.email || !payload.idade || !payload.area || !payload.bio) {
        lblRes.innerText = "Erro: Preencha todos os campos!";
        lblRes.style.color = "red";
        return;
    }

    try {
        lblRes.innerText = "Conectando ao servidor de API...";
        
        const resposta = await fetch(ENDERECO_API, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        });

        const json = await resposta.json();
        lblRes.innerText = json.mensagem;
        lblRes.style.color = "green";
        
    } catch (erro) {
        lblRes.innerText = "Erro: Não foi possível alcançar a API.";
        lblRes.style.color = "red";
        console.error(erro);
    }
};