# Use the official .NET SDK image to build the application
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build

# Set the working directory in the container
WORKDIR /app

# Copy the project file and restore dependencies
COPY *.csproj .
RUN dotnet restore

# Copy the rest of the application code
COPY . .

# Publish the application to the /out directory
RUN dotnet publish -c Release -o /out

# Use the official .NET Runtime image for running the application
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime

# Set the working directory
WORKDIR /app

# Copy the published output from the build stage
COPY --from=build /out .

# Set the entry point to run the application
ENTRYPOINT ["dotnet", "devopsdemodotnetapp.dll"]



# FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build

# WORKDIR /app
# COPY . .
# RUN dotnet restore
# RUN dotnet publish -o out

# FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime

# WORKDIR /app
# COPY --from=build /app/out .
# ENV ASPNETCORE_URLS=http://+:5000
# ENTRYPOINT ["dotnet", "devopsdemodotnetapp.dll"]