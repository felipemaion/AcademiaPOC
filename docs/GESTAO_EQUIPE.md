# Gestão da equipe

Como uma equipe de voluntários, a maioria fazendo "vibe coding", entrega com qualidade sem
depender de alguém cobrando no WhatsApp.

## 1. Papéis no time

| Papel | Quem | Responsabilidades |
|---|---|---|
| **Gestor do projeto** | felipemaion | Prioriza o backlog, aprova ADRs, é code owner das áreas críticas (banco, criptografia, auth, CI), guarda as chaves de produção, faz o deploy |
| **Revisor** | 2 a 3 devs promovidos (ver §6) | Revisam PRs não críticos, ajudam quem está travado |
| **Padrinho/madrinha** | um revisor por novato | Acompanha o novato até o primeiro PR com merge |
| **Dev** | todos | Pegam issues, escrevem testes, revisam PRs dos colegas quando puderem |

**Acesso:** devs e revisores têm permissão *Write* no repositório; só o gestor tem *Admin*.
Produção fica só com o gestor e uma pessoa de backup.

## 2. Quadro (GitHub Projects)

Colunas: **Backlog → Pronta → Em andamento → Em revisão → Feito**

| Regra | Por quê |
|---|---|
| **Uma issue em andamento por pessoa** | Evita trabalho pela metade espalhado |
| Pegou? Atribua-se, mova a issue e comente "pegando" | Ninguém faz trabalho duplicado |
| **Cinco dias sem atualização → a issue volta para Pronta** (com comentário gentil) | Voluntário some; a tarefa não pode sumir junto |
| Só entra em **Pronta** issue com critérios de aceite claros | A IA de cada um precisa de requisito objetivo |
| Tamanho **P** (até meio dia) ou **M** (até 2 dias). **G = quebrar em menores** | PRs pequenos são revisados rápido |
| Issue `precisa-decisao` não vai para Pronta | Decisão é do gestor ou do stakeholder |

## 3. Ritmo (ciclos de 2 semanas = 1 milestone)

| Quando | O quê | Duração |
|---|---|---|
| Início do ciclo | **Planejamento**: o gestor apresenta as issues prontas e cada um escolhe a sua | 30 min (chamada) |
| Terça e sexta | **Check-in assíncrono** no grupo: *fiz / vou fazer / travado em* | 2 min por pessoa |
| Semanal | **Triagem** pelo gestor: novas issues, labels, desbloqueios, PRs parados | 15 min |
| Fim do ciclo | **Demo + retrospectiva**: cada um mostra o que entregou; o que melhorar | 45 min |

## 4. Onde cada conversa acontece

| Canal | Para |
|---|---|
| **Issue** | Tudo sobre uma tarefa: dúvidas, decisões, bloqueios |
| **Pull Request** | Revisão de código |
| **Discussions** | Ideias, dúvidas gerais, apresentações, propostas de ADR |
| **WhatsApp** | Avisos e urgências. **Decisão tomada no WhatsApp só vale se registrada na issue ou no ADR** |

## 5. Revisão de código

- Todo PR precisa de 1 aprovação e de CI verde (a `main` é protegida).
- Áreas críticas (`supabase/`, `src/server/crypto/`, `src/server/auth/`, `.github/`) exigem
  aprovação do gestor (CODEOWNERS).
- **Meta: revisar em até 2 dias.** Um PR parado desmotiva mais do que uma revisão dura.
- O revisor usa o checklist do `CONTRIBUTING.md` e **roda localmente** quando há mudança de
  tela.
- Feedback é sobre o código, nunca sobre a pessoa. "A IA escreveu" não é justificativa: quem
  abre o PR responde por ele.

## 6. Trilha de evolução

| Nível | Pode pegar | Para subir |
|---|---|---|
| 1 · Chegando | `bom-primeiro-issue` | 1 PR com merge |
| 2 · Dev | `frontend`, `backend`, `infra` | 3 PRs com merge, sem regressão |
| 3 · Dev de segurança | `seguranca` (com o gestor como revisor) | 2 PRs `seguranca` com merge |
| 4 · Revisor | Revisa PRs dos colegas | Indicação do gestor |

O objetivo é **tirar o gestor do caminho** de tudo que não for crítico.

## 7. Indicadores (vistos na triagem semanal)

- Issues concluídas por ciclo.
- PRs esperando revisão há mais de 2 dias.
- Issues "em andamento" paradas há mais de 5 dias.
- Bugs reabertos (retrabalho).

## 8. Entrada e saída de pessoas

**Entrada** (gestor):
1. `gh api -X PUT repos/felipemaion/Complexo42/collaborators/<usuario> -f permission=push`
2. Adicionar ao grupo; designar o padrinho.
3. Apontar `docs/ONBOARDING.md` e uma `bom-primeiro-issue`.

**Saída:** remover de colaboradores, devolver as issues dele para **Pronta** e agradecer.

## 9. Usar a própria plataforma (futuro)

Como o código é um framework genérico (ADR 0005), uma instância dele poderá organizar **o
próprio time de TI**: habilidades, tarefas, feitos e badges dos voluntários. Até lá, o quadro
do GitHub cumpre esse papel.
