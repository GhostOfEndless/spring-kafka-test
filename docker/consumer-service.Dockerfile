FROM gradle:jdk21-alpine AS dependencies
WORKDIR /opt/app
ENV GRADLE_USER_HOME /cache
COPY build.gradle settings.gradle ./
COPY consumer-service/build.gradle consumer-service/build.gradle
RUN gradle :consumer-service:dependencies --no-daemon --stacktrace

FROM gradle:jdk21-alpine AS builder
ENV APP_HOME=/opt/app
WORKDIR $APP_HOME
COPY --from=dependencies /cache /home/gradle/.gradle
COPY --from=dependencies $APP_HOME $APP_HOME
COPY consumer-service/src consumer-service/src
RUN gradle :consumer-service:clean :consumer-service:bootJar --no-daemon --stacktrace

FROM eclipse-temurin:21.0.4_7-jre-alpine AS final
ENV APP_HOME=/opt/app
WORKDIR $APP_HOME
COPY --from=builder $APP_HOME/consumer-service/build/libs/*.jar .
EXPOSE 8091
ENTRYPOINT exec java -jar *.jar