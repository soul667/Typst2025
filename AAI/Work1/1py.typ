#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()

= Code of Problem 1
// #show code: block
// #codex(lang: "python")[#read("1.py")]

#codly(enabled: true,header: [The Code of Problem 1])
```python
from collections import deque
import heapq
from dataclasses import dataclass, field
import logging
from typing import Dict, List, Tuple

@dataclass
class Edge:
    node1: int
    node2: int
    weight: int = 1

# 1-1
@dataclass
class Graph:
    nodes: List[int] = field(default_factory=list)
    edges: List[Edge] | List[tuple] = field(default_factory=list)
    adjacency_list: Dict[int, List[Edge]] = field(default_factory=dict) # 这里还用Edge存吧，node1是自己 node2是邻居 weight是权重
    path_list: List[int] = field(default_factory=list)
    weight_map: Dict[tuple, int] = field(default_factory=dict)
    def __post_init__(self):
        try:
            self.nodes = list(self.nodes)
        except Exception:
            self.nodes = [self.nodes]

        # edges 应为 Edge 对象列表
        # 如果传入的是数组或 tuples，尽量适配到 Edge
        normalized_edges: List[Edge] = []
        for e in self.edges:
            if isinstance(e, Edge):
                normalized_edges.append(e)
            else:
                # 支持传入 (n1, n2) 或 (n1, n2, w)
                try:
                    n1, n2, *rest = e
                    w = rest[0] if rest else 1
                    normalized_edges.append(Edge(int(n1), int(n2), int(w)))
                except Exception:
                    # 跳过无法解析的项
                    logging.warning(f"Skipping invalid edge entry: {e}")
        self.edges = normalized_edges

        # 根据边去每一个节点的邻接点  便于搜索
        self.adjacency_list = {int(node): [] for node in self.nodes}
        for edge in self.edges:
            edge1 = Edge(int(edge.node1), int(edge.node2), int(edge.weight))
            edge2 = Edge(int(edge.node2), int(edge.node1), int(edge.weight))
            self.adjacency_list.setdefault(edge.node1, []).append(edge1)
            self.adjacency_list.setdefault(edge.node2, []).append(edge2)
        
        # 对邻接表进行排序（按照从小到大排序）
        for node in self.adjacency_list:
            self.adjacency_list[node] = sorted(self.adjacency_list[node], key=lambda x: x.node2)

        # 构建 weight_map
        for edge in self.edges:
            self.weight_map[(edge.node1, edge.node2)] = edge.weight
            self.weight_map[(edge.node2, edge.node1)] = edge.weight
    def get_edge_weight(self, node1: int, node2: int) -> int:
        """获取两个节点之间的权重"""
        return self.weight_map.get((node1, node2), -1)
    def get_cost(self, path_list: List[int]|None) -> int:
        """计算路径的权重和"""
        if path_list is None:
            path_list = self.path_list
        cost = 0
        for i in range(len(path_list) - 1):
            cost_ = self.get_edge_weight(path_list[i], path_list[i + 1])
            if cost_ == -1:
                raise ValueError(f"Invalid path: {path_list}  node1: {path_list[i]} node2: {path_list[i + 1]}")
            cost += cost_
        return cost
    

@dataclass
class Algorithm_1Base:
    graph: Graph = field(default_factory=Graph)
    start_node: int = ord('E')
    goal_node: int = ord('D')
    order: List[int] = field(default_factory=list)
    algorithm: str = "BASE"
    path_list: List[int] = field(default_factory=list)
    cost: int = -1
    
    def _initialize_traverse(self, start: int | None, goal: int | None) -> Tuple[int, int]:
        """初始化遍历的通用逻辑"""
        if start is None:
            start = self.start_node
        if goal is None:
            goal = self.goal_node
        
        self.order = []
        self.path_list = []
        self.cost = -1
        
        return start, goal
    
    def _reconstruct_path(self, parents: Dict[int, int | None], goal: int, visited: set) -> List[int]:
        """从parents字典重构路径"""
        path: List[int] = []
        if goal in visited:
            current = goal
            while current is not None:
                path.append(current)
                current = parents.get(current)
            path.reverse()
        return path
    
    def _finalize_traverse(self, path: List[int]) -> Tuple[List[int], List[int], int]:
        """完成遍历的通用逻辑"""
        self.graph.path_list = path
        self.path_list = path
        self.cost = self.graph.get_cost(path) if path else -1
        self.output()
        return self.order, path, self.cost
    
    def output(self):
        """输出结果"""
        print(f"{self.algorithm} 结果")
        print("- 访问顺序:", " -> ".join(chr(n) for n in self.order))
        print("- 最终路径:", " -> ".join(chr(n) for n in self.path_list))
        print("- 总成本:", self.cost)
    
    def traverse(self, start: int | None = None, goal: int | None = None) -> Tuple[List[int], List[int], int]:
        """子类需要实现此方法"""
        raise NotImplementedError("Subclass must implement traverse method")

@dataclass
class Bfs(Algorithm_1Base):
    algorithm: str = "BFS"
    
    def traverse(self, start: int | None = None, goal: int | None = None) -> Tuple[List[int], List[int], int]:
        """BFS that tracks visit order, final path, and total cost."""
        start, goal = self._initialize_traverse(start, goal)

        visited = set()
        parents: Dict[int, int | None] = {start: None}
        queue = deque([start])

        while queue:
            node = queue.popleft()
            if node in visited:
                continue

            visited.add(node)
            self.order.append(node)
            
            if node == goal:
                logging.info(f"BFS reached goal node: {goal}")
                break

            for edge in self.graph.adjacency_list.get(node, []):
                neighbour = edge.node2
                if neighbour not in visited and neighbour not in parents:
                    parents[neighbour] = node
                    queue.append(neighbour)

        path = self._reconstruct_path(parents, goal, visited)
        return self._finalize_traverse(path)

@dataclass
class Dfs(Algorithm_1Base):
    algorithm: str = "DFS"
    
    def traverse(self, start: int | None = None, goal: int | None = None) -> Tuple[List[int], List[int], int]:
        """DFS that tracks visit order, final path, and total cost."""
        start, goal = self._initialize_traverse(start, goal)

        visited = set()
        parents: Dict[int, int | None] = {start: None}
        stack = [start]

        while stack:
            node = stack.pop()
            if node in visited:
                continue

            visited.add(node)
            self.order.append(node)
            
            if node == goal:
                logging.info(f"DFS reached goal node: {goal}")
                break

            neighbours = self.graph.adjacency_list.get(node, [])
            for edge in reversed(neighbours):
                neighbour = edge.node2
                if neighbour not in visited and neighbour not in parents:
                    parents[neighbour] = node
                    stack.append(neighbour)

        path = self._reconstruct_path(parents, goal, visited)
        return self._finalize_traverse(path)


@dataclass
class Ucs(Algorithm_1Base):
    algorithm: str = "UCS"

    def traverse(self, start: int | None = None, goal: int | None = None) -> Tuple[List[int], List[int], int]:
        """Uniform-Cost Search that tracks visit order, final path, and total cost."""
        start, goal = self._initialize_traverse(start, goal)

        parents: Dict[int, int | None] = {start: None}
        best_cost: Dict[int, int] = {start: 0}
        heap: List[Tuple[int, int]] = [(0, start)]
        visited = set()

        while heap:
            cost_so_far, node = heapq.heappop(heap)
            if node in visited:
                continue

            visited.add(node)
            self.order.append(node)

            if node == goal:
                logging.info(f"UCS reached goal node: {goal}")
                break

            for edge in self.graph.adjacency_list.get(node, []):
                neighbour = edge.node2
                new_cost = cost_so_far + edge.weight
                if neighbour not in best_cost or new_cost < best_cost[neighbour]:
                    best_cost[neighbour] = new_cost
                    parents[neighbour] = node
                    heapq.heappush(heap, (new_cost, neighbour))

        path = self._reconstruct_path(parents, goal, visited)
        return self._finalize_traverse(path)


@dataclass
class Gbfs(Algorithm_1Base):
    algorithm: str = "GBFS"
    heuristic: Dict[int, int] = field(default_factory=dict)

    def __post_init__(self):
        """初始化启发式函数，如果没有提供则使用默认值"""
        if not self.heuristic:
            # 默认启发式值（到目标节点D的估计距离）
            # 这些值是假设的，实际应用中应该根据问题特性设定
            self.heuristic = {
                ord('A'): 5,  # E到D的估计距离
                ord('B'): 10,
                ord('C'): 9,
                ord('E'): 15,
                ord('F'): 7,
                ord('H'): 4,
                ord('I'): 7,
                ord('D'): 0   # 目标节点
            }

    def get_heuristic(self, node: int) -> int:
        """获取节点的启发式值"""
        return self.heuristic.get(node, 0)

    def traverse(self, start: int | None = None, goal: int | None = None) -> Tuple[List[int], List[int], int]:
        """Greedy Best-First Search that tracks visit order, final path, and total cost."""
        start, goal = self._initialize_traverse(start, goal)

        parents: Dict[int, int | None] = {start: None}
        heap: List[Tuple[int, int]] = [(self.get_heuristic(start), start)]
        visited = set()

        while heap:
            h_value, node = heapq.heappop(heap)
            
            if node in visited:
                continue

            visited.add(node)
            self.order.append(node)

            if node == goal:
                logging.info(f"GBFS reached goal node: {goal}")
                break

            for edge in self.graph.adjacency_list.get(node, []):
                neighbour = edge.node2
                if neighbour not in visited and neighbour not in parents:
                    parents[neighbour] = node
                    heapq.heappush(heap, (self.get_heuristic(neighbour), neighbour))

        path = self._reconstruct_path(parents, goal, visited)
        return self._finalize_traverse(path)


@dataclass
class Fileprocessor:
    problem_1_input_file: str = "./work1/problem_1_input.txt"

    def read_input_1(self) -> Graph:
        with open(self.problem_1_input_file, "r") as f:
            lines = f.readlines()
        nodes = set()
        edges = []
        for line in lines:
            parts = line.strip().split(" ")
            
            n1_str, n2_str, w_str = parts
            n1 = ord(n1_str)
            n2 = ord(n2_str)
            w = int(w_str)
            
            edges.append((n1, n2, w))
            nodes.update([n1, n2])

        return Graph(nodes=list(nodes), edges=edges)
#  ord  是acsii码  chr  是ascii码对应的字符
def main():
    # small smoke test
    file_use = Fileprocessor()
    g = file_use.read_input_1() # 读取第一题地图
    bfs = Bfs(graph=g)
    bfs.traverse()
    dfs = Dfs(graph=g)
    dfs.traverse()
    ucs = Ucs(graph=g)
    ucs.traverse()
    gbfs = Gbfs(graph=g)
    gbfs.traverse()
    # print("BFS order:", bfs.traverse())
    # print("BFS order:", bfs.traverse(1))
if __name__ == "__main__":
    # print("This is the main module of work1.")
    main()    
```