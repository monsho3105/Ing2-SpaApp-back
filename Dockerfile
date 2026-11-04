# ---- Etapa 1: compilar con Maven y Java 21 ----
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app

# Cachear dependencias
COPY pom.xml .
RUN mvn -B -q dependency:go-offline

# Compilar el proyecto
COPY src ./src
RUN mvn -B -q clean package -DskipTests

# ---- Etapa 2: imagen liviana para ejecutar ----
FROM eclipse-temurin:21-jre
WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
