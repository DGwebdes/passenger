# STAGE 1: Build
FROM node:24-slim AS build

SHELL ["/bin/bash", "-uec"]

RUN apt-get update && apt-get install -y --no-install-recommends \
	ca-certificates \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

RUN corepack enable

WORKDIR /app

COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile
 
COPY . .
RUN pnpm build

# STAGE 2: Serve
FROM nginx:alpine AS runner
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]


