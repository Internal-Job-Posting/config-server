# Build stage
FROM eclipse-temurin:17-jdk-jammy AS build
ENV HOME=/usr/app/config-server
RUN mkdir -p $HOME
WORKDIR $HOME

# Copy gradle wrapper and source code
COPY build.gradle $HOME/
COPY settings.gradle $HOME/
COPY gradlew $HOME/
COPY gradle $HOME/gradle
COPY src $HOME/src

# Build the application with Gradle
RUN ./gradlew clean build -x test --no-daemon

# Package stage
FROM eclipse-temurin:17-jre-jammy
COPY --from=build /usr/app/config-server/build/libs/*.jar /app/config-server.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/config-server.jar"]