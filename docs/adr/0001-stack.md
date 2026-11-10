# ADR 0001 — Stack tecnológica

- **Status:** Proposto (validar na reunião de kickoff)
- **Data:** 2026-11-09

## Contexto

Precisamos de custo zero, segurança forte com pouca experiência do time, e uma stack que as
IAs dos voluntários conheçam bem. Escala de 50 a 2.000 usuários no piloto, podendo chegar a
algumas dezenas de milhares.

## Decisão proposta

| Camada | Escolha | Plano gratuito |
|---|---|---|
| Front + servidor | **Next.js (App Router) + TypeScript** | — |
| Banco + Auth | **Supabase** | 500 MB de banco, 50 mil usuários ativos/mês, pausa após 7 dias sem uso |
| Hospedagem | **Cloudflare Pages/Workers** *ou* **Vercel Hobby** | ver nota |
| UI | Tailwind CSS + shadcn/ui | — |
| Validação | Zod | — |
| Testes | Vitest, Playwright, pgTAP (`supabase test db`) | — |
| CI | GitHub Actions | 2.000 min/mês em repositório privado |

**Nota sobre hospedagem:** os termos do Vercel Hobby restringem o uso a projetos pessoais e
não comerciais, o que pode não servir para uma organização. A Cloudflare não tem essa
restrição no plano gratuito, mas o Next.js nela exige o adaptador OpenNext. **Decidir na
tarefa M0 de hospedagem.**

## Alternativas consideradas

| Opção | Por que não (por ora) |
|---|---|
| Google Forms + Planilhas | Grátis e imediato, mas sem permissões finas, sem equipes, ações ou medalhas, e a planilha inteira vaza num único link. **Pode servir de plano B para o cadastro** se a data for muito curta |
| Firebase | Também bom, mas NoSQL dificulta filtros e relatórios por região e habilidade; regras de segurança menos testáveis |
| Trello/Notion para as ações | Grátis, mas a medalha depende de saber quem concluiu o quê; integrar custaria mais que um quadro simples |
| Backend próprio (Django/Express) + VPS | Mais controle, mas exige servidor gerenciado por voluntários: mais superfície de ataque e mais custo |

## Requisito de custo (decidido em 2026-11-09)

**Custo zero é o foco.** A escolha de hospedagem, banco e autenticação precisa caber nos
planos gratuitos, inclusive nos termos de uso (ex.: o Vercel Hobby é não comercial, o que
favorece a Cloudflare). Notificações por SMS ou WhatsApp, IA paga e upgrades ficam fora.
Um custo mínimo (ex.: domínio próprio) só entra com aprovação explícita do gestor.

**Reunião de kickoff (2026-11-09):**

- O stakeholder aceita um **teto de R$ 100/mês**, mas a meta continua sendo custo zero.
  Qualquer gasto exige ADR.
- **Vercel:** o time já levou susto com cobrança num pico de acessos de outro projeto. Isso
  reforça a Cloudflare, que tem plano gratuito sem cobrança por pico, e a proteção contra
  ataques na frente.
- **VPS gratuita da Oracle:** membros do time já têm uma. Ela pode rodar tarefas
  agendadas, como o backup semanal (#38), desde que o backup seja **cifrado** e a chave
  fique só com os mantenedores. Voluntário não guarda dado de produção em texto puro.
- **Linguagem:** TypeScript no front e no back, com TDD.

## Consequências

- (+) Tudo roda localmente com `supabase start`; os voluntários nunca tocam produção.
- (+) RLS testável no CI.
- (−) RLS é o ponto mais fácil de errar: mitigado por teste obrigatório.
- (−) Pausa do plano gratuito: mitigada por uso regular ou ping agendado.
