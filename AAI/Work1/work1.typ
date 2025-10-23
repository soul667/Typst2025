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
  title: "AAI work1",
  authors: ("Aoxiang Gu",),
  date: "2025 10.22",
)
#set text(font:("New Computer Modern","Source Han Serif SC"), size: 10pt) // 设置中英语文字体 小四宋体 英语新罗马 
#let 行间距转换(正文字体,行间距) = ((行间距)/(正文字体)-0.75)*1em
#set par(leading: 行间距转换(12,20),justify: true,first-line-indent: 2em)
#import "@preview/indenta:0.0.3": fix-indent
#show: fix-indent() // 修复第一段的问题
#show heading: it =>  {it;par()[#let level=(-0.3em,0.2em,0.2em);#for i in (1, 2, 3) {if it.level==i{v(level.at(int(i)-1))}};#text()[#h(0.0em)];#v(-1em);]} // 修复标题下首行 以及微调标题间距

= 第一题

- BFS 结果
  - 访问顺序: E -> B -> C -> A -> I -> F -> H -> D
  - 最终路径: E -> C -> F -> D
  - 总成本: 16
- DFS 结果
  - 访问顺序: E -> B -> A -> H -> D
  - 最终路径: E -> B -> A -> H -> D
  - 总成本: 22
- UCS 结果
  - 访问顺序: E -> C -> F -> B -> A -> H -> I -> D
  - 最终路径: E -> C -> H -> D
  - 总成本: 15
- GBFS 结果
  - 访问顺序: E -> C -> H -> D
  - 最终路径: E -> C -> H -> D
  - 总成本: 15
#v(1em)
上述是代码运行的访问顺序，最终路径以及总成本。
#text(fill: blue)[具体计算过程见附录中第一题代码。]

下面我们手工验算一下并给出过程。
== Map 
```txt 
E B 10
E C 4
B I 9
B A 5
A I 2
A H 3
A C 7
C H 7
C F 5
H D 4
H F 3
F D 7
```
== bfs 手工验算

BFS（广度优先搜索）从起始节点E开始，逐层扩展，每次扩展时按照ASCII码顺序加入相邻节点。

#v(0.5em)

#h(-2em)*初始状态：*
- 队列 Queue: $[E]$
- 已访问 Visited: ${E}$
- 父节点记录 Parent: ${E: "null"}$

#v(0.5em)

*步骤1：* 扩展节点 E
- 从队列中取出 E
- E 的邻居: B(10), C(4)
- 按ASCII码排序: B < C
- 将未访问的邻居加入队列: B, C
- Queue: $[B, C]$
- Visited: ${E, B, C}$
- Parent: ${E: "null", B: E, C: E}$

#v(0.5em)

*步骤2：* 扩展节点 B
- 从队列中取出 B
- B 的邻居: E(10), I(9), A(5)
- E 已访问，跳过
- 按ASCII码排序未访问的: A < I
- 将 A, I 加入队列
- Queue: $[C, A, I]$
- Visited: ${E, B, C, A, I}$
- Parent: ${E: "null", B: E, C: E, A: B, I: B}$

#v(0.5em)

*步骤3：* 扩展节点 C
- 从队列中取出 C
- C 的邻居: E(4), A(7), H(7), F(5)
- E, A 已访问，跳过
- 按ASCII码排序未访问的: F < H
- 将 F, H 加入队列
- Queue: $[A, I, F, H]$
- Visited: ${E, B, C, A, I, F, H}$
- Parent: ${E: "null", B: E, C: E, A: B, I: B, F: C, H: C}$

#v(0.5em)

*步骤4：* 扩展节点 A
- 从队列中取出 A
- A 的邻居: B(5), I(2), H(3), C(7)
- 所有邻居都已访问，跳过
- Queue: $[I, F, H]$

#v(0.5em)

*步骤5：* 扩展节点 I
- 从队列中取出 I
- I 的邻居: B(9), A(2)
- 所有邻居都已访问，跳过
- Queue: $[F, H]$

#v(0.5em)

