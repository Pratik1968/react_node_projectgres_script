echo "Enter the name of project :"
read project_name
mkdir ./$project_name
#   server block start
mkdir ./$project_name/server
mkdir ./$project_name/server/src
mkdir ./$project_name/server/dist
cd ./$project_name/server
npm install typescript --save
npm install express --save
npm install nodemon --save
echo  '
import { Express, Request, Response } from "express";
import express = require("express")
const app: Express = express();
const port =  3000;
app.listen(port, () => {
  console.log(`[server]: Server is running at http://localhost`);
});

'>>./src/app.ts

npm init -y
echo  '
{
    "compilerOptions":{
        "module": "CommonJS",
        "removeComments": true,
        "sourceMap": true,
        "outDir": "dist/"
    },
    "include": ["src/**/*"],
}
' >> tsconfig.json 
echp 'node_modules'>>.dockerignore
echo '

FROM node:alpine
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install
RUN npm install -g nodemon
COPY . .
' >> Dockerfile
brew install jq
# Append the "dev" key-value pair to package.json
value="nodemon -w src -e ts,tsx --exec 'npx tsc --build && node dist/app.js'"

jq --arg dev "$dev_value" '.scripts += { "dev": "'$value'" }' package.json > tmp.json && mv tmp.json package.json
# server block end
# app start
cd ..
npm create vite@latest app --template react
cd app
npm install 
npm install react-router-dom
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init -p
echo '
/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",


"./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}



'> tailwind.config.js

echo '
import * as React from "react";
import * as ReactDOM from "react-dom/client";
import {
  createBrowserRouter,
  RouterProvider,
} from "react-router-dom";
import "./index.css";

const router = createBrowserRouter([
  {
    path: "/",
    element: <div>Hello world!</div>,
  },
]);

ReactDOM.createRoot(document.getElementById("root")!).render(
  <React.StrictMode>
    <RouterProvider router={router} />
  </React.StrictMode>
);

'>src/main.tsx

echo '
@tailwind base;
@tailwind components;
@tailwind utilities;

'>src/index.css
echo '
FROM node:21-alpine
WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install
COPY ./src .
CMD [ "npm" ,"run","dev"]
' >> Dockerfile


rm src/App.tsx
rm src/App.css




# app end
cd ..
echo '
version: "1.0"
services:
  frontend:
    restart: always
    build: ./app
    ports:
      - '5173:5173'
    volumes:
      - ./app/src:/app/src

  db:
    restart: always

    image: postgres
    ports:
      - '5432:5432'
    environment:
      - POSTGRES_PASSWORD=test
      - POSTGRES_USER=username
      - POSTGRES_DB=database

  server:
    restart: always
    build: ./server
    ports:
      - '5001:5000'
    command:  npm run dev
    volumes:
      - ./server/src:/app/src

       


' >> docker-compose.yaml
