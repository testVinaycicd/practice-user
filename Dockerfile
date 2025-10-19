FROM            node:20-alpine AS deps

WORKDIR         /app

COPY            package*.json ./

RUN             npm install

LABEL           maintainer=vinay





FROM            node:20-alpine AS build

WORKDIR         /app

COPY            . .





FROM            node:20-alpine AS runner

ENV             PORT=8080

WORKDIR         /app

RUN             addgroup -S appgroup && adduser -S appuser -G appgroup

COPY            --from=deps /app/node_modules  ./node_modules

COPY            --chown=appuser:appgroup  --from=build /app ./

EXPOSE          8080

HEALTHCHECK --interval=30s --timeout=3s \
    CMD curl -f http:localhost:8080/health || exit 1

CMD ["node","server.js"]