*步骤6：* 扩展节点 F
- 从队列中取出 F
- F 的邻居: C(5), H(3), D(7)
- C, H 已访问，D 未访问
- 将 D 加入队列
- Queue: $[H, D]$
- Visited: ${E, B, C, A, I, F, H, D}$
- Parent: ${E: "null", B: E, C: E, A: B, I: B, F: C, H: C, D: F}$

#v(0.5em)

*步骤7：* 找到目标节点 D
- D 已加入队列，BFS 找到目标
- *访问顺序:* E → B → C → A → I → F → H → D

#v(0.5em)

*路径回溯：*
- 从 D 开始，沿着 Parent 链回溯到 E
- D ← F ← C ← E
- *最终路径:* E → C → F → D
- *总成本:* $4 + 5 + 7 = 16$

#v(1em)

== dfs 手工验算

DFS（深度优先搜索）从起始节点E开始，沿着一条路径尽可能深地探索，遇到死路或目标节点后回溯。

#v(0.5em)

*关键机制说明：*
- 邻接表已按ASCII码从小到大排序：A < B < C < ...
- 代码使用 `reversed()` 反转邻居列表后再入栈
- 由于栈的LIFO特性（后进先出），反转后使得ASCII码小的节点先被访问
- 例如：邻居为 $[B, C]$ → 反转为 $[C, B]$ → C先入栈，B后入栈 → B先出栈被访问

#v(0.5em)

#h(-2em)*初始状态：*
- 栈 Stack: $[E]$
- 已访问 Visited: ${}$
- 父节点记录 Parent: ${E: "null"}$

#v(0.5em)

*步骤1：* 弹出并访问节点 E
- 从栈中弹出 E
- 标记 E 为已访问
- E 的邻居（已排序）: $[B, C]$
- 反转后: $[C, B]$
- *依次入栈*：先push C，再push B
- Stack: $[C, B]$（B在栈顶）
- Visited: ${E}$
- Parent: ${E: "null", B: E, C: E}$
- 访问顺序: $[E]$

#v(0.5em)

*步骤2：* 弹出并访问节点 B（栈顶）
- 从栈中弹出 B
- 标记 B 为已访问
- B 的邻居（已排序）: $[A,E, I]$
- 过滤后未访问的: $[A, I]$（E已访问）
- 反转后: $[I, A]$
- *依次入栈*：先push I，再push A
- Stack: $[C, I, A]$（A在栈顶）
- Visited: ${E, B}$
- Parent: ${E: "null", B: E, C: E, A: B, I: B}$
- 访问顺序: $[E, B]$

#v(0.5em)

*步骤3：* 弹出并访问节点 A（栈顶）
- 从栈中弹出 A
- 标记 A 为已访问
- A 的邻居（已排序）: $[B, C, H, I]$
- 过滤后未访问的: $[C, H]$（B已访问，I已在parents中不再添加）
- 反转后: $[H, C]$
- *依次入栈*：先push H，再push C（但C已在parents中，跳过）
- Stack: $[C, I, H]$（H在栈顶）
- Visited: ${E, B, A}$
- Parent: ${..., H: A}$
- 访问顺序: $[E, B, A]$

#v(0.5em)

*步骤4：* 弹出并访问节点 H（栈顶）
- 从栈中弹出 H
- 标记 H 为已访问
- H 的邻居（已排序）: $[A, C, D, F]$
- 过滤后未访问的: $[C, D, F]$（A已访问）
- C已在parents中，实际可入栈: $[D, F]$
- 反转后: $[F, D]$
- *依次入栈*：先push F，再push D
- Stack: $[C, I, F, D]$（D在栈顶）
- Visited: ${E, B, A, H}$
- Parent: ${..., D: H, F: H}$
- 访问顺序: $[E, B, A, H]$

#v(0.5em)

*步骤5：* 弹出并访问节点 D
- *找到目标！*
- 访问顺序: $[E, B, A, H, D]$

#v(0.5em)

*路径回溯：*
- 从 D 开始，沿着 Parent 链回溯到 E
- D ← H ← A ← B ← E
- *最终路径:* E → B → A → H → D
- *总成本:* $10 + 5 + 3 + 4 = 22$

#v(0.5em)


== ucs 手工验算

UCS（一致代价搜索）使用优先队列（最小堆），每次选择从起点到当前节点累积代价最小的节点进行扩展。

