# Onboarding — comece por aqui

Bem-vindo(a)! Seguindo este guia, você sai **com o projeto rodando e o primeiro PR aberto**.
Tempo estimado: 2 a 3 horas.

> Os comandos `npm run …` abaixo são o **contrato do projeto**. Eles passam a existir quando
> as issues de scaffold e de ambiente do M0 forem concluídas. Até lá, o passo 3 ainda não
> funciona.

---

## Passo 1 — Leia (30 min)

Leia nesta ordem. Não pule o `AGENTS.md`.

1. [`README.md`](../README.md): o que é o projeto.
2. [`AGENTS.md`](../AGENTS.md): **as regras**. A sua IA também precisa segui-las.
3. [`CONTRIBUTING.md`](../CONTRIBUTING.md): o fluxo de issue → branch → PR.
4. [`docs/GESTAO_EQUIPE.md`](GESTAO_EQUIPE.md): como a equipe se organiza.
5. Resumo dos ADRs [0002](adr/0002-permissoes-hierarquicas.md),
   [0003](adr/0003-protecao-de-dados.md) e [0005](adr/0005-framework-e-hierarquia-generica.md):
   permissões, criptografia e por que o código é genérico.

## Passo 2 — Contas (15 min)

- [ ] Conta no GitHub com **autenticação em dois fatores ativa** (obrigatório).
- [ ] Mande o seu usuário do GitHub para o gestor do projeto e **aceite o convite** de
      colaborador.
- [ ] Entre no grupo da equipe e apresente-se em
      [Discussions → Apresentações](../../../discussions).

Você **não** recebe acesso a produção. Ninguém da equipe de desenvolvimento recebe: é de
propósito.

## Passo 3 — Ambiente (30 a 60 min)

Escolha **um** dos caminhos.

### Caminho A — Na sua máquina (recomendado se tiver 8 GB de RAM ou mais)

Pré-requisitos:

| Ferramenta | Para quê | Como instalar |
|---|---|---|
| Git | código | `git --version` |
| Node.js 22 | app | [fnm](https://github.com/Schniz/fnm) ou nvm: `fnm install 22` |
| Docker | banco local (Supabase) | Docker Desktop, OrbStack (Mac) ou Docker Engine (Linux) |
| Editor + sua IA | desenvolver | VS Code, Cursor, Claude Code… |

```bash
git clone git@github.com:felipemaion/Complexo42.git
cd Complexo42
npm run setup     # cria .env.local com chaves de TESTE, instala dependências,
                  # sobe o Supabase no Docker, aplica migrations e o seed fictício
npm run dev       # abre http://localhost:3000
npm run check     # lint + tipos + testes + build: tem que passar ANTES de todo PR
```

### Caminho B — Devcontainer ou GitHub Codespaces (máquina fraca ou sem Docker)

- **Codespaces:** no GitHub, *Code → Codespaces → Create*. Tudo vem pronto no navegador.
  O plano gratuito dá cerca de 60 horas por mês numa máquina de 2 núcleos; **desligue o
  Codespace quando parar**.
- **Devcontainer local:** VS Code + extensão *Dev Containers* → "Reopen in Container".

Depois rode `npm run setup` e `npm run dev`, como no caminho A.

### Por que o Docker roda só o banco, e não o app inteiro?

O Supabase local (Postgres, Auth, API) roda em contêineres gerenciados pela CLI do Supabase:
é aí que o Docker é indispensável. O app Next.js roda direto no Node, porque o *hot reload*
dentro do Docker fica lento, principalmente no Mac. Quem quer **tudo** em contêiner usa o
caminho B.

### Comandos do dia a dia

| Comando | O que faz |
|---|---|
| `npm run setup` | Prepara tudo do zero (pode rodar de novo) |
| `npm run dev` | App em modo desenvolvimento |
| `npm run check` | Tudo o que o CI roda. **Obrigatório antes do PR** |
| `npm test` | Testes unitários (Vitest) |
| `npm run test:e2e` | Testes ponta a ponta (Playwright) |
| `npm run db:start` / `db:stop` | Sobe ou para o Supabase local |
| `npm run db:reset` | Recria o banco local com migrations e seed |
| `npm run db:test` | Testes de RLS e permissões (pgTAP) |

Painel do banco local (Supabase Studio): http://localhost:54323. Ali só há **dados
fictícios**.

## Passo 4 — Configure sua IA (10 min)

- Claude Code lê o `CLAUDE.md`, que aponta para o `AGENTS.md`. Cursor, Copilot e outros:
  configure a ferramenta para ler o `AGENTS.md`.
- Use o modelo de prompt da seção 5 do `AGENTS.md`.
- **Nunca cole dados reais** (nomes, telefones) no chat da IA.

## Passo 5 — Primeira contribuição

1. No [quadro do projeto](../../../projects), pegue uma issue com o label
   `bom-primeiro-issue` na coluna **Pronta**.
2. Atribua-se e mova para **Em andamento**. **Uma issue por vez.**
3. Branch, testes, código, `npm run check` e PR (ver `CONTRIBUTING.md`).
4. Responda a revisão. Depois do merge, comemore no grupo. 🎉

## Problemas comuns

| Sintoma | Solução |
|---|---|
| `Cannot connect to the Docker daemon` | Abra o Docker Desktop/OrbStack e espere ele iniciar |
| Porta 54321/54322/3000 em uso | `npm run db:stop`; feche outro projeto Supabase; `lsof -i :3000` |
| Banco local "estranho" | `npm run db:reset` |
| Máquina lenta com o Supabase | Use o Codespaces (caminho B) |
| `npm run check` falha e a IA quer desativar a regra | **Não desative.** Peça ajuda na issue ou em Discussions |

## Checklist final

- [ ] Li o `AGENTS.md`
- [ ] 2FA ativo no GitHub
- [ ] `npm run check` passou na minha máquina ou Codespace
- [ ] Abri meu primeiro PR
