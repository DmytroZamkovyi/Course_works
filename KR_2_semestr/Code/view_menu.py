from tkinter import *
from help_modul import save_res_in_file
from Graph_class import *


class App:
    def __init__(self, root):
        self.__matrix_val = []

        # Виведення графа
        def gr_output(len, path, data):
            def save_res():
                save_res_in_file('res', data)
                text_save.pack()

            # Видалення рамок 1, 2 та 3
            frame_input_1.destroy()
            frame_input_2.destroy()
            frame_input_3.destroy()
            btn_gen.destroy()

            # Зміна розміру вікна
            width = 660
            height = 600
            root.geometry('%dx%d' % (width, height))

            # Рамка для виведення графа
            frame_output = Frame(root)
            frame_output['bg'] = '#ffffff'
            frame_output.place(x=10, y=10)

            # Зображення графа
            img = PhotoImage(file='graf.png')
            lb_img = Label(frame_output)
            lb_img.image = img
            lb_img['image'] = lb_img.image
            lb_img.pack()

            # Текст про довжину і шлях в графі
            out = Label(frame_output)
            out['text'] = f'Довжина: {len}\nШлях: {path}'
            out['bg'] = '#ffffff'
            out.pack()

            # Кнопка збереження
            btn_save = Button(frame_output)
            btn_save['text'] = 'Зберегти результат'
            btn_save['command'] = save_res
            btn_save.pack()

            # Повідомлення про успішне збереження
            text_save = Label(frame_output)
            text_save['text'] = 'Успішно збережено у файл res'
            text_save['bg'] = '#ffffff'

        # Кінцева функція для закінчення введення даних
        def finish():
            scale_start['state'] = DISABLED
            scale_finish['state'] = DISABLED
            gr = TGraph(scale_size.get(), method.get(), scale_start.get() - 1, scale_finish.get() - 1,
                        self.__matrix_val)
            gr.solve_graph()
            img = Draw(gr)
            img.draw_gr()

            path = ''
            if not gr.tops[gr.finish]['path']:
                path = 'inf'
            elif gr.tops[gr.finish]['path'][0] == '':
                path = '-'
            else:
                for i in range(len(gr.tops[gr.finish]['path'])):
                    path = path + (str(int(gr.tops[gr.finish]['path'][i]) + 1) + ' -> ')
                path = path[:len(path) - 5] + str(gr.finish + 1)
            gr_output(gr.tops[gr.finish]['size'], path, gr.info())

        # Функція, яка виводить повзунки для початкової і кінцевої вершини та публікує рамку 3
        def start_finish_btn():
            frame_input_3.place(y=300, x=10)
            scale_start['to'] = scale_size.get()
            scale_finish['to'] = scale_size.get()

        # Перевіряє правильність введення даних у рамці 1
        def check_btn_gen():
            if method.get() == 1:
                error_method['fg'] = '#ffffff'
                if_method = True
            elif method.get() == 2:
                error_method['fg'] = '#ffffff'
                if_method = True
            else:
                error_method['fg'] = 'red'
                if_method = False

            if if_method:
                frame_input_2.place(y=180, x=10)
                scale_size['state'] = DISABLED
                rbutton1['state'] = DISABLED
                rbutton2['state'] = DISABLED

        # Перевіряє правильність введення даних у рамці 2
        def check_btn_set():

            def top_deleted():
                if_check = True
                self.__matrix_val = [[(input_val[j][i].get()) for j in range(scale_size.get())] for i in
                                     range(scale_size.get())]
                for i in range(scale_size.get()):
                    for j in range(scale_size.get()):
                        mx = self.__matrix_val[j][i]
                        if mx.isdigit():
                            input_val[i][j]['bg'] = '#ffffff'
                            self.__matrix_val[j][i] = int(self.__matrix_val[j][i])
                        elif mx == '':
                            self.__matrix_val[j][i] = 0
                            input_val[i][j]['bg'] = '#ffffff'
                        elif mx[0] == '-':
                            if mx[1:].isdigit():
                                input_val[i][j]['bg'] = '#ffffff'
                                self.__matrix_val[j][i] = int(self.__matrix_val[j][i])
                            else:
                                input_val[i][j]['bg'] = '#fca9a9'
                                if_check = False
                        else:
                            input_val[i][j]['bg'] = '#fca9a9'
                            if_check = False
                if if_check:
                    top.destroy()
                    btn_set['state'] = NORMAL

            btn_set['state'] = DISABLED
            top = Toplevel()
            input_val = [[(Entry(top, bg='#ffffff', width=3)) for i in range(scale_size.get())] for j in
                         range(scale_size.get())]
            [[(input_val[i][j].grid(column=i, row=j)) for i in range(scale_size.get())] for j in
             range(scale_size.get())]
            top.protocol('WM_DELETE_WINDOW', top_deleted)
            btn_set['command'] = start_finish_btn
            btn_set['text'] = 'Продовжити'

        # Налаштування вікна
        root.title('Найкоротший шлях')
        width = 325
        height = 600
        screenwidth = root.winfo_screenwidth()
        screenheight = root.winfo_screenheight()
        root.geometry('%dx%d+%d+%d' % (width, height, (screenwidth - width) / 2, (screenheight - height) / 2))
        root.resizable(width=False, height=False)
        root['bg'] = 'white'

        # Рамка 1 для кількості вершин і алгоритма вирішення
        frame_input_1 = Frame(root)
        frame_input_1['bg'] = '#ffffff'
        frame_input_1.place(x=10, y=10)

        # Підказка щодо кількості вершин
        txt_size = Label(frame_input_1)
        txt_size['text'] = 'Виберіть кількість вершин'
        txt_size['bg'] = '#ffffff'
        txt_size.pack()

        # Повзунок вибору кількості вершин
        scale_size = Scale(frame_input_1)
        scale_size['orient'] = HORIZONTAL
        scale_size['length'] = 300
        scale_size['from'] = 2
        scale_size['to'] = 20
        scale_size['tickinterval'] = 2
        scale_size['resolution'] = 1
        scale_size['bg'] = '#ffffff'
        scale_size.pack()

        # Підказка щодо вибору метода
        txt_method = Label(frame_input_1)
        txt_method['text'] = 'Виберіть метод'
        txt_method['bg'] = '#ffffff'
        txt_method.pack()

        # Вибір метода
        method = IntVar()
        rbutton1 = Radiobutton(frame_input_1)
        rbutton1['text'] = 'Метод Дейкстри'
        rbutton1['variable'] = method
        rbutton1['value'] = 1
        rbutton1['bg'] = '#ffffff'
        rbutton2 = Radiobutton(frame_input_1)
        rbutton2['text'] = 'Метод Беллмана-Форда'
        rbutton2['variable'] = method
        rbutton2['value'] = 2
        rbutton2['bg'] = '#ffffff'
        rbutton1.pack(side='left')
        rbutton2.pack(side='right')

        # Підказка, щодо того, що користувач не вибрав метод
        error_method = Label(root)
        error_method['text'] = 'Виберіть метод!'
        error_method['fg'] = '#ffffff'
        error_method['bg'] = '#ffffff'
        error_method.place(y=132, x=11)

        # Кнопка для підтвердження вибору кількості вершин і методу рішення
        btn_gen = Button(root)
        btn_gen['text'] = 'Продовжити'
        btn_gen['width'] = 42
        btn_gen['command'] = check_btn_gen
        btn_gen.place(y=150, x=11)

        # Рамка 2 для задання графа матрицею ваг
        frame_input_2 = Frame(root)
        frame_input_2['bg'] = '#ffffff'

        # Підказка щодо задання графа
        txt_set = Label(frame_input_2)
        txt_set['text'] = 'Матриця вагів'
        txt_set['bg'] = '#ffffff'
        txt_set['font'] = '20'
        hint_set = Label(frame_input_2)
        hint_set[
            'text'] = 'Заповніть матрицю ваги.\nПусті клітинки будуть вважатися за 0\nПри вирішенні методом Дейкстри всі\nчисла візьмуться по модулю автоматично'
        hint_set['bg'] = '#ffffff'
        txt_set.pack()
        hint_set.pack()

        # Кнопка підтвердження задання графа
        btn_set = Button(frame_input_2)
        btn_set['text'] = 'Задати матрицю ваг'
        btn_set['width'] = 42
        btn_set['command'] = check_btn_set
        btn_set.pack()

        # Рамка 3 для вибору початкової і кінцевої вершини
        frame_input_3 = Frame(root)
        frame_input_3['bg'] = '#ffffff'

        # Підказка щодо початкової вершини
        txt_start = Label(frame_input_3)
        txt_start['text'] = 'Виберіть початкову вершину'
        txt_start['bg'] = '#ffffff'
        txt_start.pack()

        # Повзунок вибору початкової вершини
        scale_start = Scale(frame_input_3)
        scale_start['orient'] = HORIZONTAL
        scale_start['length'] = 300
        scale_start['from'] = 1
        scale_start['tickinterval'] = 2
        scale_start['resolution'] = 1
        scale_start['bg'] = '#ffffff'
        scale_start.pack()

        # Підказка щодо кінцевої вершини
        txt_finish = Label(frame_input_3)
        txt_finish['text'] = 'Виберіть кінцеву вершину'
        txt_finish['bg'] = '#ffffff'
        txt_finish.pack()

        # Повзунок щодо вибору кінцевої вершини
        scale_finish = Scale(frame_input_3)
        scale_finish['orient'] = HORIZONTAL
        scale_finish['length'] = 300
        scale_finish['from'] = 1
        scale_finish['tickinterval'] = 2
        scale_finish['resolution'] = 1
        scale_finish['bg'] = '#ffffff'
        scale_finish.pack()

        # Кнопка для вирішення графа
        btn_count = Button(frame_input_3)
        btn_count['text'] = 'Порахувати'
        btn_count['width'] = 42
        btn_count['height'] = 8
        btn_count['command'] = finish
        btn_count.pack()
