ARG runtime_base_tag=43234
ARG build_base_tag=24234

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
FROM openshift/dotnet:2.1 AS runtime
WORKDIR /app
COPY --from=build /app/opcpublisher/out ./
COPY ./src/*.json /appdata/
WORKDIR /appdata
ENTRYPOINT ["dotnet", "/app/opcpublisher.dll", "opcuagateway", "connstring", "--autoaccept=TRUE", "-ll=DEBUG"]
