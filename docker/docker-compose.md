# 使用docker-compose配置环境

## 目标：
### 一、php部分增加所需扩展，增加php的composer。
### 二、简化安装过程，实现一键化安装。
### 三、具体逻辑参考[github上的项目文件](https://github.com/max-workspace/docker-compose)

***
### 1.创建docker-compose.yml文件
#### 注意此处yml文件类似于python文件使用缩进控制格式。
***
### 2.在docker-composer.yml文件中注册卷服务
#### 此处的卷服务使用官方镜像源创建。
***
### 3.在docker-composer.yml文件中注册php服务
#### 3.1此处如果使用官方的镜像源，会缺少实际所需的php扩展，所以使用dockerfile自定义镜像。（详细代码参考上面给出的github的连接）
#### 3.2引入之前创建的卷容器。
***
### 4.在docker-composer.yml文件中注册nginx服务
#### 4.1使用官方镜像源，但注意所需版本。
#### 4.2连接刚刚创建的php容器。
#### 4.3引入之前创建的卷容器。
***
### 5.执行命令进行安装
***
### 总结：
#### 1.使用dockerfile自定义的php容器安装了实际所需的php扩展（包含php的composer扩展）。
#### 2.创建的卷容器实现了php容器和nginx容器的数据共享。
#### 3.在docker-compose文件配置完毕后，只需要执行命令即可一键话安装。
***
### 待改进：
#### 1.docker中php容器和实体机器中IDE的xdebug联调需要解决。
#### 2.php容器的定时任务（crontab）在容器重启后会被重置，需要解决。
