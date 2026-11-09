# AGENTS.md — Regras para agentes de IA e desenvolvedores

Este arquivo vale para **qualquer** assistente (Claude Code, Cursor, Copilot, Codex, Gemini,
etc.) e para humanos. Se a sua ferramenta lê outro arquivo (`CLAUDE.md`, `.cursorrules`), ele
apenas aponta para cá. **Em caso de conflito, este arquivo vence.**

---

## 0. Antes de escrever qualquer código

1. Trabalhe em **uma issue por vez**. Sem issue, não há trabalho: abra uma antes.
2. Leia a issue inteira, os critérios de aceite e os documentos citados nela.
3. Leia `docs/MODELO_DADOS.md` se a tarefa tocar dados e `docs/LGPD_E_SEGURANCA.md` se tocar
   autenticação, permissões ou dados pessoais. Tocou permissão? Leia
   `docs/adr/0002-permissoes-hierarquicas.md`. Tocou nome, WhatsApp ou redes? Leia
   `docs/adr/0003-protecao-de-dados.md`.
4. Se algo estiver ambíguo, **pare e pergunte na issue**. Não invente requisito.

## 1. Regras inegociáveis (o CI bloqueia ou o revisor recusa)

| # | Regra |
|---|---|
| R1 | **Nunca** fazer commit direto na `main`. Todo código entra por Pull Request. |
| R2 | **Nenhum PR sem teste.** Toda funcionalidade nova ou bug corrigido traz teste automatizado. |
| R3 | `npm run check` (lint + tipos + testes + build) **passa localmente** antes de abrir o PR. |
| R4 | **Nenhum campo de dado pessoal novo** fora da lista em `docs/MODELO_DADOS.md`. Para adicionar um, abra um ADR e peça aprovação. CPF, RG, endereço, data de nascimento, e-mail exibido e foto de documento são **proibidos**. |
| R5 | **Toda tabela nova tem RLS habilitada e política explícita**, com teste provando que um usuário **não** lê dados de outro. |
| R6 | **Nunca** usar a chave `service_role` (ou equivalente com acesso total) em código que roda no navegador. |
| R7 | **Nenhum segredo no repositório**: chaves, tokens e senhas ficam em `.env.local` (no `.gitignore`) e nos secrets da plataforma. |
| R8 | Mudança de banco **somente via migration versionada** em `supabase/migrations/`. Nunca editar o banco de produção pelo painel. |
| R9 | **Nenhuma dependência nova** sem justificar no PR: para que serve, por que não dá para fazer sem ela, e se é mantida. |
| R10 | Nunca desativar teste, lint ou checagem para "fazer passar". Se um teste está errado, corrija o teste e explique no PR. |
| R11 | Não logar dados pessoais (WhatsApp, nome) em `console.log`, logs de servidor ou mensagens de erro. |
| R12 | PR pequeno: idealmente **menos de 400 linhas alteradas**, um assunto só. |
| R13 | **Dado pessoal (nome, WhatsApp, redes) só é gravado cifrado**, em colunas `*_enc`, e só é cifrado e decifrado em `src/server/crypto/`, no servidor. Nunca no navegador, nunca em texto puro no banco (ADR 0003). |
| R14 | **O navegador não consulta direto as tabelas com dado pessoal.** Ele passa pelo servidor, que usa o JWT do usuário (a RLS continua valendo). |
| R15 | **Toda decisão de acesso usa as funções SQL `app.can_*`** (ADR 0002). Não reimplementar a regra de papel ou escopo no front. Esconder botão é conforto, não segurança. |
| R16 | **Todo PR que toca permissão atualiza `supabase/tests/permissions_matrix.test.sql`**, com pelo menos um caso "fora do escopo → negado". |
| R17 | **Toda tabela de negócio tem `organization_id`** e filtra por organização na RLS (ADR 0004). |
| R18 | Arquivos críticos (`supabase/`, `src/server/crypto/`, `src/server/auth/`, `.github/`, `AGENTS.md`) só entram com **aprovação do code owner**. |

## 2. Convenções

- **Idioma:** código, nomes de variáveis, tabelas e commits em **inglês**; interface,
  documentação e issues em **português**.
- **Branch:** `tipo/numero-da-issue-descricao-curta`
  (ex.: `feat/12-cadastro-perfil`, `fix/31-filtro-bairro`).
- **Commit:** [Conventional Commits](https://www.conventionalcommits.org/)
  (`feat:`, `fix:`, `test:`, `docs:`, `refactor:`, `chore:`), citando a issue (`refs #12`).
- **PR:** use o template e coloque `Closes #NN` na descrição.
- **TypeScript estrito.** Proibido `any` sem comentário explicando o motivo.
- **Validação de entrada** com schema (Zod) **no servidor**, sempre. Validação no cliente é
  só conforto para o usuário.

## 3. Stack (proposta — ver `docs/adr/0001-stack.md`)

- Next.js (App Router) + TypeScript
- Supabase (Postgres + Auth + Row Level Security)
- Testes: Vitest (unidade), Playwright (ponta a ponta) e testes SQL de RLS (pgTAP via `supabase test db`)
- Hospedagem com plano gratuito (definida no ADR 0001)

> Enquanto o ADR 0001 estiver como **Proposto**, não crie código de produção. Só a tarefa de
> scaffold do M0 pode criar a estrutura inicial.

## 4. Definição de pronto (DoD)

Uma tarefa só está pronta quando:

- [ ] Todos os critérios de aceite da issue foram atendidos.
- [ ] Há testes cobrindo o caminho feliz **e** pelo menos um caso de erro ou permissão negada.
- [ ] `npm run check` passa localmente e no CI.
- [ ] Nenhum dado pessoal novo; se a tarefa cria tabela, há teste de RLS.
- [ ] Documentação atualizada se a mudança altera comportamento, dados ou o modo de rodar.
- [ ] O PR foi revisado e aprovado por **outra pessoa** (não pelo autor nem pela IA do autor).

## 5. Como pedir trabalho à sua IA (modelo de prompt)

```
Leia AGENTS.md, docs/MODELO_DADOS.md e a issue #NN (colada abaixo).
Implemente SOMENTE o que a issue pede.
Antes de codar, liste os arquivos que vai criar ou alterar e os testes que vai escrever.
Escreva os testes primeiro, depois o código, e rode `npm run check`.
Não adicione dependências nem campos de dados sem me perguntar.
```

## 6. O que fazer quando a IA "travar"

- Se ela quiser desabilitar RLS, usar `service_role` no cliente, apagar teste, adicionar
  campo pessoal, gravar nome ou WhatsApp sem cifrar, ou checar permissão só no front:
  **recuse** e releia a seção 1.
- Se o CI falhar e a correção não for óbvia: comente o erro na issue e peça ajuda. Não force
  merge.
