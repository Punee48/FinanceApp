FROM mcr.microsoft.com/dotnet/sdk:8.0 AS Build
USER $APP_UID
WORKDIR /src
ARG BUILD_CONFIG=Release
COPY *.sln ./
COPY ["FinanceApp/FinanceApp.csproj", "FinanceApp/"]

#Restore Dependencies
RUN dotnet restore "./FinanceApp/FinanceApp.csproj"

#Copy all file
COPY . ./
#Publish the Application
WORKDIR "/src/FinanceApp"
RUN dotnet build "./FinanceApp.csproj" -c $BUILD_CONFIG -o /app/build 

FROM build as publish 
ARG $BUILD_CONFIG=Release
RUN dotnet publish "./FinanceApp.csproj" -c $BUILD_CONFIG -o /app/publish /p:UseAppHost=false
 
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=publish /app/publish .
EXPOSE 5000

ENTRYPOINT ["dotnet", "FinanceApp.dll"] 
