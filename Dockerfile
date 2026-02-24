# 1. Usamos una imagen oficial de JBoss (WildFly es el sucesor de JBoss)
FROM quay.io/wildfly/wildfly:latest

# 2. Definimos quién mantiene la imagen (opcional)
LABEL maintainer="aaron"

# 3. Copiamos el archivo generado en el build a la carpeta de despliegue de JBoss
# IMPORTANTE: Asegúrate de que el nombre coincida con el que genera tu Maven
COPY target/*.war /opt/jboss/wildfly/standalone/deployments/

# 4. JBoss/WildFly corre por defecto en el puerto 8080
EXPOSE 8080

# 5. El comando de arranque ya viene definido en la imagen base
