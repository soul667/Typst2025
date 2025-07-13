// 基本模板
#import "@preview/rubber-article:0.1.0": *
#show: article.with()
#import "@preview/mitex:0.2.4": * // latex 兼容包
#import "@preview/cmarker:0.1.1" //  md兼容包
#import "@preview/codly:1.0.0": * // 设置代码块
#import "@preview/note-me:0.3.0": * //提示
// #show: codly-init.with()
#import "@preview/showybox:2.0.3": showybox // 彩色盒子
#import "@preview/cetz:0.3.1": canvas, draw // CeTZ 绘图包
#import "@preview/i-figured:0.2.4"
#show math.equation: i-figured.show-equation.with(only-labeled: false) // 只有引用的公式才会显示编号
#show figure: i-figured.show-figure // 图1.x
#import "@preview/physica:0.9.3":* // 数学公式简写
#import "@preview/lovelace:0.3.0": * // 伪代码算法
#set text(font:("Times New Roman","Source Han Serif SC"), size: 12pt) // 设置中英语文字体 小四宋体 英语新罗马 
// #import "@preview/cuti:0.2.1": show-cn-fakebold  // 中文伪粗体 像我们使用的Source Han Serif SC是粗体字体不用开启
// #show: show-cn-fakebold
#import "@preview/dashy-todo:0.0.1": todo
#import "@preview/pavemat:0.1.0":* // show matrix beautifully
#let 行间距转换(正文字体,行间距) = ((行间距)/(正文字体)-0.75)*1em
#set par(leading: 行间距转换(12,20),justify: true,first-line-indent: 2em)
#import "@preview/indenta:0.0.3": fix-indent
#show: fix-indent() // 修复第一段的问题
#show heading: it =>  {it;par()[#let level=(-0.3em,0.2em,0.2em);#for i in (1, 2, 3) {if it.level==i{v(level.at(int(i)-1))}};#text()[#h(0.0em)];#v(-1em);]} // 修复标题下首行 以及微调标题间距
#show ref: it => {
  let eq = math.equation;let el = it.element;
  if el != none and el.func() == eq {link(el.location(),"式"+numbering(el.numbering,..counter(eq).at(el.location())))} else {it}
} // 设置引用公式为式
#show figure.where(kind:image): set figure(supplement: [图]) // 设置图
#show figure.where(kind:"tablex"): set figure(supplement: [表]) // 设置表
#import "@preview/mannot:0.1.0": * // 公式突出
// #import "@preview/oasis-align:0.1.0" // 自动布局
#import "@preview/tablex:0.0.9": * // 表格
// ------------定理 证明----------------
// 默认可间断了，可调
#import "@preview/ctheorems:1.1.3": *
#show: thmrules
#let theorem = thmbox("定理", "定理", stroke: rgb("#ada693a1") + 1pt,breakable: true) //定理环境
#let example = thmbox("例", "例", stroke:(paint: blue, thickness: 0.5pt, dash: "dashed") ,breakable: true) //定理环境

#let definition = thmbox("定义", "定义", inset: (x: 0.5em, top: -0.25em,bottom:-0.25em),stroke: rgb("#ada693a1") + 0pt,breakable: false) // 定义环境
#let proof = thmproof("证", "证",breakable: true) //证明环境
// ----------------------------

// #import "@preview/grayness:0.2.0": * // 基本图片编辑功能

// #include "use.typ"
#set page(columns: 1)
= 初高衔接
== 和差公式
=== 平方和差公式
$ (a+b)(a-b)&=a^2-b^2 \ (a+b)^2&=a^2+b^2+2 a b $ 
=== 完全n次方公式 $#h(-0.5em)" "^*$
可以使用杨辉三角来进行记忆


// #align(center,[#image("img/23.png",width: 70%)])
$ (a+b)^0&=1 \ (a+b)^1 &=a+b \ (a-b)^1&=a-b \ (a+b)^2&=a^2+2a b -b^2 \ (a-b)^2&=a^2 - 2 a b + b^2 \ (a+b)^3&=a^3+3a^2b+3 a b^2 + b^3 \ (a-b)^3&=a^3-3a^2b+3 a b^2 - b^3 \ .&.. $

Q: 请自己写出$(a+b)^4$和$(a-b)^4$的公式

$ (a+b)^4 &= a^4 + 4a^3b + 6a^2b^2 + 4a b^3 + b^4  
\
(a-b)^4&= a^4 - 4a^3b + 6a^2b^2 - 4a b^3 + b^4
  $