#v(0.5em)


#h(-2em)*关键机制：*
- 使用优先队列（最小堆），按照从起点到当前节点的累积代价排序
- 每次弹出代价最小的节点进行扩展
- 如果找到更短的路径，更新节点的最佳代价
- 保证找到的第一条路径就是代价最小的路径

#v(0.5em)

*初始状态：*
- 优先队列 Heap: $[(0, E)]$（格式：(累积代价, 节点)）
- 已访问 Visited: ${}$
- 最佳代价 Best_cost: ${E: 0}$
- 父节点记录 Parent: ${E: "null"}$

#v(0.5em)

*步骤1：* 弹出 (0, E)
- 当前节点: E，累积代价: 0
- 标记 E 为已访问
- E 的邻居: B(10), C(4)
- 计算新代价并加入堆：
  - B: $0 + 10 = 10$
  - C: $0 + 4 = 4$
- Heap: $[(4, C), (10, B)]$
- Best_cost: ${E: 0, B: 10, C: 4}$
- Parent: ${E: "null", B: E, C: E}$
- 访问顺序: $[E]$

#v(0.5em)

*步骤2：* 弹出 (4, C)
- 当前节点: C，累积代价: 4
- 标记 C 为已访问
- C 的邻居: E(4), A(7), H(7), F(5)
- E 已访问，跳过
- 计算新代价：
  - A: $4 + 7 = 11$（但B到A是10+5=15，所以这里11更优）
  - H: $4 + 7 = 11$
  - F: $4 + 5 = 9$
- Heap: $[(9, F), (10, B), (11, A), (11, H)]$
- Best_cost: ${..., A: 11, H: 11, F: 9}$
- Parent: ${..., A: C, H: C, F: C}$
- 访问顺序: $[E, C]$

#v(0.5em)

*步骤3：* 弹出 (9, F)
- 当前节点: F，累积代价: 9
- 标记 F 为已访问
- F 的邻居: C(5), H(3), D(7)
- C 已访问，跳过
- 计算新代价：
  - H: $9 + 3 = 12$（但已有11，不更新）
  - D: $9 + 7 = 16$
- Heap: $[(10, B), (11, A), (11, H), (16, D)]$
- Best_cost: ${..., D: 16}$
- Parent: ${..., D: F}$
- 访问顺序: $[E, C, F]$

#v(0.5em)

*步骤4：* 弹出 (10, B)
- 当前节点: B，累积代价: 10
- 标记 B 为已访问
- B 的邻居: E(10), A(5), I(9)
- E 已访问，跳过
- 计算新代价：
  - A: $10 + 5 = 15$（已有11更优，不更新）
  - I: $10 + 9 = 19$
- Heap: $[(11, A), (11, H), (16, D), (19, I)]$
- Best_cost: ${..., I: 19}$
- Parent: ${..., I: B}$
- 访问顺序: $[E, C, F, B]$

#v(0.5em)

*步骤5：* 弹出 (11, A)
- 当前节点: A，累积代价: 11
- 标记 A 为已访问
- A 的邻居: B(5), I(2), H(3), C(7)
- B, C 已访问，跳过
- 计算新代价：
  - I: $11 + 2 = 13$（比19更优，更新）
  - H: $11 + 3 = 14$（比11差，不更新）
- 需要将 (13, I) 加入堆
- Heap: $[(11, H), (13, I), (16, D), (19, I)]$
- Best_cost: ${..., I: 13}$（更新）
- Parent: ${..., I: A}$（更新）
- 访问顺序: $[E, C, F, B, A]$

#v(0.5em)

*步骤6：* 弹出 (11, H)
- 当前节点: H，累积代价: 11
- 标记 H 为已访问
- H 的邻居: A(3), C(7), F(3), D(4)
- A, C, F 已访问，跳过
- 计算新代价：
  - D: $11 + 4 = 15$（比16更优，更新）
- 将 (15, D) 加入堆
- Heap: $[(13, I), (15, D), (16, D), (19, I)]$
- Best_cost: ${..., D: 15}$（更新）
- Parent: ${..., D: H}$（更新）
- 访问顺序: $[E, C, F, B, A, H]$

