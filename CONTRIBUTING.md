# Como contribuir

Primeira vez? Faça antes o [`docs/ONBOARDING.md`](docs/ONBOARDING.md). Ritmo, quadro e
papéis da equipe estão em [`docs/GESTAO_EQUIPE.md`](docs/GESTAO_EQUIPE.md).

## Fluxo

```
issue → branch → testes + código → npm run check → PR → CI verde → revisão → squash merge
```

1. **Pegue uma issue** sem responsável, com o label `pronta`. Atribua a si mesmo e comente
   "pegando".
2. **Crie a branch** a partir da `main` atualizada:
   ```bash
   git switch main && git pull
   git switch -c feat/12-cadastro-perfil
   ```
3. **Escreva o teste primeiro** (ele deve falhar) e depois o código (ele passa).
4. **Rode tudo localmente:** `npm run check`.
5. **Abra o PR** preenchendo o template, com `Closes #12`.
6. **CI verde é obrigatório.** Com CI vermelho não há revisão.
7. **Revisão:** uma pessoa diferente do autor aprova. O revisor roda a aplicação localmente
   quando há mudança visível.
8. **Merge:** *squash and merge*, feito por quem revisou ou pelo mantenedor.

## Ambientes

| Ambiente | Branch | Dados |
|---|---|---|
| Local | qualquer | Supabase local (`supabase start`) com dados **fictícios** do seed |
| Preview | cada PR | Banco de staging com dados fictícios |
| Produção | `main` | Dados reais. Acesso restrito aos mantenedores |

**Nunca** copie dados reais de produção para o ambiente local ou de preview.

## Labels

| Label | Significado |
|---|---|
| `pronta` | Requisitos claros, pode ser pega |
| `bloqueada` | Depende de decisão ou de outra issue |
| `precisa-decisao` | Aguarda resposta do stakeholder |
| `seguranca` | Toca auth, permissões ou dados pessoais: exige revisão de mantenedor |
| `bom-primeiro-issue` | Boa para quem está chegando |
| `frontend` / `backend` / `infra` / `docs` | Área |

## Revisão: checklist do revisor

- [ ] O PR faz só o que a issue pede?
- [ ] Os testes cobrem permissão negada e entrada inválida?
- [ ] Alguma tabela nova sem RLS? Algum campo pessoal novo?
- [ ] Alguma chave ou segredo no diff?
- [ ] Alguma dependência nova sem justificativa?
- [ ] Rodei localmente (quando há mudança de interface)?
