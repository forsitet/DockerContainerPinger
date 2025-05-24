FROM ubuntu:22.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y curl git wget unzip xz-utils zip libglu1-mesa fonts-droid-fallback sudo ca-certificates python3 && \
    apt-get clean

RUN useradd -m flutter && echo "flutter ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

ENV PUB_HOSTED_URL=https://pub.flutter-io.cn
ENV FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
ENV PATH="/home/flutter/flutter/bin:/home/flutter/flutter/bin/cache/dart-sdk/bin:${PATH}"

USER flutter
WORKDIR /home/flutter
RUN git clone https://github.com/flutter/flutter.git && \
    flutter/bin/flutter doctor

RUN flutter channel master
RUN flutter upgrade
RUN flutter config --enable-web

USER root
WORKDIR /app


COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .

RUN git config --global --add safe.directory /home/flutter/flutter
RUN flutter build web --release

FROM nginx:stable-alpine AS base

RUN apk update && apk upgrade --no-cache && rm /etc/nginx/conf.d/default.conf

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/build/web /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