#v(0.5em)

*步骤7：* 弹出 (13, I)
- 当前节点: I，累积代价: 13
- 标记 I 为已访问
- I 的邻居: B(9), A(2)
- 都已访问，跳过
- 访问顺序: $[E, C, F, B, A, H, I]$

#v(0.5em)

*步骤8：* 弹出 (15, D)
- 当前节点: D，累积代价: 15
- *找到目标节点！*
- 访问顺序: $[E, C, F, B, A, H, I, D]$

#v(0.5em)

*路径回溯：*
- 从 D 开始，沿着 Parent 链回溯到 E
- D ← H ← C ← E
- *最终路径:* E → C → H → D
- *总成本:* $4 + 7 + 4 = 15$

#v(1em)

== gbfs 手工验算

GBFS（贪婪最佳优先搜索）使用启发式函数，每次选择启发式值最小（最接近目标）的节点进行扩展。

#v(0.5em)

#h(-2em)提问*启发式函数（到目标D的估计距离）：*
- h(A) = 5, h(B) = 10, h(C) = 9, h(D) = 0
- h(E) = 15, h(F) = 7, h(H) = 4, h(I) = 7

#v(0.5em)

*关键机制：*
- 使用优先队列（最小堆），按照启发式值h(n)排序
- 每次弹出h值最小的节点（贪心策略）
- 不考虑已走过的路径代价，只看"距离目标还有多远"
- 不保证找到最优路径，但速度快

#v(0.5em)

*初始状态：*
- 优先队列 Heap: $[(15, E)]$（格式：(启发式值, 节点)）
- 已访问 Visited: ${}$
- 父节点记录 Parent: ${E: "null"}$

#v(0.5em)

*步骤1：* 弹出 (15, E)
- 当前节点: E，h(E) = 15
- 标记 E 为已访问
- E 的邻居: B(10), C(4)
- 按启发式值加入堆：
  - B: h(B) = 10
  - C: h(C) = 9
- Heap: $[(9, C), (10, B)]$
- Parent: ${E: "null", B: E, C: E}$
- 访问顺序: $[E]$

#v(0.5em)

*步骤2：* 弹出 (9, C)
- 当前节点: C，h(C) = 9
- 标记 C 为已访问
- C 的邻居: E(4), A(7), H(7), F(5)
- E 已访问，跳过
- 按启发式值加入堆：
  - A: h(A) = 5
  - H: h(H) = 4
  - F: h(F) = 7
- Heap: $[(4, H), (5, A), (7, F), (10, B)]$
- Parent: ${..., A: C, H: C, F: C}$
- 访问顺序: $[E, C]$

#v(0.5em)

*步骤3：* 弹出 (4, H)
- 当前节点: H，h(H) = 4
- 标记 H 为已访问
- H 的邻居: A(3), C(7), F(3), D(4)
- C 已访问，跳过；A、F 已在parents中，跳过
- 加入 D：h(D) = 0
- Heap: $[(0, D), (5, A), (7, F), (10, B)]$
- Parent: ${..., D: H}$
- 访问顺序: $[E, C, H]$

#v(0.5em)

*步骤4：* 弹出 (0, D)
- 当前节点: D，h(D) = 0
- *找到目标节点！*
- 访问顺序: $[E, C, H, D]$

#v(0.5em)

*路径回溯：*
- 从 D 开始，沿着 Parent 链回溯到 E
- D ← H ← C ← E
- *最终路径:* E → C → H → D
- *总成本:* $4 + 7 + 4 = 15$

#v(0.5em)

*GBFS特点：*
- 仅访问4个节点就找到目标（最少）
- 贪心地选择"看起来最接近目标"的节点
- 本例中恰好找到了最优路径（代价15），但这并非总是如此
- 效率高但不保证最优性

#v(1em)
= 2
== Please calculate the costs of the two paths ABCDEFGHIJKLMN andAHCDKLJNIFBGEM (rounded to three decimal places). (10 marks)
```shell 
Path ABCDEFGHIJKLMN cost: 75.167
Path AHCDKLJNIFBGEM cost: 73.824
```
#v(1em)
具体计算过程见附录中第二题代码。
== Please use the ordinal representation to present the following two paths,AHCDKLJNIFBGEM and AHIECDNMFKLJBG, where the canonic tour isALJBICDHMFKNEG. (10 marks)


