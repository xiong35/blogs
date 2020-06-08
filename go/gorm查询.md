
# gorm 查询

## 根据id查

```golang
var userF User1
var userL User1
var usersA []User1

// First() 根据主键查, 第二个参数默认是主键值
// 没查到不会对参数一进行任何修改, 也不报错
db.First(&userF, 10)
db.Last(&userL) // 最后一个
db.Find(&usersA) // 所有
```

## where

基本同于sql语句

```golang
// IN
db.Where("name IN (?)", []string{"jinzhu", "jinzhu 2"}).Find(&users)
// SELECT * FROM users WHERE name in ('jinzhu','jinzhu 2');

// LIKE
db.Where("name LIKE ?", "%jin%").Find(&users)
// SELECT * FROM users WHERE name LIKE '%jin%';

// AND
db.Where("name = ? AND age >= ?", "jinzhu", "22").Find(&users)
// SELECT * FROM users WHERE name = 'jinzhu' AND age >= 22;
```

## not / or

```golang
/* NOT */
// Not In
db.Not("name", []string{"jinzhu", "jinzhu 2"}).Find(&users)
// SELECT * FROM users WHERE name NOT IN ("jinzhu", "jinzhu 2");

// 普通 SQL
db.Not("name = ?", "jinzhu").First(&user)
// SELECT * FROM users WHERE NOT(name = "jinzhu") ORDER BY id LIMIT 1;

/* OR */
db.Where("role = ?", "admin").Or("role = ?", "super_admin").Find(&users)
// SELECT * FROM users WHERE role = 'admin' OR role = 'super_admin';
```

## FirstOr...

| \\|Assign | Attrs |
| --------- | --------- |
| Init      | 不管记录是否找到，都将参数赋值给 struct.                | 如果记录未找到，将使用参数初始化 struct.      |
| Create    | 不管记录是否找到，都将参数赋值给 struct 并保存至数据库. | 如果记录未找到，将使用参数创建 struct 和记录. |

e.g.

```golang
db.Where(User{Name: "non_existing"}).Attrs(User{Age: 20}).FirstOrCreate(&user)

db.Where(User{Name: "non_existing"}).Assign(User{Age: 20}).FirstOrInit(&user)
```

## 高级查询

```golang
db.Select("name, age").Find(&users)
// SELECT name, age FROM users;

db.Table("users").Select("COALESCE(age,?)", 42).Rows()
// SELECT COALESCE(age,'42') FROM users;

db.Order("age desc, name").Find(&users)
// SELECT * FROM users ORDER BY age desc, name;

db.Limit(3).Find(&users)
// SELECT * FROM users LIMIT 3;

// 忽略前 n 条
db.Offset(3).Find(&users)
// SELECT * FROM users OFFSET 3;

db.Where("name = ?", "jinzhu").Find(&users).Count(&count)
db.Where("name = ?", "jinzhu").Count(&count)

db.Table("users").Select("users.name, emails.email").Joins("left join emails on emails.user_id = users.id").Scan(&results)
```

## scan 的用法

基础

```golang
type test struct {
	ID   int
	Name string // 必须首字母大写
}

var users []test
db.Table("user1").Select("id, name").Scan(&users)
```

复杂

```golang
type Result struct {
    Date     time.Time
    TotalAge int // 注意驼峰/蛇形命名
}

var results []Result

db.Table("user1").
    Select("date(created_at) as date, sum(age) as total_age").
    Group("date(created_at)").Scan(&results)

fmt.Println(results)

/* ↑ 或者 ↓ */

var result Result

rows, err := db.Table("user1").
    Select("date(created_at) as date, sum(age) as total_age").
    Group("date(created_at)").
    Having("sum(age) > 80").
    Rows()

for rows.Next() {
    rows.Scan(&result.Date, &result.TotalAge)
    fmt.Println(result)
}
```