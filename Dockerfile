FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /source

RUN git clone https://github.com/Splamy/TS3AudioBot.git .

RUN dotnet publish TS3AudioBot -c Release -o /app/out

FROM mcr.microsoft.com/dotnet/runtime:8.0
WORKDIR /app

COPY --from=build /app/out ./

COPY --from=build /source/WebInterface ./WebInterface

RUN apt-get update && apt-get install -y \
    ffmpeg \
    python3 \
    curl \
    libopus-dev \
    && rm -rf /var/lib/apt/lists/*

RUN curl -L -o youtube-dl https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_linux && \
    chmod +x youtube-dl

VOLUME /app/data

WORKDIR /app/data

ENTRYPOINT ["dotnet", "/app/TS3AudioBot.dll", "--non-interactive"]
