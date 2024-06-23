# Use a base image with Flutter pre-installed
FROM cirrusci/flutter:3.22.2

# Set the working directory
WORKDIR /app

# Copy the current directory to the Docker container
COPY . .

# Run flutter pub get to fetch dependencies
RUN flutter pub get

# Build the APK
RUN flutter build apk --release

# Create an output directory
RUN mkdir /output

# Copy the build output to the output directory
RUN cp build/app/outputs/flutter-apk/app-release.apk /output/

# Command to keep the container running (optional, for debugging purposes)
CMD ["tail", "-f", "/dev/null"]
