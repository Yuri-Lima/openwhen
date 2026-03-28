#!/usr/bin/env bash
# Obtém idToken via Identity Toolkit (REST) — útil para testar curl ao bootstrapAdminClaim.
#
# NÃO coloques segredos neste ficheiro (é versionado).
#
# 1) cp scripts/bootstrap-token.example.sh scripts/bootstrap-token.local.sh
# 2) chmod +x scripts/bootstrap-token.local.sh
# 3) Edita bootstrap-token.local.sh e descomenta + preenche os três export abaixo
#    (ou exporta no terminal antes de correr o script).
# 4) ./scripts/bootstrap-token.local.sh
#
# scripts/bootstrap-token.local.sh está no .gitignore.

set -euo pipefail

# Descomenta e preenche APENAS em bootstrap-token.local.sh (não aqui):
# export FIREBASE_WEB_API_KEY="(Firebase Console → Project settings → Your apps → Web API Key)"
# export BOOTSTRAP_EMAIL="seu@email.com"
# export BOOTSTRAP_PASSWORD="(password forte)"

: "${FIREBASE_WEB_API_KEY:?Defina FIREBASE_WEB_API_KEY (ver comentários no topo)}"
: "${BOOTSTRAP_EMAIL:?Defina BOOTSTRAP_EMAIL}"
: "${BOOTSTRAP_PASSWORD:?Defina BOOTSTRAP_PASSWORD}"

curl -s "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${FIREBASE_WEB_API_KEY}" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"${BOOTSTRAP_EMAIL}\",\"password\":\"${BOOTSTRAP_PASSWORD}\",\"returnSecureToken\":true}"

echo ""
echo "# Na resposta JSON, usa o campo idToken em: Authorization: Bearer <idToken>"
