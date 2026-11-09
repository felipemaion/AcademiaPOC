# Roadmap

> Retrato das Issues abertas em 2026-11-09. **A fonte da verdade são as Issues e os Milestones do GitHub.**

| Milestone | Data-alvo | Entrega |
|---|---|---|
| M0 · Fundação e decisões | 2026-11-23 | Kickoff com stakeholder, ADR da stack aprovado, scaffold, CI e guardrails de segurança funcionando. |
| M1 · Cadastro do aluno | 2026-12-07 | Aluno entra por convite, aceita o termo, preenche e edita o perfil, baixa e exclui seus dados. |
| M2 · Painel da coordenação | 2026-12-21 | Papéis, filtros por habilidade e região, contagem por região, catálogo de habilidades. |
| M3 · Equipes (incubadoras) | 2027-01-18 | Criar equipes a partir dos filtros, definir líder, aluno vê suas equipes. |
| M4 · Ações (quadro) | 2027-02-01 | Quadro simples por equipe com fluxo de aprovação de conclusão. |
| M5 · Medalhas | 2027-02-15 | Catálogo de medalhas, concessão manual e automática, exibição no perfil. |
| M6 · Piloto RMSP | 2027-03-01 | Produção, revisão de segurança, teste com grupo pequeno e lançamento na Região Metropolitana. |
| M7 · Expansão SP/Brasil | a definir | Coordenação regional com escopo e ampliação da base de municípios. |

## M0 · Fundação e decisões

- #1 Reunião de kickoff: responder as perguntas bloqueantes (⛔) — `precisa-decisao, docs`
- #2 Aprovar ADR 0001 (stack) e escolher a hospedagem gratuita — `precisa-decisao, infra, docs`
- #3 Scaffold: Next.js + TypeScript estrito + Tailwind + Zod + Vitest + `npm run check` — `bloqueada, infra`
- #4 Supabase local + migrations + teste 'toda tabela pública tem RLS' — `bloqueada, seguranca, backend, infra`
- #5 Playwright configurado com um teste E2E de fumaça no CI — `bloqueada, infra`
- #6 Proteger a `main`, CODEOWNERS e MFA dos mantenedores — `pronta, seguranca, infra`
- #7 Rascunho do termo de consentimento e da página 'Seus dados' — `precisa-decisao, docs`
- #8 Seeds: municípios da RMSP, catálogo inicial de habilidades e dados fictícios — `bloqueada, bom-primeiro-issue, backend`
- #45 Módulo de criptografia de campo (`src/server/crypto`) + HMAC — `bloqueada, seguranca, backend`

## M1 · Cadastro do aluno

- #9 Login (Google + link mágico) com link de convite — `bloqueada, seguranca, frontend, backend`
- #10 Tabela `profiles` com dados pessoais cifrados + RLS por escopo — `bloqueada, seguranca, backend`
- #11 Tela de consentimento obrigatória antes do perfil — `bloqueada, frontend`
- #12 Formulário de perfil: nome, WhatsApp e localização — `bloqueada, frontend`
- #15 Habilidades: seleção a partir do catálogo — `bloqueada, frontend, backend`
- #17 Redes sociais (cifradas) com proteção contra XSS — `bloqueada, seguranca, frontend`
- #18 Excluir minha conta (exclusão real) — `bloqueada, seguranca, frontend, backend`
- #20 Baixar meus dados (JSON) — `bloqueada, bom-primeiro-issue, frontend, backend`
- #21 E2E do fluxo completo de cadastro — `bloqueada, infra`
- #46 Hierarquia e escopos: organizations, classes, role_assignments + funções `app.can_*` + matriz de testes — `bloqueada, seguranca, backend`

## M2 · Painel da coordenação

- #22 Delegação de papéis por escopo (nacional → estadual → monitor) + audit_log — `bloqueada, seguranca, backend`
- #23 Lista de alunos com filtros por habilidade, município e distrito — `bloqueada, frontend, backend`
- #24 Contagem de alunos por região — `bloqueada, bom-primeiro-issue, frontend, backend`
- #25 Gestão do catálogo de habilidades (admin) — `bloqueada, frontend, backend`
- #26 Aprovação de cadastros pendentes — `bloqueada, precisa-decisao, frontend, backend`
- #47 Turmas: criar turma, matricular alunos e nomear monitor — `bloqueada, frontend, backend`
- #48 'Ver contato' com auditoria — `bloqueada, seguranca, frontend, backend`

## M3 · Equipes (incubadoras)

- #27 Tabelas `teams` e `team_members` + RLS — `bloqueada, seguranca, backend`
- #28 Criar equipe e adicionar membros a partir dos filtros — `bloqueada, frontend, backend`
- #29 Definir líder e página 'Minhas equipes' — `bloqueada, frontend, backend`

## M4 · Ações (quadro)

- #30 Tabelas `tasks`, `task_assignees` e `task_completions` + RLS por escopo — `bloqueada, seguranca, backend`
- #31 Lista/quadro de tarefas do aluno e do monitor — `bloqueada, frontend`
- #32 Validação de feitos pelo monitor/gestor do escopo — `bloqueada, frontend, backend`
- #33 Tarefa para um escopo inteiro (turma, UF ou nacional) — `bloqueada, precisa-decisao, frontend, backend`

## M5 · Medalhas

- #34 Tabelas `badges` e `profile_badges` + RLS — `bloqueada, seguranca, backend`
- #35 Concessão manual de medalha com justificativa — `bloqueada, frontend, backend`
- #36 Regras automáticas de medalha (ex.: N ações concluídas) — `bloqueada, backend`
- #37 Exibir medalhas no perfil — `bloqueada, bom-primeiro-issue, frontend`
- #49 Painel de acompanhamento por escopo — `bloqueada, frontend, backend`

## M6 · Piloto RMSP

- #38 Produção: deploy, domínio, secrets e backup semanal — `bloqueada, seguranca, infra`
- #39 Revisão de segurança pré-lançamento — `bloqueada, seguranca`
- #40 Teste com grupo pequeno (10–20 alunos) e coleta de feedback — `bloqueada, docs`
- #41 Lançamento na RMSP e acompanhamento das métricas — `bloqueada, docs`
- #50 Chaves de criptografia: geração, backup offline e rotação — `bloqueada, seguranca, infra`

## M7 · Expansão SP/Brasil

- #43 Expandir municípios (SP e Brasil) e reavaliar limites gratuitos — `backend, infra`
