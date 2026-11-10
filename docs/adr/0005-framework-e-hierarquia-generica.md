# ADR 0005 — Framework reutilizável: uma instância por uso e hierarquia genérica

- **Status:** Aceito. **Substitui o ADR 0004** e a parte de *estrutura* do ADR 0002 (as regras
  de acesso do 0002 continuam valendo).
- **Data:** 2026-11-09

## Contexto

O mesmo código poderá ser usado em **sistemas separados**: a Academia e, no futuro, outros
usos, como a organização do próprio time de TI. Cada uso tem uma hierarquia diferente:

| Uso | Hierarquia |
|---|---|
| Academia | Nacional → Estado → [Região, opcional] → Turma (turma = equipe) |
| Time de TI | Projeto → Squad |

## Decisão

### 1. Uma instância por uso (substitui o ADR 0004)

Cada uso é **outro deploy**: projeto Supabase próprio, chaves de criptografia próprias,
domínio próprio e termo de consentimento próprio. Nada de dados de vários usos no mesmo
banco.

- (+) Isolamento total e simples: um vazamento numa instância não toca as outras.
- (+) Sem `organization_id` nas tabelas, o que remove uma condição de todas as políticas RLS.
  **A regra R17 do `AGENTS.md` sai.**
- (+) A base da Academia nunca está no mesmo banco que outro uso.

### 2. Hierarquia genérica de unidades (substitui as tabelas fixas estado/turma/equipe)

```
unit_types(id, key, label, level)            -- configuração da instância
  ex.: national(0) "Nacional", state(1) "Estado", region(2) "Região" (opcional), class(3) "Turma"

units(id, type_id, parent_id, name, path ltree, state_code null, status)
  ex.: brasil > sp > zona-leste > turma-azul   (ou brasil > sp > turma-azul, sem região)

unit_members(unit_id, profile_id, member_role, joined_at)

role_assignments(id, profile_id, role, unit_id, granted_by, granted_at, revoked_at)
  role: 'monitor' | 'manager' | 'tech_admin'
```

**Regra única de escopo:** quem tem papel na unidade **U** enxerga **U e tudo abaixo dela**
(`units.path <@ U.path`, com a extensão `ltree`, índice GiST).

As regras do ADR 0002 ficam assim:

| ADR 0002 | Neste modelo |
|---|---|
| Monitor da turma | `monitor` em uma unidade do tipo `class` (ou `region`) |
| Gestor estadual | `manager` em uma unidade do tipo `state` |
| Gestor nacional | `manager` na unidade raiz |
| Delegação só para baixo | Só se concede papel em unidade **descendente** da sua, e `monitor` nunca concede |

**Aluno sem turma:** ao se cadastrar, ele entra automaticamente na unidade do seu estado
(derivada do município), e o gestor estadual o enxerga até matriculá-lo numa turma.

### 3. O que é configurável por instância

Arquivo `config/instance.ts` (versionado) mais o seed da instância:

- Nome, logo e cores.
- Tipos de unidade e seus rótulos ("Turma", "Região", "Squad").
- Rótulos de papel ("Monitor", "Coordenador regional").
- Catálogo inicial de habilidades e badges.
- Texto do termo de consentimento.

**Não é configurável:** os campos de dado pessoal (lista fechada, cifrada, ADR 0003) e as
regras de segurança. Um novo uso que precise de outro campo pessoal exige ADR próprio.

### 4. Código genérico

- Nomes no código são genéricos: `unit`, `member`, `task`, `badge`. Nunca nomes da
  instância (ex.: "academia", "turma").
- Textos da interface vêm de `config/` e dos rótulos do banco, nunca fixos no componente.

## Consequências

- (+) A mesma matriz de testes de permissão vale para qualquer hierarquia.
- (+) Criar uma instância nova = deploy + seed + config, sem fork do código.
- (−) `ltree` e uma hierarquia genérica são um pouco mais abstratos para quem está chegando:
  o `docs/MODELO_DADOS.md` traz exemplos concretos.
- (−) O "framework" pode crescer demais. **Regra: só generalizar o que dois usos reais já
  precisam.** O resto é específico da instância ou fica para depois.
