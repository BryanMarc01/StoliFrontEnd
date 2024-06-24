# Usa una imagen base oficial de Node.js para construir la aplicación
FROM node:16 as build

# Establece el directorio de trabajo
WORKDIR /usr/src/app

# Copia los archivos de configuración necesarios
COPY package*.json ./

# Instala las dependencias del proyecto
RUN npm install

# Copia el resto de los archivos del proyecto
COPY . .

# Construye la aplicación
RUN npm run build

# Usa una imagen base oficial de Node.js para producción
FROM node:16-alpine as production

# Instala el servidor estático 'serve'
RUN npm install -g serve

# Establece el directorio de trabajo
WORKDIR /usr/src/app

# Copia los archivos construidos desde la fase de construcción
COPY --from=build /usr/src/app/build ./build

# Exponer el puerto de la aplicación
EXPOSE 3001

# Comando para ejecutar la aplicación
CMD ["serve", "-s", "build"]

# Usa una imagen base oficial de Node.js para pruebas
FROM node:16 as test

# Establece el directorio de trabajo
WORKDIR /usr/src/app

# Copia los archivos de configuración necesarios
COPY package*.json ./

# Instala todas las dependencias (producción + desarrollo)
RUN npm install

# Copia el resto de los archivos del proyecto
COPY . .

# Ejecuta las pruebas
CMD ["npm", "test"]
