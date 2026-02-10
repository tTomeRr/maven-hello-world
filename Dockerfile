FROM maven:3.9.12-eclipse-temurin-25-alpine AS builder

WORKDIR /app

COPY ./myapp/pom.xml .
RUN mvn dependency:resolve dependency:resolve-plugins -B

COPY ./myapp/src ./src
RUN mvn package -DskipTests -B

FROM gcr.io/distroless/java21-debian12:nonroot

WORKDIR /app

COPY --from=builder /app/target/*.jar /app/app.jar

USER nonroot

CMD ["app.jar"]
