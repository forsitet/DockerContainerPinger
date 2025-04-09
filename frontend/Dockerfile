FROM ubuntu:24.04.2 AS builder

RUN apt-get update && apt-get install -y curl git unzip xz-utils zip libglu1-mesa openjdk-11-jdk

RUN curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.19.2-stable.tar.xz \
  && tar xf flutter_linux_3.19.2-stable.tar.xz

ENV PATH="/flutter/bin:/flutter/bin/cache/dart-sdk/bin:${PATH}"

WORKDIR /app
COPY . .

RUN flutter pub get
RUN flutter build web

# Этап для nginx
FROM nginx:stable-alpine
COPY --from=builder /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]