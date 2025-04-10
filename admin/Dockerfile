FROM python:3.10-slim

RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev

WORKDIR /app

COPY requirements.txt ./
RUN pip install -r requirements.txt

COPY . /app/

RUN chmod +x /app/entrypoint.sh && \
    [ -f /app/entrypoint.sh ] && \
    head -1 /app/entrypoint.sh | grep -q "^#!" || { echo "No shebang in entrypoint.sh"; exit 1; }

# Правильный формат запуска
ENTRYPOINT ["/app/entrypoint.sh"]
