# Complexo42

Plataforma para organizar **turmas** que discutem, propõem e realizam ações na sua região,
cumprindo **missões** gamificadas: doar sangue, limpar uma praça, escrever e protocolar um
projeto de lei, discursar na câmara… Cada etapa validada vira um **feito**, rende **pontos** e
pode render **badges**. **Monitores e gestores** identificam as habilidades dos alunos, publicam
missões e validam as entregas. Primeira instância: a Academia. O acesso é hierárquico: o monitor vê sua
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

## 👋 Chegou agora? Comece pelo [`docs/ONBOARDING.md`](docs/ONBOARDING.md)

Ele leva você do zero ao projeto rodando (Docker ou Codespaces) e ao primeiro PR.
Como a equipe trabalha: [`docs/GESTAO_EQUIPE.md`](docs/GESTAO_EQUIPE.md).

> O código é um **framework reutilizável** (ADR 0005): a Academia é a primeira instância.
> Outros usos (ex.: organizar times de voluntários de TI) serão deploys separados do mesmo código.

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
| [`docs/adr/`](docs/adr/) | Decisões: 0001 stack · **0002 permissões por escopo** · **0003 criptografia dos dados** · ~~0004~~ · **0005 framework e hierarquia genérica** · **0006 missões, pontos e identidade das turmas** · **0007 equipes rotativas, medalhas e avaliação reservada** |
| [`SECURITY.md`](SECURITY.md) | Como reportar uma vulnerabilidade |

## Licença

[AGPL-3.0](LICENSE): quem modificar o código e oferecê-lo como serviço precisa publicar as
mudanças sob a mesma licença.

## Onde está cada coisa

- **Tarefas:** GitHub Issues (cada uma vinculada a um Milestone).
- **Decisões:** `docs/adr/NNNN-titulo.md`.
- **Código:** criado a partir da tarefa de scaffold do M0 (ainda não existe).
