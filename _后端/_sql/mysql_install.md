
# Windows10上的MySQL-8安装笔记

## 下载zip文件

[下载链接](https://dev.mysql.com/downloads/mysql/)

将文件解压到安装目录下, 我的目录是C:\MyDownloads\mysql\mysql-8.0.19-winx64

## 配置init

在上述目录下创建 my.ini 配置文件，编辑 my.ini 配置以下基本信息:

    [client]
    # 设置mysql客户端默认字符集
    default-character-set=utf8
    [mysql]
    default-character-set=utf8
    [mysqld]
    # 设置3306端口
    port = 3306
    # 设置mysql的安装目录
    basedir=C:\\MyDownloads\\mysql\\mysql-8.0.19-winx64
    # 允许最大连接数
    max_connections=20
    # 服务端使用的字符集默认为8比特编码的latin1字符集
    character-set-server=utf8
    # 创建新表时将使用的默认存储引擎
    default-storage-engine=INNODB

## 启动 MySQL 数据库

打开`C:\Windows\System32`文件夹(64位32位电脑一般都是这个文件夹), 找到cmd.exe, 右键, 选择"以管理员身份运行"(一定要以管理员身份进!)

切换目录:

    cd C:\MyDownloads\mysql\mysql-8.0.19-winx64\bin

初始化数据库

    mysqld --initialize --console

此时可能会报错:[找不到vcruntime140_1.dll]  
解决方案:参考[这篇文章](https://blog.csdn.net/qq_42365534/article/details/102847013)

输出应该如:

    ...
    2018-04-20T02:35:05.464644Z 5 [Note] [MY-010454] [Server] A temporary password is generated for root@localhost: <PWCY5ws&hjQ
    ...

其中```<PWCY5ws&hjQ```就是初始密码, 拿小本本记下来  
一共12位, 可能出现'<'啊, '&'啊之类的奇怪字符  
下一章讲述如何修改  

安装

    mysqld install

全局化路径

    mysqld --initialize-insecure

启动

    net start mysql

*关闭

    net stop mysql

## 登录

    mysql -u root -p
    // 响应如下, 输入初始密码, 按回车
    Enter password:************

结果如下:

    C:\MyDownloads\mysql\mysql-8.0.19-winx64\bin\>mysql -u root -p
    Enter password: ************
    Welcome to the MySQL monitor.  Commands end with ; or \g.
    Your MySQL connection id is 17
    Server version: 8.0.19 MySQL Community Server - GPL

    Copyright (c) 2000, 2020, Oracle and/or its affiliates. All rights reserved.

    Oracle is a registered trademark of Oracle Corporation and/or its
    affiliates. Other names may be trademarks of their respective
    owners.

    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

    mysql>

修改密码

    mysql>ALTER USER 'root'@'localhost' IDENTIFIED WITH MYSQL_NATIVE_PASSWORD BY '新密码';

其中的单引号都是必须的, 只用自己的密码替换[新密码]几个字就行了  
