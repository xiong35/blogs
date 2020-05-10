
- 用postman在body里添加raw参数, 在request.POST里取不出数据
- info = json.load(request.body)

- 新增数据时添加有多对多关系的数据
``` py
tags = ArticalTag.objects.filter(tag_name__in=info.get('tags'))
for tag in tags:
    record.tags.add(tag) 
```

- 已拦截跨源请求：同源策略禁止读取位于 http://127.0.0.1:8000/artical/blog/ 的远程资源。（原因：CORS 请求未能成功）
```py
from django.utils.deprecation import MiddlewareMixin
class CORSMid(MiddlewareMixin):
    def process_response(self, request, response):
        response["Access-Control-Allow-Origin"] = "*"
        return response
```

- 已拦截跨源请求：同源策略禁止读取位于 http://127.0.0.1:8000/artical/blog/ 的远程资源。（原因：CORS 预检响应的 'Access-Control-Allow-Headers'，不允许使用头 'content-type'）
```python
response["Access-Control-Allow-Origin"] = "*"
response["Access-Control-Allow-Origin"] = "*"
response["Access-Control-Allow-Credentials"] = "true"
response["Access-Control-Allow-Methods"] = "*"
response["Access-Control-Allow-Headers"] = "Content-Type,Access-Token"
response["Access-Control-Expose-Headers"] = "*"
```
    headers:{'Content-Type': 'application/json'}

[r.f.](https://www.cnblogs.com/caimuqing/p/6733405.html)


- 基于数据库+类视图的缓存

```python
# python manage.py createcachetable TABLE_NAME

""" 
CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.db.DatabaseCache',
        'LOCATION': 'TABLE_NAME',
    }
} """

from django.utils.decorators import method_decorator
from django.views.decorators.cache import cache_page

class HelloPage(View):
    @method_decorator(cache_page(60*60*24))
    def get(self,request):
        print("enter HelloPage.get")

        return HttpResponse('Hello world ...')
```

- 基于redis的缓存

```python
# pip install django-redis
# pip install django-redis-cache

# setting.py
CACHES = {
    'default': {
        'BACKEND': 'django_redis.cache.RedisCache',
        'LOCATION': 'redis://127.0.0.1:6379/1',
        'OPTIONS': {
            'CLIENT_CLASS': 'django_redis.client.DefaultClient'
        }
    }
}

# 下载安装redis: https://www.runoob.com/redis/redis-install.html
# SHELL: redis-server
```