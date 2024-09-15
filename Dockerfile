# Use official Node.js image from Docker Hub (use the latest 18.x version)
FROM node:18

# Set the working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package*.json ./
RUN npm install

# Copy the remaining application code
COPY . .

# Build the app for production
RUN npm run build

# Expose the application port
EXPOSE 80

# Start the application
CMD ["npm", "start"]
