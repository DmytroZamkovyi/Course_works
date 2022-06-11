from view_menu import *
from tkinter import *


# Головний клас
class Main:
    # Виведення графа ініціалізація класу
    def __init__(self):
        root = Tk()
        App(root)
        root.mainloop()


Main()
