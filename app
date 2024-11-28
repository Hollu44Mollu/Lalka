import tkinter as tk
from tkinter import messagebox
import os
from datetime import datetime  # Для работы с датой и временем

# Глобальные переменные для хранения имени, возраста и постов
user_name = ""
user_age = ""
user_posts = []  # Список для хранения постов
name_entry = None
age_entry = None
user_input_frame = None

# Функция для загрузки данных пользователя из файла
def load_user_data():
    global user_name, user_age, user_posts
    if os.path.exists("user_data.txt"):
        with open("user_data.txt", "r") as file:
            data = file.readlines()
            if len(data) >= 2:  # Проверка на корректность данных
                user_name = data[0].strip()
                user_age = data[1].strip()
                # Загружаем все посты
                user_posts = [line.strip() for line in data[2:]]

# Функция для сохранения данных пользователя в файл
def save_user_data():
    global user_name, user_age, name_entry, age_entry
    user_name = name_entry.get()
    user_age = age_entry.get()
    
    if user_name and user_age:
        print(f"Добро пожаловать, {user_name}!")
    else:
        print("Пожалуйста, введите ваши данные!")
    
    # Сохраняем данные в файл
    with open("user_data.txt", "w") as file:
        file.write(f"{user_name}\n{user_age}\n")
        for post in user_posts:
            file.write(f"{post}\n")  # Сохраняем все посты

    messagebox.showinfo("Данные сохранены", "Данные успешно сохранены!")
    show_profile()  # Показываем профиль после сохранения данных

    if user_input_frame:
        user_input_frame.pack_forget()  # Скрываем окно ввода данных
    show_menu()  # Показываем меню

# Функция для отображения личного кабинета
def show_profile():
    # Если данные введены, скрываем окно ввода и показываем профиль
    if user_input_frame:
        user_input_frame.pack_forget()

    # Скрыть ленту новостей, если она была показана
    feed_frame.pack_forget()
    
    profile_frame.pack(fill="both", expand=True)

    # Очистим предыдущий текст перед обновлением
    for widget in profile_frame.winfo_children():
        widget.pack_forget()

    # Показываем приветствие + имя и возраст
    profile_info.config(text=f"Приветствуем тебя, войсер!\nИмя: {user_name}\nВозраст: {user_age}")
    profile_info.pack(pady=20)
    
    # Кнопка редактирования
    edit_button = tk.Button(profile_frame, text="Редактировать", command=edit_user_data)
    edit_button.pack(pady=10)

# Функция для редактирования данных пользователя
def edit_user_data():
    global user_input_frame, name_entry, age_entry
    
    # Проверяем, существует ли user_input_frame, если нет - создаем его
    if user_input_frame is None:
        user_input_frame = tk.Frame(root)
    
    # Убираем старые виджеты
    for widget in user_input_frame.winfo_children():
        widget.destroy()
    
    # Создаём новые поля ввода для имени и возраста
    name_label = tk.Label(user_input_frame, text="Введите ваше имя:")
    name_label.pack(pady=5)
    name_entry = tk.Entry(user_input_frame)
    name_entry.pack(pady=5)
    name_entry.insert(0, user_name)  # Вставляем текущее имя
    
    age_label = tk.Label(user_input_frame, text="Введите ваш возраст:")
    age_label.pack(pady=5)
    age_entry = tk.Entry(user_input_frame)
    age_entry.pack(pady=5)
    age_entry.insert(0, user_age)  # Вставляем текущий возраст

    # Кнопка для сохранения данных
    save_button = tk.Button(user_input_frame, text="Сохранить", command=save_user_data)
    save_button.pack(pady=20)

    # Показываем форму для редактирования
    user_input_frame.pack(fill="both", expand=True)

# Функция для отображения ленты новостей
def show_feed():
    # Скрыть личный кабинет, если он был показан
    profile_frame.pack_forget()
    
    feed_frame.pack(fill="both", expand=True)

    # Очистим предыдущий текст перед обновлением
    for widget in feed_frame.winfo_children():
        widget.pack_forget()

    if not user_posts:
        feed_label.config(text="Лента Echo: Здесь будут посты")
    else:
        feed_label.config(text="Лента Echo")

    feed_label.pack(pady=20)

    # Отображаем все посты
    for post in user_posts:
        post_label = tk.Label(feed_frame, text=post, anchor="w", justify="left")
        post_label.pack(fill="x", padx=20, pady=5)

    # Кнопка для добавления нового поста
    post_button = tk.Button(feed_frame, text="Написать пост", command=edit_post)
    post_button.pack(pady=10)

