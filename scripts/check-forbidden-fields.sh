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
echo "OK: nenhum campo proibido."
