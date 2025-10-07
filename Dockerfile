# Stage 1: Build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Set working directory inside the container
WORKDIR /src

# Copy only the project file to optimize layer caching
COPY ["FinanceApp/FinanceApp.csproj", "FinanceApp/"]

# Restore dependencies
RUN dotnet restore "FinanceApp/FinanceApp.csproj"

# Copy the rest of the source code
COPY . .

# Set working directory to the project folder
WORKDIR /src/FinanceApp

# Build the application
RUN dotnet build "FinanceApp.csproj" -c Release -o /app/build

# Stage 2: Publish the application
FROM build AS publish

# Publish the application for deployment
RUN dotnet publish "FinanceApp.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Stage 3: Create final runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final

# Create a non-root user for security
RUN useradd -m appuser

# Set working directory
WORKDIR /app

# Copy published output from the publish stage
COPY --from=publish /app/publish .

# Change ownership of the app directory to the non-root user
RUN chown -R appuser:appuser /app

# Switch to the non-root user
USER appuser

# Expose the port your app will run on
EXPOSE 5000

# Run the application
ENTRYPOINT ["dotnet", "FinanceApp.dll"]
