#!/bin/bash

declare -A REPOS=(
  ["eureka-server"]="https://github.com/Showcase-of-projects/eureka-server.git"
  ["gateway"]="https://github.com/Showcase-of-projects/gateway.git"
  ["topic-service"]="https://github.com/Showcase-of-projects/topic-service.git"
  ["auth-service"]="https://github.com/Showcase-of-projects/auth-service.git"
  ["team-service"]="https://github.com/Showcase-of-projects/team-service.git"
)


BRANCH="master"
UPDATED_SERVICES=()

echo "Клонирование/обновление репозиториев..."

for DIR in "${!REPOS[@]}"; do
  URL="${REPOS[$DIR]}"
  echo "Проверка $DIR"

  if [ ! -d "$DIR" ]; then
    echo "Клонируем $DIR из $URL"
    git clone --branch "$BRANCH" "$URL" "$DIR"
    UPDATED_SERVICES+=("$DIR")
  else
    cd "$DIR"
    git fetch origin "$BRANCH"
    LOCAL_HASH=$(git rev-parse HEAD)
    REMOTE_HASH=$(git rev-parse origin/"$BRANCH")

    if [ "$LOCAL_HASH" != "$REMOTE_HASH" ]; then
      echo "Обновления найдены в $DIR, делаем pull"
      git pull origin "$BRANCH"
      UPDATED_SERVICES+=("$DIR")
    else
      echo "$DIR актуален"
    fi
    cd ..
  fi
done

for SERVICE in "${UPDATED_SERVICES[@]}"; do
  echo "🔨 Пересборка контейнера для $SERVICE"
  docker-compose build "$SERVICE"
done

echo "Запуск docker-compose..."
docker-compose up
