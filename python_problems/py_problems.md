
# python问题笔记

## 一些普遍使用的操作

### > \_\_init\_\_.py

当import xxx的时候，\_\_init\_\_.py里的命令会被全部执行  
主要作用：

- 将文件夹标记为包
- 一次性导入所需要的包
- import *：需要init里有一个\_\_all\_\_列表指示包里有哪些可以拿出去的

详情点[这里](https://www.cnblogs.com/tp1226/p/8453854.html)

### > \_\_main\_\_.py

首先，\_\_main\_\_这个名字是怎么来的：  
如果import一个程序，它的\_\_name\_\_属性形如keras.models.xxx(在模组中的位置)  
如果直接python一个程序，这个程序的\_\_name\_\_属性就是\_\_main\_\_  
所以程序里的例如```if __name__ == "__main__":```之类的代码的意思是，如果这个程序是主程序(比如测试的时候直接调用)就执行，如果是被引入的(如被import)就不必执行了  

那么\_\_main\_\_.py是干嘛的？  

当你把一个包直接用这种方法执行的时候

    python -m <modual name(there is no '.py')>

调用的就是包里的\_\_main\_\_.py  

-m是干什么的？  
指示系统以模块的方式运行它  

当运行一个普通程序的时候，系统会把**执行的文件所在的目录**放到sys.path属性中  

如果以模块的方式运行，系统会做这么几件事：  

1. 把你**输入命令的目录**（也就是当前工作路径）放到sys.path属性中
2. 自动import这个模块（即调用里面的\_\_init\_\_.py）
3. 执行\_\_main\_\_.py中的命令

**如果去掉那个"-m"**，就只执行上述过程的第三步

详情点[这里](http://blog.konghy.cn/2017/04/24/python-entry-program/)

### > timeit模块

    timeit.timeit(stmt='pass', setup='pass', timer=, number=1000000, globals=None)

参数解释：

- stmt 语句，要执行的表达式，多个语句可以使用
- setup 语句，只在第一次初始化时执行的表达式，在之后会跳过
- timer 计时器，默认是time.perf_counter()
- number 执行次数
- globals 全局变量，需要是个字典

### > arg, \*args, \*\*kwargs

e.g.

    def function(arg,*args,**kwargs):
        print(arg,args,kwargs)

    function(6, 7, 8, 9, a=1, b=2, c=3)

结果：

    6 (7, 8, 9) {'a': 1, 'b': 2, 'c': 3}

### > 命名空间

详情点[这里](http://sebastianraschka.com/Articles/2014_python_scope_and_namespaces.html)

### > \_\_dict\_\_

内置于对象里的参数，记录了对象包含的方法/变量  
常用方法：```\_\_dict\_\_.update(some_dic)```  
效果：将some_dic里的键值对添加（更新）到对象中  

类的\_\_dict\_\_里还会包含方法/魔法方法  
实例里只有变量  

如果字类dict里没找到就会去父类里找

### > \_\_, \_之类的用法

详情点[这里](https://zhuanlan.zhihu.com/p/105783765)

#### \_\_xxx\_\_：魔法方法

如\_\_init\_\_, \_\_del\_\_（构造/析构函数）  
如\_\_ad\_\_, \_\_eq\_\_（重载运算符）

太多了真的写不下。。。

详情点[这里](https://www.cnblogs.com/zhouyixian/p/11129347.html)

#### \_xxx和\_\_xxx

\_xxx 表示xxx是protected方法/变量  
\_\_xxx 表示xxx是private  

并不是规则，只是约定的规定  

#### xxx\_

表示本来xxx和关键词冲突了，但我就是想用他

### > @修饰符

装饰器模式：

    @funA
    def funB():
        pass

等价于```funB = funA(funB)```  

详情点[这里](https://blog.csdn.net/class_brick/article/details/81170697)和[这里](http://c.biancheng.net/view/2270.html)

### > 类方法，类属性

e.g.

    class Foo:
        count = o

        @classmethod
        def count(cls):
            print(cls.count)

        def __init__(self):
            Foo.count += 1

        # ...

### > 静态方法/抽象方法

静态方法：  
不依赖其他任何属性的方法可被封装成静态方法，静态方法不能继承，可看作全局函数，如：

    @staticmethod
    def getHelp(cls):
        print(cls.help)

详情点[这里](https://www.cnblogs.com/ForT/articles/10658593.html)

抽象方法：
子类必须实现的方法

### > argparse包

拆解命令行参数的包  
用于编写命令行直接执行的python程序  

详情点[这里](https://www.jianshu.com/p/fef2d215b91d)

### > curse包

美化终端界面的包  

详情点[这里](https://www.jianshu.com/p/e1bd64c2df4e)

### > 骚操作杂项

    if answer not in 'yY':

    a, b = c, d

    some_list[::-1]

    import numpy
    print(numpy)

    for i in range(10):
        pass
    else:
        print('done')

    os.system('pip3 install keras')

    type(self).__name__ == some_cls.__name__

    # in some_cls
    def __str__(self):
        return 'lol'
    print(this_cls)
    # 'lol'

    try：
        #try block
    except:
        # except situation 1
    except:
        # except situation 2
    else:
        # when the program goes well
    finally:
        # whatever happens, this will execute,
        # if there IS an error,
        # the error will be reported after finally
    
    class Student():
        def __init__(self):
            self._score = None
        @property
        def score(self):
            return self._score
        @score.setter # execute when 'score' is assigned a value
        def score(self, value):
            if value < 0 or value > 100:
                raise ValueError('score must between 0 ~ 100!')
            self._score = value
    # with the above block
    s = Student()
    s.score = 66 # execute @setter
    print(s.score) # execute @property
