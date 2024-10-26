FROM gradle:jdk21-alpine AS dependencies
WORKDIR /opt/app
ENV GRADLE_USER_HOME /cache
COPY build.gradle settings.gradle ./
COPY producer-service/build.gradle producer-service/build.gradle
RUN gradle :producer-service:dependencies --no-daemon --stacktrace

FROM gradle:jdk21-alpine AS builder
ENV APP_HOME=/opt/app
WORKDIR $APP_HOME
COPY --from=dependencies /cache /home/gradle/.gradle
COPY --from=dependencies $APP_HOME $APP_HOME
COPY producer-service/src producer-service/src
RUN gradle :producer-service:clean :producer-service:bootJar --no-daemon --stacktrace

FROM eclipse-temurin:21.0.4_7-jre-alpine AS final
ENV APP_HOME=/opt/app
WORKDIR $APP_HOME
COPY --from=builder $APP_HOME/producer-service/build/libs/*.jar .
EXPOSE 8091
ENTRYPOINT exec java -jar *.jar