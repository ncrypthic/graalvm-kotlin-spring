FROM ghcr.io/graalvm/graalvm-community:17.0.8-ol7-20230725 as builder

ENV DB_HOST=mongodb
ENV DB_USER=root
ENV DB_PASS=example

WORKDIR /root

RUN curl -o apache-maven-3.9.4-bin.tar.gz https://dlcdn.apache.org/maven/maven-3/3.9.4/binaries/apache-maven-3.9.4-bin.tar.gz

RUN tar xfz apache-maven-3.9.4-bin.tar.gz && ln -s /root/apache-maven-3.9.4/bin/mvn /usr/bin

COPY . /app

WORKDIR /app

RUN mvn -Pnative native:compile

FROM ghcr.io/graalvm/graalvm-community:17.0.8-ol7-20230725

COPY --from=builder /app/target /app

CMD ["sh", "-c", "/app/demo"]
