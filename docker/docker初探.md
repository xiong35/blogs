
# docker初探

## 下载

centos一键安装: ```curl -sSL https://get.daocloud.io/docker | sh```

如果有报错, 挨个解决就是了

运行```sudo docker run hello-world```来检验是否安装成功

## 基本命令

- ```docker search xxx```: 查找公开仓库
- ```docker pull xxx```: 下载到本地
- ```docker run xxx```: 优先在本地找, 有就直接运行, 没有就下载再运行, 
  - -it(直接拉起新的bash) 或 -d(后台静默运行)
  - -v /\<本机dir\>:/\<docker dir\>[:ro], 来指定关联文件夹, :ro==read only
  - --name="xxx"
- ```docker ps```: 查看所有docker进程
  - -a 显示历史
  - -q 只显示id
- ```docker rm / docker rmi[-f]```: 删除容器 / 镜像
- ```docker exec <id> <cmd>```: 直接在容器里运行命令
- ```docker attach <id> / ctrl+p+q```: 链接 / 暂时退出容器

## 数据卷

在运行docker容器时可以指定绑定目录, 且多次绑定不会覆盖(即支持多个docker绑定同一个主机目录)

e.g.: ```docker run -it -v /root/test:/volume centos```, 运行名为centos的容器, 并将主机的/root/test目录与docker的/volume目录绑定(共享数据)

## dockerfile

e.g.

```
FROM centos     # 继承自哪个镜像文件
MAINTAINER xiong35<xiong35@qq.com>  # 作者信息
COPY test.txt /root     # 将主机上的文件复制到docker
ADD foo.zip /usr/local  # 复制并解压缩
RUN yum install vim     # 执行某些命令
ENV FOO_HOME /usr/foo   # 设置环境变量
ENV PATH $PATH:$FOO_HOME/bin
WORKDIR $FOO_HOME       # 设置进入容器的初始路径
EXPOSE 8080             # 容器打开的端口
CMD foo -a && run foo   # 进入容器时默认执行的命令
```

主机上运行```docker build -f dockerfile -t some_name:some_tag .```<-注意这里有一个点, 代表当前文件夹, 即可创建镜像

## 推送到云端

登录阿里云托管的[镜像服务管理界面](https://cr.console.aliyun.com/cn-hangzhou/instances/repositories), 创建自己的命名空间和仓库, 创建好后点击详情既可看到阿里云的官方教程