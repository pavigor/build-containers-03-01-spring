FROM bitnami/java:17 as builder

WORKDIR /app

COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
COPY src src

ENV JDBC_URL="jdbc:postgresql://172.17.0.3:5432/db?user=app&password=pass"

RUN ./mvnw verify

FROM bitnami/java:17 as final

USER nobody
COPY --from=builder /app/target/app.jar /app.jar
EXPOSE 8080

ENTRYPOINT ["/app.jar"]