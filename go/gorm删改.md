
# gorm删改

## 修改

```go
// 选出要更新的数据
var user User1
db.First(&user, "id=3")

// update 只会修改选择字段
db.Model(&user).Update("name", "u333")

// save 会更新所有字段
user.Name = "jinzhu 2"
user.Age = 100
db.Save(&user)

// 可以加 where, 但是这样就不会设置更新时间了
db.Model(&user).Where("id<?", 4).Update("name", "u-1")      // 只更新选出来的那个
db.Model(&User1{}).Where("id<?", 4).Update("name", "u-1")   // 更新所有

// 可以直接传入对象
db.Model(&user).Updates(User1{Name: "hello", Age: 18})

// 可以选中或忽视特定字段
db.Model(&user).Select("name").Updates(map[string]interface{}{"name": "hello", "age": 18})
// UPDATE users SET name='hello', updated_at='2013-11-17 21:34:10' WHERE id=3;
db.Model(&user).Omit("name").Updates(map[string]interface{}{"name": "hello", "age": 18})
// UPDATE users SET age=18, updated_at='2013-11-17 21:34:10' WHERE id=3;

// 表达式
db.Model(&user).Update("age", gorm.Expr("age + ?", 1))
```

## 删除

```go
// 选出要更新的数据
var user User1
db.First(&user, "id=3")

//普通删除
db.Delete(&user)

// 批量删除
db.Where("age = ?", 20).Delete(&User{})

// 恢复软删除
db.Table("user1").Unscoped().Update("deleted_at", nil)

// 物理删除
db.Unscoped().Delete(&user)
```