FROM golang:1.24.2-bookworm AS build

# renovate: datasource=github-releases depName=teslamotors/vehicle-command
ENV APP_VERSION=v0.3.4

WORKDIR /app

RUN git clone --depth 1 --branch $APP_VERSION https://github.com/teslamotors/vehicle-command.git .
RUN go mod download

COPY . .

RUN mkdir build
RUN go build -o ./build ./...

FROM gcr.io/distroless/base-debian12:nonroot AS runtime

COPY --from=build /app/build /usr/local/bin

ENTRYPOINT ["tesla-http-proxy"]
