// 基本模板
#import "@preview/rubber-article:0.5.0": *
// #show: article.with()

// For math
#import "@preview/mitex:0.2.5": * // latex 兼容包
#import "@preview/pavemat:0.2.0":* // show matrix beautifully
#import "@preview/physica:0.9.5":* // 数学公式简写
#import "@preview/i-figured:0.2.4"
#show math.equation: i-figured.show-equation.with(only-labeled: false) // 只有引用的公式才会显示编号
#show figure: i-figured.show-figure // 图1.x
#import "@preview/mannot:0.3.0": * // 公式突出
#set math.mat(delim: "[")
#import "@preview/equate:0.3.2" // <breakable>  <dot-product>
// For Code
#import "@preview/lovelace:0.3.0": * // 伪代码算法
                                     // 
// For paper
#import "@preview/showybox:2.0.3": showybox // 彩色盒子
// #set text(font:("Times New Roman","Source Han Serif SC"), size: 12pt) // 设置中英语文字体 小四宋体 英语新罗马 
#import "@preview/tablex:0.0.9": * // 表格
                                   // 
                                   // 
// Tools
#import "@preview/dashy-todo:0.1.1": todo
#import "@preview/cetz:0.4.2" // 绘图

#set page(columns: 1)

// = 目录
// #outline(title: none)
// -----------------------------
#set page(columns: 1)
#show: article

#maketitle(
  title: "The Note of  Reinforcement Learning",
  authors: ("Aoxiang","xuyuan"),
  date: "Oct 2025",
)
#set text(font:("New Computer Modern","Source Han Serif SC"), size: 10pt) // 设置中英语文字体 小四宋体 英语新罗马 
#let 行间距转换(正文字体,行间距) = ((行间距)/(正文字体)-0.75)*1em
#set par(leading: 行间距转换(13,23),justify: true,first-line-indent: 2em)
#import "@preview/indenta:0.0.3": fix-indent
#show: fix-indent() // 修复第一段的问题
#show heading: it =>  {it;par()[#let level=(-0.3em,0.2em,0.2em);#for i in (1, 2, 3) {if it.level==i{v(level.at(int(i)-1))}};#text()[#h(0.0em)];#v(-1em);]} // 修复标题下首行 以及微调标题间距
=  Bellman equation
== basic concept
The agent in time $t$ is in state $S_t$ , takes action $A_t$ , receives reward $R_(t+1)$ , the next state is $S_(t+1)$, it can be represented as a state-action-reward trajectory:
#mitex(`
S_t\xrightarrow{A_t}S_{t+1},R_{t+1}\xrightarrow{A_{t+1}}S_{t+2},R_{t+2}\xrightarrow{A_{t+2}}S_{t+3},R_{t+3}\ldots.
`)

and the discounted return can be defined as: 
$ G_t &= R_(t+1)+gamma R_(t+2)+gamma^2 R_(t+3)+... 
\
&=R_(t+1) +gamma(R_((t+1)+1)+gamma R_((t+1)+2)+... )
&=R_(t+1)+gamma G_(t+1)
 $
 where $ gamma in (0,1)$ is the discount rate , and we also anoted the $R_(t+1)$ as imediate reward #footnote([when agent receives reward, the agent is in time $t+1$]).

#v(0.5em)
Cause $R_t,A_t$ is random variable (even for a fixed $pi$, the $A_t$ is also random#footnote([for example,$P(S_a|S_t)=0.5,P(S_b|S_t)=0.5 quad a!=b$])), so is $G_t$ , we can define the value function as the expectation of $G_t$ :

$ mark(v_pi(mark(s, tag: #<1>, color: #black)), tag: #<2>, color: #red) = EE[G_t|S_t=s] =mark(EE[ G_t|s], tag: #<3>, color: #blue) $
 #annot(<1>, dx: 1em ,dy:-2.2em )[$s$ is a typical state]
 #annot(<2>, dx: -0.5em ,dy:0em )[same as $v(pi,s)$]
 #annot(<3>, dx: -0.5em ,dy:0em )[简写为]
#text(fill:rgb(255,0,0))[Notice that when $|s$ occurs in $EE[G_t|s]$ , it equals to $|S_t=s$.  (And $EE[G_(t+1)|S_(t+1)=1] <-> EE[G_(t+1)|s]$ )]
#v(0.2em)

And $v_pi(s)$ is time-independent, it only releates to the state $s$ and policy $pi$ (for diifferent policies, the action space may be different) .
// #v(0.5em)

 $ "when" quad P(S_(a_i)|S_t)=p_i quad \& quad sum p_i=1 quad  "then" quad v_pi (s) = sum p_i G_(a_i) $ <1.4>

 == simply $v_pi(s)$
From the definition of $G_t$ , we have:
$ v_pi(s) = EE[G_t|s] &= EE[(R_(t+1)+gamma G_(t+1))|s]
\ &= EE[R_(t+1)|S_t=s]+gamma EE[G_(t+1)|S_t=s] $

Notice there $EE[G_(t+1)|S_t=s]$ can,t be simplified to $EE[G_(t+1)|s]$ .
#v(0.5em)
When agent in $s$ at time $t$ , it will be lots of prossible $S_(t+1)=s_i$ when take action $a_i$.  
// and we have 
// $ p(s_i|s,pi)=p_i = pi(A_i|s) $

We first consider $EE[R_(t+1)|s]$ : 

$ EE[R_(t+1)|S_(t)=s] 
&=sum_i^n p(a_i|s,pi)  EE[R_(t+1)|S_t=s,A_t=a_i] \
&=sum_i^n pi(a_i|s)  EE[R_(t+1)|S_t=s,A_t=a_i] \ 
&=sum_i^n pi(a_i|s)   sum _j ^ m p \(r_j|s,a_i\) r_j
$

where $n$ is number of possible actions in $cal(A)_s$ , $m$ is possible the number of rewards in $cal(R)_(s,a)$


Then we consider $EE[G_(t+1)|S_t=s]$ 


$ EE[G_(t+1)|S_(t)=s] &=sum_i ^(l)P(s_i|s,pi) EE[G_(t+1)|s_i]=sum_i^l  p(s_i|s,pi) v_pi (s_i) \ & =sum_i^l p(a_i|s,pi) p (s_i|a_i,s) v_pi (s_i) =sum_i^l pi(a_i|s) p (s_i|a_i,s) v_pi (s_i)
$

so finally we have:
$ v_pi(s) = sum_i^n pi(a_i|s) [ sum _j ^ m p \(r_j|s,a_i\) r_j + gamma sum _k ^ l p(s_k|s,a_i) v_pi (s_k) ] $

where $l$ is the number of possible states in $cal(S)_(t+1) $ when $S_t=s$.
#pagebreak()
// == environment
#bibliography(("RL.bib"), title: [
参考文献#v(1em)
],style: "nature")
 