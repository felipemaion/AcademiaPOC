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
unit_types ─< units (árvore: nacional > estado > turma > equipe, via ltree)
                │
profiles ───────┼─< unit_members >── units
                ├─< role_assignments >── units   (papel vale na unidade e abaixo dela)
                ├─< profile_skills >── skills
                ├─< task_assignees >── tasks ──> units (tarefa pertence a uma unidade)
                ├─< task_completions             (o "feito": entrega + validação)
                └─< profile_badges >── badges
audit_log
```

**Uma instância por uso** (ADR 0005): o banco da Academia só tem dados da Academia. Todas as
tabelas têm **RLS habilitada**.

### Exemplo concreto da árvore (instância Academia)

| `units.path` | tipo | Quem enxerga |
|---|---|---|
| `br` | Nacional | gestor nacional |
| `br.sp` | Estado | gestor de SP (+ nacional) |
| `br.sp.turma_2026_1` | Turma | monitor da turma (+ SP + nacional) |
| `br.sp.turma_2026_1.equipe_azul` | Equipe | monitor da equipe (+ todos acima) |

### `profiles`
| Coluna | Tipo | Observação |
|---|---|---|
| `id` | uuid PK | = `auth.users.id` |
| `display_name_enc` | text | 🔒 `v1.iv.ct` (ADR 0003 §3) |
| `whatsapp_enc` | text | 🔒 |
| `whatsapp_hmac` | text | único |
| `social_links_enc` | text null | 🔒 JSON cifrado |
| `municipality_code` | int FK | IBGE |
| `state_code` | char(2) | derivado do município (trigger); no cadastro, o aluno entra na unidade do seu estado |
| `district` | text null | distrito da capital [?] |
| `status` | enum | `pending`, `active`, `suspended` |
| `consent_version`, `consent_at` | text, timestamptz | |
| `created_at`, `updated_at` | timestamptz | |

O papel **não** fica no perfil: fica em `role_assignments`.

### `municipalities` (referência pública, só leitura)
`code` (IBGE), `name`, `state_code`, `metro_region`.

### `unit_types`, `units` e `unit_members` (ADR 0005)
`unit_types`: `id`, `key`, `label`, `level` (rótulos configuráveis por instância).
`units`: `id`, `type_id`, `parent_id`, `name`, `path` (ltree, índice GiST), `state_code`
null, `starts_on`/`ends_on` null, `status`.
`unit_members`: `unit_id`, `profile_id`, `member_role` (`lead`, `member`), `joined_at`.

### `role_assignments` (ADR 0002 + 0005)
`id`, `profile_id`, `role` (`monitor`, `manager`, `tech_admin`), `unit_id`, `granted_by`,
`granted_at`, `revoked_at`. O papel vale na unidade **e em todas abaixo dela**.

### `skills` e `profile_skills`
`skills`: `id`, `name`, `category`, `active`.
`profile_skills`: `profile_id`, `skill_id`, `level` [?].

### `tasks`, `task_assignees` e `task_completions`
`tasks`: `id`, `unit_id` (vale para a unidade e as de baixo), `title`, `description`,
`due_date`, `badge_id` null
(badge concedido ao concluir), `created_by`, `status`.
`task_assignees`: `task_id`, `profile_id` (vazio = vale para todos do escopo).
`task_completions`: `id`, `task_id`, `profile_id`, `evidence_url` null (https),
`submitted_at`, `status` (`submitted`, `approved`, `rejected`), `reviewed_by`,
`reviewed_at`, `review_note`.

### `badges` e `profile_badges`
`badges`: `id`, `name`, `description`, `icon`, `rule_type` (`manual`,
`task`, `tasks_count`), `rule_params` jsonb.
`profile_badges`: `profile_id`, `badge_id`, `awarded_at`, `awarded_by` (null quando
automático), `task_completion_id` null, `reason`.

### `audit_log`
`id`, `actor_id`, `event` (`contact_viewed`, `role_granted`,
`role_revoked`, `export`, `badge_granted`, `account_deleted`), `target_id`, `created_at`.
**Nunca contém dados pessoais em claro.** Só os gestores leem, e só dentro do seu escopo.

## Acesso

A matriz completa está em [`adr/0002-permissoes-hierarquicas.md`](adr/0002-permissoes-hierarquicas.md).
Toda política RLS usa as funções `app.can_*`, e toda mudança atualiza
`supabase/tests/permissions_matrix.test.sql`.