=== 立方和差公式

$ a^3+b^3&=(a+b)(a^2-a b+b^2) \ a^3-b^3&=(a-b)(a^2+a b+b^2) $

=== 拓展到n方和差公式
$ a^n-b^n=(a-b)(a^(n-1)+a^(n-2)b+dots +a b^(n-2) +b^(n-1))#h(1em)n"为任意整数" $
$ a^n+b^n=(a+b)(a^(n-1)-a^(n-2)b+dots +a b^(n-2) -b^(n-1))#h(1em)n"为正奇数" $

==== 例题1
$ 27a-a^4=a(3^3-a^3)=a(3-a)(3^2+3a+a^2) $
==== 例题2
$ 729a^6-243a^4+27a^2-1 $

#mitex(`
\begin{align}&\text{原式 }=9^3a^6-3^5a^4+3^3a^2-1\\&=(9a^2)^3-3(9a^2)^2+3(9a^2)\cdot1^2-1^2\\&=(9a^2-1)^3\end{align}
`)
=== 例题3
$ 9x^5-72x^2y^3 $
$ "原式"=9x^2[x^3-(2y)^3]= 9x^2(x-2y)(x^2+2x y+4y^2) $

=== 例题4
#mitex(`
\begin{pmatrix}2x+y\end{pmatrix}^3-\begin{pmatrix}2y-x\end{pmatrix}^3
`)

$ "原式"=(3x-y)(3x^2+3x y+7y^2) $
=== 例题5
$ x^5-1  $

$ (x-1)(x^4+x^3+x^2+x+1) $
==== 对于根式套根式
$ sqrt(5-2sqrt(6)) #h(3em) sqrt(4-sqrt(15)) "的化简" $

$ sqrt(5-2sqrt(6))&= sqrt(sqrt(2)^2+sqrt(3)^2-2 sqrt(2) sqrt(3))=|sqrt(2)-sqrt(3)|=sqrt(3)-sqrt(2) $

$ sqrt(4-sqrt(15))&= sqrt(1/2(8-2sqrt(15)))=sqrt(2)/2(sqrt(5)-sqrt(3))=1/2(sqrt(10)-sqrt(6)) $
== 因式分解
=== 十字相乘
$ (a x +b)(c x + d)&=a c x^2+ (a d +a c)x + b d \
&= A x^2 + B x + C $

==== 例题
$ x^2-3x-4 &\ 
x^2 -5x +6 &\
x^2 -12x + 20 &\
x^2 + 2x - 8 &\
$


$ 6x^2-7x-3 &\ 
x^2 -5x +6 &\
x^2 -12x + 20 &\
x^2 + 2x - 8 &\
$
=== 长除法$#h(-0.2em)" "^*$
将一个多项式（被除式）除以另一个多项式（除式），以找到商式和余式
如$x^3+2x^2-5x-6$，我们能找到其一个根$x=2$，对于剩下的根，使用长除法
$ &(x^3+2x^2-5x-6) / (x-2)  \ &= (4x^2-5x-6) / (x-2)+x^2 \ &= (3x-6) / (x-2) +x^2+4x \ &= x^2+4x-3 \ &=(x-3)(x-1) $
// = 集合
// == 定义
// // 群是抽象代数的概念，群是一种集合加上一种运算的代数结构，我们将集合记作 $A$, 那么群就可以记作是 $G=(A,.)$，该运算满足如下几个条件
// // / 封闭性: $forall  a_1,a_2 in A$,$a_1 dot a_2 in A$
// // // #set font: 
// // 

//
== 三角形相关知识
=== 直角三角形相关
// page()
= 集合 
== 基本概念
/ 集合 : *研究对象所组成的整体*
  - 比如自然数集合 $NN$, 实数集合 $RR$，一个教室里的学生等都可以叫做集合
  - 一般用大写字母来表示，如 $A$, $B$, $C$ 等
/ 元素 : *组成集合的各个对象*
  - 比如自然数集合 $NN$ 中的元素有 $0, 1, 2, 3, ...$ 等 
  - 一般用小写字母来表示，如 $a$, $b$, $c$ 等
集合中的元素具有 *无序性*和*唯一性*，即集合中的元素不考虑顺序，且每个元素只能出现一次。

常见的集合有 自然数集
=== 集合的表示方法
/ 列举法 : *直接列出集合中的所有元素*，如 $A = {1, 2, 3, 4}$
/ 描述法 : *用条件描述集合中的元素*，如 $B = {x in RR | x > 0}$ 表示所有大于0的实数
=== 集合的相关符号（集合关系）
属于、包含、交并补。
/ 属于($ a in A "或" a in.not A$): 元素$a$属于集合$A$
/ 包含($ A subset.eq B$): 集合$A$是集合$B$的子集
   / 真包含(#mi("A \subsetneqq B")): 集合$A$是集合$B$的*真*子集，真子集的定义是$A subset.eq B,exists("存在") x in A,x in.not B$
/ 空集($diameter$): 没有任何元素的集合，*空集是任意集合的子集*

=== 集合之间的运算
主要包括交、并、补运算
/ 交集($ A inter B$): $ {x| x in A " 且 " x in B }$
/ 并集($ A union B$): $ {x| x in A " 或 " x in B }$
/ 全集($ U$): 包含所研究对象元素的集合，通常用大写字母$U$表示
/ 补集($ C_u A$):  $ {x| x in U " 且 " x in.not A }$
/ venn图: 用来表示集合之间的关系和运算，如下例子

#figure(
  canvas({
    import draw: *
    
    // 设置坐标系
    set-style(
      stroke: (thickness: 1.5pt, paint: black),
      fill: none
    )
    
    // 绘制外边框（全集U）
    rect((-3, -2.5), (3, 2.5), stroke: (thickness: 2pt, paint: black), name: "universe")
    content((-2.5, 2), [U], anchor: "center")
    
    // 绘制集合A（左圆）
    circle((-0.8, 0), radius: 1.2, 
           fill: rgb(255, 0, 0, 50), 
           stroke: (thickness: 1.5pt, paint: red),
           name: "A")
    content((-1.5, 0), text(size: 14pt, fill: red)[A], anchor: "center")
    
    // 绘制集合B（右圆）
    circle((0.8, 0), radius: 1.2, 
           fill: rgb(0, 0, 255, 50), 
           stroke: (thickness: 1.5pt, paint: blue),
           name: "B")
    content((1.5, 0), text(size: 14pt, fill: blue)[B], anchor: "center")
    
    // 标记交集区域
    content((0, 0), text(size: 10pt, fill: purple)[A∩B], anchor: "center")
    
    // 标记并集外的区域
    content((0, -1.8), text(size: 12pt, fill: black)[A∪B], anchor: "center")
  }),
  caption: [两个集合的 Venn 图示例],
  supplement: [图]
)
== 关于集合的一些基本定理
*德摩根定律*
$ C_u (A inter B) = C_u A union C_u B $
$ C_u (A union B) = C_u A inter C_u B $

= 函数 极限 导数 积分
== 函数及其定义
#definition([*函数*])[
  函数本质上是一个集合（自变量）到另一个集合（因变量）的映射（单射）#footnote([单射表示的是每一个自变量都对应一个唯一的因变量])，或者说对于某个集合中的每一个输入（自变量），都对应唯一的输出（因变量）。其有*解析法、表格法、图像法*等多种表示方式。

]
我们将自变量的集合叫做*定义域*，将因变量的集合叫做*值域*。
#example([*定义域和值域*])[
  设函数$f(x)=x^2$，则其定义域为$RR$，值域为$[0,+ oo)$#footnote([注意这里这样写法，$[0,+ oo)$等价于${x in   RR| x>=0}$,再比如说$(a,b]$就等价于 ${x in RR| a<x<=b}$。]).
]

#include "img/f1.typ"


根据函数的定义，很自然可以知道分段函数的定义，比如

#mitex(`
 $ f(x)=\begin{cases} x^2 &\quad x<0  \\ x+1 & \quad x>=0 \end{cases} $
