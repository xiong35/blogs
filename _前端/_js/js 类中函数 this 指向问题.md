# js 类中函数 this 指向问题

> 关键词: JavaScript

```js
class Foo {
  bar() {
    console.log(this);
  }

  baz = () => {
    console.log(this);
  };
}

var foo = new Foo();

foo.bar();
foo.baz();

let foobar = foo.bar;
let foobaz = foo.baz;

foobar();
foobaz();
```

结果为

```js
Foo { baz: [Function: baz] }
Foo { baz: [Function: baz] }
undefined
Foo { baz: [Function: baz] }
```

实际上类里面的普通函数 this 使用的是`隐式绑定`(具体可参考我的[这篇文章](http://www.xiong35.cn/blog2.0/articles/blog/79)), 而使用箭头函数相当于做了这样一件事:

```js
class Foo {
  constructor() {
    this.baz = this.baz.bind(this);
  }

  baz() {
    // 注意这里不是箭头函数
    console.log(this);
  }
}
```

这样才能快乐的使用 this
