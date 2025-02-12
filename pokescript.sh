# Script that fetches the pokeapi

if [ -z "$1" ]; then
    echo "Error: write a pokemon name"
    exit 1
fi

POKEMON="$1"

API_URL="https://pokeapi.co/api/v2/pokemon/$POKEMON"

RESPONSE=$(curl -s -w "%{http_code}" "$API_URL")

HTTP_CODE_RESPONSE="${RESPONSE: -3}"

BODY_RESPONSE="${RESPONSE::-3}"

if [ "$HTTP_CODE_RESPONSE" -ne 200 ]; then
    echo "Error: couldn't find the pokemon $POKEMON"
    exit 1
fi

ID=$(echo "$BODY_RESPONSE" | jq '.id')
NAME=$(echo "$BODY_RESPONSE" | jq -r '.name')
WEIGHT=$(echo "$BODY_RESPONSE" | jq '.weight')
HEIGHT=$(echo "$BODY_RESPONSE" | jq '.height')
ORDER=$(echo "$BODY_RESPONSE" | jq '.order')

echo "${NAME} (No. $ID)"
echo "Id = $ID"
echo "Weight = $WEIGHT"
echo "Height = $HEIGHT"
echo "Order = $ORDER"

FILE="pokemon_data.csv"

if [ ! -f "$FILE" ]; then
    echo "id,name,weight,height,order" > "$FILE"
fi

echo "$ID,$NAME,$WEIGHT,$HEIGHT,$ORDER" >> "$FILE"
