FROM node:22.23.2 AS build

WORKDIR /usr/src/app
COPY package.json yarn.lock ./
RUN yarn

# Copia tudo dentro do diretório original para o WORKDIR.
COPY . .

RUN yarn run build
RUN yarn install --production

FROM node:22.23.2-alpine3.24

WORKDIR /usr/src/app
COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules
COPY --from=build /usr/src/app/package.json ./

# Expoẽ a porta 3000
EXPOSE 3000

# A diferença é que o ENTRYPOINT não é mutável a nível de CLI.
CMD ["yarn", "run", "start:prod"]