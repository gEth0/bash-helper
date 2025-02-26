#!/bin/bash

API_KEY="$DEEP_API_KEY"
API_URL="https://api.deepinfra.com/v1/openai/chat/completions"

CONTEXT='[{"role":"system","content":"Sei un chatbot molto intelligente ,devi  rispondere SOLAMENTE con il codice bash che ti chiedo, spiega solamente attraverso i commenti NEL CODICE e falli in modo dettagliato, fai si che il codice sia possibile copiarlo e incolarlo in un file sh per eseguirlo, non devi fare errori, realizza il tutto usando i comandi nella maniera più semplice possibile evitando soluzioni di alto livello ma stando alla pari di uno studente delle superiori di informatica"}]'


chat_with_ai() {
    local user_message="$1"

    
    CONTEXT=$(echo "$CONTEXT" | jq --arg msg "$user_message" '. + [{"role": "user", "content": $msg}]')

    
    RESPONSE=$(curl -s -X POST "$API_URL" \
        -H "Authorization: Bearer $API_KEY" \
        -H "Content-Type: application/json" \
        -d '{
            "model": "meta-llama/Meta-Llama-3-8B-Instruct",
            "messages": '"$CONTEXT"',
            "max_tokens": 512
        }')

   
    AI_RESPONSE=$(echo "$RESPONSE" | jq -r '.choices[0].message.content')

    # Verifica se la risposta è vuota
    if [ -z "$AI_RESPONSE" ]; then
        AI_RESPONSE="(Errore o nessuna risposta ricevuta)"
    fi

   
    CONTEXT=$(echo "$CONTEXT" | jq --arg msg "$AI_RESPONSE" '. + [{"role": "assistant", "content": $msg}]')

    echo "$AI_RESPONSE"
}

# Loop della chat
echo "bash helper chat - Scrivi 'exit' per uscire"
while true; do
    echo -n "Tu: "
    read USER_INPUT
    [[ "$USER_INPUT" == "exit" ]] && break
    echo -e "$(chat_with_ai "$USER_INPUT")\n"
done
