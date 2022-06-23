# FROM gcr.io/distroless/static
FROM alpine:latest
RUN apk --no-cache add fio
ENV DBENCH_MOUNTPOINT="/data" \
    FIO_SIZE="100M" \
    FIO_OFFSET_INCREMENT="10M" \
    FIO_DIRECT="1"
COPY benchmark.sh /bin/
CMD ["/bin/benchmark.sh"]
