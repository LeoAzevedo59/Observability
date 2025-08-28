FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /app

COPY Observability.sln .

COPY ./Observability/Observability.csproj ./Observability/

RUN dotnet restore
RUN mkdir -p /logs && chmod 777 /logs

COPY . .

WORKDIR Observability
RUN dotnet publish Observability.csproj -c Release -o /out

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime

WORKDIR /app
COPY --from=build /out .

EXPOSE 80

RUN mkdir -p /logs && chown -R app:app /logs && chmod -R 755 /logs

ENTRYPOINT ["dotnet", "Observability.dll"]