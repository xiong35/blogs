
# js ...args探究

```js

let fn1 = (args1, ...args2) => {
    console.log(args1);
    console.log(args2);
}

// error, Rest parameter must be last formal parameter
let fn2 = (...args1, ...args2) => {/* ... */}   


fn1(1, 2, 3)
// 1
// [2, 3]

fn1(1)
// 1
// []

fn1()
// undefined
// []
```
