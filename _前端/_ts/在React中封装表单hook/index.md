# 在 React 中封装类型友好的表单 hook

作为前端开发者, 我们经常会遇到填写表单的需求. 很多情况下表单还需要进行输入检验, 可以有默认值等.

![一份表单](http://blog.xiong35.cn/a-form.png)

散落在各处的这种表单的逻辑是相似的, 我们在**重复进行工作**, 这不利于项目的维护.

接下来我们将在 React 中封装一个`useForm`来统一处理这些逻辑, 我将使用 TS 来获得可靠的类型检查

## 需求整理

相似的逻辑:

- 获得表单本身
- 根据一定逻辑获得表单的校验结果
- 设置表单的某些字段

不同之处:

- 表单有哪些字段
- 默认值, 校验逻辑等

那么我们需要传入的参数就是这些不同之处, 要封装的地方就是相同之处!

## 具体实现

### 类型定义

我们先定义一下表单需要被配置的内容的类型

```ts
type ConfigOpts = {
  /** (可选的)字段的默认值 */
  default?: string;
  /**
   * 对字段的检验函数
   * @param value 此字段现在的值
   * @returns 若检验成功则返回 undefined, 否则返回对应的提示信息
   */
  validator: (value: string) => string | undefined;
};
```

### 函数骨架

定义函数的大体样子:

```ts
/**
 * 和表单操作相关的 hook, 接受的配置为一个对象, 各个属性名为表单中希望出现的属性名, 值为配置参数
 */
function useForm<T extends { [name: string]: ConfigOpts }>(config: T) {
  /* do something */

  return { form, setForm, formIsValidate, setFormValidate };
}

/* e.g. */
const { form, setForm, formIsValidate, setFormValidate } = useForm({
  name: {
    default: "foo",
    validator: (s) => (s.length > 12 ? undefined : "用户名长度需在 0~12 之间"),
  },
  password: {
    validator: (s) =>
      /^.{6,20}$/.test(s) ? undefined : "密码长度需在 6~20 之间",
  },
});
```

### 实现函数

详见注释

```ts
function useForm<T extends { [name: string]: ConfigOpts }>(config: T) {
  // 返回的 表单的类型
  type Form = { [K in keyof T]: string };
  // 返回的 表单检验结果的类型
  type FormHint = { [K in keyof T]?: string };

  // 根据传入配置得到表单的初始值
  const initForm: Form = Object.keys(config).reduce((prev, key: keyof T) => {
    // 若传入了默认值则使用之, 否则设置为空串
    prev[key] = config[key].default || "";
    return prev;
  }, {} as Form);

  // 调用真正的 react hook 得到响应式的表单数据, 之所以叫 _setForm 是因为后面还要做一层封装
  const [form, _setForm] = useState(initForm);
  // 调用 react hook 得到响应式的表单检验情况数据, 默认为都通过
  const [formIsValidate, setFormValidate] = useState<FormHint>({});

  /**
   * 修改表单的部分字段
   * @param partOfNewForm {字段: 值}, 只改变传入参数中包含的字段
   */
  function setForm(partOfNewForm: Partial<Form>) {
    const newForm: Form = { ...form, ...partOfNewForm };
    _setForm(newForm);
  }

  /**
   * 检查表单的部分(或全部)字段
   * @param keysToCheck 传入多个参数作为需要检验的字段, 若不传参数则检查所有字段
   */
  function doValidate(...keysToCheck: (keyof T)[]) {
    if (keysToCheck.length === 0) {
      // 如果不传入参数则检查所有字段
      keysToCheck = Object.keys(config);
    }
    const newIsValidate = { ...formIsValidate };
    keysToCheck.forEach(
      // 使用传入的 validator 检查你想检查的字段并更新 formIsValidate 的值
      (key) => (newIsValidate[key] = config[key].validator(form[key]))
    );
    setFormValidate(newIsValidate);
  }

  return { form, setForm, formIsValidate, doValidate };
}
```

### test

```ts
const { form, setForm, formIsValidate, doValidate } = useForm({
  name: {
    default: "foo",
    validator: (s) => (s.length > 12 ? undefined : "用户名长度需在 0~12 之间"),
  },
  password: {
    validator: (s) =>
      /^.{6,20}$/.test(s) ? undefined : "密码长度需在 6~20 之间",
  },
});

/* 以下操作均有完整的类型检查 */

form.name; // -> string
formIsValidate.password; // -> string
setForm({ name: "new val" });
doValidate("name", "password");
```

## 总结

开发中要坚持 DRY 原则(don't repeat yourself), 当遇到重复逻辑时一定要注意提取相似部分进行封装, 在封装时
也要注意其可拓展性. 借助 TS 进行一些花哨的操作, 我们也可以得到完整的类型检查, 这对开发也是大有裨益的

## 完整代码

```ts
function useState<T>(init: T) {
  const state: T = init;
  function setState(state: T) {}

  return [state, setState] as const;
}

type ConfigOpts = {
  /** 字段的默认值 */
  default?: string;
  /**
   * 对字段的检验函数
   * @param value 此字段现在的值
   * @returns 若检验成功则返回 undefined, 否则返回对应的提示信息
   */
  validator: (value: string) => string | undefined;
};

function useForm<T extends { [name: string]: ConfigOpts }>(config: T) {
  // 返回的 表单的类型
  type Form = { [K in keyof T]: string };
  // 返回的 表单检验结果的类型
  type FormHint = { [K in keyof T]?: string };

  // 根据传入配置得到表单的初始值
  const initForm: Form = Object.keys(config).reduce((prev, key: keyof T) => {
    // 若传入了默认值则使用之, 否则设置为空串
    prev[key] = config[key].default || "";
    return prev;
  }, {} as Form);

  // 调用真正的 react hook 得到响应式的表单数据, 之所以叫 _setForm 是因为后面还要做一层封装
  const [form, _setForm] = useState(initForm);
  // 调用 react hook 得到响应式的表单检验情况数据, 默认为都通过
  const [formIsValidate, setFormValidate] = useState<FormHint>({});

  /**
   * 修改表单的部分字段
   * @param partOfNewForm {字段: 值}, 只改变传入参数中包含的字段
   */
  function setForm(partOfNewForm: Partial<Form>) {
    const newForm: Form = { ...form, ...partOfNewForm };
    _setForm(newForm);
  }

  /**
   * 检查表单的部分(或全部)字段
   * @param keysToCheck 传入多个参数作为需要检验的字段, 若不传参数则检查所有字段
   */
  function doValidate(...keysToCheck: (keyof T)[]) {
    if (keysToCheck.length === 0) {
      // 如果不传入参数则检查所有字段
      keysToCheck = Object.keys(config);
    }
    const newIsValidate = { ...formIsValidate };
    keysToCheck.forEach(
      // 使用传入的 validator 检查你想检查的字段并更新 formIsValidate 的值
      (key) => (newIsValidate[key] = config[key].validator(form[key]))
    );
    setFormValidate(newIsValidate);
  }

  return { form, setForm, formIsValidate, doValidate };
}

const { form, setForm, formIsValidate, doValidate } = useForm({
  name: {
    default: "foo",
    validator: (s) => (s.length > 12 ? undefined : "用户名长度需在 0~12 之间"),
  },
  password: {
    validator: (s) =>
      /^.{6,20}$/.test(s) ? undefined : "密码长度需在 6~20 之间",
  },
});

/* 以下操作均有完整的类型检查 */

form.name; // -> string
formIsValidate.password; // -> string
setForm({ name: "new val" });
doValidate("name", "password");
```
