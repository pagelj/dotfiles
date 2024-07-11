export PORT=22223
docker pull searxng/searxng
docker run --rm \
           -d -p ${PORT}:8080 \
           -v "$HOME/.config/searxng:/etc/searxng" \
           -e "BASE_URL=http://localhost:$PORT/" \
           -e "INSTANCE_NAME=searxng" \
           searxng/searxng
