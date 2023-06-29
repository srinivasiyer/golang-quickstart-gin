FROM golang:1.20-bookworm
COPY . /app
WORKDIR /app
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o app main.go

FROM debian:bookworm-slim
WORKDIR /root
COPY --from=0 /app/app ./
RUN apt-get update \
    && apt-get install -y --force-yes --no-install-recommends apt-transport-https curl ca-certificates \
    && apt-get clean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*
EXPOSE 80
ENTRYPOINT ["./app"]