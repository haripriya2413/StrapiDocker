# Use an official Node.js runtime as a parent image
FROM node:14-alpine

# Set the working directory in the container
WORKDIR /usr/src/app

# Install Strapi CLI globally
RUN npm install -g strapi@latest

# Create a new Strapi project
RUN strapi new my-strapi-app --quickstart --no-run

# Set the working directory to the Strapi project
WORKDIR /usr/src/app/my-strapi-app

# Expose the Strapi default port
EXPOSE 1337

# Start Strapi
CMD ["npm", "start"]
