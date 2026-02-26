# Test locally:
#   docker rm yesno-poller
#   docker build -t yesno-poller .
#   docker run -e MOCK=true --restart on-failure --name yesno-poller yesno-poller
#   docker start -a yesno-poller
#   docker logs yesno-poller -f
#   docker rm yesno-poller

# Build and push to Docker Hub:
#   docker buildx build --platform linux/amd64,linux/arm64 -t kirbownz/yesno-poller:latest --push .

# To run on production:
#   docker run --pull always --restart on-failure --name yesno-poller kirbownz/yesno-poller:latest
#   docker logs yesno-poller -f



# Create image based on the latest Debian image
FROM debian:stable-slim

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . .

# Install git, clone the repository, and make the entrypoint executable
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates git \
	&& git clone https://gitlab.com/kirbo/docker-container-auto-updater-test.git \
	&& chmod +x /app/entrypoint.sh /app/update.sh /app/run.sh \
	&& rm -rf /var/lib/apt/lists/*

# Start the application
ENTRYPOINT [ "/app/entrypoint.sh" ]
