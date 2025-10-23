#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()

= Code of Problem 2
// #show code: block
// #codex(lang: "python")[#read("1.py")]

#codly(enabled: true,header: [The Code of Problem 2])
```python
from collections import deque
import heapq
from dataclasses import dataclass, field
import logging
from typing import Dict, List, Tuple
import math

@dataclass
class Node:
    x: int
    y: int
    name: int | str = 0
    def __post_init__(self):
        if isinstance(self.name, str):
            self.name = ord(self.name)
    def distance(self, node2):
            """计算此节点到另一个节点之间的欧氏距离"""
            return math.sqrt((node2.x - self.x) ** 2 + (node2.y - self.y) ** 2)

@dataclass
class OridinalTools: # 用序数法表示节点
    base: str = "ALJBICDHMFKNEG"  # 默认编号used to map indices to names
    def get_index(self, name: str|int) -> int:
        """根据节点名称获取其序数索引"""
        if isinstance(name, int):
            name = chr(name)
        return self.base.index(name)

    def get_oridinal_path(self, path: List[int]|str) -> str:
        """根据序数索引获取节点名称"""
        if isinstance(path, str):
            path = [self.get_index(c) for c in path]
        return ''.join(str(i)+" " for i in path)
            
# 1-1
@dataclass
class Graph:
    nodes: List[Node] = field(default_factory=list)
    oridinal_tools: OridinalTools = field(default_factory=OridinalTools)
    # oridinal_nodes: List[int] = field(default_factory=list)
    def __post_init__(self):
        self.oridinal_tools = OridinalTools()
        pass
    
    def distance(self, node1, node2):
            """计算两个节点之间的欧氏距离"""
            return math.sqrt((node2.x - node1.x) ** 2 + (node2.y - node1.y) ** 2)
    # 默认print函数
    def __repr__(self):
        return f"Graph(nodes={self.nodes})"

    def get_cost(self,path_list: List[int]|str) -> float:
         cost = 0
         if isinstance(path_list, str):
             # map characters like 'A'..'N' to node indices based on node.name
             name_to_index = {node.name: idx for idx, node in enumerate(self.nodes)}
             mapped = []
             for c in path_list:
                 name = ord(c)
                 if name not in name_to_index:
                     raise ValueError(f"Unknown node name '{c}' in path")
                 mapped.append(name_to_index[name])
             path_list = mapped
         # path_list should now be a list of node indices
         if len(path_list) < 2:
             print("cost: 0.0")
             return 0.0
         for i in range(len(path_list) - 1):
             a = path_list[i]
             b = path_list[i + 1]
             if a < 0 or a >= len(self.nodes) or b < 0 or b >= len(self.nodes):
                 raise IndexError(f"Node index out of range: {a} or {b}")
             cost += self.distance(self.nodes[a], self.nodes[b])
            #  print(f"Distance from {chr(self.nodes[a].name)} to {chr(self.nodes[b].name)}: {self.distance(self.nodes[a], self.nodes[b])}")
        #  输出保留三位小数的cost
         cost+=self.distance(self.nodes[path_list[-1]], self.nodes[path_list[0]])
         cost = round(cost, 3)
        #  print(f"cost: {cost}")
         return cost

@dataclass  
class Fileprocessor:
    problem_2_input_file: str = "./work1/problem_2_input.txt"

    def read_input_2(self) -> Graph:
        with open(self.problem_2_input_file, "r") as f:
            lines = f.readlines()
        nodes = []
        for line in lines:
            parts = line.strip().split(" ")
            
            name, x, y = parts
            name = ord(name)
            x = int(x)
            y = int(y)
            nodes.append(Node(x=x, y=y, name=name))

        return Graph(nodes=nodes)
    
@dataclass
class GeneticAlgorithm:
    graph: Graph
    population_size: int = 100
    generations: int = 1000
    mutation_rate: float = 0.01
    crossover_rate: float = 0.9
    tournament_size: int = 5

    def fitness(self, individual: List[int]|str) -> float:
        return 1 / (self.graph.get_cost(individual))

#  ord  是acsii码  chr  是ascii码对应的字符
def main():
    pass
    # # small smoke test
    file_use = Fileprocessor()
    g = file_use.read_input_2() # 读取第一题地图
    # print(g)
    print(f"Path ABCDEFGHIJKLMN cost: {g.get_cost('ABCDEFGHIJKLMN')}")
    print(f"Path AHCDKLJNIFBGEM cost: {g.get_cost('AHCDKLJNIFBGEM')}")
    print(f"Oridinal path for indices AHCDKLJNIFBGEM : {g.oridinal_tools.get_oridinal_path('AHCDKLJNIFBGEM')}")
    print(f"Oridinal path for indices AHIECDNMFKLJBG : {g.oridinal_tools.get_oridinal_path('AHIECDNMFKLJBG')}")

    ga = GeneticAlgorithm(graph=g)
    # 计算• Compute the fitness values for the two candidate paths: ABCDEFGHIJKLMN and AHCDKLJNIFBGEM
    fitness1 = ga.fitness('ABCDEFGHIJKLMN')
    fitness2 = ga.fitness('AHCDKLJNIFBGEM')
    print(f"Fitness for path ABCDEFGHIJKLMN: {fitness1}")
    print(f"Fitness for path AHCDKLJNIFBGEM: {fitness2}")
if __name__ == "__main__":
    # print("This is the main module of work1.")
    main()    
```