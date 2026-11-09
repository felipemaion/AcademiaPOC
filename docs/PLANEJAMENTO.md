# Planejamento do POC

> Versão 0.1 (2026-11-09). Rascunho antes da reunião de kickoff. Itens marcados **[?]**
> dependem de resposta em `PERGUNTAS_STAKEHOLDER.md`.

## 0. Contexto (atualizado em 2026-11-09)

- **Quem desenvolve:** alunos de TI da própria Academia (Valete/MBL), a maioria fazendo
  "vibe coding" com IA. O gestor do projeto atua como sênior e revisor (code owner).
- **Quem usa:** os **monitores** e **gestores** da Academia, para identificar habilidades,
  criar tarefas, acompanhar os **feitos** (tarefas concluídas e validadas) e dar **badges**.
  Os alunos se cadastram e executam as tarefas.
- **Futuro:** a mesma plataforma poderá gerir equipes de **campanhas eleitorais**, como
  organização separada (ADR 0004).
- **Segurança definida:** dados pessoais cifrados (ADR 0003) e acesso hierárquico por escopo
  (ADR 0002): monitor → turma/equipe; gestor estadual → UF; gestor nacional → tudo.

## 1. Visão

Dar à coordenação da Academia uma visão clara de **quem são os alunos, onde estão e o que
sabem fazer**, para montar **equipes (incubadoras)**, distribuir **ações** e reconhecer quem
executa com **medalhas virtuais**. Tudo isso com o mínimo de dados pessoais e custo zero.

## 2. Objetivos do piloto (proposta)

| Objetivo | Métrica sugerida [?] |
|---|---|
| Cadastrar os alunos da RMSP | ≥ 60% dos alunos ativos cadastrados em 30 dias |
| Formar incubadoras | ≥ 5 equipes formadas pela plataforma |
| Executar ações | ≥ 70% das ações atribuídas concluídas no prazo |
| Segurança | Zero incidentes; 100% das tabelas com teste de RLS |
| Custo | R$ 0/mês de infraestrutura no piloto |

## 3. Escopo

### Dentro do POC (MVP)
1. **Cadastro e perfil**: nome, WhatsApp, município/bairro, habilidades, links de redes
   sociais e "feitos". Consentimento LGPD, edição e exclusão da própria conta.
2. **Painel da coordenação**: lista com filtros por habilidade e região, contagem por região.
3. **Equipes**: criar equipe, adicionar e remover membros, definir líder.
4. **Ações**: quadro simples por equipe (A fazer / Fazendo / Feito), com conclusão aprovada.
5. **Medalhas**: catálogo de medalhas; concessão manual e automática por regras simples.

### Fora do POC (por enquanto)
- Chat interno: o WhatsApp continua sendo o canal de conversa.
- Notificações por WhatsApp/SMS (pagas).
- Aplicativo nativo: o POC é web responsivo, que pode virar PWA.
- Upload de fotos e documentos.
- Ranking público.
- Coordenação multi-estado (fica preparada no modelo, mas não é exposta na interface).

## 4. Personas e papéis (definidos — ADR 0002)

| Papel | Escopo | Pode |
|---|---|---|
| **Aluno** | si mesmo | Editar e excluir o próprio perfil; ver suas turmas, equipes, tarefas e badges; enviar a conclusão de tarefas |
| **Monitor** | turmas/equipes atribuídas | Ver os alunos do escopo e suas habilidades; criar tarefas; validar feitos; conceder badges |
| **Gestor estadual** | sua UF | Tudo do monitor na UF + criar turmas e equipes + nomear monitores |
| **Gestor nacional** | tudo | Tudo + catálogo de habilidades e badges + nomear gestores estaduais |
| **Admin técnico** | sistema | Configuração e primeiro gestor nacional. **Não vê dados pessoais** |

O líder de equipe é um papel dentro da equipe (`team_members.member_role`), sem acesso extra a
dados [?].

## 5. Requisitos funcionais (histórias)

**Cadastro (M1)**
- RF01: Como aluno, entro pela página a partir de um link de convite e faço login.
- RF02: Como aluno, aceito o termo de consentimento antes de preencher o perfil.
- RF03: Como aluno, preencho nome, WhatsApp, município/bairro, habilidades, redes e feitos.
- RF04: Como aluno, edito meu perfil a qualquer momento.
- RF05: Como aluno, excluo minha conta e meus dados são apagados de fato.
- RF06: Como aluno, baixo meus dados (direito de acesso da LGPD).

