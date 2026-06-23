"""
Conectivos aceitos:
  Negação:       ~  !  ¬
  Conjunção:     &  &&  ^  ∧
  Disjunção:     |  ||  v  ∨   (v minúsculo = disjunção; V maiúsculo = constante VERDADEIRO)
  Implicação:    ->  =>  →
  Bicondicional: <->  <=>  ↔
  Constantes:    V (verdadeiro)  F (falso)  1 (verdadeiro)  0 (falso)
"""

import re
import itertools
from typing import Dict, List, Tuple, Optional

CONSTANTES = {'V', 'F', '0', '1'}


def normalizar(formula: str) -> str:
    subs = [
        (r'<->|<=>|↔',                        ' <-> '),
        (r'->|=>|→',                           ' -> '),
        (r'\|\||∨',                            ' | '),
        (r'(?<![a-zA-Z0-9])v(?![a-zA-Z0-9])', ' | '),  # v minúsculo isolado = disjunção
        (r'&&|∧|\^',                           ' & '),
        (r'¬|!',                               ' ~ '),
        (r'\|(?!\|)',                           ' | '),
        (r'&(?!&)',                             ' & '),
    ]
    for p, s in subs:
        formula = re.sub(p, s, formula)
    return formula


def tokenizar(formula: str) -> List[str]:
    formula = normalizar(formula)
    formula = formula.replace('(', ' ( ').replace(')', ' ) ')
    return [t for t in re.findall(r'<->|->|~|[&|()]|[a-zA-Z][a-zA-Z0-9_]*|[01]', formula) if t.strip()]


def extrair_variaveis(tokens: List[str]) -> List[str]:
    vistas, variaveis = set(), []
    for t in tokens:
        if t in CONSTANTES: continue
        if re.match(r'^[a-zA-Z][a-zA-Z0-9_]*$', t) and t not in vistas:
            vistas.add(t); variaveis.append(t)
    if all(len(v) == 1 for v in variaveis):
        variaveis.sort()
    return variaveis

class Parser:
    def __init__(self, tokens):
        self.tokens = tokens; self.pos = 0

    def peek(self):
        return self.tokens[self.pos] if self.pos < len(self.tokens) else None

    def consume(self, esp=None):
        tok = self.tokens[self.pos]
        if esp and tok != esp:
            raise SyntaxError(f"Esperado '{esp}', encontrado '{tok}'")
        self.pos += 1; return tok

    def parse(self):
        no = self.bicondicional()
        if self.pos < len(self.tokens):
            raise SyntaxError(f"Token inesperado: '{self.peek()}'")
        return no

    def bicondicional(self):
        e = self.implicacao()
        while self.peek() == '<->': self.consume(); e = ('<->', e, self.implicacao())
        return e

    def implicacao(self):
        e = self.disjuncao()
        while self.peek() == '->': self.consume(); e = ('->', e, self.disjuncao())
        return e

    def disjuncao(self):
        e = self.conjuncao()
        while self.peek() == '|': self.consume(); e = ('|', e, self.conjuncao())
        return e

    def conjuncao(self):
        e = self.negacao()
        while self.peek() == '&': self.consume(); e = ('&', e, self.negacao())
        return e

    def negacao(self):
        if self.peek() == '~': self.consume(); return ('~', self.negacao())
        return self.atomo()

    def atomo(self):
        tok = self.peek()
        if tok == '(':
            self.consume('('); no = self.bicondicional(); self.consume(')'); return no
        if tok in CONSTANTES:
            self.consume(); return ('const', tok in ('V', '1'))
        if tok and re.match(r'^[a-zA-Z][a-zA-Z0-9_]*$', tok):
            self.consume(); return ('var', tok)
        raise SyntaxError(f"Átomo inesperado: '{tok}'")


def parse(formula: str):
    tokens = tokenizar(formula)
    return Parser(tokens).parse(), tokens


def avaliar(no, valores: Dict[str, bool]) -> bool:
    op = no[0]
    if op == 'var':   return valores[no[1]]
    if op == 'const': return no[1]
    if op == '~':     return not avaliar(no[1], valores)
    e, d = avaliar(no[1], valores), avaliar(no[2], valores)
    if op == '&':   return e and d
    if op == '|':   return e or d
    if op == '->':  return (not e) or d
    if op == '<->': return e == d
    raise ValueError(f"Operador desconhecido: {op}")


