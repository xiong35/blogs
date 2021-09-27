# mysql 知识点杂记(一)

> 关键词: sql

教程地址: [MySQL 基础+高级篇- 数据库 -sql -尚硅谷](https://www.bilibili.com/video/BV12b411K7Zu)

## 约束

```sql
CREATE TABLE <表名> {
    <字段名> <类型> <约束>
}
```

六大约束如下:

1. not null
2. default
3. primary key
4. unique
5. check: 对值进行限制 (mysql 不支持, 如果加了就静默失败)
6. foreign key: 该字段的值必须来自主表的关联列的值

外键只能当作**表级约束**, **列级约束**不能出现非空和默认

```sql
CREATE TABLE studentInfo {
    id INT PRIMARY KEY, -- 主键
    stuName VARCHAR(20) NOT NULL, -- 非空
    gender CHAR(1) CHECK (gender = "男" OR gender = "女"), -- 检查
    seat INT UNIQUE, -- 唯一
    age INT DEFAULT 18, -- 默认
    major INT FOREIGN KEY REFERENCES major(id) -- 外键
}
```

> `SHOW INDEX FROM <表名>`可以查看外键

## 事务

```sql
SET autocommit=0; -- 禁用隐式事务

START TRANSACTION; -- 开启事务, 如果写了上一句, 这一句就是可选的

-- INSERT
-- DELETE

SAVEPOINT foo;

-- UPDATE
-- ...

ROLLBACK TO foo;

COMMIT; -- 提交, 或者: ROLLBACK;
```

## 视图

相当于封装了一个函数

```sql
CREATE VIEW foo
-- CREATE OR REPLACE VIEW foo
-- ALTER VIEW foo
-- DROP VIEW foo [, bar]
AS
SELECT stuName, major
FROM Students s
INNER JOIN majors m ON s.`major`=M.`ID`;

------------------------

SELECT * FROM foo
```
