# git配置

## 查看配置

``` shell
# 查看所有git配置
$ git config -l

# 查看系统git配置
$ git config --system --list;

#查看用户git配置
$ git config --global --list;

```



## git相关的配置文件

+ Git\etc\gitconfig                                  -- 系统级  
+ C:\Users\dell(用户名)\ .gitconfig       -- 用户级



## git必要配置

> 配置名称和邮箱

``` shell
$ git config --global user.name "zby"

$ git config --global user.email "zby15035703149@outlook.com"
```



## git创建项目及克隆

``` shell
# 在当前目录新建一个代码库
$ git init    #初始化

#克隆一个gitee/github项目
$ git clone [URL]
```



## git基本命令

```shell
#初始化  创建.git文件
$ git init

#查看文件状态 Untracked 未跟踪，没有进入暂存区 
$ git status 

#添加所有文件到暂存区
$ git add .

#提交暂存区的文件到本地仓库
$ git commit -m "提交信息"
```



## 本机绑定SSH公钥

> 实现免密登录

```shell
# C:\dell\.ssh中的id.rsa.pub文件
$ ssh-keygen -t rsa -C "zby15035703149@outlook.com"

#验证公钥
$ ssh -T git@gitee.com
```



## 关联码云

```shell
$ git init

#本地仓库与gitee仓库关联
$ git remote add origin git@gitee.com:gitee_of_zby/markdown-notes.git

#查看远程库信息:
$ git remote -v 
```



## 流程

```shell
$ git add .
$ git commit -m "提交信息"
$ git remote add origin git@gitee.com:gitee_of_zby/markdown-notes.git
$ git push -u origin master
```





