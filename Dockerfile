
# Minimal base docker image
FROM python:3.13.0-alpine@sha256:fcbcbbecdeae71d3b77445d9144d1914df55110f825ab62b04a66c7c33c09373 

# Navigate to /app directory
WORKDIR /app

# Copy application dependencies
COPY ./app/requirements.txt /app/requirements.txt

# Install dependencies
RUN pip install --no-cache-dir --upgrade -r /app/requirements.txt 

# Create a new group, user and change permission for /app directory
RUN addgroup -S yarowa-app && \
    adduser -S -G yarowa-app yarowa && \
    chown -R yarowa:yarowa-app /app

# Copy the application code
COPY ./app/ /app/

# Switch to "yarowa" user
USER yarowa

# Define port
EXPOSE 5000

# Run the web application
CMD ["fastapi", "run", "main.py", "--port", "5000"]
