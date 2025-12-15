# Proyecto

Este directorio contiene utilidades para generar rápidamente una **Minimal API** en .NET junto con su proyecto de pruebas y configuración básica de Docker.

## Estructura generada

Al ejecutar el generador se crean, para el nombre de proyecto que elijas, dos proyectos y una solución:

- `<NombreProyecto>/` — Proyecto principal de Minimal API de .NET.
- `<NombreProyecto>.Tests/` — Proyecto de pruebas con xUnit.
- `<NombreProyecto>.sln` — Solución que referencia ambos proyectos.
- `<NombreProyecto>/Dockerfile` — Imagen base para publicar y ejecutar la API.

## Script disponible

- [`generador.sh`](generador.sh): script Bash que automatiza la creación del proyecto, las pruebas y el Dockerfile.

## Requisitos

- .NET 6 SDK o superior.
- Bash (por ejemplo, en WSL, macOS o Linux).
- Docker (opcional, solo para construir/ejecutar la imagen).

## Uso

Desde este directorio, ejecuta:

```bash
chmod +x generador.sh
./generador.sh MiApi
```

El script realizará:

1. Crear la Minimal API (`dotnet new webapi -n MiApi`).
2. Crear las pruebas (`dotnet new xunit -n MiApi.Tests`).
3. Referenciar los proyectos entre sí (`dotnet add ... reference ...`).
4. Crear la solución y agregar ambos proyectos (`dotnet sln ... add ...`).
5. Agregar paquetes de pruebas necesarios (`Microsoft.AspNetCore.Mvc.Testing`, `Minivalidation`).
6. Generar un `Dockerfile` listo para publicar y ejecutar la API.

## Siguientes pasos

1. Entra al proyecto principal:
   ```bash
   cd MiApi
   dotnet run
   ```
2. Ejecuta las pruebas:
   ```bash
   cd ../MiApi.Tests
   dotnet test
   ```
3. Construye la imagen Docker (opcional):
   ```bash
   cd ../MiApi
   docker build -t miapi:latest .
   docker run -p 8080:80 miapi:latest
   ```