```shell
Oridinal path for indices AHCDKLJNIFBGEM : 0 7 5 6 10 1 2 11 4 9 3 13 12 8
Oridinal path for indices AHIECDNMFKLJBG : 0 7 4 12 5 6 11 8 9 10 1 2 3 13
```

#v(1em)
具体计算过程见附录中第二题代码。

== fitness function design and compute fitness values
设计适应度函数为总路径长度$l$的倒数，即
$ "fitness" =1/(l)  $
这可以保证更短的路径其适应度值更大，有利于遗传算法的选择操作。使用代码计算两个路径的适应度值，结果如下
#h(0.5em)

```shell
Fitness for path ABCDEFGHIJKLMN: 0.013303710404831907
Fitness for path AHCDKLJNIFBGEM: 0.013545730385782401
``` 
具体计算过程见附录中第二题代码。

== 交叉算子和变异算子设计

=== 交叉算子

部分映射交叉（PMX）通过片段交换和映射机制实现父代基因重组，映射表用于消解交换片段引入的基因冲突。
#v(0.5em)
#pseudocode-list(booktabs: true, numbered-title: [交叉算子])[
  + *输入:* Parent1, Parent2（长度为 $N$ 的排列）；*输出:* Offspring1, Offspring2
  + 随机选择交叉点 $"pos1", "pos2"$，满足 $1 lt.eq "pos1" < "pos2" lt.eq N$
  + *for* $i = "pos1"$ to $"pos2"$ *do*
    + Offspring1[$i$] $arrow.l$ Parent1[$i$]；Offspring2[$i$] $arrow.l$ Parent2[$i$]
  + *end*
  + 建立映射表 $M$：*for* $i = "pos1"$ to $"pos2"$ *do*
    + $M["Parent1"[i]] arrow.l "Parent2"[i]$；$M["Parent2"[i]] arrow.l "Parent1"[i]$
  + *end*
  + *for* $i = 1$ to $N$ *do*（填充Offspring1的非交叉区域）
    + *if* $i < "pos1"$ or $i > "pos2"$ *then*
      + $"candidate" arrow.l "Parent2"[i]$
      + *while* candidate 已存在于 Offspring1 中 *do*
        + $"candidate" arrow.l M["candidate"]$
      + *end*
      + Offspring1[$i$] $arrow.l$ candidate
    + *end*
  + *end*
  + 用相同方法填充 Offspring2（从Parent1获取候选基因并使用映射表 $M$ 解决冲突）
  + *返回* Offspring1, Offspring2
]


以 Parent1 = $"AHCDKLJNIFBGEM"$ 和 Parent2 = $"KLJNIFBGEMAHCD"$ 为例，设交叉点为位置5至10。交换片段后得到 Offspring1 = $[#h(0.4em)][#h(0.4em)][#h(0.4em) ][#h(0.4em)]"KLJNIF"[#h(0.4em)][#h(0.4em)][#h(0.4em) ][#h(0.4em)]$，Offspring2 = $[#h(0.4em)][#h(0.4em)][#h(0.4em) ][#h(0.4em)]"IFBGEM"[#h(0.4em)][#h(0.4em)][#h(0.4em) ][#h(0.4em)]$。交叉片段对应位置建立双向映射：K↔I, L↔F, J↔B, N↔G, I↔E, F↔M。

#v(1em)

填充非交叉区域时，从另一父代获取候选基因，若冲突则沿映射链查找。对Offspring1而言：位置1从Parent2[1]=K开始，经K→I→E得E；位置2经L→F→M得M；位置3经J→B得B；位置4经N→G得G；位置11-14的A、H、C、D无冲突直接填入。最终 Offspring1 = $"EMBGKLJNIFAHCD"$，对称地 Offspring2 = $"AHCDIFBGEMKLJN"$。映射机制保证每个基因恰好出现一次。

=== 变异算子

使用倒置变异通过反转随机选定的基因片段引入多样性，操作仅改变片段内顺序而不改变基因集合。

#v(0.5em)
#pseudocode-list(booktabs: true, numbered-title: [变异算子])[
  + *输入:* Parent（长度为 $N$ 的排列），变异概率 $p_m$；*输出:* Offspring
  + 以概率 $p_m$ 决定是否执行变异
  + *if* 执行变异 *then*
    + 随机选择变异点 $"pos1", "pos2"$，满足 $1 lt.eq "pos1" < "pos2" lt.eq N$
    + Offspring $arrow.l$ Parent
    + *for* $i = 0$ to $floor(("pos2" - "pos1") / 2)$ *do*
      + swap Offspring[$"pos1" + i$] and Offspring[$"pos2" - i$]
    + *end*
  + *else*
    + Offspring $arrow.l$ Parent（保持不变）
  + *end*
  + *返回* Offspring
]

