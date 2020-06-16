
# nginx高可用的探究

## 简介

nginx 可以将请求分配到多个服务器来进行负载均衡, 就算一两台服务器挂了 nginx 也能很快的找到别人来接替, 但是万一nginx挂了呢?  
这时候, 可以准备另一台nginx服务器备用, 一旦主服务器挂了立刻改用备用服务器  
具体检测方法为: 用一个叫 keepalived 的程序, 在 Keepalived 服务正常工作时, 主 Master节点会不断地向备节点发送（多播的方式）心跳消息, 用以告诉备Backup节点自己还活着, 当主 Master节点发生故障时, 就无法发送心跳消息, 备节点也就因此无法继续检测到来自主 Master节点的心跳了, 于是调用自身的接管程序, 接管主Master节点的 IP资源及服务. 而当主 Master节点恢复时, 备Backup节点又会释放主节点故障时自身接管的IP资源及服务, 恢复到原来的备用角色

## 操作

### 在两台(及以上)服务器中配置好nginx

### 下载并配置 keepalived

```yum install keepalived -y```

yum方式安装的会生产配置文件在/etc/keepalived下. ```vim keepalived.conf```, 修改为以下配置:

主机上修改为:

```bash
global_defs {
    # keepalived 自带的邮件提醒需要开启 sendmail 服务.
    # 建议用独立的监控或第三方 SMTP,也可配置邮件发送
    router_id    192.168.0.121      # 即是主机的ip
}
#检测脚本
vrrp_script chk_http_port {
    script "/usr/local/src/check_nginx_pid.sh" #心跳执行的脚本, 检测nginx是否启动
    interval    2                          #（检测脚本执行的间隔, 单位是秒）
    weight     -2                          # 当脚本执行失败时对权值进行的调整
}
#vrrp 实例定义部分
vrrp_instance VI_1 {
    state MASTER            # 指定keepalived的角色, MASTER为主, BACKUP为备
    interface ens33         # 当前进行vrrp通讯的网络接口卡(当前centos的网卡) 用ifconfig查看你具体的网卡
    virtual_router_id 66    # 虚拟路由编号, 主从要一致
    priority 100            # 优先级, 数值越大越高, 主 要大于 从
    advert_int 1            # 检查间隔, 默认为1s(vrrp组播周期秒数), 节点们必须一样
    #授权访问
    authentication {
        auth_type PASS  #设置验证类型和密码, MASTER和BACKUP必须使用相同的密码才能正常通信
        auth_pass 1111
    }
    track_script {
        chk_http_port            #（调用检测脚本）
    }
    virtual_ipaddress {
        192.168.16.130           # 定义虚拟ip(VIP), 可多设, 每行一个, 及对外展示的ip
        www.xiong35.cn
    }
}
```

**备机配置类似, 注意几个区别的地方即可**

检测脚本如下:

```bash
#!/bin/bash
#检测nginx是否启动了
A=`ps -C nginx --no-header |wc -l`        
if [ $A -eq 0 ];then    #如果nginx没有启动就启动nginx                        
      systemctl start nginx                #重启nginx
    if [ `ps -C nginx --no-header |wc -l` -eq 0 ];then    #nginx重启失败, 则停掉keepalived服务, 进行VIP转移
            killall keepalived
    fi
fi
```

脚本授权:```chmod 775 check_nginx_pid.sh```

启动keepalived:```systemctl start keepalived```, 主从都要启动 