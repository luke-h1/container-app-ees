FROM node:16.14.2-alpine AS builder

WORKDIR /app
COPY . .

# RUN rm -rf src/GovUk.*

RUN corepack enable

RUN pnpm i
RUN pnpm --filter=explore-education-statistics-frontend... install
RUN pnpm --filter=explore-education-statistics-frontend build

FROM node:16.14.2-alpine

WORKDIR /usr/src/app

COPY --from=builder /app/package.json .
COPY --from=builder /app/pnpm-lock.yaml .
COPY --from=builder /app/pnpm-workspace.yaml .
COPY --from=builder /app/src/explore-education-statistics-common/ ./src/explore-education-statistics-common/
COPY --from=builder /app/src/explore-education-statistics-frontend/ ./src/explore-education-statistics-frontend/

RUN corepack enable

RUN pnpm i
RUN pnpm --filter=explore-education-statistics-frontend... --prod install

WORKDIR /usr/src/app/src/explore-education-statistics-frontend

ENV NODE_ENV=production
EXPOSE 3000

USER node
CMD [ "pnpm", "start" ]
# Dockerfile-public-frontend
# change dockerignore to reflect naming
# remove rm -rf stuff as it's ignored
# maybe in new docker dir
# will need to change build context (keep as root of repo) - starting point of docker image
# change dockerfile to reflect naming