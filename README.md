# AcademiaPOC

Plataforma piloto da Academia (Valete/MBL) para que **monitores e gestores** identifiquem as
habilidades dos alunos, criem tarefas, acompanhem os **feitos** (tarefas concluídas e
validadas) e concedam **badges** (gamificação). O acesso é hierárquico: o monitor vê sua
turma/equipe, o gestor estadual vê seu estado e o gestor nacional vê tudo. Os dados pessoais
são guardados **cifrados**.

Desenvolvida pelos próprios alunos de TI da Academia.

- **Escopo inicial:** Região Metropolitana de São Paulo, 50 a 2.000 pessoas.
- **Expansão prevista:** Estado de SP, depois o Brasil.
- **Restrições:** custo zero (planos gratuitos), coleta mínima de dados (LGPD) e, se
  alguém invadir, quase nada de valor a levar.
- **Time:** voluntários, a maioria desenvolvendo com assistentes de IA.

> **Estado atual:** planejamento (Milestone M0). A stack ainda é uma *proposta* e precisa ser
> validada na reunião com o stakeholder. Veja `docs/PERGUNTAS_STAKEHOLDER.md`.

## Leia nesta ordem

| Documento | Para quê |
|---|---|
| [`AGENTS.md`](AGENTS.md) | **Regras obrigatórias** para quem programa, humano ou IA |
| [`CONTRIBUTING.md`](CONTRIBUTING.md) | Fluxo de branch, PR, testes e revisão |
| [`docs/PLANEJAMENTO.md`](docs/PLANEJAMENTO.md) | Visão, escopo, requisitos, arquitetura, riscos |
| [`docs/ROADMAP.md`](docs/ROADMAP.md) | Milestones e tarefas |
| [`docs/MODELO_DADOS.md`](docs/MODELO_DADOS.md) | Entidades e lista fechada de campos permitidos |
| [`docs/LGPD_E_SEGURANCA.md`](docs/LGPD_E_SEGURANCA.md) | Minimização de dados, ameaças e controles |
| [`docs/PERGUNTAS_STAKEHOLDER.md`](docs/PERGUNTAS_STAKEHOLDER.md) | Perguntas em aberto para a reunião |
| [`docs/adr/`](docs/adr/) | Decisões: 0001 stack · **0002 permissões por escopo** · **0003 criptografia dos dados** · 0004 multi-organização |
| [`SECURITY.md`](SECURITY.md) | Como reportar uma vulnerabilidade |

## Onde está cada coisa

- **Tarefas:** GitHub Issues (cada uma vinculada a um Milestone).
- **Decisões:** `docs/adr/NNNN-titulo.md`.
- **Código:** criado a partir da tarefa de scaffold do M0 (ainda não existe).
