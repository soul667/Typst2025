#import "@preview/cetz:0.3.1": canvas, draw // CeTZ 绘图包
#figure(
  canvas({
    import draw: *
    
    // 设置网格和坐标轴
    set-style(stroke: (thickness: 0.8pt, paint: gray.lighten(30%)))
    
    // 绘制网格
    for i in range(-3, 4) {
      line((i, -3), (i, 3))
      line((-3, i), (3, i))
    }
    
    // 绘制坐标轴
    set-style(stroke: (thickness: 1.5pt, paint: black))
    line((-3, 0), (3, 0)) // x轴
    line((0, -3), (0, 3)) // y轴
    
    // 添加箭头
    line((2.8, 0), (3, 0), mark: (end: ">"))
    line((0, 2.8), (0, 3), mark: (end: ">"))
    
    // 标记坐标轴
    content((3.2, 0), [x], anchor: "east")
    content((0, 3.2), [y], anchor: "south")
    content((0.2, -0.2), [O], anchor: "west")
    
    // 绘制 y = x²
    set-style(stroke: (thickness: 2pt, paint: red))
    let points_y_eq_x2 = ()
    for i in range(-25, 26) {
      let x = i / 10
      let y = x * x
      if y <= 3 {
        points_y_eq_x2.push((x, y))
      }
    }
    line(..points_y_eq_x2)
    
    // 绘制 x = y²（即 y = ±√x）
    set-style(stroke: (thickness: 2pt, paint: blue))
    let points_x_eq_y2_pos = ()
    let points_x_eq_y2_neg = ()
    for i in range(0, 31) {
      let y = i / 10
      let x = y * y
      if x <= 3 {
        points_x_eq_y2_pos.push((x, y))
        if y != 0 {
          points_x_eq_y2_neg.push((x, -y))
        }
      }
    }
    line(..points_x_eq_y2_pos)
    line(..points_x_eq_y2_neg)
    
    // 添加函数标签
    content((1.5, 2.3), text(fill: red)[y = x²], anchor: "center")
    content((2.3, 1.2), text(fill: blue)[x = y²], anchor: "center")
    
    // 标记坐标刻度
    set-style(stroke: (thickness: 1pt, paint: black))
    for i in range(-2, 3) {
      if i != 0 {
        line((i, -0.1), (i, 0.1))
        content((i, -0.3), text(size: 8pt)[#i], anchor: "center")
        line((-0.1, i), (0.1, i))
        content((-0.3, i), text(size: 8pt)[#i], anchor: "center")
      }
    }
  }),
  caption: [函数 y = x² 和 x = y² 的图像],
  supplement: [图]
)