
# c 语言各种input函数用法

1. [fscanf](https://www.runoob.com/cprogramming/c-function-fscanf.html): `int fscanf(FILE *stream, const char *format, ...)`, 从流 stream 读取格式化输入
2. [sscanf](https://www.runoob.com/cprogramming/c-function-sscanf.html): `int sscanf(const char *str, const char *format, ...)`, 从字符串读取格式化输入
3. [fgetc](https://www.runoob.com/cprogramming/c-function-fgetc.html)&[getc](https://www.runoob.com/cprogramming/c-function-getc.html): `int fgetc(FILE *stream)`, 从指定的流 stream 获取下一个字符（一个无符号字符），并把位置标识符往前移动
4. [fgets](https://www.runoob.com/cprogramming/c-function-fgets.html): `char *fgets(char *str, int n, FILE *stream)`, 从指定的流 stream 读取一行，并把它存储在 str 所指向的字符串内。当读取 (n-1) 个字符时，或者读取到换行符时，或者到达文件末尾时，它会停止(读取的内容**不包括换行符**). 如果成功，该函数返回相同的 str 参数。如果到达文件末尾或者没有读取到任何字符，str 的内容保持不变，并返回一个空指针, 如果发生错误，返回一个空指针
5. [getchar](https://www.runoob.com/cprogramming/c-function-getchar.html): `int getchar(void)`, 从标准输入 stdin 获取一个字符（一个无符号字符）, 其实是用`fgetc`通过宏定义实现的
6. [gets](https://www.runoob.com/cprogramming/c-function-gets.html): `char *gets(char *str)`, 从标准输入 stdin 读取一行，并把它存储在 str 所指向的字符串中。当读取到换行符时，或者到达文件末尾时，它会停止. 如果成功，该函数返回 str。如果发生错误或者到达文件末尾时还未读取任何字符，则返回 NULL. (存在越界风险)
7. getch: `int getch(void)`, 不带回显, 不需要回车
8. getche: `int getche(void)`, 带回显, 不需要回车

## 参考资料

- [菜鸟教程: c 标准库](https://www.runoob.com/cprogramming/c-standard-library-stdio-h.html)
- [fgets和gets的区别解析](https://www.docin.com/p-1923570849.html)