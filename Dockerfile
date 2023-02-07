FROM node:16-alpine AS builder

WORKDIR /app

COPY . .

RUN corepack enable

RUN pnpm --filter=explore-education-statistics-frontend... install
RUN pnpm --filter=explore-education-statistics-frontend build

FROM node:16-alpine

WORKDIR /usr/src/app

COPY --from=builder /app/package.json .
COPY --from=builder /app/pnpm-lock.yaml .
COPY --from=builder /app/pnpm-workspace.yaml .
# COPY --from=builder /app/src/explore-education-statistics-common/ ./src/explore-education-statistics-common/
COPY --from=builder /app/src/explore-education-statistics-frontend/ ./src/explore-education-statistics-frontend/

RUN corepack enable
RUN pnpm --filter=explore-education-statistics-frontend... --prod install

WORKDIR /usr/src/app/src/explore-education-statistics-frontend

ENV NODE_ENV=production
EXPOSE 3000

USER node
CMD [ "pnpm", "start" ]
