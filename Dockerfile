FROM docker-registry.default.svc:5000/openshift/dotnet:2.1 AS build
WORKDIR /app
<<<<<<< HEAD

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

=======
>>>>>>> ccc1e294801435704b4f6fd1e9baa8d73e3c8082
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
<<<<<<< HEAD
#FROM microsoft/dotnet:${runtime_base_tag} AS runtime
#WORKDIR /app
#COPY --from=build /app/opcpublisher/out ./
COPY /app/opcpublisher/out ./ #Riga 22 solo Per Openshift
#COPY ./src/*.json /appdata/
=======
FROM docker-registry.default.svc:5000/openshift/dotnet:2.1 AS runtime
WORKDIR /app
COPY --from=build /app/opcpublisher/out ./
COPY ./src/*.json /appdata/
>>>>>>> ccc1e294801435704b4f6fd1e9baa8d73e3c8082
WORKDIR /appdata
ENTRYPOINT ["dotnet", "/app/opcpublisher.dll", "opcuagateway", "connstring", "--autoaccept=TRUE", "-ll=DEBUG"]
