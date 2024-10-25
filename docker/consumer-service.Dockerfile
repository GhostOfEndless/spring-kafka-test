FROM gradle:jdk21-alpine AS builder
ENV APP_HOME=/opt/app
WORKDIR $APP_HOME
COPY build.gradle settings.gradle ./
COPY consumer-service/build.gradle ./consumer-service/build.gradle
COPY consumer-service/src ./consumer-service/src
RUN gradle clean bootJar

FROM eclipse-temurin:21.0.4_7-jre-alpine AS final
ENV APP_HOME=/opt/app
WORKDIR $APP_HOME
COPY --from=builder $APP_HOME/consumer-service/build/libs/*.jar .
EXPOSE 8091
ENTRYPOINT exec java -jar *.jar