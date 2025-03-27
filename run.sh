#!/bin/bash

declare -A REPOS=(
  ["eureka-server"]="https://github.com/Showcase-of-projects/eureka-server.git"
  ["gateway"]="https://github.com/Showcase-of-projects/gateway.git"
  ["topic-service"]="https://github.com/Showcase-of-projects/topic-service.git"
)

BRANCH="master"

echo "🚀 Клонирование и обновление репозиториев..."

for DIR in "${!REPOS[@]}"; do
  URL="${REPOS[$DIR]}"

  if [ -d "$DIR" ]; then
    echo "🔄 $DIR уже существует, обновляем..."
    cd "$DIR" && git pull origin "$BRANCH" && cd ..
  else
    echo "📥 Клонируем $DIR из $URL"
    git clone --branch "$BRANCH" "$URL" "$DIR"
  fi
done

echo "🐳 Запуск docker-compose..."
docker-compose up --build
