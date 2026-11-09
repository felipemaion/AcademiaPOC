# ADR 0004 — Multi-organização (preparação para campanhas)

- **Status:** Substituído pelo [ADR 0005](0005-framework-e-hierarquia-generica.md): cada
  uso (Academia, campanha) é uma **instância separada**, não uma organização dentro do mesmo
  banco. Os pontos jurídicos abaixo continuam válidos.
- **Data:** 2026-11-09

## Contexto

No futuro, a plataforma poderá ser usada para gerir equipes de **campanhas eleitorais**. Uma
campanha é **outro controlador de dados** (candidato ou partido), com **outra finalidade**, e
está sujeita à legislação eleitoral.

Pontos de atenção **[jurídico]**:

- **LGPD art. 11:** dado que revele opinião política é dado **sensível** e exige consentimento
  específico e destacado.
- **Lei 9.504/97, art. 57-E:** proíbe venda e cessão de cadastros a candidatos e partidos.
  Repassar a base de alunos para uma campanha pode ser ilegal.
- **Resolução TSE 23.610/2019:** traz regras para uso de dados pessoais em propaganda.

## Decisão

1. **Toda tabela de negócio tem `organization_id`** desde o primeiro dia. A Academia é a
   organização nº 1.
2. **Dados nunca cruzam organizações.** A RLS filtra por organização antes de qualquer outra
   regra; existe teste para isso.
3. **Uma campanha é uma organização nova**, com cadastro, termo de consentimento, chaves de
   criptografia e gestores próprios. Reaproveita-se **o código**, nunca a base de pessoas.
4. **No POC, a interface não mostra organizações.** Há uma só, e a coluna fica preenchida por
   padrão. Isso custa uma coluna por tabela e evita uma migração dolorosa depois.

## Consequências

- (+) A futura campanha não exige reescrever o sistema.
- (+) O isolamento de dados entre a Academia e a campanha já nasce garantido por teste.
- (−) Uma condição a mais em cada política RLS (já coberta pela função `app.current_org()`).
