# Build stage with Maven and Java 17
FROM maven:3.8.8-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .

# Make Maven wrapper executable, if it exists
RUN chmod +x mvnw || true

# Build the project
RUN ./mvnw clean package -DskipTests

# Runtime stage
FROM eclipse-temurin:17-jdk
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar

# Set JAVA_HOME just in case
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH=$JAVA_HOME/bin:$PATH

EXPOSE 8080
CMD ["java", "-jar", "app.jar"]
