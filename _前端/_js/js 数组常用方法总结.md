# js 数组常用方法总结

> 关键词: JavaScript

```ts
interface Array<T> {
  length: number;

  toString(): string;

  toLocaleString(): string; // 分别调用子元素的`toLocaleString`方法

  pop(): T | undefined; // 修改原数组

  push(...items: T[]): number; // 修改原数组

  concat(...items: ConcatArray<T>[]): T[]; // 不改变原数组
  concat(...items: (T | ConcatArray<T>)[]): T[];
  /* 
    [1, 2, 3].concat([4, [5]], 6, [7]) => [1, 2, 3, 4, [5], 6, 7]
     */

  join(separator?: string): string; // seperator 默认为 ","

  reverse(): T[]; // 修改原数组, 并返回其引用

  shift(): T | undefined; // 删除第 0 个元素并返回他

  slice(start?: number, end?: number): T[]; // start end 都支持负值

  sort(compareFn?: (a: T, b: T) => number): this; // 修改原数组并返回引用
  // a negative value if first argument is less than second argument
  // zero if they're equal and a positive value otherwise

  splice(start: number, deleteCount?: number): T[]; // 修改原数组
  splice(start: number, deleteCount: number, ...items: T[]): T[];

  unshift(...items: T[]): number; // 返回新的长度

  indexOf(searchElement: T, fromIndex?: number): number;

  lastIndexOf(searchElement: T, fromIndex?: number): number; // 同上, 返回最后出现的元素下标

  every<S extends T>(
    predicate: (value: T, index: number, array: T[]) => value is S,
    thisArg?: any
  ): this is S[]; // 返回 falsy 值结束
  every(
    predicate: (value: T, index: number, array: T[]) => unknown,
    thisArg?: any
  ): boolean;

  some(
    predicate: (value: T, index: number, array: T[]) => unknown,
    thisArg?: any
  ): boolean; // 返回 truthy 结束

  forEach(
    callbackfn: (value: T, index: number, array: T[]) => void,
    thisArg?: any
  ): void;

  map<U>(
    callbackfn: (value: T, index: number, array: T[]) => U,
    thisArg?: any
  ): U[];

  filter<S extends T>(
    predicate: (value: T, index: number, array: T[]) => value is S,
    thisArg?: any
  ): S[]; // predict return true 则留下
  filter(
    predicate: (value: T, index: number, array: T[]) => unknown,
    thisArg?: any
  ): T[];

  reduce(
    callbackfn: (
      previousValue: T,
      currentValue: T,
      currentIndex: number,
      array: T[]
    ) => T
  ): T;
  reduce(
    callbackfn: (
      previousValue: T,
      currentValue: T,
      currentIndex: number,
      array: T[]
    ) => T,
    initialValue: T
  ): T;
  reduce<U>(
    callbackfn: (
      previousValue: U,
      currentValue: T,
      currentIndex: number,
      array: T[]
    ) => U,
    initialValue: U
  ): U;

  reduceRight(
    callbackfn: (
      previousValue: T,
      currentValue: T,
      currentIndex: number,
      array: T[]
    ) => T
  ): T;
  reduceRight(
    callbackfn: (
      previousValue: T,
      currentValue: T,
      currentIndex: number,
      array: T[]
    ) => T,
    initialValue: T
  ): T;
  reduceRight<U>(
    callbackfn: (
      previousValue: U,
      currentValue: T,
      currentIndex: number,
      array: T[]
    ) => U,
    initialValue: U
  ): U;

  [n: number]: T;
}
```
