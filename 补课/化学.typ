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
#import "@preview/typsium:0.2.0": ce
// #import "@preview/grayness:0.2.0": * // 基本图片编辑功能

// #include "use.typ"
#set page(columns: 1)
= 基础知识
== 物质的量
/ 物质的量$n$ : 含有一定*微粒*的集合体，单位为摩尔（mol）。注意一定得指明微粒的名称（分原离质中电，转移电子共价键）。
  - 比如3 mol 氢、氧（错）         1 mol He（对，只有这一种） 
/ 阿伏伽德罗常数$N_A$ : 1 mol 含有 $6.023 times 10^(23)$ 个微粒，单位为 $"mol"^(-1)$。

/ 摩尔质量$M$ : 1 mol 的物质的质量，单位为 *g/mol*。它等于物质的相对分子质量（或相对原子质量）,注意单位。
  - 例如：$M(H_2)=2$，$M(O_2)=32 $  对吗？
/ 气体摩尔体积: 
  - 气体的摩尔体积$V_m$ : 在标准状况下*（0℃，1 atm*），1 mol 气体的体积为 $22.4 L$。
/ B的物质的量浓度$c_B$ : #h(2em)单位体积的溶液中所含溶质$B$的物质的量，简写为$c$，单位为 *mol/L*。

== 理想气体状态方程
$ P V=n R T  $

其中
/ $T$\: : *热力学*温度，单位为 *K*（开尔文），$T=273.15+T_0$，其中$T_0$为摄氏温度。（一般保留整数即可）
/ $P$\: : 气体的*压强*，单位为 *Pa*（帕斯卡）
/ $V$\: : 气体的*体积*，单位为 $m^3$（立方米）
/ $n$\: : 气体的*物质的量*，单位为 *mol*（摩尔）
/ $R$\: : *理想气体常数*，$R=8.314 J\/("mol" K)$


一般来说，我们定义室温为25℃，也就是298 K。

*气体摩尔体积的求解*

#mitex(`
V=\frac{1\mathrm{mol}\times8.314\mathrm{J}\cdot\mathrm{mol}^{-1}\cdot\mathrm{K}^{-1}\times273\mathrm{K}}{1\:01\times10^{5}\mathrm{Pa}}\approx22.4\times10^{-3}\mathrm{m}^{3}=22.4\mathrm{~L}
`)


辨析: 
+ 同温同压同体积的气体含有的物质的量相等  （对/错）
+ 同温同压同物质的量的气体含有的原子数相等  （对/错）

例：
+ 恒容装置中充入一定量的气体，升高温度，则气体总压强
+ 恒压装置中充入一定量的气体，升高温度，则气体的总体积
+ 恒容装置中，温度不变，充入惰性气体，则气体总压强
+ 恒压装置中，温度不变，充入惰性气体，则气体总体积

理想气体状态方程有多种变式，主要是因为物质的量
$ m=n M , V=n V_m $

所以
$ P V &= m / M  R T \ P V &= V / V_m  R T $

例:求48g #ce("2NaHO3")完全分解后固体的质量

#ce("2NaHO3 = Na2CO3 + H2O + O2")

/ 溶解度$s$\: : 温度t下,100 g 水中所能溶解的溶质的最大质量，单位为 *g*。
 - 或者说，饱和溶液中的物质的量浓度，单位为 *mol/L*。 

*溶液的质量分数*

$ w=(m_质)/(m_"溶液")=(s/(1+s))times 100% $


*质量分数和质量分数的换算*
$ c=n_质/V_液=m_质/M_质\/m_液/(rho)=(1000 rho w)/M_质 $

例: 
1L的水中溶解了标况下VL氨气，所得氨水的密度为$rho #h(0.5em)g \/ c m^3 $,求c和w

= 氧化还原反应
== 化合价
/ 化合价: 不同原子之间形成化合物的时候得失$e^(-)$（或者共用电子对的偏移）,化合物中化合价的代数和为0，离子当中化合价的代数和为离子电荷。

比如  #ce("H2O, H2O2, NaCl, SO4^2-") 


得到电子或者共用电子对偏移自己，化合价下降, 负价。

失去电子或者共用电子对偏移自己，化合价上升, 正价。

*判断化合价的常用方法*

金属元素无负价，元素的电负性(元素周期表越靠近右上越大)越大，化合价越小。

#image("img/1752286777511.png")
== 元素周期表的记忆
