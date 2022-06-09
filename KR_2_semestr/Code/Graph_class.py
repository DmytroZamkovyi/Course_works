from Top_class import *
from help_modul import *
import networkx as nx
import matplotlib.pyplot as plt


# Клас графа
class TGraph:
    # Ініціалізація
    def __init__(self, size: int, method: int, start: int, finish: int, matrix: []):

        # __size   - Кількість вершин
        # __method - Метод вирішення (1 - дейкстри, 2 - Беллмана-Форда)
        # __start  - Початкова точка для пошуку маршруту
        # __finish - Кінцева точка
        # __tops   - Масив об'єктів класу TTop

        if size >= 2:
            self.__size = size
        else:
            self.__size = 10

        if method == 1 or method == 2:
            self.__method = method
        else:
            self.__method = 1

        if start >= 0:
            self.__start = start
        else:
            self.__start = 0

        if finish >= 0:
            self.__finish = finish
        else:
            self.__finish = size - 1
        self.__tops = [(TTop(i)) for i in range(self.__size)]

        if method == 1:  # Для Дейкстри беремо по модулю всі числа
            matrix = [[(abs(matrix[i][j])) for j in range(self.__size)] for i in range(self.__size)]

        # Перетворюємо матрицю ваг на масив об'єктів
        for i in range(self.__size):
            tmp_input = []
            tmp_output = []
            for j in range(self.__size):
                if matrix[j][i] != 0:
                    tmp_input.append([j, matrix[j][i]])
                if matrix[i][j] != 0:
                    tmp_output.append([j, matrix[i][j]])
            self.__tops[i].output_top = tmp_output

        # Задаємо початкову точку і шлях до нього
        self.__tops[self.__start].size = 0
        self.__tops[self.__start].path = [self.__start]

    # Метод Дейкстри
    def __dijkstra(self) -> int:

        # w         - поточний елемент
        # for_check - масив для задання перевірки елементів
        # tops_num  - масив вершин, яки виходять з поточної
        # tops_val  - вага шляху від поточної вершини до її сусудів

        w = self.__start
        self.__tops[w].checked = True
        for_check = []
        for i in range(self.__size):
            if w == self.__finish:
                return
            for_check.clear()
            tops_num = [(tops[0]) for tops in self.__tops[w].output_top]
            tops_val = [(tops[1]) for tops in self.__tops[w].output_top]
            for j in range(len(tops_num)):
                tmp = self.__tops[tops_num[j]].size
                self.__tops[tops_num[j]].size = min(self.__tops[tops_num[j]].size, self.__tops[w].size + tops_val[j])
                if tmp != self.__tops[tops_num[j]].size:
                    self.__tops[tops_num[j]].path = self.__tops[w].path + [tops_num[j]]
            for j in self.__tops:
                if not j.checked:
                    for_check.append(j.size)
                else:
                    for_check.append(float('inf'))
            w = minimum(for_check)
            self.__tops[w].checked = True

    # Метод Беллмана-Форда
    def __bellman_ford(self) -> int:
        # Масив кортежей вершин для зручності обробки алгоритмом
        edge = []
        for i in range(self.__size):
            edge = edge + [(i, tops[0], tops[1]) for tops in self.__tops[i].output_top]

        # Рахуємо довжину шляху і сам шлях
        for i in range(self.__size - 1):
            for v1, v2, s in edge:
                if self.__tops[v1].size != float('inf') and self.__tops[v1].size + s < self.__tops[v2].size:
                    self.__tops[v2].size = self.__tops[v1].size + s
                    self.__tops[v2].path = self.__tops[v1].path + [v2]

        # Перевіряємо на наявність від'ємних циклів
        for v1, v2, s in edge:
            if self.__tops[v1].size != float('inf') and self.__tops[v1].size + s < self.__tops[v2].size:
                self.__tops[v2].size = float('-inf')
                self.__tops[v2].path = ['-']

    # Функція для вирішення графа заданим методом
    def solve_graph(self) -> int:

        # Повертає True у випадку правильності обробки алгоритму, False - в випадку виникнення циклу з нескінченно малим шляхом

        if self.__method == 1:  # Метод Дейкстри
            self.__dijkstra()
        else:  # Метод Беллмана-Форда
            self.__bellman_ford()

    # Інформація
    def info(self) -> {}:
        return {'size': self.__size,
                'method': self.__method,
                'start': self.__start,
                'finish': self.__finish,
                'tops': [(top.info()) for top in self.__tops]}

    # Генерація картинки графа
    def gr_image_output(self, res) -> None:
        g = nx.MultiDiGraph()

        [g.add_node(i) for i in range(1, self.__size+1)]

        for i in range(self.__size):
            [g.add_edge(i+1, tops[0]+1, tops[1]) for tops in self.__tops[i].output_top]

        nx.draw(g, with_labels=True)
        plt.savefig('graf.png')

    # Геттери
    @property
    def size(self) -> int:
        return self.__size

    @property
    def method(self) -> int:
        return self.__method

    @property
    def start(self) -> int:
        return self.__start

    @property
    def finish(self) -> int:
        return self.__finish

    @property
    def tops(self) -> {}:
        return [(i.info()) for i in self.__tops]
