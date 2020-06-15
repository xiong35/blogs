# 记录一下 nginx 的配置

```nginx
worker_processes  1;

#pid        logs/nginx.pid;

events {
    worker_connections  1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;

    sendfile        on;

    keepalive_timeout  65;

    upstream go {
        server 127.0.0.1:8080; 
    }

    upstream nodenuxt {
        server 127.0.0.1:3007; #nuxt项目 监听端口
        keepalive 64;
    }
    server {
        listen       80;
        server_name  xiong35.cn;

        access_log /var/www/nuxt-blog/log/access_nginx.log;
        error_log /var/www/nuxt-blog/log/error_nginx.log;

        location = / {
            rewrite ^/(.*) http://xiong35.cn/blog2.0/articles permanent; 
        }

        location ^~ /blog2.0/ {
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;  
            proxy_set_header Connection "upgrade";
            proxy_set_header Host $host;
            proxy_set_header X-Nginx-Proxy true;
            proxy_cache_bypass $http_upgrade;

            proxy_pass http://nodenuxt; #反向代理
        }
        
        location ^~ /data/ {
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;  
            proxy_set_header Connection "upgrade";
            proxy_set_header Host $host;
            proxy_set_header X-Nginx-Proxy true;
            proxy_cache_bypass $http_upgrade;

            # rewrite ^/data/(.*)$ /$1 break;
            proxy_pass http://go/; #反向代理
        }

        location ^~ /static/ {
            alias /var/www/static/;
        }
    }
    server {
        listen       80;
        server_name  static.xiong35.cn;

        access_log /var/www/nuxt-blog/log/access_nginx_static.log;
        error_log /var/www/nuxt-blog/log/error_nginx_static.log;

        location = / {
            rewrite ^/(.*) http://xiong35.cn/blog2.0/articles permanent; 
        }
        location ^~ /download/ {
            alias /var/www/static/;
        }
    }
}
```