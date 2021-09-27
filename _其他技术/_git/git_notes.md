# Git 操作总结

> 关键词: 其他知识

## 配置环境

    ssh-keygen -t rsa -C "2242787668@qq.com"
    vim ~/.ssh/id_rsa.pub
    # add it to the github

    git config --global user.email "2242787668@qq.com"
    git config --global user.name "xiong35"

## 基本操作

- init：初始化一个仓库
- add：暂存更改
- commit：提交更改
- status：查看工作区状态
- diff：查看更改内容
- log：查看提交记录[--graph --pretty==onrline]
- reset --hard \<id\>
  - HEAD：当前版本
  - HEAD^^：前两个版本
  - 978r4g：某个版本
- reflog：查看历史 commit/pull
- checkout -- \<file\>：让 file 回到最近一次 add/commit 的状态(撤销)
- reset HEAD \<file\>：取消 file 的暂存
- rm：从版本库里删除

## 分支管理

### 基本命令

- switch -c xxx：创建并切换分支（-c：creat）
- branch [-d xxx]：查看分支（-d：del，删除分支）
- merge [-d] xxx：将 xxx 合并到当前分支

### 解决冲突

合并发生冲突时会在文件里添加<<<<, ====, >>>>，将对应行删除，编辑冲突部分，再提交即可合并冲突

### bug 分支

- stash：把当前工作现场储存起来
  - apply stash@{0}：恢复 stash{0}这个储存
  - pop：应用并删除
  - list：查看储存的工作区
- cherry-pick \<commit\>：复制一个 commit 到当前分支

### 远程分支

- checkout -b branch-name origin/branch-name：在本地创建和远程对应的分支
- branch --set-upstream branch-name origin/branch-name：建立本地分支和远程分支的关联
- remote [-v]：查看远程库信息

### rebase

让你的 git log 变成好看的直线

## 标签

- tag xxx \<commit\>：在当前(commit)分支的最新提交上打上 xxx 的标签
- tag -d xxx：删除内容为 xxx 的标签
- push origin \<tag name\>：上传一个标签
- push origin --tags：将所有本地标签上传

## 自定义 git

- config --global color.ui true
- .gitignore：无视对应文件（add 被无视的会弹出提示）
  - add -f：无视 ignore
  - check-ignore -v xxx：检查 xxx 怎么就被 ignore 了
- config --global alias.XX xxxx：用 XX 替换 xxxx（简化命令）
  - co: checkout
  - ci: commit
  - br: branch
  - pl: pull

git 的配置文件在.git/config 里

## 参考资料

[廖雪峰 git 教程](https://www.liaoxuefeng.com/wiki/896043488029600)

[Git Cheat Sheet](https://gitee.com/liaoxuefeng/learn-java/raw/master/teach/git-cheatsheet.pdf)
