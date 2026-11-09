#!/usr/bin/env bash
# Bloqueia colunas de dados pessoais proibidos nas migrations (regra R4 do AGENTS.md).
set -euo pipefail
DIR="${1:-supabase/migrations}"
[ -d "$DIR" ] || { echo "Sem $DIR — nada a checar."; exit 0; }
PATTERN='\b(cpf|rg|titulo_eleitor|voter_id|birth_?date|birthday|date_of_birth|data_nascimento|address|endereco|cep|zip_?code|postal_code|gender|genero|race|raca|religion|religiao|latitude|longitude|lat|lng|ip_address|photo|selfie|document_image)\b'
if grep -rniE "$PATTERN" "$DIR" --include='*.sql'; then
  echo ""
  echo "ERRO: campo de dado pessoal proibido encontrado (ver docs/MODELO_DADOS.md)."
  echo "Para adicionar um campo novo, abra um ADR e peça aprovação."
  exit 1
fi
# Dados pessoais permitidos só podem existir cifrados (colunas *_enc) — ADR 0003.
PLAIN='\b(display_name|full_name|name_plain|whatsapp|phone|telefone|celular|social_links|email)\b[[:space:]]+(text|varchar|character|jsonb|json|citext)'
if grep -rniE "$PLAIN" "$DIR" --include='*.sql'; then
  echo ""
  echo "ERRO: dado pessoal em texto puro. Use a coluna cifrada <campo>_enc (ADR 0003)."
  exit 1
fi
echo "OK: nenhum campo proibido."