def subexpressoes(no) -> List:
    resultado = []
    vistas = set()

    def visitar(n):
        s = arvore_para_str(n)
        if s in vistas: return
        vistas.add(s)
        if n[0] == '~':
            visitar(n[1])
        elif n[0] in ('&', '|', '->', '<->'):
            visitar(n[1]); visitar(n[2])
        if n[0] not in ('var', 'const'):
            resultado.append(n)

    visitar(no)
    return resultado


def arvore_para_str(no) -> str:
    op = no[0]
    if op == 'var':   return no[1]
    if op == 'const': return 'V' if no[1] else 'F'
    if op == '~':
        f = no[1]
        if f[0] in ('&', '|', '->', '<->'):
            return f"¬({arvore_para_str(f)})"
        return f"¬{arvore_para_str(f)}"
    s = {'&': '∧', '|': '∨', '->': '→', '<->': '↔'}[op]
    return f"({arvore_para_str(no[1])} {s} {arvore_para_str(no[2])})"


def imprimir_tabela(formula: str):
    arvore, tokens = parse(formula)
    variaveis = extrair_variaveis(tokens)

    subs = subexpressoes(arvore)
    raiz_str = arvore_para_str(arvore)

    colunas_header = variaveis + [arvore_para_str(s) for s in subs]

    larguras = [max(3, len(h)) for h in colunas_header]

    cabecalho_parts = []
    for i, (h, w) in enumerate(zip(colunas_header, larguras)):
        marcador = "⇓" if h == raiz_str else " "
        cabecalho_parts.append(f"{marcador}{h:^{w}}")
    cab = "  ".join(cabecalho_parts)

    sep = "─" * len(cab)

    print("\n" + "═" * len(cab))
    print(f"  Fórmula: {formula}")
    print("═" * len(cab))
    print(cab)
    print(sep)

    resultados = []
    for combo in itertools.product([True, False], repeat=len(variaveis)):
        vals = dict(zip(variaveis, combo))

        partes = [f" {'V' if combo[i] else 'F':^{larguras[i]}}" for i in range(len(variaveis))]

        offset = len(variaveis)
        for j, sub in enumerate(subs):
            v = avaliar(sub, vals)
            partes.append(f" {'V' if v else 'F':^{larguras[offset + j]}}")

        res = avaliar(arvore, vals)
        resultados.append(res)
        print("  ".join(partes))

    print(sep)

    qtd_v = sum(resultados)
    qtd_f = len(resultados) - qtd_v
    if all(resultados):
        classif = "TAUTOLOGIA (sempre verdadeira)"
    elif not any(resultados):
        classif = "CONTRADIÇÃO (sempre falsa)"
    else:
        classif = "CONTINGÊNCIA (nem sempre verdadeira)"

    print(f"\n  Classificação : {classif}")
    print(f"  Verdadeiro: {qtd_v}  |  Falso: {qtd_f}")
    print("═" * len(cab))

    return variaveis, resultados, classif


def tabela_verdade(formula: str):
    arvore, tokens = parse(formula)
    variaveis = extrair_variaveis(tokens)
    linhas, resultados = [], []
    for combo in itertools.product([True, False], repeat=len(variaveis)):
        vals = dict(zip(variaveis, combo))
        linhas.append(list(combo))
        resultados.append(avaliar(arvore, vals))
    return variaveis, linhas, resultados


def gerar_fnd(formula: str) -> str:
    variaveis, linhas, resultados = tabela_verdade(formula)
    comps = []
    for linha, res in zip(linhas, resultados):
        if res:
            lits = [v if val else f"~{v}" for v, val in zip(variaveis, linha)]
            comps.append(" ∧ ".join(lits))
    if not comps:              return "F  (contradição — FND vazia)"
    if len(comps) == len(linhas): return "V  (tautologia)"
    if len(comps) == 1:        return f"({comps[0]})"
    return " ∨ ".join(f"({c})" for c in comps)


def gerar_fnc(formula: str) -> str:
    variaveis, linhas, resultados = tabela_verdade(formula)
    comps = []
    for linha, res in zip(linhas, resultados):
        if not res:
            lits = [f"~{v}" if val else v for v, val in zip(variaveis, linha)]
            comps.append(" ∨ ".join(lits))
    if not comps:              return "V  (tautologia — FNC vazia)"
    if len(comps) == len(linhas): return "F  (contradição)"
    if len(comps) == 1:        return f"({comps[0]})"
    return " ∧ ".join(f"({c})" for c in comps)



def iguais(a, b) -> bool:
    if a[0] != b[0]: return False
    if a[0] in ('var', 'const'): return a[1] == b[1]
    if a[0] == '~': return iguais(a[1], b[1])
    return iguais(a[1], b[1]) and iguais(a[2], b[2])


