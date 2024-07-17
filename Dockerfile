#FROM golang:latest
# Use a specific Go version instead of latest for consistency and caching
FROM golang:1.22 as builder

RUN mkdir /app

WORKDIR /app

# Cache dependencies - this will only rerun if go.mod or go.sum changes
COPY go.mod ./
RUN go mod download

# Copy the source code into the container
COPY . .

# Build the Go app
RUN go build -o main .

# Use a smaller base image for the final output
FROM alpine:latest  
RUN apk --no-cache add ca-certificates

WORKDIR /root/

# Copy the pre-built binary file from the previous stage
COPY --from=builder /app/main .

EXPOSE 8080

CMD [ "./main" ]
