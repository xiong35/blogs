
# nginx 初探

## 基本命令

- ```nginx -t -c <file dir>```: 测试配置是否ok
- ```nginx -c <file dir>```: 根据配置文件启动nginx
- ```nginx -s stop / quit```: 快速的 / 优雅的停止服务
- ```nginx -s reload```: 重载服务(根据上一次的配置文件)

## 常用配置

```bash
user  www www;
worker_processes  2;        # worker进程数
error_log  logs/error.log;  # 默认的记录错误信息的log文件地址
pid        logs/nginx.pid;  # 设置保存master进程id的文件
events {
    # use epoll;            # 默认用epoll事件模型, 
    worker_connections  2048;   # 每一个worker进程能并发处理（发起）的最大连接数
}
http {
    include       mime.types;   # 必须包含的一个文件
    default_type  application/octet-stream;     #默认设置的请求类型
    sendfile        on;         # 是否开启高效文件传输模式
    keepalive_timeout  65;  #  长连接超时时间，单位是秒
                            # 长连接请求大量小文件的时候，可以减少重建连接的开销
                            # 假如有大文件上传，65s内没上传完成会导致失败
                            # 如果设置时间过长，用户又多，长时间保持连接会占用大量资源。

    #access_log  logs/access.log  main;     # 正确的请求的日志路径

    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';    # 日志格式
    # tcp_nopush     on;        # ??

    # gzip压缩功能设置
    gzip on;                # 开启gzip压缩输出，减少网络传输
    gzip_min_length 1k;     # 允许压缩的页面最小字节数(再小就不要压缩了,意义不大)
    gzip_buffers    4 16k;  # #缓冲(压缩在内存中缓冲几块? 每块多大?)
    gzip_http_version 1.0;  # 开始压缩的http协议版本
    gzip_comp_level 6;      # 级别越高,压的越小,越浪费CPU计算资源
                            # [1-9], 超过6级压缩率增的少, 而内存占用很大
    # 对哪些类型的文件用压缩, 音视频就别压缩了, 压不了多少
    gzip_types text/html text/plain text/css text/javascript application/json application/javascript application/x-javascript application/xml; 
    gzip_vary on;   # 在响应头加个 Vary: Accept-Encoding
                    # 可以让前端的缓存服务器缓存经过gzip压缩的页面

    # http_proxy 设置
    client_max_body_size   10m;     # 允许客户端请求的最大单文件字节数
    client_body_buffer_size   128k; # 缓冲区代理缓冲用户端请求的最大字节数
    proxy_connect_timeout   75;     # nginx跟后端服务器连接超时时间
    proxy_send_timeout   75;        # ??
    proxy_read_timeout   75;        # 连接成功后，与后端服务器两个成功的响应操作之间超时时间
    proxy_buffer_size   4k;         # 设置代理服务器（nginx）从后端realserver读取并保存用户头信息的缓冲区大小
    proxy_buffers   4 32k;          # nginx针对单个连接缓存来自后端realserver的响应，网页平均在32k以下的话，这样设置
    proxy_busy_buffers_size   64k;  # 高负荷下缓冲大小（proxy_buffers*2）
    proxy_max_temp_file_size  1024M # 当 proxy_buffers 放不下后端服务器的响应内容时，
                                    # 会将一部分保存到硬盘的临时文件中，
                                    # 这个值用来设置最大临时文件大小，默认1024M，
                                    # 它与 proxy_cache 没有关系。
                                    # 大于这个值，将从upstream服务器传回。设置为0禁用
    proxy_temp_file_write_size  64k;# 每次写临时文件的大小
    proxy_temp_path   /usr/local/nginx/proxy_temp 1 2;  # 临时文件保存目录

    # 设定负载均衡后台服务器列表 
    upstream  backend  { 
              ip_hash;      # 利用ip进行哈希运算, 保证同一个ip被分到同一个分服务器
              # least_time  # 根据响应速度分配任务 
              # max_fails: 失败多少次 认为主机已挂掉则，踢出
              # fail_timeout: 踢出后重新探测时间
              # weight: 分配任务的权重
              # max_conns: 设置最大连接数，防止挂掉
              server   192.168.10.100:8080 max_fails=2 fail_timeout=30s weight=10 max_conns=800;  
              server   192.168.10.101:8080 max_fails=2 fail_timeout=30s weight=5; 
              backup   192.168.10.102:8080      # 备用服务
    }
    # 很重要的虚拟主机配置
    server {
        listen       80;    # 小于1024的要以root启动。可以为listen *:80、listen 127.0.0.1:80等形式
        server_name  itoatest.example.com;  # 可以通过正则匹配
        root   /apps/oaapp;
        charset utf-8;
        access_log  logs/host.access.log  main;
        #对 / 所有做负载均衡+反向代理

        # # location 匹配:
        # 语法规则： location [=|~|~*|^~] /uri/ { … }
        # = 开头表示精确匹配
        # ^~ 开头表示uri以某个常规字符串开头，理解为匹配 url路径即可。nginx不对url做编码，因此请求为/static/20%/aa，可以被规则^~ /static/ /aa匹配到（注意是空格）。
        # ~ 开头表示区分大小写的正则匹配
        # ~*  开头表示不区分大小写的正则匹配
        # !~和!~*分别为区分大小写不匹配及不区分大小写不匹配 的正则
        # / 通用匹配，任何请求都会匹配到。
        # 多个location配置的情况下匹配顺序为：
        # 首先匹配 =，其次匹配^~, 其次是按文件中顺序的正则匹配，最后是交给 / 通用匹配。

        location /static/ {
            root   /apps/oaapp/;    # 定义服务器的默认网站根目录位置
                                    # root路径 拼接 location路径
                                    # 末尾斜杠可有可无
                                    # 如果locationURL匹配的是子目录或文件，root没什么作用
                                    # 一般放在server指令里面或/下
            # alias  /apps/oaapp/static/;   # 使用alias路径 替换 location路径, 末尾必须有斜杠
            index  index.html index.htm;    # 定义路径下默认访问的文件名，一般跟着root放
            proxy_pass    http://backend;   # 反向代理的路径名称
                                            # 如果是http://backend(没有最后的斜杠)
                                            # location匹配到的那个路径也会被传过去
                                            # 如果是http://backend/(有最后的斜杠)
                                            # location匹配的路径会被吃掉
            # 以下几行一般不动, 就这么配
            proxy_redirect off;
            # 后端的Web服务器可以通过X-Forwarded-For获取用户真实IP
            proxy_set_header  Host  $host;
            proxy_set_header  X-Real-IP  $remote_addr;  
            proxy_set_header  X-Forwarded-For  $proxy_add_x_forwarded_for;
        }
        # 静态文件，nginx自己处理，不去backend请求tomcat之类的
        location  ~* /download/ {  
            root /apps/oa/fs;  

        }
        location ~ .*/.(gif|jpg|jpeg|bmp|png|ico|txt|js|css)$   
        {   
            root /apps/oaapp;
            expires      7d;        # 设置静态资源的缓存时间 
        }
           location /nginx_status {
            stub_status on;
            access_log off;
            allow 192.168.10.0/24;
            deny all;
        }
        # 控制访问权限
        location /nginx-status {
            stub_status on;
            access_log off;
            # 以下两行可用htpasswd创建登录认证
            #  auth_basic   "NginxStatus";
            #  auth_basic_user_file   /usr/local/nginx-1.6/htpasswd;
            allow 192.168.10.100;
            allow 172.29.73.0/24;
            deny all;
        }
        location /images {
            root   /var/www/nginx-default/images;
            autoindex on;       # 再访问的网页上显示整个目录
            autoindex_exact_size off;   # 默认为on，显示出文件的确切大小，单位是bytes。
                                        # 改为off后，显示出文件的大概大小，单位是kB或者MB或者GB
            autoindex_localtime on;     # 默认为off，显示的文件时间为GMT时间。
                                        # 改为on后，显示的文件时间为文件的服务器时间
        }
        #error_page  404              /404.html;
        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
    }
  ## 其它虚拟主机，server 指令开始
}
```