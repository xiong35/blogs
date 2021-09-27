# ts 高阶指南

> 关键词: TypeScript

## & |

```ts
type A = {
  a: Function;
  c: string;
};
type B = {
  b: Array<any>;
  c: number | string;
};

type AORB = B | A;

var a_or_b: AORB = { a: () => {}, b: [], c: 2 };
// c 为"2"也可, 缺少a,b之一也可, 但 c 不能缺少
// 即 a_or_b 是 A 或 B 之一, 或两者都是

type ANB = B & A;

var a_and_b: ANB = { a: () => {}, b: [], c: "2" };
// c 只能为 "2", a, b, c 缺一不可
// a_and_b 是 AB 的并集
```

## never, unknown, void

- `never`: 参考[尤雨溪的回答](https://www.zhihu.com/question/354601204/answer/888551021), 特点有
  - 在一个函数中调用了返回 `never` 的函数后, 之后的代码都会变成`deadcode`
  - 无法把其他类型赋给 `never`
- `unknown`: 可以替代 any 的功能同时保留静态检查的能力, 静态编译的时候，unknown 不能调用任何方法
- `void`: 表示逻辑上不关注具体的返回值类型

## 类型谓词

为了方便 ts 判断类型, 可让函数的返回值类型不是 `Boolean`, 而是 `obj is TYPE`

```ts
function isFish(pet: Fish | Bird): pet is Fish {
  return (<Fish>pet).swim !== undefined;
}

// 'swim' 和 'fly' 调用都没有问题了

if (isFish(pet)) {
  pet.swim();
} else {
  pet.fly();
}
```

## keyof

返回一个字符串的并集类型, 可用于加强函数的类型功能

```ts
function get<T extends object, K extends keyof T>(o: T, name: K): T[K] {
  return o[name];
}
```

也可用固定语法进行迭代

```ts
type Record<K extends keyof any, T> = {
  [key in K]: T;
};
```

## `T extends U? X: Y`

类似三元运算符, 但是只能在类型中使用, 返回值也是类型

## infer

可进行自动类型推断

```ts
type Parameters<T extends (...args: any) => any> = T extends (
  ...args: infer P
) => any
  ? P
  : never;

type ReturnType<T extends (...args: any) => any> = T extends (
  ...args: any
) => infer R
  ? R
  : any;
```

## typeof

获得**实例**的**类**

## 泛型工具

直接上实现

```ts
/**
 * Make all properties in T optional
 */
type Partial<T> = {
  [P in keyof T]?: T[P];
};

/**
 * Make all properties in T required
 */
type Required<T> = {
  [P in keyof T]-?: T[P];
};

/**
 * Make all properties in T readonly
 */
type Readonly<T> = {
  readonly [P in keyof T]: T[P];
};

/**
 * From T, pick a set of properties whose keys are in the union K
 */
type Pick<T, K extends keyof T> = {
  [P in K]: T[P];
};

/**
 * Construct a type with a set of properties K of type T
 */
type Record<K extends keyof any, T> = {
  [P in K]: T;
};

/**
 * Exclude from T those types that are assignable to U
 */
type Exclude<T, U> = T extends U ? never : T;

/**
 * Extract from T those types that are assignable to U
 */
type Extract<T, U> = T extends U ? T : never;

/**
 * Construct a type with the properties of T except for those in type K.
 */
type Omit<T, K extends keyof any> = Pick<T, Exclude<keyof T, K>>;

/**
 * Exclude null and undefined from T
 */
type NonNullable<T> = T extends null | undefined ? never : T;

/**
 * Obtain the parameters of a function type in a tuple
 */
type Parameters<T extends (...args: any) => any> = T extends (
  ...args: infer P
) => any
  ? P
  : never;

/**
 * Obtain the parameters of a constructor function type in a tuple
 */
type ConstructorParameters<
  T extends new (...args: any) => any
> = T extends new (...args: infer P) => any ? P : never;

/**
 * Obtain the return type of a function type
 */
type ReturnType<T extends (...args: any) => any> = T extends (
  ...args: any
) => infer R
  ? R
  : any;

/**
 * Obtain the return type of a constructor function type
 */
type InstanceType<T extends new (...args: any) => any> = T extends new (
  ...args: any
) => infer R
  ? R
  : any;
```

## 查找类型

```ts
// old way
interface Address {
  city: string;
  street: string;
  num: number;
}

interface Person {
  addr: Address;
}

// new way
interface Person {
  addr: {
    city: string;
    street: string;
    num: number;
  };
}

Person["addr"]; // -> Address.
```

## 显式泛型

返回值的类型是运行时才能确定的，除了返回 any ，还可以返回传入的类型

## Deep

```ts
type DeepReadonly<T> = {
  readonly [P in keyof T]: DeepReadonly<T[P]>;
};

type DeepPartial<T> = {
  [P in keyof T]?: DeepPartial<T[P]>;
};

/* and so on */
```

## 参考

- [TypeScript 中提升幸福感的 10 个高级技巧](https://juejin.cn/post/6919478002925453320)
- [TypeScript 高级用法](https://juejin.cn/post/6926794697553739784)
