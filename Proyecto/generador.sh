#!/bin/bash

# Verifica si se ha proporcionado un nombre de proyecto como argumento
if [ -z "$1" ]; then
    echo "Por favor, proporciona un nombre para el proyecto como argumento."
    exit 1
fi

# Nombre del proyecto
PROJECT_NAME="$1"

# Crea un proyecto de minimal api de .net
echo "CREANDO PROYECTO DE MINIMAL API DE .NET: ${PROJECT_NAME}"
dotnet new webapi -n "${PROJECT_NAME}"

# Crea un proyecto de pruebas para el proyecto de minimal api de .net
echo "CREANDO PROYECTO DE TESTS"
dotnet new xunit -n "${PROJECT_NAME}.Tests"

# Asocia los dos proyectos
echo "ASOCIANDO PROYECTOS"
dotnet add "${PROJECT_NAME}.Tests/${PROJECT_NAME}.Tests.csproj" reference "${PROJECT_NAME}/${PROJECT_NAME}.csproj"

# Crea un archivo de solución de .net
echo "CREANDO SOLUCIÓN DE .NET: ${PROJECT_NAME}.sln"
dotnet new sln -n "${PROJECT_NAME}"

# Agrega ambos proyectos a la solución
echo "AGREGANDO PROYECTOS A LA SOLUCIÓN"
dotnet sln "${PROJECT_NAME}.sln" add "${PROJECT_NAME}/${PROJECT_NAME}.csproj"
dotnet sln "${PROJECT_NAME}.sln" add "${PROJECT_NAME}.Tests/${PROJECT_NAME}.Tests.csproj"

# Agrega los paquetes necesarios para el proyecto de test de minimal api de .net
echo "AGREGANDO PAQUETES NECESARIOS AL PROYECTO DE TESTS"
dotnet add "${PROJECT_NAME}.Tests/${PROJECT_NAME}.Tests.csproj" package Microsoft.AspNetCore.Mvc.Testing
dotnet add "${PROJECT_NAME}.Tests/${PROJECT_NAME}.Tests.csproj" package Minivalidation

# Agrega un archivo de Docker en el proyecto de minimal api de .net
echo "AGREGANDO DOCKERFILE AL PROYECTO DE MINIMAL API"
cd "${PROJECT_NAME}" || exit

cat <<EOL > Dockerfile
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS build
WORKDIR /app

COPY *.csproj ./
RUN dotnet restore

COPY . ./
RUN dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime
WORKDIR /app
COPY --from=build /app/out ./

EXPOSE 80

ENTRYPOINT ["dotnet", "${PROJECT_NAME}.dll"]
EOL

echo "ARCHIVO DE DOCKER AGREGADO"

cd .. || exit

echo "PROYECTO ${PROJECT_NAME} DESPLEGADO CON ÉXITO"