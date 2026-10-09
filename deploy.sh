#!/bin/bash
set -euo pipefail

PROJECT_DIR="/home/roi/devops-lab/devops-lab"
IMAGE="ghcr.io/prokhorovalexey1/devops-lab:latest"

cd "$PROJECT_DIR"

echo "=== Checking GHCR image ==="

REMOTE_DIGEST=$(docker buildx imagetools inspect "$IMAGE" --format '{{.Manifest.Digest}}')
LOCAL_DIGEST=$(docker image inspect "$IMAGE" --format '{{index .RepoDigests 0}}' 2>/dev/null | cut -d '@' -f 2 || true)

if [ -n "$LOCAL_DIGEST" ] && [ "$REMOTE_DIGEST" = "$LOCAL_DIGEST" ]; then
    echo "Image unchanged. Nothing to deploy."
    exit 0
fi

echo "New image detected. Pulling..."
docker compose pull backend

echo "Applying update..."
docker compose up -d --no-deps backend

echo "Checking application health..."
for i in {1..10}; 
do 
	if curl -fsS http://localhost:8080/ >/dev/null; then 
	echo "Application responds successfully" 
	exit 0 
fi
echo "Waiting for application... attempt $i/10"
sleep 3
done
echo "ERROR: Application is not responding!" 
docker compose logs --tail=50 backend nginx 
exit 1
echo "=== Deployment finished ==="