`)


#include "img/f2.typ"

#example([在上述例子中求值域])[
+ 定义域为$(-1,1)$
+ 定义域为$[1/2,0) union (0,1)$

]

=== 定义域的求解类题
注意分母不为0，根式里面非负等。如
$ f(x)=sqrt(x-1)/(|x-2|) $

=== 是否表示相同函数

$ f(x)=(x^2-1)/(x-1) #h(1.5em)g(x)=x+1 $

$ f(x)=x^0 #h(1.5em)g(x)=1 $
$ f(x)=x/(sqrt(x)^2) #h(1.5em)g(x)=(sqrt(x)^2)/x $
== 函数的性质
  单调性、奇偶性、周期性

  #definition([*单调性*])[

$forall x_1,x_2 in D,  x_1 < x_2$时都有$f(x_1) < f(x_2)$，原函数在定义域$D$上是单调递增的,原函数为增函数；

$forall x_1,x_2 in D,x_1 < x_2$时都有$f(x_1) > f(x_2)$，原函数在定义域$D$上是单调递减的，原函数为减函数。
  ]
  #definition([*单调区间*])[
    
    
    $exists D_1 subset.eq D,forall x_1,x_2 in D_1,  x_1 < x_2$时都有$f(x_1) < f(x_2)$，我们就称$f(x)$在区间$D_1$上是*单调递增*的，$D_1$是$f(x)$的单调增区间；

    $exists D_1 subset.eq D,forall x_1,x_2 in D_1,  x_1 > x_2$时都有$f(x_1) > f(x_2)$，我们就称$f(x)$在区间$D_1$上是*单调递减*的，$D_1$是$f(x)$的单调减区间；
    
    类似地，请给出单调不递增和单调不递减的定义。
    // 如果$x_1 < x_2$时都有$f(x_1) > f(x_2)$，则称$f(x)$在区间$D_1$上是单调递减的。
  ]
  
  #definition([*奇偶性*])[
  
  奇函数：$forall x in D, -x in D, f(-x)=-f(x)$
  
  偶函数：$forall x in D, -x in D,f(-x)=f(x)$
  
  *注意定义域一定要对称*
  ]
  #definition([*周期性*])[
  周期函数：$exists T>0,forall x in D,f(x+T)=f(x)$，其中$T$为周期。
  ]


  // 接下来我们定义函数的最值，最值是指函数在定义域$D$内的最大值和最小值。
  #definition([*最值*])[
    
    $forall x in D,f(x)<=M, exists x in D,f(x)=M$,则称$M$为函数$f(x)$在$D$上的最大值；
    
    $forall x in D,f(x)>=m, exists x in D,f(x)=m$,则称$m$为函数$f(x)$在$D$上的最小值。
  
    类似单调区间的定义，我们也可以定义某个区间上的最大值和最小值。
  ]


  // #definition([*极值*])[
  //   $exists D_1 subset.eq D, forall x in D_1,f(x)<=M, exists x in D_1,f(x)=M$,则称$M$为函数$f(x)$在$D$上的极大值；
  //   $exists D_1 subset.eq D,forall x in D_1,f(x)>=m, exists x in D_1,f(x)=m$,则称$m$为函数$f(x)$在$D$上的最小值。
  // ]

#example()[
求$|x^2-5x+6|$的单调增区间以及$x in(1.5,2.5)$时候的最小值，这时候存在最大值吗？$x in [1.5,2.5]$呢？
]
#example([12.2])[
$forall x_1 ,x_2 in (-oo,0]$ , $x_1 > x_2$时都有$f(x_1) > f(x_2),g(x_1)>g(x_2)$

因为$f(x)$是偶函数$f(x)=f(-x)$,$g(x)$是奇函数,$g(x)+g(-x)=0$。

$forall -x_1 ,-x_2 in (0,oo]$ , $-x_1 < -x_2$时都有$f(x_1) > f(x_2),-g(x_1)>-g(x_2),g(x_1)<g(x_2)$

假设$g(x)$值域为$Z$所以
$forall x_3,x_4 in Z,x_3<x_4$时都有$f(x_3)>f(x_4)$，即$f(g(x))$在区间$[0,oo)$单调递减。 $g(f(x))$同理。
]

#definition([*对称性*])[
    $exists t,  forall x in RR , "当"(t+x) in D "时","有"(t-x) in D, f(t+x)=f(t-x)$ ，就说$f(x)$关于$x=t$对称
]

#example()[
  $forall x in RR ,f(a+x)=f(b-x)$恒成立，分析对称性
// 求$|x^2-5x+6|$的单调增区间以及$x in(1.5,2.5)$时候的最小值，这时候存在最大值吗？$x in [1.5,2.5]$呢？
]
#definition([*中心对称*])[
    $exists t,  forall x in RR , "当"(t+x) in D "时","有"(t-x) in D, f(t+x)+f(t-x)=2m$ ，就说$f(x)$关于点$(t,m)$对称
]

#example()[
  $f(-1+x)+f(5-x)=4$关于哪个点中心对称。
// 求$|x^2-5x+6|$的单调增区间以及$x in(1.5,2.5)$时候的最小值，这时候存在最大值吗？$x in [1.5,2.5]$呢？
]

*其实到这里我们也可以法线，偶函数是关于$x=0$对称的,奇函数是关于$(0,0)$的中心对称*
== 函数的极限
