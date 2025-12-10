
# Build stage, official microsoft .NET SDK image for building app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Setup working directory
WORKDIR /app

# Copy csproj and restore dependencies (caching layers)
COPY *.sln ./
COPY hello-world-api/*.csproj ./hello-world-api/
RUN dotnet restore

# Copy rest of the source code
COPY . ./

# Build app in Release config
RUN dotnet publish hello-world-api/hello-world-api.csproj -c Release -o out/

# Runtime stage, official microsoft .NET runtime image for running app
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app

# Make the app listen on all network interfaces
ENV ASPNETCORE_URLS=http://0.0.0.0:5000

# Copy published output from the build stage
COPY --from=build /app/out .

# Expose port 
EXPOSE 5000

# Entry point to run application
ENTRYPOINT ["dotnet", "hello-world-api.dll"]
