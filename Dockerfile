# --------------------
# 1. ETAPA DE CONSTRUCCIÓN (Build Stage)
# --------------------
# Usa una imagen de Node.js (por ejemplo, la versión 18) para construir la aplicación.
FROM node:22.21-alpine3.22 as builder

# Establece el directorio de trabajo.
WORKDIR /app

# Copia los archivos de configuración de dependencias.
COPY package.json package-lock.json ./

# Instala las dependencias (mejor usar npm ci para instalaciones limpias y exactas si tienes lockfile).
RUN npm install

# Copia el código fuente restante.
COPY . .

# Ejecuta la construcción de la aplicación Vite.
RUN npm run build

# --------------------
# 2. ETAPA DE EJECUCIÓN (Runtime Stage)
# --------------------
# Usa una imagen ligera de Nginx para servir los archivos estáticos.
FROM nginx:alpine

# Copia los archivos estáticos construidos desde la etapa 'builder' al directorio de servicio de Nginx.
# La carpeta 'dist' es donde Vite guarda la construcción de producción por defecto.
COPY --from=builder /app/dist /usr/share/nginx/html

# Opcional: Si necesitas una configuración personalizada de Nginx,
# puedes copiar aquí tu archivo nginx.conf.

# Expone el puerto por defecto de Nginx.
EXPOSE 80

# Comando para iniciar Nginx (el que viene por defecto en la imagen de Nginx).
CMD ["nginx", "-g", "daemon off;"]