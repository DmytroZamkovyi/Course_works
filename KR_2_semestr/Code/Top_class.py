# Клас вершини графа
class TTop:
    # Ініціалізація
    def __init__(self, id: int, checked: bool = False, path: [] = [], size: int = float('inf'), output_top: [] = []) -> None:

        # __id         - Ім'я вершини
        # __checked    - Чи перевірина вершина
        # __path       - Шлях до вершини
        # __size       - Вага шляху
        # __output_top - Список сусідніх елементів, що виходять із вершини

        self.__id = id
        self.__checked = checked
        self.__path = path
        self.__size = size
        self.__output_top = output_top

    # Інформація
    def info(self) -> {}:
        return {'id': self.__id, 'checked': self.__checked, 'path': self.__path, 'size': self.__size, 'output_top': self.__output_top}

    # Геттери
    @property
    def id(self):
        return self.__id

    @property
    def checked(self):
        return self.__checked

    @property
    def path(self):
        return self.__path

    @property
    def size(self):
        return self.__size

    @property
    def output_top(self):
        return self.__output_top

    # Сеттери
    @checked.setter
    def checked(self, value: bool):
        self.__checked = value

    @path.setter
    def path(self, value: []):
        self.__path = value

    @size.setter
    def size(self, value: int):
        self.__size = value

    @output_top.setter
    def output_top(self, value: []):
        self.__output_top = value
