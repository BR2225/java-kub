# === Stage 1: Build Java WAR ===
FROM maven:3.9.4-eclipse-temurin-17 AS builder

WORKDIR /app

COPY pom.xml ./
RUN mvn dependency:go-offline -B

COPY src ./src
RUN mvn clean package -DskipTests

# === Stage 2: Runtime Image ===
FROM eclipse-temurin:17
WORKDIR /app

# FIX: this is the correct way to copy the WAR from builder stage
COPY --from=builder /app/target/onlinebookstore.war app.war

EXPOSE 8080


CMD ["java", "-war", "app.war"]

