# 🔴 Build stage with older Node.js (known CVEs)
FROM node:14 AS build
WORKDIR /app
COPY package*.json ./

# 🔴 Vulnerable dependency (added below)
RUN npm install

COPY . .
RUN npm run build

# 🔴 Production stage with vulnerable nginx version
FROM nginx:1.17
COPY --from=build /app/dist /usr/share/nginx/html

# 🔴 Optional: simulate a secret
RUN echo "AWS_SECRET_ACCESS_KEY=demo1234567890fakekey" >> /etc/nginx/env_secrets.txt

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