def e_negacao(a, b) -> bool:
    if a[0] == '~' and iguais(a[1], b): return True
    if b[0] == '~' and iguais(b[1], a): return True
    return False


def simplificar(formula: str) -> List[Tuple[str, str]]:
    passos: List[Tuple[str, str]] = []
    arvore, _ = parse(formula)
    ultimo = [arvore_para_str(arvore)]

    def registrar(lei, no):
        s = arvore_para_str(no)
        if s != ultimo[0]:
            passos.append((lei, s)); ultimo[0] = s

    # 1. Eliminar → e ↔
    def elim_impl(no):
        op = no[0]
        if op in ('var', 'const'): return no
        if op == '~': return ('~', elim_impl(no[1]))
        e, d = elim_impl(no[1]), elim_impl(no[2])
        if op == '->':  return ('|', ('~', e), d)
        if op == '<->': return ('&', ('|', ('~', e), d), ('|', ('~', d), e))
        return (op, e, d)

    apos_elim = elim_impl(arvore)
    registrar("Eliminação de → e ↔  [ (A→B) ≡ (¬A∨B) ]", apos_elim)

    # 2. De Morgan + dupla negação
    def intern_neg(no):
        op = no[0]
        if op in ('var', 'const'): return no
        if op == '~':
            f = intern_neg(no[1])
            if f[0] == '~':     return intern_neg(f[1])
            if f[0] == '&':     return intern_neg(('|', ('~', f[1]), ('~', f[2])))
            if f[0] == '|':     return intern_neg(('&', ('~', f[1]), ('~', f[2])))
            if f[0] == 'const': return ('const', not f[1])
            return ('~', f)
        return (op, intern_neg(no[1]), intern_neg(no[2]))

    apos_neg = intern_neg(apos_elim)
    registrar("De Morgan + dupla negação  [ ¬(A∧B)≡¬A∨¬B  |  ¬¬A≡A ]", apos_neg)

    # 3–7. Simplificações algébricas (uma regra por vez, pós-ordem)
    def reduzir(no):
        op = no[0]
        if op in ('var', 'const'): return no, None
        if op == '~':
            f, lei = reduzir(no[1])
            return (('~', f), lei) if lei else (no, None)
        e, lei = reduzir(no[1])
        if lei: return (op, e, no[2]), lei
        d, lei = reduzir(no[2])
        if lei: return (op, no[1], d), lei
        e, d = no[1], no[2]

        if op in ('|', '&') and iguais(e, d):
            return e, f"Idempotência  [ A {'∨' if op=='|' else '∧'} A ≡ A ]"
        if op == '|' and e_negacao(e, d):
            return ('const', True),  "Complemento  [ A ∨ ¬A ≡ V ]"
        if op == '&' and e_negacao(e, d):
            return ('const', False), "Complemento  [ A ∧ ¬A ≡ F ]"
        if op == '|':
            if iguais(d, ('const', False)): return e, "Identidade  [ A ∨ F ≡ A ]"
            if iguais(e, ('const', False)): return d, "Identidade  [ F ∨ A ≡ A ]"
            if iguais(d, ('const', True)):  return ('const', True),  "Absorvente  [ A ∨ V ≡ V ]"
            if iguais(e, ('const', True)):  return ('const', True),  "Absorvente  [ V ∨ A ≡ V ]"
        if op == '&':
            if iguais(d, ('const', True)):  return e, "Identidade  [ A ∧ V ≡ A ]"
            if iguais(e, ('const', True)):  return d, "Identidade  [ V ∧ A ≡ A ]"
            if iguais(d, ('const', False)): return ('const', False), "Absorvente  [ A ∧ F ≡ F ]"
            if iguais(e, ('const', False)): return ('const', False), "Absorvente  [ F ∧ A ≡ F ]"
        if op == '|' and d[0] == '&':
            if iguais(e, d[1]) or iguais(e, d[2]): return e, "Absorção  [ A ∨ (A∧B) ≡ A ]"
        if op == '|' and e[0] == '&':
            if iguais(d, e[1]) or iguais(d, e[2]): return d, "Absorção  [ (A∧B) ∨ A ≡ A ]"
        if op == '&' and d[0] == '|':
            if iguais(e, d[1]) or iguais(e, d[2]): return e, "Absorção  [ A ∧ (A∨B) ≡ A ]"
        if op == '&' and e[0] == '|':
            if iguais(d, e[1]) or iguais(d, e[2]): return d, "Absorção  [ (A∨B) ∧ A ≡ A ]"
        return no, None

    atual = apos_neg
    for _ in range(50):
        novo, lei = reduzir(atual)
        if lei is None: break
        atual = novo
        registrar(lei, atual)

    passos.append(("FND — Forma Normal Disjuntiva (linhas V da tabela)", gerar_fnd(formula)))
    passos.append(("FNC — Forma Normal Conjuntiva (linhas F da tabela)", gerar_fnc(formula)))
    return passos


