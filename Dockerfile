FROM python:3.14-alpine

RUN adduser -D -u 10001 appuser

WORKDIR /app

COPY hello.html .

RUN chown -R appuser:appuser /app

USER appuser

CMD ["python", "-m", "http.server",  "--bind", "0.0.0.0", "8000"]

#docker build -t web:1.0.0 .
#docker run -d -p 8080:8000 --name myweb web:1.0.0


# # Установите Kind
# curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
# chmod +x ./kind
# sudo mv ./kind /usr/local/bin/
# # Создайте кластер
# kind create cluster  # Создает кластер ВНУТРИ Docker