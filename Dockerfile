FROM golang:1.19.3 as builder

ARG PACKAGE=eventindexer

RUN apt install git curl

RUN mkdir /taiko-mono

WORKDIR /taiko-mono

COPY . .

RUN go mod download

WORKDIR /taiko-mono/packages/$PACKAGE

RUN CGO_ENABLED=0 GOOS=linux go build -o /taiko-mono/packages/$PACKAGE/bin/${PACKAGE} /taiko-mono/packages/$PACKAGE/cmd/main.go

FROM alpine:latest

ARG PACKAGE

RUN apk add --no-cache ca-certificates

COPY --from=builder /taiko-mono/packages/$PACKAGE/bin/$PACKAGE /usr/local/bin/

ENTRYPOINT ["$PACKAGE"]