# FROM openresty/openresty:1.15.8.1-1-alpine
FROM openresty/openresty:1.13.6.2-0-centos
ADD conf.d/app.conf /etc/nginx/conf.d/app.conf
ADD conf.d/forward.conf /etc/nginx/conf.d/forward.conf
CMD ["/usr/bin/openresty", "-g", "daemon off;"]
