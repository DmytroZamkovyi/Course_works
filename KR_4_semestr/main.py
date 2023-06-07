from sklearn.metrics import mean_squared_error, r2_score
from sklearn.model_selection import train_test_split
from sklearn.ensemble import ExtraTreesRegressor, RandomForestRegressor
from sklearn.linear_model import LinearRegression
import matplotlib.pyplot as plt
import pandas as pd
import time


pd.set_option('display.max_columns', None)
pd.set_option('display.max_rows', None)


def check_negative(ds, column):
    for i, row in ds.iterrows():
        if row[column] < 0:
            print('Знайдено значення менше нуля в колонці', column)
            return False
    return True


def check_data(ds):
    ds.info()
    ds.hist(figsize=(8, 8))
    plt.show()
    col = list(ds.columns.values)
    for i in col:
        if check_negative(ds, i):
            print('Значень менше нуля не знайдено в колонці', i)
    return ds


def train_model(ds):
    train, test = train_test_split(ds, test_size=0.2, random_state=1)
    X_train = train.drop(columns='quality')
    y_train = train['quality']

    X_test = test.drop(columns='quality')
    y_test = test['quality']

    # Ініціалізація моделі Extra Trees Regressor
    extra_tree_reg = ExtraTreesRegressor()

    # Навчання моделі на тренувальних даних
    extra_tree_reg.fit(X_train, y_train)
    y_predict_lin = extra_tree_reg.predict(X_test)

    # Оцінка моделі
    mse = mean_squared_error(y_test, y_predict_lin)
    r2 = r2_score(y_test, y_predict_lin)
    print('Extra Trees Regressor')
    print('MSE:', mse)
    print('R^2:', r2, '\n')

    fig, ax = plt.subplots()
    ax.scatter(y_test, y_predict_lin)
    ax.plot([y_test.min(), y_test.max()], [y_test.min(), y_test.max()], 'k--', lw=4)
    ax.set_xlabel('Справжні значення')
    ax.set_ylabel('Передбачені значення')
    plt.show()

    # Ініціалізація моделі Random Forest Regressor
    rand_forest_reg = RandomForestRegressor()

    # Навчання моделі на тренувальних даних
    rand_forest_reg.fit(X_train, y_train)
    y_predict_lin = rand_forest_reg.predict(X_test)

    # Оцінка моделі
    mse = mean_squared_error(y_test, y_predict_lin)
    r2 = r2_score(y_test, y_predict_lin)
    print('Random Forest Regressor')
    print('MSE:', mse)
    print('R^2:', r2, '\n')

    fig, ax = plt.subplots()
    ax.scatter(y_test, y_predict_lin)
    ax.plot([y_test.min(), y_test.max()], [y_test.min(), y_test.max()], 'k--', lw=4)
    ax.set_xlabel('Справжні значення')
    ax.set_ylabel('Передбачені значення')
    plt.show()

    # Ініціалізація моделі Linear Regression
    lin_reg = LinearRegression()

    # Навчання моделі на тренувальних даних
    lin_reg.fit(X_train, y_train)
    y_predict_lin = lin_reg.predict(X_test)

    # Оцінка моделі
    mse = mean_squared_error(y_test, y_predict_lin)
    r2 = r2_score(y_test, y_predict_lin)
    print('Linear Regression')
    print('MSE:', mse)
    print('R^2:', r2, '\n')

    fig, ax = plt.subplots()
    ax.scatter(y_test, y_predict_lin)
    ax.plot([y_test.min(), y_test.max()], [y_test.min(), y_test.max()], 'k--', lw=4)
    ax.set_xlabel('Справжні значення')
    ax.set_ylabel('Передбачені значення')
    plt.show()

    return ds, extra_tree_reg, rand_forest_reg, lin_reg


if __name__ == '__main__':
    start = time.perf_counter()
    path = r'C:\Users\Dima\source\PC\ADIS\KURsoVA\winequality-red.csv'
    dataset = pd.read_csv(path, low_memory=False)
    dataset = check_data(dataset)

    dataset = train_model(dataset)[0]
    print(f"Time taken is {int(time.perf_counter() - start)}s")
