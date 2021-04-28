
# Git操作总结

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
- reflog：查看历史commit/pull
- checkout -- \<file\>：让file回到最近一次add/commit的状态(撤销)
- reset HEAD \<file\>：取消file的暂存
- rm：从版本库里删除

## 分支管理

### 基本命令

- switch -c xxx：创建并切换分支（-c：creat）
- branch [-d xxx]：查看分支（-d：del，删除分支）
- merge [-d] xxx：将xxx合并到当前分支

### 解决冲突

合并发生冲突时会在文件里添加<<<<, ====, >>>>，将对应行删除，编辑冲突部分，再提交即可合并冲突

### bug分支

- stash：把当前工作现场储存起来
  - apply stash@{0}：恢复stash{0}这个储存
  - pop：应用并删除
  - list：查看储存的工作区
- cherry-pick \<commit\>：复制一个commit到当前分支

### 远程分支

- checkout -b branch-name origin/branch-name：在本地创建和远程对应的分支
- branch --set-upstream branch-name origin/branch-name：建立本地分支和远程分支的关联
- remote [-v]：查看远程库信息

### rebase

让你的git log变成好看的直线

## 标签

- tag xxx \<commit\>：在当前(commit)分支的最新提交上打上xxx的标签
- tag -d xxx：删除内容为xxx的标签
- push origin \<tag name\>：上传一个标签
- push origin --tags：将所有本地标签上传

## 自定义git

- config --global color.ui true
- .gitignore：无视对应文件（add被无视的会弹出提示）
  - add -f：无视ignore
  - check-ignore -v xxx：检查xxx怎么就被ignore了
- config --global alias.XX xxxx：用XX替换xxxx（简化命令）
  - co: checkout
  - ci: commit
  - br: branch
  - pl: pull

git的配置文件在.git/config里

## 参考资料

[廖雪峰git教程](https://www.liaoxuefeng.com/wiki/896043488029600)  

[Git Cheat Sheet](https://gitee.com/liaoxuefeng/learn-java/raw/master/teach/git-cheatsheet.pdf)
