# LGPD e segurança

> Não é parecer jurídico. Os pontos marcados **[jurídico]** precisam de validação.

## 1. Princípio: "se invadirem, que não tenham nada pra roubar"

Na prática, isso vira quatro camadas:

1. **Não coletar:** só os campos de `MODELO_DADOS.md`. Sem CPF, endereço ou data de nascimento.
2. **Não expor:** RLS negada por padrão; o WhatsApp só aparece para quem precisa.
3. **Não acumular:** exclusão real da conta; retenção limitada; sem exportações soltas.
4. **Não guardar segredos no lugar errado:** nada de chave no repositório nem no navegador.

### Decisões que materializam isso

- **ADR 0003:** nome, WhatsApp e redes ficam **cifrados** (AES-256-GCM), com a chave fora do
  banco. Um dump do banco não identifica ninguém.
- **ADR 0002:** cada monitor e gestor vê só o seu escopo (turma/equipe, UF, nacional), com
  ver contato auditado.
- **ADR 0005:** cada uso do código é uma instância separada (outro banco, outras chaves);
  a base da Academia nunca é compartilhada com outra instância.

## 2. LGPD — checklist

| Item | Como atendemos |
|---|---|
| Base legal | Consentimento (art. 7º, I) ao entrar [jurídico] |
| Finalidade | Organizar alunos em equipes e ações da Academia. Texto no termo |
| Minimização | Lista fechada de campos + checagem no CI |
| Transparência | Página "Seus dados": o que guardamos, por quê e quem vê |
| Acesso e portabilidade | Botão "Baixar meus dados" (JSON) |
| Eliminação | Botão "Excluir minha conta": apaga o perfil e os vínculos, preservando só a contagem anônima de ações |
| Menores | Bloqueio de menores de 18 no piloto [?] [jurídico] |
| Dado sensível | Uma lista de membros de um movimento político pode indicar opinião política (art. 5º, II) [jurídico] |
| Controlador e encarregado | Definir quem é [?] |
| Incidente | Plano em `SECURITY.md`; comunicação à ANPD em prazo razoável (art. 48) |
| Operadores | Supabase e a hospedagem: verificar a região dos dados e os termos (transferência internacional, art. 33) [jurídico] |

## 3. Modelo de ameaças (resumo)

| Ameaça | Controle |
|---|---|
| Leitura direta da API do Supabase com a chave pública | RLS em todas as tabelas + teste no CI que **falha se existir tabela sem RLS** |
| Aluno lê dados de outro aluno | Testes pgTAP por política ("usuário A não lê B") |
| Aluno se promove a admin | Papéis só em `role_assignments`, concedidos de cima para baixo (ADR 0002) + teste |
| Monitor ou gestor acessa fora do seu escopo | Funções `app.can_*` em todas as políticas + matriz de testes de permissão |
| Dump do banco ou backup vazado | Nome, WhatsApp e redes cifrados; chave só nos secrets da hospedagem (ADR 0003) |
| Monitor copia contatos em massa | Contato fora da listagem; "ver contato" auditado; exportação só nacional e sem WhatsApp |
| Base da Academia reaproveitada em outro uso | Instâncias separadas: banco, chaves e domínio próprios (ADR 0005) |
| Avaliação reservada vazada ou usada para disputa interna | Cifrada; só quem avaliou lê a própria; gestor só por pedido com motivo, auditado; desligada até parecer jurídico (ADR 0007 §4) |
| Portfólio usado para injetar conteúdo | Sem upload; prévia só de domínios de lista fechada com `frame-src` restrito; demais links como link comum (ADR 0007 §5) |
| Segredo commitado | gitleaks no CI + `.gitignore` + rotação de chaves |
| Conta de admin roubada | MFA obrigatório nas contas do GitHub, Supabase e hospedagem; no máximo 3 admins |
| Injeção (XSS) via redes sociais ou "feitos" | Escape padrão do React; proibido `dangerouslySetInnerHTML`; links só `https://` e com `rel="noopener noreferrer"` |
| Cadastro em massa por robô | Link de convite; rate limit do Supabase Auth; aprovação [?] |
| Planilha exportada vazando | Exportação sem WhatsApp, ou só para admin, com registro no `audit_log` |
| Dependência maliciosa | Dependabot; regra R9 (justificar toda dependência); `npm ci` com lockfile |
| Voluntário com acesso a produção | Voluntários **não** têm acesso a produção; usam o Supabase local com dados fictícios |

## 4. Controles operacionais

- MFA obrigatório na organização ou conta do GitHub, no Supabase e na hospedagem.
- Chaves de produção: só os mantenedores, como *secrets* da hospedagem.
- Backups: o plano gratuito do Supabase **não tem backup diário automático confiável**.
  Fazer `pg_dump` semanal criptografado, guardado só pelos mantenedores [?].
- Revisão de acessos mensal: quem é admin ou coordenador.
