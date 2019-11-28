ARG runtime_base_tag=2.2-runtime-alpine
ARG build_base_tag=2.2-sdk-alpine

FROM microsoft/dotnet:${build_base_tag} AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY src/*.csproj ./opcpublisher/
WORKDIR /app/opcpublisher
RUN dotnet restore

# copy and publish app
WORKDIR /app
COPY src/. ./opcpublisher/
WORKDIR /app/opcpublisher
RUN dotnet publish -c Release -o out

# start it up
FROM microsoft/dotnet:${runtime_base_tag} AS runtime
WORKDIR /app
COPY --from=build /app/opcpublisher/out ./
COPY ./src/*.json /appdata/
WORKDIR /appdata
ENTRYPOINT ["dotnet", "/app/opcpublisher.dll", "opcuagateway", "connstring", "--autoaccept=TRUE", "-ll=DEBUG"]