# ADR 0002 — Permissões hierárquicas por escopo

- **Status:** Aceito (definido pelo gestor do projeto em 2026-11-09). As **regras de acesso**
  continuam valendo; a **estrutura** (tabelas de estado/turma/equipe e `organization_id`) foi
  substituída pela hierarquia genérica de unidades do
  [ADR 0005](0005-framework-e-hierarquia-generica.md).
- **Data:** 2026-11-09

## Contexto

Monitores e gestores precisam identificar habilidades, criar tarefas, validar os "feitos" e
conceder badges. Cada um deve enxergar **só o seu pedaço**:

- o **monitor** vê só a sua turma ou equipe;
- o **gestor estadual** vê só o seu estado;
- o **gestor nacional** vê tudo.

## Decisão

### Hierarquia

```
Organização (ex.: Academia)            ← ADR 0004
 └─ Estado (UF)
     └─ Turma
         └─ Equipe (incubadora)
             └─ Aluno
```

O estado do aluno é **derivado do município** que ele informa (código IBGE). Uma equipe
pertence a uma turma, e uma turma pertence a um estado.

### Papéis são atribuições com escopo, não um campo do perfil

```
role_assignments(
  id, organization_id, profile_id,
  role        -- 'monitor' | 'state_manager' | 'national_manager' | 'tech_admin'
  state_code  -- obrigatório se role = state_manager
  class_id    -- monitor de turma
  team_id     -- monitor de equipe
  granted_by, granted_at, revoked_at
)
```

Uma pessoa pode ter várias atribuições (ex.: monitor de duas turmas). Todo aluno é `student`
implicitamente; não há linha para isso.

### Matriz de acesso

| Papel | Escopo | Vê perfis (nome, habilidades, região) | Vê contato (WhatsApp, redes) | Cria missões | Valida feitos | Concede badges | Atribui papéis |
|---|---|---|---|---|---|---|---|
| Aluno | si mesmo | colegas da turma (nome, habilidades) | **não** (o monitor cria o grupo de WhatsApp da turma) | — | — | — | — |
| Monitor | turmas e equipes atribuídas | alunos do escopo | do escopo, **auditado** | no escopo | no escopo | cria e concede, no escopo | — |
| Gestor estadual | sua UF | todos da UF | da UF, **auditado** | na UF | na UF | na UF | monitores da UF |
| Gestor nacional | tudo | tudo | tudo, **auditado** | tudo | tudo | cria e concede, tudo | gestores estaduais e monitores |
| Admin técnico | sistema | **nenhum** | **nenhum** | — | — | — | só cria o 1º gestor nacional |

### Regras

1. **Só se delega para baixo.** Ninguém concede papel igual ou superior ao seu; o gestor
   estadual só concede dentro da sua UF.
2. **Separação de funções.** O admin técnico (quem cuida do sistema) **não vê dados
   pessoais**, e os desenvolvedores não têm papel em produção.
3. **Uma única fonte de verdade.** As decisões de acesso ficam em funções SQL
   (`app.can_view_profile(target)`, `app.can_view_contact(target)`,
   `app.can_manage_team(team)`, …), declaradas `security definer` e `stable`. As políticas RLS
   e o servidor usam **as mesmas funções**. É proibido reimplementar a regra no front.
4. **Matriz de testes obrigatória.** `supabase/tests/permissions_matrix.test.sql` cobre cada
   papel × alvo dentro e fora do escopo × operação. Todo PR que toca permissão atualiza a
   matriz.
5. **Toda concessão e revogação** de papel vai para o `audit_log`.
6. **Ver contato é auditado.** O WhatsApp de terceiros não vem na listagem: aparece ao clicar
   em "ver contato", e isso gera um evento `contact_viewed`.

## Alternativas consideradas

- **Papel como coluna em `profiles`:** não expressa "monitor da turma X", nem várias turmas.
- **Checagem só no servidor (sem RLS):** um único endpoint esquecido vaza tudo. Com RLS, o
  banco é a última barreira.

## Consequências

- (+) O mesmo modelo serve para piloto, estado e país, e futuramente para outros usos.
- (−) RLS com funções exige testes cuidadosos: por isso a matriz é obrigatória e os arquivos
  de `supabase/` exigem revisão do code owner.
- (−) Desempenho: as funções precisam de índices em `role_assignments` e nas tabelas de
  vínculo. Medir com 50 mil perfis fictícios antes da expansão.
