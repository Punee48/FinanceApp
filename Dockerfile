FROM mcr.microsoft.com/dotnet/sdk:8.0 AS Build
WORKDIR /src
ARG BUILD_CONFIG=Release
COPY *.sln ./
COPY ["/FinanceApp.csproj", "FinanceApp/"]

#Restore Dependencies
RUN dotnet restore "./FinanceApp/FinanceApp.csproj"

#Copy all file
COPY . ./
#Publish the Application
WORKDIR "/src/FinanceApp"
RUN dotnet build "./FinanceApp.csproj" -c ${BUILD_CONFIG} -o /app/build

FROM build as publish
ARG $BUILD_CONFIG=Release
RUN dotnet publish "./FinanceApp.csproj" -c ${BUILD_CONFIG} -o /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
RUN useradd -m appuser
WORKDIR /app
COPY --from=publish /app/publish .
RUN chown -R appuser:appuser /app
USER appuser
EXPOSE 5000

ENTRYPOINT ["dotnet", "FinanceApp.dll"]
