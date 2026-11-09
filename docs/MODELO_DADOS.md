# Modelo de dados

> **Lista fechada.** Os únicos dados pessoais permitidos estão marcados com 🔒 e são
> **guardados cifrados** (ADR 0003). Adicionar qualquer outro exige ADR aprovado (regra R4).
> O script `scripts/check-forbidden-fields.sh` bloqueia no CI colunas proibidas e colunas
> pessoais em texto puro.

## Dados pessoais permitidos (🔒 = cifrado)

| Dado | Coluna | Proteção | Quem vê (ADR 0002) |
|---|---|---|---|
| Nome | `profiles.display_name_enc` | AES-256-GCM | Escopo do monitor/gestor; colegas de equipe |
| WhatsApp | `profile_contacts.whatsapp_enc` + `whatsapp_hmac` | AES-256-GCM + HMAC | Escopo, ao clicar em "ver contato" (auditado); colegas de equipe [?] |
| Redes sociais (máx. 5 URLs https) | `profile_contacts.social_links_enc` | AES-256-GCM | Escopo (auditado) |
| E-mail de login | `auth.users` (Supabase) | Texto puro, gerenciado pelo Supabase | **Ninguém**: nunca exibido nem exportado |

Ficam **em texto puro**, por não identificarem sozinhos: município, UF, turma, equipe,
habilidades, missões, pontos e badges.

> **"Feitos" = entregas de missão validadas** (ADR 0006). Não existe campo de texto livre
> para isso.

## Proibidos

CPF, RG, título de eleitor, endereço/CEP, data de nascimento, gênero, raça, religião, filiação
partidária, foto de rosto, foto de documento, geolocalização precisa, IP em tabela de negócio,
e **qualquer coluna `display_name`, `whatsapp` ou `social_links` sem o sufixo `_enc`**.

## Entidades

```
unit_types ─< units (árvore: nacional > estado > [região] > turma, via ltree)
                │
profiles ───────┼─< unit_members >── units
   │            ├─< role_assignments >── units   (papel vale na unidade e abaixo dela)
   │            ├─< profile_skills >── skills
   │            ├─< mission_run_members >── mission_runs
   │            └─< profile_badges >── badges
   └── profile_contacts (1:1, RLS mais restrita: WhatsApp e redes)

missions ─< mission_steps
missions ─< mission_runs (uma turma assume a missão) ─< step_submissions (entregas)
step_submissions (approved = "feito") ──> points_ledger (só INSERT)
audit_log
```

**Uma instância por uso** (ADR 0005): o banco da Academia só tem dados da Academia. Todas as
tabelas têm **RLS habilitada**.

### Exemplo concreto da árvore (instância Academia)

| `units.path` | tipo | Quem enxerga |
|---|---|---|
| `br` | Nacional | gestor nacional |
| `br.sp` | Estado | gestor de SP (+ nacional) |
| `br.sp.zona_leste` | Região (opcional) | coordenador da região (+ SP + nacional) |
| `br.sp.zona_leste.turma_azul` | Turma | monitor da turma (+ todos acima) |
| `br.sp.turma_verde` | Turma sem região | monitor da turma (+ SP + nacional) |

**Turma = equipe.** Cada aluno está em **uma** turma (constraint), e mudar de turma gera um
evento `member_moved` no audit_log.

### `profiles`
| Coluna | Tipo | Observação |
|---|---|---|
| `id` | uuid PK | = `auth.users.id` |
| `display_name_enc` | text | 🔒 `v1.iv.ct` (ADR 0003 §3) |
| `municipality_code` | int FK | IBGE |
| `state_code` | char(2) | derivado do município (trigger); no cadastro, o aluno entra na unidade do seu estado |
| `district` | text null | distrito da capital [?] |
| `status` | enum | `pending`, `active`, `suspended` |
| `consent_version`, `consent_at` | text, timestamptz | |
| `created_at`, `updated_at` | timestamptz | |

O papel **não** fica no perfil: fica em `role_assignments`.

### `profile_contacts` (1:1 com `profiles`)
`profile_id` PK, `whatsapp_enc` 🔒, `whatsapp_hmac` (único), `social_links_enc` 🔒 null,
`updated_at`.
Fica **separada** para que listagens de perfis nunca tragam contato por engano. A RLS é mais
restrita: o próprio titular e `app.can_view_contact()`. Ideia adaptada do protótipo original
Vguedess/Complexo42 (`member_contacts`).

