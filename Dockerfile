# Stage 1: Build and publish the app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /src

# Copy project file and restore dependencies
COPY ["/FinanceApp.csproj", "FinanceApp/"]
RUN dotnet restore "FinanceApp/FinanceApp.csproj"

# Copy the rest of the source code
COPY . .

# Publish the application (skip build step)
WORKDIR /src/FinanceApp
RUN dotnet publish "FinanceApp.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Stage 2: Create final runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final

# Create a non-root user
RUN useradd -m appuser

WORKDIR /app

# Copy published output
COPY --from=build /app/publish .

# Set permissions
RUN chown -R appuser:appuser /app
USER appuser

# Expose port
EXPOSE 5000

# Start the app
ENTRYPOINT ["dotnet", "FinanceApp.dll"]
