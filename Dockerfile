# syntax = docker/dockerfile:1.2

FROM bitnami/java:17 as builder

ARG CACHE_DIR=.m2

WORKDIR /app

COPY .mvn .mvn
COPY mvnw .
COPY pom.xml .
RUN ./mvnw dependency:resolve

COPY src src

ENV JDBC_URL="jdbc:postgresql://localhost:5432/db?user=app&password=pass"
RUN ./mvnw verify

FROM bitnami/java:17 as final

USER nobody
COPY --from=builder /app/target/app.jar /app.jar
EXPOSE 8080

ENTRYPOINT ["/app.jar"]