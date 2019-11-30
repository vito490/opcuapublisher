ARG runtime_base_tag=2.2-runtime-alpine
ARG build_base_tag=2.2-sdk-alpine

FROM microsoft/dotnet:${build_base_tag} AS build
WORKDIR /app

##fix permission per /app##################
     chown -R opcpublisher /app && \
     chgrp -R 0 /app && \
     chmod -R g+rw /app && \
     find /app -type d -exec chmod g+x {} + 
############################################

##fix permission per /configuration##################
     chown -R opcpublisher /configuration && \
     chgrp -R 0 /configuration && \
     chmod -R g+rw /configuration && \
     find /configuration -type d -exec chmod g+x {} + 
############################################

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
#FROM microsoft/dotnet:${runtime_base_tag} AS runtime
#WORKDIR /app
#COPY --from=build /app/opcpublisher/out ./
COPY /app/opcpublisher/out ./ #Riga 22 solo Per Openshift
#COPY ./src/*.json /appdata/
WORKDIR /appdata
ENTRYPOINT ["dotnet", "/app/opcpublisher.dll", "opcuagateway", "connstring", "--autoaccept=TRUE", "-ll=DEBUG"]