# Функция для редактирования поста
def edit_post():
    global user_input_frame, post_entry

    # Проверяем, существует ли user_input_frame, если нет - создаем его
    if user_input_frame is None:
        user_input_frame = tk.Frame(root)
    
    # Убираем старые виджеты
    for widget in user_input_frame.winfo_children():
        widget.destroy()
    
    # Создаём новое поле ввода для поста
    post_label = tk.Label(user_input_frame, text="Напишите ваш пост:")
    post_label.pack(pady=5)
    post_entry = tk.Entry(user_input_frame)
    post_entry.pack(pady=5)

    # Кнопка для сохранения поста
    save_post_button = tk.Button(user_input_frame, text="Сохранить пост", command=save_post)
    save_post_button.pack(pady=20)

    # Показываем форму для редактирования поста
    user_input_frame.pack(fill="both", expand=True)

# Функция для сохранения поста
def save_post():
    global user_posts, post_entry

    user_post = post_entry.get()

    if user_post:
        # Получаем текущую дату и время
        current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        post_with_time = f"{user_post} (Опубликовано: {current_time})"
        
        user_posts.append(post_with_time)  # Добавляем новый пост в список
        print(f"Пост сохранен: {post_with_time}")
    else:
        print("Пожалуйста, введите пост!")
    
    # Сохраняем посты в файл
    with open("user_data.txt", "w") as file:
        file.write(f"{user_name}\n{user_age}\n")
        for post in user_posts:
            file.write(f"{post}\n")  # Сохраняем все посты

    messagebox.showinfo("Пост сохранен", "Пост успешно сохранен!")
    show_feed()  # Показываем обновленную ленту

    if user_input_frame:
        user_input_frame.pack_forget()  # Скрываем окно редактирования поста
    show_menu()  # Показываем меню

# Функция для отображения меню вкладок
def show_menu():
    # Показываем меню сверху
    menu_frame.pack(fill="x")
    
    # Скрыть вкладки на всех экранах, кроме меню
    feed_frame.pack_forget()
    profile_frame.pack_forget()

    # Кнопки вкладок - создаются один раз, потом просто скрываются/показываются
    tab_profile.pack(side="left", padx=10, pady=5)
    tab_feed.pack(side="left", padx=10, pady=5)

# Создание главного окна приложения
root = tk.Tk()
root.title("Echo")
root.geometry("600x400")

# Фрейм для отображения ленты новостей
feed_frame = tk.Frame(root)

# Фрейм для отображения личного кабинета
profile_frame = tk.Frame(root)
profile_info = tk.Label(profile_frame, text="Личный кабинет\nЗдесь будет отображаться ваш профиль")

# Фрейм для меню (вкладок)
menu_frame = tk.Frame(root)

# Кнопки вкладок создаются здесь
tab_profile = tk.Button(menu_frame, text="Личный кабинет", command=show_profile)
tab_feed = tk.Button(menu_frame, text="Лента войсов", command=show_feed)

# Фрейм для отображения ленты новостей
feed_label = tk.Label(feed_frame, text="Лента Echo: Здесь будут посты")

# Проверяем, есть ли сохраненные данные
load_user_data()

if user_name and user_age:
    # Если данные есть, сразу показываем меню и личный кабинет
    show_menu()
    show_profile()
else:
    # Фрейм для ввода данных (имя и возраст)
    user_input_frame = tk.Frame(root)

    # Поле для ввода имени
    name_label = tk.Label(user_input_frame, text="Введите ваше имя:")
    name_label.pack(pady=5)
    name_entry = tk.Entry(user_input_frame)
    name_entry.pack(pady=5)

    # Поле для ввода возраста
    age_label = tk.Label(user_input_frame, text="Введите ваш возраст:")
    age_label.pack(pady=5)
    age_entry = tk.Entry(user_input_frame)
    age_entry.pack(pady=5)

    # Кнопка для сохранения данных
    save_button = tk.Button(user_input_frame, text="Сохранить", command=save_user_data)
    save_button.pack(pady=20)

    user_input_frame.pack(fill="both", expand=True)

# Запуск приложения
root.mainloop()
