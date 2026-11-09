# Modelo de dados

> **Lista fechada.** Os únicos dados pessoais permitidos estão marcados com 🔒 e são
> **guardados cifrados** (ADR 0003). Adicionar qualquer outro exige ADR aprovado (regra R4).
> O script `scripts/check-forbidden-fields.sh` bloqueia no CI colunas proibidas e colunas
> pessoais em texto puro.

## Dados pessoais permitidos (🔒 = cifrado)

| Dado | Coluna | Proteção | Quem vê (ADR 0002) |
|---|---|---|---|
| Nome | `profiles.display_name_enc` | AES-256-GCM | Escopo do monitor/gestor; colegas de equipe |
| WhatsApp | `profiles.whatsapp_enc` + `whatsapp_hmac` | AES-256-GCM + HMAC | Escopo, ao clicar em "ver contato" (auditado); colegas de equipe [?] |
| Redes sociais (máx. 5 URLs https) | `profiles.social_links_enc` | AES-256-GCM | Escopo (auditado) |
| E-mail de login | `auth.users` (Supabase) | Texto puro, gerenciado pelo Supabase | **Ninguém**: nunca exibido nem exportado |

Ficam **em texto puro**, por não identificarem sozinhos: município, UF, turma, equipe,
habilidades, tarefas e badges.

> **"Feitos" = tarefas concluídas e validadas.** Não existe campo de texto livre para isso.

## Proibidos

CPF, RG, título de eleitor, endereço/CEP, data de nascimento, gênero, raça, religião, filiação
partidária, foto de rosto, foto de documento, geolocalização precisa, IP em tabela de negócio,
e **qualquer coluna `display_name`, `whatsapp` ou `social_links` sem o sufixo `_enc`**.

## Entidades

```
organizations ─┬─< classes (turmas, por UF) ─< teams (equipes)
               │
profiles ──────┼─< class_members >── classes
               ├─< team_members  >── teams
               ├─< profile_skills >── skills
               ├─< role_assignments          (escopo: nacional | UF | turma | equipe)
               ├─< task_assignees >── tasks  (tarefa de pessoa ou de equipe)
               ├─< task_completions          (o "feito": entrega + validação)
               └─< profile_badges >── badges
audit_log
```

**Todas as tabelas de negócio têm `organization_id`** (ADR 0004) e **RLS habilitada**.

### `organizations`
`id`, `name`, `slug`, `created_at`. No POC há uma só (a Academia).

### `profiles`
| Coluna | Tipo | Observação |
|---|---|---|
| `id` | uuid PK | = `auth.users.id` |
| `organization_id` | uuid FK | |
| `display_name_enc` | text | 🔒 `v1.iv.ct` (ADR 0003 §3) |
| `whatsapp_enc` | text | 🔒 |
| `whatsapp_hmac` | text | único por organização |
| `social_links_enc` | text null | 🔒 JSON cifrado |
| `municipality_code` | int FK | IBGE |
| `state_code` | char(2) | derivado do município (trigger); base do escopo estadual |
| `district` | text null | distrito da capital [?] |
| `status` | enum | `pending`, `active`, `suspended` |
| `consent_version`, `consent_at` | text, timestamptz | |
| `created_at`, `updated_at` | timestamptz | |

O papel **não** fica no perfil: fica em `role_assignments`.

### `municipalities` (referência pública, só leitura)
`code` (IBGE), `name`, `state_code`, `metro_region`.

### `classes` (turmas) e `class_members`
`classes`: `id`, `organization_id`, `name`, `state_code`, `municipality_code` null,
`starts_on`, `ends_on`, `status`.
`class_members`: `class_id`, `profile_id`, `joined_at`.

### `teams` e `team_members`
`teams`: `id`, `organization_id`, `class_id` (opcional [?]), `state_code`, `name`,
`description`, `status`, `created_by`.
`team_members`: `team_id`, `profile_id`, `member_role` (`lead`, `member`), `joined_at`.

### `role_assignments` (ADR 0002)
`id`, `organization_id`, `profile_id`, `role` (`monitor`, `state_manager`,
`national_manager`, `tech_admin`), `state_code` null, `class_id` null, `team_id` null,
`granted_by`, `granted_at`, `revoked_at`.
Uma constraint garante que o escopo seja coerente com o papel.

### `skills` e `profile_skills`
`skills`: `id`, `organization_id`, `name`, `category`, `active`.
`profile_skills`: `profile_id`, `skill_id`, `level` [?].

### `tasks`, `task_assignees` e `task_completions`
`tasks`: `id`, `organization_id`, `scope_type` (`team`, `class`, `state`, `national`),
`team_id`/`class_id`/`state_code`, `title`, `description`, `due_date`, `badge_id` null
(badge concedido ao concluir), `created_by`, `status`.
`task_assignees`: `task_id`, `profile_id` (vazio = vale para todos do escopo).
`task_completions`: `id`, `task_id`, `profile_id`, `evidence_url` null (https),
`submitted_at`, `status` (`submitted`, `approved`, `rejected`), `reviewed_by`,
`reviewed_at`, `review_note`.

### `badges` e `profile_badges`
`badges`: `id`, `organization_id`, `name`, `description`, `icon`, `rule_type` (`manual`,
`task`, `tasks_count`), `rule_params` jsonb.
`profile_badges`: `profile_id`, `badge_id`, `awarded_at`, `awarded_by` (null quando
automático), `task_completion_id` null, `reason`.

### `audit_log`
`id`, `organization_id`, `actor_id`, `event` (`contact_viewed`, `role_granted`,
`role_revoked`, `export`, `badge_granted`, `account_deleted`), `target_id`, `created_at`.
**Nunca contém dados pessoais em claro.** Só os gestores leem, e só dentro do seu escopo.

## Acesso

A matriz completa está em [`adr/0002-permissoes-hierarquicas.md`](adr/0002-permissoes-hierarquicas.md).
Toda política RLS usa as funções `app.can_*`, e toda mudança atualiza
`supabase/tests/permissions_matrix.test.sql`.
