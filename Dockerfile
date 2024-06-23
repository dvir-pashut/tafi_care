FROM mobiledevops/flutter-sdk-image

# Set the working directory inside the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . .
 
RUN flutter pub get 

# Run flutter build apk --release
RUN flutter build apk --release

# Specify the output directory
VOLUME ["/output"]