#v(1em)

以 Parent = $"AHCDKLJNIFBGEM"$ 为例，设变异点为位置4至11，对应片段 $"DKLJNIFB"$。反转后片段变为 $"BFINJLKD"$（D↔B, K↔F, L↔I, J↔N），变异后基因为 Offspring = $"AHCBFINJLKDGEM"$。反转操作为就地重排，片段外基因保持不变，保证每个基因恰好出现一次。

== 选择算法

这里选用锦标赛法，锦标赛法选择通过在随机抽取的个体子集中选择最优个体作为父代，锦标赛规模 $k$ 直接调控选择压力与种群多样性的平衡。

#v(0.5em)
#pseudocode-list(booktabs: true, numbered-title: [选择算法])[
  + *输入:* Population（种群），$k$（锦标赛规模），$n$（需选择的父代数）；*输出:* Parents
  + 初始化 Parents $arrow.l$ 空集
  + *for* $i = 1$ to $n$ *do*
    + 从 Population 中随机无放回抽取 $k$ 个体构成锦标赛池 $T$
    + *for each* individual in $T$ *do*
      + 计算 fitness(individual)
    + *end*
    + $"best" arrow.l arg max_("individual" in T) "fitness"("individual")$
    + Parents $arrow.l$ Parents $union$ {best}
  + *end*
  + *返回* Parents
]

#v(1em)

锦标赛规模 $k$ 对选择压力的影响具有单调性。当 $k=2$ 时，锦标赛池仅含两个体，适应度中等的个体有约50%概率战胜另一个体被选中，选择压力较低，有利于维持多样性但收敛较慢。当 $k$ 增大（如 $k=7$）时，锦标赛池中出现高适应度个体的概率提高，低适应度个体难以胜出，选择压力增强，加速收敛但易导致早熟。

// 形式化地，个体 $i$ 被选中的概率为 $ P_i = sum_(S subset.eq P, |S|=k, i in S) P(S) dot.c I(f_i = max_(j in S) f_j) $，其中 $f_i$ 为适应度，该概率随 $k$ 增大而对适应度差异更敏感。

#v(1em)

锦标赛选择通过随机性维持种群多样性。与轮盘赌选择（选择概率正比于适应度）不同，锦标赛选择的非确定性使得任何个体在其参与的锦标赛中都有获胜可能，即使全局最优个体也并非总被选中。适中的 $k$ 值允许次优个体携带的基因特征得以保留，这些特征经交叉和变异可能产生突破性解。此外，选择操作的独立重复性保证了种群中不同区域的基因均有机会参与繁殖，避免种群快速坍缩至局部最优附近，为算法的全局搜索能力提供保障。

// #let appendix-counter = counter("appendix", "1")

/// altered version of https://github.com/typst/templates/blob/main/charged-ieee/lib.typ
/// DOES NOT WORK WITH DEEPER LEVELS
#let appendix(body) = {
  set heading(numbering: "A.1", supplement: [Appendix])
  counter(heading).update(0)
  show heading: it => {
    set text(11pt, weight: 400)
    set align(center)
    show: block.with(above: 15pt, below: 13.75pt, sticky: true)
    show: smallcaps
    [#it.supplement #counter(heading).display():]
    h(0.3em)
    it.body
  }
  body
}

#show: appendix

#include "1py.typ"
#include "2py.typ"
