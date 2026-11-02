FROM maven:3.6.3-openjdk-8 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

FROM tomcat:8-jre8-alpine

# Удаляем стандартные приложения
RUN rm -rf /usr/local/tomcat/webapps/*

# Копируем WAR
COPY --from=build /app/target/App42PaaS-Java-MySQL-Sample-0.0.1-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

# Вручную распаковываем WAR в папку ROOT
RUN mkdir /usr/local/tomcat/webapps/ROOT && \
    cd /usr/local/tomcat/webapps/ROOT && \
    jar -xvf ../ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]