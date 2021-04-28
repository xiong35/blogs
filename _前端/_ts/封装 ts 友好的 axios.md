
# 封装 ts 友好的 axios

尽管 axios 自带有很不错的 ts 类型支持, 但是也有一个致命的问题: 请求得到的东西
的类型是`any`, 如果处理不当会带来很多不必要的强制类型转换

在此提供一种对 axios 的封装方案, 来解决类型的问题

```ts
import axios, { AxiosRequestConfig } from "axios";

export function request<T>(config: AxiosRequestConfig) {
  const instance = axios.create({
    baseURL: BASE,
    timeout: 50000,
    withCredentials: false,
  });

  instance.interceptors.request.use((config) => { }, console.error);

  instance.interceptors.response.use(
    (response) => {
      return response.data || {};
    },
    (err) => { }
  );

  // 返回一个 promise, 其resolve的值是与后端定义好的统一格式, 而 data 字段类型是传入的泛型参数
  return new Promise<Response<T>>(async (resolve) => {
    const res = await instance(config);
    resolve((res as unknown) as Response<T>);
  });
}

interface Response<T> {
  success: boolean;
  error: string;
  data: T;
}

/* 使用 */
export async function search(
  params: {
    page: number;
    keyword: string;
  }
): Promise<Item[]> {
  const res = await request<{ items: Item[] }>({
    url: "/search/item",
    method: "GET",
    params,
  });

  // 这里的 res 就有友好的类型提示了
  if (res && res.success) return res.data.items;
  else return [];
}
```
