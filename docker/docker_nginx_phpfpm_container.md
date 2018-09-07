# docker 安装配置nginx和php容器

***

## 1.安装docker

## 2.通过docker search命令或者在docker hub网站上查询镜像的名称

## 3.通过docker pull 拉取镜像名称

* 这里要拉取nginx:1.10.2、php:7.1.21-fpm以及alpine:latest。

## 4.制作存储实际代码的卷容器(使用时注意折行符号)

* 这里的作用是创建一个容器，容器中的目录（/etc/nginx/conf.d、/data、/usr/share/nginx/html）是卷的挂载点。有点类似与本地机器和虚拟机之间的共享目录，里面存放实际的项目文件，供机器运行时使用。

`sudo docker run -v /etc/nginx/conf.d -v /data -v /usr/share/nginx/html --name vc_dockerData alpine:latest`

## 5.制作包含卷容器的php容器
* 需要注意的两点，一个是端口指定，一个是挂载卷容器。挂载卷容器的作用是phpfpm解析php文件时要从卷容器中获取对应的php文件。

`sudo docker run -d -p 9000 --volumes-from vc_dockerData --name phpfpm php:7.1.21-fpm`

## 6.制作包含卷容器并连接php容器的nginx容器
* 注意此处容器会创建成功但无法运行，原因是引入的卷文件覆盖了之前的/etc/nginx/conf.d、/usr/share/nginx/html目录，现在这两个文件的内容均为空而引起的，并非容器的问题。

`sudo docker run -d -p 80 --volumes-from vc_dockerData --link phpfpm:php --name myNginx nginx:1.10.2`

## 7.导入缺少的配置和项目文件
* 先查看卷容器在本机上实际存储的位置。
* 执行sudo docker inspect vc_dockerData，查看mount标签的相关内容。
* Destination对应卷容器要挂载的位置，Source对应在本机上实际的存储位置。
* 一般来说存储的路径格式为：/var/lib/docker/volumes/****
***
* 将/etc/nginx/conf.d/目录缺少的default.conf文件放入本机的实际位置。
* 将/usr/share/nginx/html/目录缺少的index.html、50x.html放入本机的实际位置。

## 8.重启nginx容器、检测nginx服务是否正常
* sudo docker restart myNginx	// 重启容器
* sudo docker container ls -a	// 查看myNginx的端口设置
* curl http://localhost:实际的端口值/	// 测试nginx服务是否可用

## 9.调整nginx配置，使nginx能够解释php脚本
* 在实体机存储/etc/nginx/conf.d/的目录内修改default.conf，将php脚本解析部分的127.0.0.1:9000修改为php:9000。（php为连接phpfpm容器时设置的别名）
* 重启nginx容器：sudo docker restart myNginx，在实体机存储/usr/share/nginx/html/内容的目录创建phpinfo.php文件。
* 查询nginx重启后开放的端口，因为之前设置的端口是动态映射所以不固定。
* 查看是否可以解析curl http://localhost:实际的端口/phpinfo.php。

## 缺点
* docker对window支持不太好尤其是win10家庭版，更适合linux发行版和mac。
* 本次使用分步安装比较繁琐，后续使用dockerfile可以简化安装过程。

## 优点
* 容器的建立不依赖于开发者电脑的操作系统、虚拟机版本，能够最大程度保证环境的一致性。
* 基于镜像创建的容器创建、运行、销毁比较独立，可以任意组合php版本和nginx版本来搭建系统。
* 后续如果实现dockerfile安装，能够简化开发环境的过程。

## 待改进
* 在第二版使用dockerfile构建，实现傻瓜式安装。
* 容器环境下的定时任务的设置与触发没有尝试，第二版将实现此功能。
* 此次构建的容器未包含php指定的扩展，第二版将实现此功能。
