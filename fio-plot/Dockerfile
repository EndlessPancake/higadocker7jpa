FROM alpine:latest
RUN apk --no-cache add fio bash python3 python3-pip libpng libpng-dev libjpeg-dev zlib1g-dev
RUN pip3 install --no-cache --upgrade pip setuptools fio-plot 
# ENV DBENCH_MOUNTPOINT="/data" \
#     FIO_SIZE="100M" \
#     FIO_OFFSET_INCREMENT="10M" \
#     FIO_DIRECT="1"
COPY benchmark_and_drow.sh /bin/
CMD ["/bin/benchmark_and_draw.sh"]