### `municipalities` (referência pública, só leitura)
`code` (IBGE), `name`, `state_code`, `metro_region`.

### `unit_types`, `units` e `unit_members` (ADR 0005)
`unit_types`: `id`, `key`, `label`, `level` (rótulos configuráveis por instância).
`units`: `id`, `type_id`, `parent_id`, `name`, `path` (ltree, índice GiST), `state_code`
null, `municipality_code` null (região), `motto` null (≤ 80), `colors` (2 a 3 hex: a
"bandeira"), `logo_path` null + `logo_status` (`pending`, `approved`, `rejected`),
`public_links` (redes **da turma**, até 5 URLs https), `starts_on`/`ends_on` null,
`status`. Logo só PNG/JPEG/WebP ≤ 512 KB, **nunca SVG** (ADR 0006 §2).
`unit_members`: `unit_id`, `profile_id`, `member_role` (`lead`, `member`), `joined_at`.

### `role_assignments` (ADR 0002 + 0005)
`id`, `profile_id`, `role` (`monitor`, `manager`, `tech_admin`), `unit_id`, `granted_by`,
`granted_at`, `revoked_at`. O papel vale na unidade **e em todas abaixo dela**.

### `skills` e `profile_skills`
`skills`: `id`, `name`, `category`, `active`.
`profile_skills`: `profile_id`, `skill_id`, `level` [?].

### Missões, entregas e pontos (ADR 0006)
`missions`: `id`, `title`, `description`, `category`, `scope_unit_id`, `status`
(`proposed`, `published`, `archived`), `origin` (`national`, `regional`, por trigger),
`mode` (`individual`, `team`), `repeatable`, `cooldown_days`, `badge_id` null,
`proposed_by_unit_id` null, `created_by`, `created_at`.
`mission_steps`: `id`, `mission_id`, `position`, `title`, `description`, `points` (> 0),
`evidence_type` (`none`, `link`, `protocol_number`, `text`), `requires_previous`.
`mission_runs`: `id`, `mission_id`, `unit_id`, `profile_id` null (missão individual), `status` (`active`, `completed`,
`abandoned`), `started_at`, `completed_at`.
`mission_run_members`: `run_id`, `profile_id`.
`step_submissions`: `id`, `run_id`, `step_id`, `submitted_by`, `evidence_url` null (https),
`evidence_text` null (≤ 500), `status` (`submitted`, `approved`, `rejected`),
`reviewed_by`, `reviewed_at`, `review_note`. Único por (`run_id`, `step_id`) aprovado.
`points_ledger`: `id`, `unit_id`, `profile_id` null, `submission_id`, `points`, `reason`,
`created_by`, `created_at`. **Só INSERT**: correção é lançamento negativo.

> Missões de saúde (doação de sangue): o monitor decide como comprovar, mas **não há upload
> de comprovante**; dado de saúde é sensível (ADR 0006 §7).

### `badges` e `profile_badges`
`badges`: `id`, `scope_unit_id` (nacional ou escopo do monitor), `created_by`, `name`,
`description`, `icon`, `rule_type` (`manual`,
`mission_completed`, `points_threshold`), `rule_params` jsonb.
`profile_badges`: `profile_id`, `badge_id`, `awarded_at`, `awarded_by` (null quando
automático), `submission_id` null, `reason`, `revoked_at` null, `revoked_by` null,
`revoked_reason` null.

### `audit_log`
`id`, `actor_id`, `event` (`contact_viewed`, `role_granted`,
`role_revoked`, `member_moved`, `logo_approved`, `export`, `badge_granted`, `badge_revoked`, `submission_approved`,
`submission_rejected`, `points_adjusted`, `account_deleted`), `target_id`, `created_at`.
**Nunca contém dados pessoais em claro.** Só os gestores leem, e só dentro do seu escopo.

## Acesso

A matriz completa está em [`adr/0002-permissoes-hierarquicas.md`](adr/0002-permissoes-hierarquicas.md).
Toda política RLS usa as funções `app.can_*`, e toda mudança atualiza
`supabase/tests/permissions_matrix.test.sql`.
