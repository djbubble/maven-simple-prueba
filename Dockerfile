# 1. Usamos una imagen oficial de JBoss (WildFly es el sucesor de JBoss)
FROM quay.io/wildfly/wildfly:latest

# 2. Definimos quién mantiene la imagen (opcional)
LABEL maintainer="aaron"

# 3. Copiamos SOLO el archivo principal y lo renombramos a .war
# Esto obliga a WildFly a crear una ruta web y limpia la carpeta de archivos extra
COPY target/maven-simple-0.2-SNAPSHOT.jar /opt/jboss/wildfly/standalone/deployments/maven-simple.war

# 4. JBoss/WildFly corre por defecto en el puerto 8080
EXPOSE 8080

# 5. El comando de arranque ya viene definido en la imagen base
