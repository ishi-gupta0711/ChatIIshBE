# Build stage: Maven + Java 17
FROM maven:3.8.8-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .
RUN chmod +x mvnw || true
RUN ./mvnw clean package -DskipTests

# Runtime stage: Java 17
FROM eclipse-temurin:17-jdk
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar

ENV JAVA_HOME=/opt/java/openjdk
ENV PATH=$JAVA_HOME/bin:$PATH

EXPOSE 8080
CMD ["java", "-jar", "app.jar"]
