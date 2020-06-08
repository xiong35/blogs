
# 初探 gorm

安装:

```
go get -u github.com/jinzhu/gorm
```

## 基本的增删改查

```golang
// 生成的数据表叫"product_infos" ps.有"s"
type ProductInfo struct {
	gorm.Model // gorm.Model 中自带创建时间, 修改时间, 删除时间, id 字段
	Code       string
	Price      uint
}

func main() {
	db, err := gorm.Open("sqlite3", "./tmp/sql.db")
	if err != nil {
		panic("failed to connect database")
	}
	// defer db.Close()

	// 把结构体和数据库字段对应
	db.AutoMigrate(&ProductInfo{})

	// 创建
	db.Create(&ProductInfo{Code: "L1212", Price: 1000})

	// 读取
	var productInfo ProductInfo
	// db.First() 会将传入的参数修改为查出来的数据
	db.First(&productInfo, 1) // 查询id为1的product
	fmt.Printf("info: %v\n", productInfo)

	// 更新 - 更新product的price为2000
	db.Model(&productInfo).Update("Price", 2000)

	// 删除 - 删除product
	// db.Delete(&productInfo)
}
```

## mysql

```golang
db, err := gorm.Open("mysql", "root:xyl0321@/demo_db?charset=utf8&parseTime=True&loc=Local")
```

## 定义字段

```golang
type User struct {
	gorm.Model
	Name         string
	Age          sql.NullInt64
	Birthday     *time.Time
	Email        string  `gorm:"type:varchar(100);unique_index"`
	Role         string  `gorm:"size:123"`        // 设置字段大小为123
	MemberNumber *string `gorm:"unique;not null"` // 设置会员号（member number）唯一并且不为空
	Num          int     `gorm:"AUTO_INCREMENT"`  // 设置 num 为自增类型
	Address      string  `gorm:"index:addr"`      // 给address字段创建名为addr的索引
	IgnoreMe     int     `gorm:"-"`               // 忽略本字段
}
```

## 默认值 / 指针值 / Debug()

```golang
type User struct {
	ID   int32
	Name *string `gorm:"default:'lalala'"` // use pointer to allow ""
	// Name sql.NullString 或者用这种方法, 允许直接传空串
	Age  uint
}

func main() {
	db, err := gorm.Open("mysql", "root:xyl0321@/demo_db?charset=utf8&parseTime=True&loc=Local")
	if err != nil {
		panic("failed to connect database")
	}
	defer db.Close()

	db.AutoMigrate(&User{})

	user1 := User{
		Name: new(string), // use ""
		Age:  29,
	}
	user2 := User{
		// Name: , // use default
		Age: 39,
	}

	fmt.Println(db.NewRecord(&user1)) // return a bool val to indicate if the primary key is unused
	db.Debug().Create(&user1)         // use Debug() to see the sql string
	fmt.Println(db.NewRecord(&user1))

	fmt.Println(db.NewRecord(&user2))
	db.Debug().Create(&user2)
	fmt.Println(db.NewRecord(&user2))
}
```