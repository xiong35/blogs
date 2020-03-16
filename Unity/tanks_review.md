
# Unity制作坦克大战

所有代码都在[这里](https://github.com/xiong35/UnityWork)  

## 1 下载素材

下载[坦克大战素材](http://www.sikiedu.com/course/90/material/2429/download)  

## 2 处理组件

### 2.1 剪切图片

在Inspector里将一整张几个帧合成的图片裁剪成单张:

- 调整Texture Type为Sprite(2D & UI)
- Sprite Mode为Multiple
- 点开Sprite Editor, 用Slice裁剪图片

### 2.2 创建组件

#### 2.2.1 导入图片

直接把图片拖到Hierarchy里

#### 2.2.2 创建预制件

在Hierarchy里调整好大小, 把他们拖到Project里(创建一个Prefabs目录专门存放), 也可以直接CTRL+d复制调好了的, 把对应图片拖到Inspector的Sprite Renderer里

#### 2.2.3 导入动画

**全部**选中将裁剪好的图片, 一起拖到Hierarchy栏, 就可以创建动画

#### 2.2.4 整理动画和控制器

将Project里生成的动画和对应控制器放到新建的Animation和AnimationController文件夹里

### 2.3 设置组件

#### 2.3.1 设置环境

在Inspector里为墙, 障碍等设置碰撞:  
在底部Add Component里添加Box Collider 2D  
给老家添加一个脚本, 让他被击中时变换形态, 结束游戏  

#### 2.3.2 设置角色/同时设置敌人

添加Box Collider 2D, Rigidbody 2D, Player(script)  
在Rigidbody里设置Freeze z轴, Gravity Scale = 0  
编辑脚本  

编译后脚本那一栏会有几个新的对象, 将子弹的预制体, 上下左右的贴图分别添加到对象中

#### 2.3.3 设置图层

在Inspection里的Sprite Renderer的Additional Settings里有两个图层选项:

- Sorting Layer: 大图层
- Order In Layer: 大图层下的小图层, 数字越大越后渲染, 越在上层

#### 2.3.4 设置子弹

将发射子弹在Tank里写成Attack方法, 注意调整子弹的角度, 注意设置cd(计时器)  

给子弹Add Component => Box Collider 2D => 设置Is Trigger True  
设置子弹为刚体(因为碰撞触发检测必须双方都有碰撞检测器, 且有一方是刚体)  

在Inspection里给环境添加标签, 来让子弹区分谁是谁  
复制Barrier, 删掉渲染, 让他变成空气墙, 来销毁出界的子弹  
给子弹加一个布尔值来防止友伤  

给子弹类添加一个脚本, 内容如下  

在Tank代码里添加ExplorationPrefab, 添加预制体到Unity里的tank里  
给Exploration设一个定时结束的脚本  

#### 2.3.5 设置进场无敌

添加isImmune状态和immuneTime, 在Hit方法里添加判断, 如果isImmune就return  
添加GameObject, 在Unity里把Shield设为Player的成员, 在Transform栏reset位置, 调整图层在玩家下方, 将预制体赋给代码里新建的对象  

#### 2.3.6 设置出生特效

定义在出生特效里创建角色, 并在一段时间后关闭出生特效

#### 2.3.7 设置敌人的方法

简单修改player方法即可

- 护盾
- 攻击
- 移动

## 3 实例化地图

### 3.1 玄学计算地图大小

通过拖动组件看他的位置信息来计算

### 3.2 设置地图

在Hierarchy里新建一个GameObject, 给他一个CreateMap的脚本  
在脚本里创一个数组存放所有实例化的物体  
在unity里把对应项拖进去  

## 4 写游戏控制器

计算生命, 胜负, 得分  
若失败则让玩家不能动  

## 5 UI

### 5.1 计分板

调大屏幕比例  
设置相机的背景颜色为灰色  
在Hierarchy里添加UI图片和UI数字  
在Manager里添加命名空间获得UI的引用来修改UI  

### 5.2 开始界面

加载另一个场景  
设置背景图  
设置两个GameObject指定指针位置  
在指针上编辑一个脚本, using UnityEngine.SceneManagement  

### 5.3 结束后返回主界面

在PlayerManagement里using UnityEngine.SceneManagement, 设置回去的操作

## 6 整合

### 6.1 加载场景

在File->Build Settings里拖入两个场景  

### 6.2 添加音效

gg时播放die  
给爆炸组件添加Audio Source, 把爆炸音效挂在上面  
给障碍预制体添加脚本, 播放音效  
在背景板上添加Audio Source, 把主界面音效挂在上面  
给玩家子弹添加Audio Source, 把开火音效挂在上面  
编辑脚本设置移动/静止音效  

注意! 在bullet脚本里, 只有玩家子弹会触发Barrier的音效, 修改, 否则会报错  
