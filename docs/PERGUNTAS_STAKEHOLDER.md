# Perguntas para o stakeholder (reunião de kickoff)

## Respostas já registradas (2026-11-09)

| Tema | Resposta | Onde ficou registrado |
|---|---|---|
| Objetivo (#1) | Monitores e gestores identificam habilidades, criam tarefas, acompanham os feitos e dão badges | PLANEJAMENTO §0 |
| Quem desenvolve (#39) | Alunos de TI da Academia; o gestor do projeto é o sênior e revisor | PLANEJAMENTO §0 |
| Papéis e escopo (#5, #40) | Monitor → turma/equipe; gestor estadual → UF; gestor nacional → tudo | ADR 0002 |
| Proteção dos dados (#43) | Dados pessoais cifrados no banco; hash para unicidade | ADR 0003 |
| "Feitos" (#14) | Tarefas concluídas e validadas, não texto livre | MODELO_DADOS |
| Uso futuro | Campanhas eleitorais, como organização separada | ADR 0004 |
| Repositório | Público (permite proteger a `main` no plano gratuito) | — |

## Novas perguntas (após as definições)

46. ⛔ **O que é uma turma?** Tem monitor fixo, datas de início e fim? Um aluno pode estar em
    mais de uma turma? Uma equipe pertence sempre a uma turma, ou pode misturar turmas?
47. ⛔ **O monitor vê o WhatsApp dos alunos do seu escopo?** Sugestão: sim, ao clicar em
    "ver contato", com registro. **E os colegas de equipe se veem?**
48. **Existe nível entre o estado e a turma** (região metropolitana, município)? Se houver,
    é bom saber agora.
49. **Quem cria tarefas para quem?** O nacional cria para todos e o monitor para a sua turma?
    A tarefa é individual, da equipe inteira, ou ambos?
50. **A validação de um feito exige evidência** (um link)? Quem valida: o monitor da turma?
51. **Badges:** só o nacional cria badges, ou o estadual também? Monitor concede badge manual?
52. **Acompanhamento:** que painel cada nível quer ver? (Ex.: feitos por turma, alunos sem
    tarefa há 30 dias, ranking de equipes.)
53. **Jurídico — campanhas:** usar a plataforma numa campanha exige organização, termo e
    cadastro separados. A base de alunos não pode ser repassada (Lei 9.504, art. 57-E;
    LGPD art. 11). Confirmar com o jurídico.

As perguntas estão em ordem de prioridade. As marcadas com ⛔ **bloqueiam o desenvolvimento**:
sem resposta, o M1 não começa. Ao lado de cada uma está a **sugestão padrão**, que vale caso
ele não tenha preferência.

---

## A. Objetivo e sucesso

1. ⛔ **Qual problema dói mais hoje?** Não saber quem são os alunos, não saber onde estão,
   não conseguir montar times, ou não conseguir acompanhar o que os times fazem?
   *Define a ordem dos milestones.*
2. **Como saberemos que o piloto deu certo?** Sugestões: X% dos alunos cadastrados em 30 dias;
   N incubadoras formadas; N ações concluídas por mês.
3. **Qual a data-alvo** para o cadastro estar no ar? Há um evento ou turma associada?
4. **Quantos alunos existem hoje** na Academia e quantos estão na Região Metropolitana?
   (Dimensiona o piloto entre 50 e 2.000.)

## B. Quem usa e quem vê o quê (permissões)

5. ⛔ **Quais papéis existem?** Sugestão: *aluno*, *líder de equipe*, *coordenador regional*,
   *administrador*. Há mais algum, como mentor ou professor?
6. ⛔ **Quem pode ver o WhatsApp de um aluno?** Sugestão: só coordenadores e os membros da
   mesma equipe. **Nunca** público entre todos os alunos, porque é o dado mais visado num
   vazamento.
7. **Um aluno pode ver o perfil de outros alunos** (habilidades, cidade)? Ou só os coordenadores
   veem a base completa?
8. **O cadastro é aberto ou por convite?** Sugestão: por **link de convite** distribuído nos
   grupos da Academia, para evitar cadastros falsos e robôs.
9. **Quem aprova um cadastro?** Automático ou um coordenador confirma que a pessoa é aluna?
10. **Existe hoje uma lista de alunos** (planilha, formulário) para importar? Em que formato?

## C. Dados do cadastro (LGPD)

11. ⛔ **Login:** como o aluno entra na plataforma? Cada opção tem um custo:
    - **Conta Google:** grátis e simples, mas recebemos o e-mail (fica guardado só para login).
    - **Link mágico por e-mail:** grátis até um limite mensal, mas também guarda e-mail.
    - **Código por WhatsApp/SMS:** não guarda e-mail, mas **é pago** (cerca de US$ 0,05 a
      US$ 0,08 por mensagem; ~US$ 100 a US$ 160 para 2.000 pessoas).
    Sugestão: **Google + link mágico**, guardando o e-mail só na tabela de autenticação, nunca
    no perfil e nunca exibido.
12. **"Habilidades":** lista fechada (escolher de um catálogo) ou texto livre? Sugestão:
    **catálogo** com categorias (comunicação, design, programação, jurídico, eventos,
    captação…) mais um campo "outra". O catálogo é o que torna possível filtrar e montar times.
    Quem define a lista inicial?
13. **Nível de habilidade** importa (básico/intermediário/avançado) ou basta ter ou não ter?
14. **"Feitos":** o que significa exatamente? Conquistas fora da plataforma (cargo, projeto,
    campanha) contadas pelo próprio aluno em texto livre? Ou só o que ele fez dentro da
    plataforma (que já viraria medalha)?
15. **Redes sociais:** quais? (Instagram, X, LinkedIn, TikTok, YouTube.) Quantos links no
    máximo? Elas ficam visíveis para quem?
16. **Localização:** município + bairro está bom? Para a capital, sugestão: **subprefeitura ou
    distrito** (lista fechada de 96 distritos) em vez de bairro livre. Evita a "maçaroca" de
    grafias diferentes e permite agrupar. Na Grande SP, município basta?
17. **Idade mínima:** podem existir alunos **menores de 18 anos**? Se sim, a LGPD (art. 14)
    exige consentimento dos pais. Sugestão: **só maiores de 18** no piloto, com uma caixa de
    declaração.
18. **Quem é o "controlador" dos dados** perante a LGPD? A Academia, a entidade por trás dela
    ou uma pessoa física? Quem será o contato (encarregado) para pedidos de exclusão?
19. **Qual texto de consentimento** o jurídico aprova? Podemos propor um rascunho.

> Observação para a reunião: nome + WhatsApp **já são dados pessoais** pela LGPD. Coletar
> pouco reduz o risco, mas não elimina a responsabilidade. Por isso o plano inclui termo de
> consentimento, exclusão de conta pelo próprio aluno e retenção limitada.
> Ponto sensível: num movimento político, **a própria lista de membros pode ser lida como
> opinião política** (dado sensível, LGPD art. 5º, II). Vale validar com o jurídico.

## D. Equipes (incubadoras)

20. ⛔ **Como as equipes são formadas?** Pelo coordenador (manual), com sugestão automática
    (por região e habilidades complementares), ou por inscrição do próprio aluno?
21. **Tamanho típico** de uma equipe? Um aluno pode estar em **mais de uma** equipe?
22. **Equipe tem líder?** O líder pode criar ações ou só o coordenador?
23. **Equipes são por região** (bairro/município) ou podem misturar regiões?
24. **O que é uma "incubadora"** além de um time? Tem duração, objetivo e encerramento?

## E. Ações (o "Trello")

25. ⛔ **Construir ou usar uma ferramenta pronta?** Trello, Notion e GitHub Projects são
    gratuitos e já existem. Construir só faz sentido porque **a medalha depende da ação
    concluída**. Sugestão: construir um quadro **simples** (A fazer / Fazendo / Feito), sem
    tentar replicar o Trello.
26. **Quem cria as ações?** Coordenação central (a mesma ação para todas as equipes, como uma
    campanha), o líder da equipe, ou ambos?
27. **Uma ação é da equipe toda ou de pessoas específicas?**
28. **Como se comprova que uma ação foi feita?** Basta marcar, ou precisa de evidência (link,
    foto) e aprovação de líder ou coordenador? *Atenção: fotos aumentam custo de
    armazenamento e risco de dados pessoais de terceiros.*
29. **Precisa de prazo, comentários ou anexos?** (Cada item aumenta o escopo.)
30. **Notificações:** o aluno precisa ser avisado de ação nova? Por onde? (Notificação por
    WhatsApp é paga; e-mail e aviso dentro da plataforma são grátis.)

## F. Medalhas

31. ⛔ **Quais as regras das medalhas?** Exemplos: "1ª ação concluída", "10 ações", "ação de
    campanha X", "membro fundador de incubadora". Medalha por ação individual, por conjunto de
    ações, ou ambas?
32. **Medalhas são automáticas** (o sistema concede ao cumprir a regra) **ou concedidas
    manualmente** por coordenador?
33. **Há ranking ou placar** entre alunos ou equipes? (Gamificação aumenta engajamento, mas
    também a tentação de fraudar.)
34. **As medalhas aparecem publicamente** (perfil compartilhável, imagem para redes sociais)?
35. Quem desenha as medalhas (arte/ícones)?

## G. Operação, custo e expansão

36. **"Gratuito" significa custo zero absoluto?** Ou aceita-se um custo pequeno (domínio
    ~R$ 40/ano; um plano pago de banco ~US$ 25/mês se o piloto crescer)?
37. **Há domínio próprio?** (ex.: `academia.algumacoisa.org`)
38. **Quem será o administrador técnico** responsável pelas chaves de produção? Sugestão: no
    máximo 2 pessoas.
39. **Quantos voluntários desenvolvedores** temos, com quanta disponibilidade por semana?
40. **Para a expansão (SP/Brasil):** haverá coordenadores regionais com acesso limitado à sua
    região? *Isso muda o modelo de permissões desde o início.*
41. **Celular ou computador?** Sugestão: **mobile-first**, pois a maioria acessará pelo celular
    vindo de um link no WhatsApp.
42. **Identidade visual:** existe manual de marca, logo e cores?

## H. Segurança

43. **"Sem risco de invasão"** não existe em nenhum sistema. O compromisso realista é:
    (a) guardar o mínimo, (b) proteger bem o que for guardado, (c) ter plano para um
    incidente. Ele concorda com essa formulação?
44. **Exportação de dados:** coordenadores podem baixar planilha com WhatsApp? *Cada planilha
    baixada é um vazamento em potencial fora do nosso controle.* Sugestão: exportar sem
    WhatsApp, ou só para administradores, com registro de quem exportou.
45. **Por quanto tempo guardar** dados de quem sai da Academia? Sugestão: excluir 30 dias após
    o pedido ou 12 meses de inatividade.
