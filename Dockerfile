# Use the official .NET SDK image to build the application
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build

# Set the working directory in the container
WORKDIR /app

# Copy the project file and restore dependencies
COPY *.csproj .
RUN dotnet restore

# Copy the rest of the application code
COPY . .

RUN mkdir -p /out && chmod 777 /out
# Publish the application to the /out directory
RUN dotnet publish /app/devopsdemodotnetapp.csproj -c Release -o /out

# Use the official .NET Runtime image for running the application
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime

# Set the working directory
WORKDIR /app

# Copy the published output from the build stage
COPY --from=build /out .

# Set the entry point to run the application
ENTRYPOINT ["dotnet", "devopsdemodotnetapp.dll"]