def imprimir_simplificacao(formula: str):
    arvore, _ = parse(formula)
    passos = simplificar(formula)

    print("\n" + "─" * 65)
    print("  MANIPULAÇÃO SINTÁTICA E SIMPLIFICAÇÃO")
    print("─" * 65)
    print(f"  Original : {arvore_para_str(arvore)}\n")

    for i, (lei, resultado) in enumerate(passos, 1):
        print(f"  [{i}] {lei}")
        print(f"      → {resultado}\n")

    print("─" * 65)


def verificar_equivalencia(f1: str, f2: str):
    a1, t1 = parse(f1); a2, t2 = parse(f2)
    v1 = extrair_variaveis(t1); v2 = extrair_variaveis(t2)
    todas = list(dict.fromkeys(v1 + v2))
    if all(len(v) == 1 for v in todas): todas.sort()

    print("\n" + "═" * 60)
    print("  VERIFICAÇÃO DE EQUIVALÊNCIA LÓGICA")
    print("═" * 60)
    print(f"  F1 : {f1}\n  F2 : {f2}")
    print(f"\n  Variáveis: {', '.join(todas)}\n")

    cab = "  ".join(f"{v:^5}" for v in todas) + "  │  F1  │  F2"
    print(cab); print("─" * len(cab))

    equiv = True
    for combo in itertools.product([True, False], repeat=len(todas)):
        vals = dict(zip(todas, combo))
        r1, r2 = avaliar(a1, vals), avaliar(a2, vals)
        if r1 != r2: equiv = False
        vs = "  ".join(f"{'V' if v else 'F':^5}" for v in combo)
        marca = "  ✗" if r1 != r2 else ""
        print(f"{vs}  │  {'V' if r1 else 'F'}   │  {'V' if r2 else 'F'}{marca}")

    print("─" * len(cab))
    if equiv:
        print("\n  ✓  As fórmulas SÃO logicamente equivalentes  (F1 ≡ F2)")
    else:
        print("\n  ✗  As fórmulas NÃO são logicamente equivalentes")
    print("═" * 60)



AJUDA = """
╔══════════════════════════════════════════════════════════╗
║       SOLVER DE LÓGICA PROPOSICIONAL                     ║
╠══════════════════════════════════════════════════════════╣
║  Conectivos aceitos:                                     ║
║    Negação:        ~  !  ¬                               ║
║    Conjunção:      &  &&  ^  ∧                           ║
║    Disjunção:      |  ||  v  ∨  (v minúsculo)            ║
║    Implicação:     ->  =>  →                             ║
║    Bicondicional:  <->  <=>  ↔                           ║
║    Constantes:     V (verdadeiro)   F (falso)            ║
║                                                          ║
║  Exemplos:                                               ║
║    p -> q                                                ║
║    ~(p & q) <-> (~p | ~q)                                ║
║    (~Q^(~P -> Q)) -> R                                   ║
║                                                          ║
║  Comandos:                                               ║
║    [fórmula]           Tabela-verdade + simplificação    ║
║    eq [f1] ; [f2]      Verificar equivalência            ║
║    ajuda               Esta ajuda                        ║
║    sair                Encerrar                          ║
╚══════════════════════════════════════════════════════════╝
"""


def main():
    print(AJUDA)
    while True:
        try:
            entrada = input("\n▶ ").strip()
        except (EOFError, KeyboardInterrupt):
            print("\nEncerrando."); break

        if not entrada: continue
        if entrada.lower() in ('sair', 'exit', 'quit'):
            print("Encerrando."); break
        if entrada.lower() in ('ajuda', 'help', '?'):
            print(AJUDA); continue

        if entrada.lower().startswith('eq ') and ';' in entrada:
            partes = entrada[3:].split(';', 1)
            try: verificar_equivalencia(partes[0].strip(), partes[1].strip())
            except Exception as e: print(f"  Erro: {e}")
            continue

        formula = entrada
        try:
            imprimir_tabela(formula)
            imprimir_simplificacao(formula)
        except Exception as e:
            print(f"  Erro ao processar '{formula}': {e}")
            print("  Digite 'ajuda' para ver exemplos de uso.")


if __name__ == '__main__':
    main()
