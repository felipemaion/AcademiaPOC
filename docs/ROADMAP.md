# Roadmap

> Gerado a partir das issues iniciais. **A fonte da verdade são as Issues e os Milestones do GitHub**; este arquivo é só um retrato do plano inicial.

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

Datas sujeitas à disponibilidade dos voluntários e às respostas do kickoff.

## M0 · Fundação e decisões

- Reunião de kickoff: responder as perguntas bloqueantes (⛔) — `docs, precisa-decisao`
- Aprovar ADR 0001 (stack) e escolher a hospedagem gratuita — `docs, infra, precisa-decisao`
- Scaffold: Next.js + TypeScript estrito + Tailwind + Zod + Vitest + `npm run check` — `infra, bloqueada`
- Supabase local + migrations + teste 'toda tabela pública tem RLS' — `backend, infra, seguranca, bloqueada`
- Playwright configurado com um teste E2E de fumaça no CI — `infra, bloqueada`
- Proteger a `main`, CODEOWNERS e MFA dos mantenedores — `infra, seguranca, pronta`
- Rascunho do termo de consentimento e da página 'Seus dados' — `docs, precisa-decisao`
- Seeds: municípios da RMSP, catálogo inicial de habilidades e dados fictícios — `backend, bloqueada, bom-primeiro-issue`

## M1 · Cadastro do aluno

- Login (Google + link mágico) com link de convite — `backend, frontend, seguranca, bloqueada`
- Tabela `profiles` + RLS + trigger que impede auto-promoção — `backend, seguranca, bloqueada`
- Tela de consentimento obrigatória antes do perfil — `frontend, bloqueada`
- Formulário de perfil: nome, WhatsApp e localização — `frontend, bloqueada`
- Habilidades: seleção a partir do catálogo — `frontend, backend, bloqueada`
- Redes sociais e 'feitos' com proteção contra XSS — `frontend, seguranca, bloqueada`
- Excluir minha conta (exclusão real) — `backend, frontend, seguranca, bloqueada`
- Baixar meus dados (JSON) — `backend, frontend, bloqueada, bom-primeiro-issue`
- E2E do fluxo completo de cadastro — `infra, bloqueada`

## M2 · Painel da coordenação

- Papéis (aluno, líder, coordenador, admin) e gestão por admin + audit_log — `backend, seguranca, bloqueada`
- Lista de alunos com filtros por habilidade, município e distrito — `frontend, backend, bloqueada`
- Contagem de alunos por região — `frontend, backend, bloqueada, bom-primeiro-issue`
- Gestão do catálogo de habilidades (admin) — `frontend, backend, bloqueada`
- Aprovação de cadastros pendentes — `backend, frontend, precisa-decisao, bloqueada`

## M3 · Equipes (incubadoras)

- Tabelas `teams` e `team_members` + RLS — `backend, seguranca, bloqueada`
- Criar equipe e adicionar membros a partir dos filtros — `frontend, backend, bloqueada`
- Definir líder e página 'Minhas equipes' — `frontend, backend, bloqueada`

## M4 · Ações (quadro)

- Tabelas `actions` e `action_assignees` + RLS — `backend, seguranca, bloqueada`
- Quadro por equipe (A fazer / Fazendo / Em revisão / Feito) — `frontend, bloqueada`
- Fluxo de aprovação de conclusão — `backend, frontend, bloqueada`
- Ação em lote para várias equipes (campanha) — `backend, frontend, precisa-decisao, bloqueada`

## M5 · Medalhas

- Tabelas `badges` e `profile_badges` + RLS — `backend, seguranca, bloqueada`
- Concessão manual de medalha com justificativa — `frontend, backend, bloqueada`
- Regras automáticas de medalha (ex.: N ações concluídas) — `backend, bloqueada`
- Exibir medalhas no perfil — `frontend, bloqueada, bom-primeiro-issue`

## M6 · Piloto RMSP

- Produção: deploy, domínio, secrets e backup semanal — `infra, seguranca, bloqueada`
- Revisão de segurança pré-lançamento — `seguranca, bloqueada`
- Teste com grupo pequeno (10–20 alunos) e coleta de feedback — `docs, bloqueada`
- Lançamento na RMSP e acompanhamento das métricas — `docs, bloqueada`

## M7 · Expansão SP/Brasil

- Coordenadores regionais com escopo por região (desenho) — `backend, seguranca, docs`
- Expandir municípios (SP e Brasil) e reavaliar limites gratuitos — `backend, infra`