**Coordenação (M2)**
- RF07: Como coordenador, filtro alunos por habilidade, município e bairro.
- RF08: Como coordenador, vejo a contagem de alunos por região (tabela; mapa é opcional).
- RF09: Como administrador, gerencio o catálogo de habilidades e os papéis.

**Equipes (M3)**
- RF10: Como coordenador, crio uma equipe e adiciono membros a partir dos filtros.
- RF11: Como coordenador, defino o líder da equipe.
- RF12: Como aluno, vejo minhas equipes e o contato dos colegas de equipe.

**Ações (M4)**
- RF13: Como coordenador ou líder [?], crio ações para uma equipe.
- RF14: Como membro, movo ações entre colunas.
- RF15: Como líder ou coordenador, aprovo a conclusão de uma ação.

**Medalhas (M5)**
- RF16: Como administrador, cadastro medalhas e suas regras.
- RF17: Como aluno, recebo a medalha ao cumprir a regra e a vejo no meu perfil.
- RF18: Como coordenador, concedo uma medalha manualmente, com justificativa.

## 6. Requisitos não funcionais

| Item | Requisito |
|---|---|
| Custo | Planos gratuitos; alertar antes de atingir 80% de qualquer limite |
| Escala | Até 2.000 usuários no piloto e 50.000 na expansão, sem reescrever |
| Dispositivo | Mobile-first; funcionar bem em Android de entrada e 4G |
| Acessibilidade | WCAG 2.1 AA nos fluxos de cadastro |
| Segurança | Ver `LGPD_E_SEGURANCA.md` |
| Qualidade | CI obrigatório; nada entra na `main` sem testes verdes e revisão |
| Disponibilidade | Melhor esforço; não é sistema crítico |

## 7. Arquitetura proposta

Detalhes e alternativas em `adr/0001-stack.md`.

```
Celular / navegador
   │  HTTPS
   ▼
Next.js (hospedagem gratuita)
   - páginas (React)
   - Server Actions / Route Handlers  ← toda escrita passa por aqui, validada com Zod
   │  sessão do usuário (JWT); nunca service_role no cliente
   ▼
Supabase (plano gratuito)
   - Auth (Google / link mágico)
   - Postgres com RLS em TODAS as tabelas (negado por padrão)
   - Funções SQL para regras de medalha (security definer, testadas)
```

**Por que essa stack para voluntários com IA:** é a combinação que as IAs mais conhecem, tem
plano gratuito suficiente, e o Supabase permite rodar tudo localmente (`supabase start`) com
testes de banco. O maior risco dela, que é tabela sem RLS, é coberto por teste automático no CI.

## 8. Riscos

| Risco | Prob. | Impacto | Mitigação |
|---|---|---|---|
| Tabela sem RLS expõe dados (erro clássico de "vibe coding") | Alta | Alto | Teste no CI falha se alguma tabela não tiver RLS; teste de RLS obrigatório por tabela |
| Chave vazada no repositório | Média | Alto | gitleaks no CI; `.env*` no `.gitignore`; rotação documentada |
| Plano gratuito do Supabase pausa após 7 dias sem uso | Média | Médio | Atividade regular no piloto; ping semanal agendado se preciso |
| Limites gratuitos estourados na expansão | Baixa (piloto) | Médio | Monitorar; orçamento B de US$ 25/mês documentado |
| Voluntários abandonam o projeto | Alta | Médio | Issues pequenas e autocontidas; documentação forte; dois mantenedores |
| Escopo cresce ("vira um Trello completo") | Alta | Médio | Lista "fora do POC" explícita; toda mudança de escopo passa pelo stakeholder |
| Cadastros falsos ou spam | Média | Baixo | Link de convite + aprovação [?] |
| Dados de menores | Média | Alto | Bloquear menores de 18 no piloto [?] |
| Termos de uso do plano gratuito de hospedagem (ex.: Vercel Hobby é "não comercial") | Média | Médio | Avaliar no ADR 0001; alternativa: Cloudflare Pages ou Netlify |

## 9. Equipe e cadência (sugestão)

- **Mantenedores (2):** revisam PRs com label `seguranca`, cuidam das chaves e fazem o deploy.
- **Voluntários:** pegam issues `pronta`.
- **Ritmo:** milestones de cerca de 2 semanas; uma chamada curta semanal; o estado das
  tarefas fica nas issues, não no grupo de WhatsApp.
