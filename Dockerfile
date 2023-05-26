   # Backend
   FROM node:14-alpine AS backend
   WORKDIR /app
   COPY backend/package*.json ./
   RUN npm install
   COPY backend/ .
   CMD ["npm", "run", "start:dev"]

   # Frontend
   FROM node:14-alpine AS frontend
   WORKDIR /app
   COPY frontend/package*.json ./
   RUN npm install
   COPY frontend/ .
   RUN npm run build

   # Nginx
   FROM nginx:alpine
   COPY --from=frontend /app/build /usr/share/nginx/html
   COPY nginx.conf /etc/nginx/conf.d/default.conf
   EXPOSE 80

   # Start backend and Redis
   CMD ["sh", "-c", "redis-server & npm run start:dev"]