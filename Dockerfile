FROM rust:1.42 as builder

ENV RUSTYHOG_VERSION=1.0.4
WORKDIR /usr/src/rustyhog

RUN curl -s -SL https://github.com/newrelic/rusty-hog/archive/v${RUSTYHOG_VERSION}.tar.gz | \
    tar -zxvf - --strip 1 -C /usr/src/rustyhog
RUN cargo build --release



FROM debian:buster-slim

WORKDIR /usr/src/rustyhog

RUN apt-get update && apt-get install -y openssl openssh-client ca-certificates
COPY --from=builder /usr/src/rustyhog/target/release/*_hog /usr/local/bin/
CMD ["ls", "-l", "/usr/local/bin"]
