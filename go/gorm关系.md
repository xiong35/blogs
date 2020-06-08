
# gorm关系

## 详见代码

```go
type StudentCard struct {
    gorm.Model
    Money  float32
    Number string
}

type Student struct {
    gorm.Model
    Name          string
    // 多对多, 指定关联表名称
    Subjects      []Subject `gorm:"many2many:stu_sub;"`
    // 一对一, 直接写
    StudentCard   StudentCard
    // 指定一对一的外键
    StudentCardID int
}

type Subject struct {
    gorm.Model
    Name     string
    Teacher  string
    // 多对多, 指定关联表名称
    Students []Student `gorm:"many2many:stu_sub;"`
}

func main() {
    db, err := gorm.Open("mysql", "root:xyl0321@/school?charset=utf8&parseTime=True&loc=Local")
    if err != nil {
        panic("failed to connect database")
    }
    defer db.Close()

    // 迁移数据表
    db.AutoMigrate(&StudentCard{}, &Student{}, &Subject{})

    student2 := Student{
        Name: "pu",
        Subjects: []Subject{
            // 如果用字面量, 将自动创建对应数据
            {Name: "cs", Teacher: "A"},
            {Name: "phy", Teacher: "c"},
            {Name: "math", Teacher: "B"},
        },
        StudentCard: StudentCard{
            Money:  33333,
            Number: "U2010",
        },
    }
    // 执行之后已经创建了相关联的数据
    db.Create(&student2)

    // 为了避免自动创建, 需要查数据库来选
    var sub1, sub []Subject

    db.Table("subjects").Where("name in (?)", []string{"cs", "phy"}).Find(&sub1)
    db.Table("subjects").Where("name in (?)", []string{"cs", "math"}).Find(&sub)

    student1 := Student{
        Name:     "lalala",
        // 指定 Subjects 为库中查出来的数据
        Subjects: sub1,
        StudentCard: StudentCard{
            Money:  3,
            Number: "U2017",
        },
    }
    student := Student{
        Name:     "xyl",
        Subjects: sub,
        StudentCard: StudentCard{
            Money:  66.6,
            Number: "U2019",
        },
    }

    db.Create(&student1)
    db.Create(&student)
}
```