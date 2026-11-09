# Modelo de dados

> **Lista fechada.** Os únicos campos de dado pessoal permitidos estão marcados com 🔒.
> Adicionar qualquer outro exige ADR aprovado (regra R4 do `AGENTS.md`).
> O script `scripts/check-forbidden-fields.sh` bloqueia no CI nomes de coluna proibidos.

## Campos pessoais permitidos (🔒)

| Campo | Onde | Motivo | Visível para [?] |
|---|---|---|---|
| `display_name` | `profiles` | Identificar o aluno | Coordenação, colegas de equipe |
| `whatsapp` (formato E.164, ex.: `+5511900000000`) | `profiles` | Contato para ações | Coordenação, colegas de equipe |
| `municipality_code` (código IBGE) + `district` | `profiles` | Agrupar por região | Coordenação |
| `social_links` (máximo de 5 URLs https) | `profiles` | Pedido do stakeholder | [?] |
| `achievements` (texto curto, "feitos") | `profiles` | Pedido do stakeholder | [?] |
| e-mail | `auth.users` (gerenciado pelo Supabase) | **Só para login**, nunca exibido nem exportado | Ninguém |

## Proibidos

CPF, RG, título de eleitor, endereço/CEP, data de nascimento, gênero, raça, religião, filiação
partidária declarada, foto de rosto, foto de documento, geolocalização precisa (lat/long), IP
armazenado em tabela de negócio.

## Entidades

```
profiles (1) ──< profile_skills >── (N) skills
profiles (1) ──< team_members >── (N) teams
teams (1) ──< actions
actions (1) ──< action_assignees >── profiles
badges (1) ──< profile_badges >── profiles
audit_log (registra quem fez o quê nas ações sensíveis)
```

### `profiles`
| Coluna | Tipo | Observação |
|---|---|---|
| `id` | uuid PK | = `auth.users.id` |
| `display_name` | text | 2 a 80 caracteres 🔒 |
| `whatsapp` | text | E.164, validado 🔒 |
| `municipality_code` | int | IBGE; FK para `municipalities` 🔒 |
| `district` | text null | Lista fechada para a capital [?] 🔒 |
| `social_links` | jsonb | array de no máximo 5 URLs https 🔒 |
| `achievements` | text null | até 500 caracteres 🔒 |
| `role` | enum | `student`, `team_lead`, `coordinator`, `admin` (só admin altera) |
| `status` | enum | `pending`, `active`, `suspended` |
| `consent_version` | text | versão do termo aceito |
| `consent_at` | timestamptz | |
| `created_at` / `updated_at` | timestamptz | |

### `municipalities` (pública, só leitura)
`code` (IBGE), `name`, `state` (UF), `metro_region` (bool). A seed inclui os 39 municípios
da RMSP; a expansão para o estado e o país só acrescenta linhas.

### `skills` / `profile_skills`
`skills`: `id`, `name`, `category`, `active`.
`profile_skills`: `profile_id`, `skill_id`, `level` [?].

### `teams` / `team_members`
`teams`: `id`, `name`, `description`, `municipality_code` (opcional), `status`, `created_by`.
`team_members`: `team_id`, `profile_id`, `member_role` (`lead`, `member`), `joined_at`.

### `actions` / `action_assignees`
`actions`: `id`, `team_id`, `title`, `description`, `status` (`todo`, `doing`, `review`,
`done`), `due_date`, `created_by`, `approved_by`, `approved_at`.
`action_assignees`: `action_id`, `profile_id`.

### `badges` / `profile_badges`
`badges`: `id`, `name`, `description`, `icon`, `rule_type` (`manual`, `actions_count`,
`specific_action`, …), `rule_params` (jsonb).
`profile_badges`: `profile_id`, `badge_id`, `awarded_at`, `awarded_by` (null quando
automática), `reason`, `action_id` (opcional).

### `audit_log`
`id`, `actor_id`, `event` (ex.: `role_changed`, `profile_exported`, `badge_granted`),
`target_id`, `created_at`. **Sem dados pessoais no payload.**

## Regras de acesso (RLS) — resumo

| Tabela | Aluno | Líder | Coordenador | Admin |
|---|---|---|---|---|
| `profiles` (próprio) | lê e edita (exceto `role` e `status`) | = | = | = |
| `profiles` (outros) | colegas de equipe: nome e WhatsApp | = | lê todos [?] | lê e edita |
| `teams` | as suas | as suas | todas | todas |
| `actions` | da sua equipe; muda status | + pede revisão | cria e aprova | tudo |
| `profile_badges` | as suas [?] | = | concede | tudo |
| `audit_log` | — | — | — | lê |
