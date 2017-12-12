FROM quay.io/assemblyline/alpine:3.6

WORKDIR /app

COPY . .

RUN apk add --no-cache --virtual .builddeps \
      build-base \
      ca-certificates \
      curl \
      git \
      mariadb-dev \
      mariadb-client \
      ruby$(cat .ruby-version) \
      ruby$(cat .ruby-version)-dev \
      ruby$(cat .ruby-version)-irb

RUN bundle install -j4 -r3

ENTRYPOINT ["bundle", "exec"]
