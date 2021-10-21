FROM node:11 as builder
RUN npm config set proxy http://kpproxygsit:8080
RUN npm config set https-proxy http://kpproxygsit:8080
WORKDIR /build
COPY package.json package-lock.json ./
RUN npm install
COPY . ./
RUN npm run build-dev


FROM nginxinc/nginx-unprivileged
ENV HTTP_PROXY "http://kpproxygsit:8080"
ENV HTTPS_PROXY "http://kpproxygsit:8080"

RUN rm -fr /etc/nginx/conf.d/default.conf
COPY frontend.conf /etc/nginx/conf.d/frontend.conf
COPY --from=builder /build/dist /var/www/html
COPY entrypoint.sh /tmp/
EXPOSE 8080


ENTRYPOINT [ "/tmp/entrypoint.sh" ]