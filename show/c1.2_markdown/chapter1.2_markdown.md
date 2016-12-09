This is an H1
=============

This is an H2
-------------

---

# This is an H1
## This is an H2
### This is an H3
#### This is an H4
##### This is an H5
###### This is an H6

---

>半亩方塘一鉴开，天光云影共徘徊。
>问渠那得清如许？为有源头活水来。

---

>古之学者必有师。师者，所以传道受业解惑也。人非生而知之者，孰能无惑？惑而不从师，其为惑也，终不解矣。生乎吾前，其闻道也固先乎吾，吾从而师之；生乎吾後，其闻道也亦先乎吾，吾从而师之。吾师道也，夫庸知其年之先後生於吾乎！是故无贵无贱无长无少，道之所存，师之所存也。
>圣人无常师。孔子师郯子、苌子、师襄、老聃。郯子之徒，其贤不及孔子。孔子曰：“三人行，必有我师。”是故弟子不必不如师，师不必贤於弟子。闻道有先後，术业有专攻，如是而已。

---

>圣人无常师。孔子师郯子、苌子、师襄、老聃。郯子之徒，其贤不及孔子。孔子曰：
>
>>三人行，必有我师。
>
>是故弟子不必不如师，师不必贤於弟子。闻道有先後，术业有专攻，如是而已。

---

>## 观书有感
>#### **朱熹**（*南宋*）
>半亩方塘一鉴开，天光云影共徘徊。
>问渠那得清如许？为有源头活水来。

---

* Red
* Green
* Blue

---

+ Red
+ Green
+ Blue

---

- Red
- Green
- Blue

---

1. Red
2. Green
3. Blue

---

1. Red
1. Green
1. Blue

---

3. Red
1. Green
5. Blue

---

1.  This is a list item with two paragraphs.

    This is the second paragraph.

2.  This is another...


---

1.  This is a list item with two paragraphs.

This is the second paragraph.

2.  This is another...

---

*   A list item with a blockquote:

    > This is a blockquote
    > inside a list item.

---

*   A list item with a code block:

        #!/usr/bin/perl
        print "Hello, world!\n";


---

1986. What a great season.


---

1986\. What a great season.


---

A normal paragraph followed by a Perl script:

    #!/usr/bin/perl
    print "Hello, world!\n";
    
---

>May the Force be with you!

    #!/usr/bin/perl
    print "Hello, world!\n";

---

This is [an example](http://example.com/ "Title") inline link.

[This link](http://example.net/) has no title attribute.

- - -

See my [About](/about/) page for details.

- - -

This is [an example][id] reference-style link.

This is [an example] [id] reference-style link.

[id]: http://example.com/  "Optional Title Here"

- - -

参考式链接的定义方式：
* [使用双引号][foo1]
* [使用单引号][foo2]
* [使用小括号][foo3]

[foo1]: http://example.com/  "Optional Title Here"

[foo2]: http://example.com/  'Optional Title Here'

[foo3]: http://example.com/  (Optional Title Here)

- - -

[Google][]
[Google]: http://google.com/

---

Visit [Daring Fireball][].
[Daring Fireball]: http://daringfireball.net/

---

I get 10 times more traffic from [Google](http://google.com/ "Google") than from [Yahoo](http://search.yahoo.com/ "Yahoo Search") or [MSN](http://search.msn.com/ "MSN Search").

---

I get 10 times more traffic from [Google] [1] than from [Yahoo] [2] or [MSN] [3].

  [1]: http://google.com/        "Google"
  [2]: http://search.yahoo.com/  "Yahoo Search"
  [3]: http://search.msn.com/    "MSN Search"
  
---

I get 10 times more traffic from [Google] [1] than from [Yahoo] [2] or [MSN] [3].

  [1]: http://google.com/       "Google"
  [2]: http://search.yahoo.com/ "Yahoo Search"
  [3]: http://search.msn.com/   "MSN Search"
  
---

I get 10 times more traffic from [Google][] than from [Yahoo][] or [MSN][].

  [google]: http://google.com/       "Google"
  [yahoo]:  http://search.yahoo.com/ "Yahoo Search"
  [msn]:    http://search.msn.com/   "MSN Search"
  
---

*single asterisks*

_single underscores_

**double asterisks**

__double underscores__

***three asterisks***

___three underscores___

---

un*frigging*believable

\*this text is surrounded by literal asterisks\*

---

Use the `printf()` function.

``There is a literal backtick (`) here.``

A single backtick in a code span: `` ` ``
  
A backtick-delimited string in a code span: `` `foo` ``

---

![Perl logo](./perl.jpg)

![Perl logo](perl.jpg "Logo of Perl")

---

![Alt text][id]

[id]: perl.jpg  "Optional title attribute"

---

<http://example.com/>

<address@example.com>

---

Footnotes[^1] have a label[^label] and a definition[^!DEF].

[^1]: This is a footnote
[^label]: A footnote on "label"
[^!DEF]: The definition of a footnote.

---

<font color="red">我是红色字体</font> 

<font color="green">我是绿色字体</font> 

<font color="blue">我是蓝色字体</font> 

<font color="#FF0000">我是红色字体</font> 

<font color="#00FF00">我是绿色字体</font> 

<font color="#0000FF">我是蓝色字体</font> 

---

#扩展语法：

##### 目录
[toc]

##### 元数据
---
title: 小书匠语法使用手册
tags: 小书匠,语法,MARKDOWN,帮助
--- 

##### 扩展的文字格式
~~添加删除线~~
++插入的文字++
==被记号的文字==
上角文字: 19^th^
下角文字: H~2~O

##### 印刷字替换
(c) (C) (r) (R) (tm) (TM) (p) (P) +-

##### 缩写定义
The HTML specification is maintained by the W3C.
*[HTML]: Hyper Text Markup Language
*[W3C]:  World Wide Web Consortium

##### 待办事项
[ ] 未完成事项
[-] 未完成事项
[x] 完成事项
[X] 完成事项

##### 定义
苹果
: 一种水果
: 一种品牌，计算机，手持设备

桔子
: 一种水果

---

```perl
#!/usr/bin/perl
print "Hello, world!\n";
```

---

Left align | Right align | Center align 
:-----------|------------:|:------------:
 This       |        This |     This
 column     |      column |    column
 will       |        will |     will
 be         |          be |      be
 left       |       right |    center
 aligned    |     aligned |   aligned 

* Outer pipes on tables are optional
* Colon used for alignment (right versus left)

---

基于LaTeX公式语法，可以创建行内公式，例如 $\Gamma(n) = (n-1)!\quad\forall n\in\mathbb N$。或者块级公式：

$$E=mc^2$$

$$ x = \dfrac{-b \pm \sqrt{b^2 - 4ac}}{2a} $$

$$
\Gamma(z) = \int_0^\infty t^{z-1}e^{-t}dt\,.
$$

---

```flow
st=>start: Start
op=>operation: Your Operation
cond=>condition: Yes or No?
e=>end

st->op->cond
cond(yes)->e
cond(no)->op
```

---

```seq
Alice->Bob: Hello Bob, how are you?
Note right of Bob: Bob thinks
Bob-->Alice: I am good thanks!
```

---

