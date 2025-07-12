// 可直接插入你的typst文档中
#import "@preview/cetz:0.3.1": canvas, draw // CeTZ 绘图包

#figure(
  canvas({
    import draw: *

    // 坐标轴与网格
    set-style(stroke: (thickness: 0.5pt, paint: gray.lighten(40%)))
    for i in range(-3, 4) {
      line((i, -2), (i, 4))
      line((-3, i), (3, i))
    }
    set-style(stroke: (thickness: 1pt, paint: black))
    line((-3, 0), (3, 0)) // x轴
    line((0, -2), (0, 4)) // y轴
    line((2.8, 0), (3, 0), mark: (end: ">"))
    line((0, 3.8), (0, 4), mark: (end: ">"))
    content((3.2, 0), [x], anchor: "east")
    content((0, 4.2), [y], anchor: "south")
    content((0.2, -0.2), [O], anchor: "west")

    // 绘制 f(x)=x^2, x<0
    set-style(stroke: (thickness: 1pt, paint: blue))
    let left = ()
    for i in range(-30, 1) {
      let x = i / 10
      let y = x * x
      if y <= 4 { left.push((x, y)) }
    }
    line(..left)

    // 绘制 f(x)=x+1, x>=0
    set-style(stroke: (thickness: 1pt, paint: red))
    let right = ()
    for i in range(0, 31) {
      let x = i / 10
      let y = x + 1
      if y <= 4 { right.push((x, y)) }
    }
    line(..right)

    // 端点标记
    set-style(stroke: (thickness: 0.8pt, paint: black), fill: white)
    circle((0, 0), radius: 0.08) // 空心点
    set-style(stroke: none, fill: red)
    circle((0, 1), radius: 0.08) // 实心点

    // 标签
    content((-2.2, 3.5), text(size: 10pt, fill: blue)[$y=x^2$], anchor: "center")
    content((2.2, 2.7), text(size: 10pt, fill: red)[$y=x+1$], anchor: "center")
  }),
  caption: [分段函数的图像],
  supplement: [图]
)
