Param(
    [Parameter(Mandatory = $true)]
    [string]$ProjectName
)

$ErrorActionPreference = "Stop"

Write-Host "CREANDO PROYECTO DE MINIMAL API DE .NET: $ProjectName"
dotnet new webapi -n $ProjectName

Write-Host "CREANDO PROYECTO DE TESTS"
dotnet new xunit -n "$ProjectName.Tests"

Write-Host "ASOCIANDO PROYECTOS"
dotnet add "$ProjectName.Tests/$ProjectName.Tests.csproj" reference "$ProjectName/$ProjectName.csproj"

Write-Host "CREANDO SOLUCIÓN DE .NET: $ProjectName.sln"
dotnet new sln -n $ProjectName

Write-Host "AGREGANDO PROYECTOS A LA SOLUCIÓN"
dotnet sln "$ProjectName.sln" add "$ProjectName/$ProjectName.csproj"
dotnet sln "$ProjectName.sln" add "$ProjectName.Tests/$ProjectName.Tests.csproj"

Write-Host "AGREGANDO PAQUETES NECESARIOS AL PROYECTO DE TESTS"
dotnet add "$ProjectName.Tests/$ProjectName.Tests.csproj" package Microsoft.AspNetCore.Mvc.Testing
# Minivalidation mantiene validaciones mínimas en tests
# Ajusta o elimina si no lo necesitas
# Usa la versión más reciente compatible con net6
dotnet add "$ProjectName.Tests/$ProjectName.Tests.csproj" package Minivalidation

Write-Host "AGREGANDO DOCKERFILE AL PROYECTO DE MINIMAL API"
Push-Location $ProjectName

@"
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

ENTRYPOINT ["dotnet", "$ProjectName.dll"]
"@ | Out-File -FilePath Dockerfile -Encoding UTF8 -Force

Pop-Location

Write-Host "PROYECTO $ProjectName DESPLEGADO CON ÉXITO"
