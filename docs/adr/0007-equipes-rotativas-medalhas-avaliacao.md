# ADR 0007 — Equipes rotativas, porta-vozes, medalhas e avaliação reservada

- **Status:** Proposto (definições da reunião de kickoff de 2026-11-09; detalhes marcados
  [?] dependem do stakeholder)
- **Data:** 2026-11-10

## Contexto

Na reunião de kickoff, o stakeholder explicou o uso esperado depois da Academia:

- Os ex-alunos formam **equipes** que apoiam **porta-vozes** em formação (produção de
  conteúdo, edição de vídeo, roteiro, memes, eventos etc.).
- **A equipe é da organização, não do porta-voz.** O membro **roda** entre porta-vozes
  (ciclos de 3 a 5 meses [?]). Enquanto está num ciclo, fica com aquele porta-voz. O
  objetivo é evitar vínculo pessoal forte: se um porta-voz sair, a equipe não sai junto.
- Cada município tem **coordenadores**, que podem nomear coordenadores por área (eventos,
  edição de vídeo, memes…). Um **condutor regional** coordena os coordenadores.
- O porta-voz pede o trabalho; o **coordenador da equipe** decide como executar; as
  diretrizes vêm da coordenação.
- Para escolher quem vai para cada equipe, a coordenação precisa ver o **histórico** da
  pessoa: com quem trabalhou, o que fez, que medalhas tem.
- **Medalhas são registro de feitos, não corrida.** Não pode haver ranking que faça quem
  chega depois desistir ("nunca vou alcançar o primeiro"). Uma medalha rara vale tanto
  quanto cinquenta comuns.

## Decisão

### 1. Papéis (complementa o ADR 0002 e o ADR 0005)

| Papel | Escopo | Pode |
|---|---|---|
| **Coordenador** (`monitor` na unidade) | a(s) equipe(s) que coordena | O mesmo que o monitor: ver membros, criar missões, validar, conceder medalhas, **avaliar** |
| **Porta-voz** (`spokesperson`, novo) | a equipe que o apoia no ciclo atual | Ver nome, habilidades, portfólio e medalhas dos membros; conceder a **sua** medalha; **avaliar** quem trabalhou com ele. Não vê WhatsApp [?] |
| **Gestor** (`manager`) | sua unidade e as de baixo | Montar e mudar equipes; ver avaliações **só por pedido auditado** (§4) |

### 2. Equipes rotativas e histórico

- Uma pessoa está em **uma equipe por vez** (igual à turma no ADR 0006).
- `unit_members` ganha `left_at` e `left_reason`. Mover alguém **encerra** o vínculo
  anterior em vez de apagá-lo. O conjunto de vínculos encerrados é o **histórico** da pessoa
  ("trabalhou na equipe de X de março a julho").
- A equipe registra o porta-voz que apoia em cada ciclo (`role_assignments` com
  `role = 'spokesperson'`, `granted_at`/`revoked_at`).
- Duração do ciclo: configurável por instância; padrão 3 meses [?].

### 3. Medalhas

O termo na interface é **medalha**; no código continua `badge`.

| Tipo (`rule_type`) | Quem cria | Exemplo |
|---|---|---|
| `manual` | nacional ou coordenador | "Melhor roteiro do mês" |
| `event` | quem organiza o evento | "Participou da arrecadação de agasalhos de 2027" |
| `worked_with` | **cada porta-voz tem a sua**, criada automaticamente | "Trabalhou com Fulano" — concedida ao fim de um ciclo |
| `milestone` | nacional ou coordenador | "Primeiro corte com 10 mil visualizações". Pode levar o **nome de quem conquistou primeiro** e contar a história; depois, todos que atingirem o marco ganham a mesma |
| `attendance` | automática | Presença em todas as reuniões do período |
| `mission_completed` / `points_threshold` | automática | ADR 0006 §8 |

- **Ninguém cria medalha para si** nem concede medalha a si mesmo (teste obrigatório).
- **Medalhas são visíveis**; o **nível da avaliação** associada não é (§4).
- Novas medalhas podem surgir a qualquer momento. Não é preciso prever todas antes.
- **Sem ranking individual** (reforça o ADR 0006 §6). O perfil mostra medalhas como
  coleção, sem total de pontos em destaque.

### 4. Avaliação reservada

Ao fim de um ciclo, o porta-voz e o coordenador podem **avaliar** quem trabalhou com eles:

- `member_evaluations`: `id`, `profile_id`, `evaluator_id`, `unit_id`, `cycle_ends_on`,
  `grade_enc` (bronze, prata ou ouro, **cifrado**, ADR 0003), `note_enc` null (≤ 500
  caracteres, cifrado), `created_at`. **Só INSERT**: avaliação não se edita.
- **Quem lê:**
  - quem avaliou vê **só as avaliações que deu**;
  - **ninguém mais**, nem coordenadores nem porta-vozes, vê avaliações de outros;
  - o gestor vê as avaliações de alguém **só por pedido** (`app.request_evaluation_access`)
    com motivo obrigatório. O pedido gera `evaluation_viewed` no `audit_log`.
- Não há média pública nem "estrelinhas". Uma avaliação pública tende a não ser honesta e
  gera disputa interna.
- **[jurídico]** A LGPD garante ao titular o **acesso aos próprios dados** (art. 18, II).
  Esconder a avaliação da própria pessoa precisa de validação jurídica antes de ir para
  produção. Até lá, a funcionalidade fica atrás de configuração da instância, desligada.

### 5. Portfólio por links (sem armazenamento)

- A pessoa adiciona **até 3 itens** de portfólio: o link de algo que ela fez (vídeo, corte,
  arte, texto), com título curto. É **autodeclarado**, diferente da medalha, que é
  concedida por outra pessoa.
- **A plataforma não guarda arquivos.** A pessoa publica no YouTube, Instagram etc. e cola o
  link. A tela mostra uma prévia incorporada só de domínios de uma lista fechada
  (`youtube-nocookie.com`, Instagram, TikTok [?]), com `frame-src` restrito na CSP.
  Qualquer outro link aparece como link comum (`https://`, `rel="noopener noreferrer"`).
- `portfolio_items`: `id`, `profile_id`, `url_enc` (cifrado: o link pode identificar a
  pessoa), `kind` (`video`, `image`, `text`, `other`), `title` (≤ 80), `position`.

### 6. Fora do POC

- **Testes de personalidade** (Big Five, MBTI): exigem licença e devolutiva profissional.
  A triagem continua humana: a pessoa diz o que quer fazer, e a coordenação conversa e
  observa. Pode entrar depois um questionário próprio da Academia [?].
- **Formação de porta-vozes** (níveis, metas de seguidores, criação de redes): é outro
  módulo, para depois do piloto.
- **Importar bases existentes:** cada pessoa se cadastra do zero.

## Consequências

- (+) O histórico de equipes e as medalhas viram um **currículo interno**, que permite
  indicar alguém qualificado quando houver demanda.
- (+) A rotação e a avaliação reservada reduzem o vínculo pessoal e a disputa interna.
- (−) A avaliação é o dado mais delicado do sistema: cifrada, com leitura só por pedido
  auditado e dependente de parecer jurídico.
- (−) Novo papel (`spokesperson`) e novos tipos de medalha ampliam a matriz de testes de
  permissão (`supabase/tests/permissions_matrix.test.sql`).
