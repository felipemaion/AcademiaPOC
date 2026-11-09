# ADR 0006 — Missões, pontos e identidade das turmas

- **Status:** Aceito (definido pelo gestor do projeto em 2026-11-09). Itens marcados com [?]
  dependem do stakeholder.
- **Data:** 2026-11-09
- **Substitui:** o modelo de "tarefas/ações" (Kanban) do `MODELO_DADOS.md`.

## Contexto

Uma **turma** é um grupo de pessoas com identidade própria (nome, bandeira, logo) que
**discute, propõe e realiza ações na sua região**. A turma cumpre **missões** e ganha pontos.
Exemplos de missão:

- doar sangue;
- limpar uma praça;
- pintar um muro;
- escrever um projeto de lei, com **mais pontos se protocolar**;
- discursar na câmara;
- entrar com um pedido na subprefeitura.

Tudo isso deve ser **gamificado e organizado**.

## Decisão

### 1. Glossário (vale para interface, issues e código)

| Termo | Código | Significado |
|---|---|---|
| Turma / Equipe | `unit` | Grupo com identidade (ADR 0005) |
| Missão | `mission` | Modelo no catálogo: "Escrever um projeto de lei" |
| Etapa | `mission_step` | Passo com pontos e tipo de evidência: "Redigir" (10), "Protocolar" (+30), "Discursar" (+20) |
| Missão em andamento | `mission_run` | Uma turma assumiu uma missão |
| Entrega | `step_submission` | A turma diz "fizemos esta etapa", com evidência |
| **Feito** | entrega `approved` | Entrega validada por monitor ou gestor |
| Pontos | `points_ledger` | Lançamentos imutáveis gerados pelos feitos |
| Badge | `badge` | Conquista: por missão concluída, por pontos ou manual |
| Proposta | `mission` com status `proposed` | A turma propõe uma missão nova para a sua região |

### 2. Identidade da turma, sem upload de imagem no POC

- `units`: `name`, `motto` (lema, até 80 caracteres), `colors` (2 a 3 cores hex, que formam
  a "bandeira"), `emblem` (escolhido de um conjunto de ícones da instância) e
  `municipality_code` (a região da turma).
- **Upload de logo fica para a fase 2.** Ele exige armazenamento, moderação (um logo ofensivo
  vira problema da organização) e cuidado com formato. **SVG enviado pelo usuário é
  proibido**, porque pode carregar script. Quando vier: só PNG/JPEG/WebP, até 512 KB, em
  bucket com tipo e tamanho restritos, aprovado pelo monitor.

### 3. Missões e etapas

```
missions(id, title, description, category, scope_unit_id,      -- visível na unidade e abaixo
         status ('proposed','published','archived'),
         repeatable bool, cooldown_days int null, badge_id null,
         proposed_by_unit_id null, created_by, created_at)
mission_steps(id, mission_id, position, title, description, points int > 0,
              evidence_type ('none','link','protocol_number','text'),
              requires_previous bool)
mission_runs(id, mission_id, unit_id, status ('active','completed','abandoned'),
             started_at, completed_at)
mission_run_members(run_id, profile_id)                          -- quem participou
step_submissions(id, run_id, step_id, submitted_by,
                 evidence_url null, evidence_text null (≤ 500),
                 status ('submitted','approved','rejected'),
                 reviewed_by, reviewed_at, review_note)
points_ledger(id, unit_id, profile_id null, submission_id, points, reason,
              created_by, created_at)                            -- só INSERT
```

- **Etapas dão pontos extras** pelo aprofundamento: escrever (10) → protocolar (+30) →
  discursar (+20). `requires_previous` impõe a ordem quando faz sentido.
- **Repetição controlada:** `repeatable` + `cooldown_days`. Doação de sangue, por exemplo,
  pode ter intervalo mínimo entre uma vez e outra.

### 4. Pontos: livro-razão imutável

- Aprovar uma entrega chama **uma única função SQL** (`app.approve_submission`), que valida a
  permissão, muda o status e insere os lançamentos de pontos **na mesma transação**.
- Lançamentos **nunca são editados nem apagados**: a RLS e um trigger bloqueiam. Uma correção
  é um lançamento negativo com motivo.
- **Quem pontua:** a turma recebe os pontos da etapa, e cada participante declarado no
  `mission_run_members` recebe os mesmos pontos individuais, que contam para badges
  individuais [?].
- **Antifraude:**
  - ninguém valida entrega da qual participou (teste);
  - a mesma etapa não é aprovada duas vezes na mesma execução (constraint);
  - todo feito tem validador identificado;
  - os gestores veem um relatório de aprovações por monitor.

### 5. Propostas: discutir e propor na região

- Membros da turma criam uma **proposta de missão** (`status = 'proposed'`), com etapas e
  pontos sugeridos.
- O monitor ou gestor revisa, ajusta os pontos e **publica**: só para aquela turma ou para
  todo o seu escopo, para outras turmas copiarem a boa ideia.
- **A discussão em si continua no grupo de WhatsApp da turma.** A plataforma guarda a
  proposta e a decisão, não o bate-papo. Um chat interno (como as "salas" do protótipo original Vguedess/Complexo42)
  exige moderação, retenção e guarda de mensagens: fica fora do POC.

### 6. Placar

- **Placar de turmas** dentro do mesmo escopo (ex.: as turmas de SP, as turmas de uma
  cidade) e por período (mês, semestre) [?].
- **Sem ranking público individual.** A pessoa vê os próprios pontos e badges; comparar
  pessoas gera pressão e incentivo à fraude.

### 7. Evidências e LGPD

- **Preferir evidência pública e verificável:** número de protocolo, link da sessão da
  câmara, notícia, publicação oficial. Isso não carrega dado pessoal novo.
- **Sem upload de fotos no POC.** Foto de ação na rua mostra terceiros.
- **Missões de saúde (ex.: doação de sangue):** o fato "fulano doou sangue" é **dado de
  saúde, portanto sensível** (LGPD art. 5º, II). **Nunca guardar comprovante.** Aceitar
  autodeclaração validada pelo monitor, ou registrar a missão só no nível da turma, sem
  participantes nominais [jurídico].
- O campo de evidência em texto exibe o aviso "não inclua dados de outras pessoas".

### 8. Badges

- Tipos de regra: `mission_completed`, `points_threshold`, `manual`.
- **Badges podem ser revogados** (`revoked_at`, `revoked_reason`), por exemplo por fraude
  descoberta depois. Ideia do protótipo original Vguedess/Complexo42.

## Consequências

- (+) O "Trello" genérico vira um **catálogo de missões com etapas e pontos**: mais simples
  de usar, mais fácil de validar e naturalmente gamificado.
- (+) O livro-razão torna o placar auditável e à prova de "editar pontos na mão".
- (−) Mais tabelas e uma função crítica (`app.approve_submission`), que exige testes de
  permissão, idempotência e antifraude.
- (−) Sem upload, a identidade visual fica limitada a cores e emblemas no POC.
