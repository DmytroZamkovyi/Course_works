# Повертає індекс мінімального елемента в масиві
import json


def minimum(r1: []) -> int:

    # minim_num - індекс мінімального елемента
    # minim_val - мінімальний елемент

    minim_num = 0
    minim_val = r1[0]
    for i in range(len(r1)):
        if r1[i] < minim_val:
            minim_val = r1[i]
            minim_num = i
    return minim_num


# Записати у файл масив даних
def save_res_in_file(file_name: str, data: []) -> None:
    with open(file_name, 'w') as file:
        file.write(json.dumps(data))
