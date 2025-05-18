import psycopg2



def delete_bd_user_phone(con):
    # Функция, создающая структуру БД(таблицы).
    with con.cursor() as cur:
        cur.execute("""
            DROP TABLE phone;
            DROP TABLE user_table;
            """)
    return True, 'Таблицы удалены'

def create_bd_user_phone(con):
    # Функция, создающая структуру БД(таблицы).
    with con.cursor() as cur:
        cur.execute("""
            CREATE TABLE IF NOT EXISTS user_table(
                user_id SERIAL PRIMARY KEY,
                first_name VARCHAR(40) NOT NULL,
                second_name VARCHAR(40) NOT NULL,
                email VARCHAR(255) UNIQUE
                );
            """)
        cur.execute("""
            CREATE TABLE IF NOT EXISTS phone(
                number INTEGER PRIMARY KEY,
                user_id INTEGER REFERENCES user_table(user_id),
                FOREIGN KEY (user_id) REFERENCES user_table(user_id)
                );
            """)
    con.commit()
    return True, 'Таблицы созданы'

def add_user(con, f_name, s_name, email):
    # Функция, позволяющая добавить нового клиента.
    with con.cursor() as cur:
        cur.execute("""
            INSERT INTO user_table(first_name, second_name, email) VALUES(%s, %s, %s);
            """, (f_name, s_name, email))
        con.commit()
        cur.execute("""
            SELECT * from user_table
            WHERE first_name = %s AND second_name = %s AND email = %s;
            """, (f_name, s_name, email))
        f = cur.fetchone()
    return True, f

def add_phone(con, number, u_id):
    # Функция, позволяющая добавить телефон для существующего клиента.
    with con.cursor() as cur:
        cur.execute("""
            SELECT user_id from user_table;
            """)
        if u_id not in map(lambda x:x[0], cur.fetchall()):
            return False, "Пользователь с указанным id в БД отсутствует."
        cur.execute("""
            INSERT INTO phone(number, user_id) VALUES(%s, %s);
            """, (number, u_id))
        con.commit()
        cur.execute("""
            SELECT * from user_table ut
            JOIN phone p ON ut.user_id = p.user_id
            WHERE ut.user_id = %s;
            """, (u_id, ))
        f = cur.fetchall()
    return True, f

def update_user(con, u_id, f_name=None, s_name=None, email=None):
    # Функция, позволяющая изменить данные о клиенте.
    updates = []
    values = []

    if f_name:
        updates.append("first_name = %s")
        values.append(f_name)
    if s_name:
        updates.append("second_name = %s")
        values.append(s_name)
    if email:
        updates.append("email = %s")
        values.append(email)
    if len(updates) == 0:
        return False, "Нет данных для обновления."
    sql_query = """
        UPDATE user_table SET {} WHERE user_id = %s;
    """.format(", ".join(updates))
    values.append(u_id)
    with con.cursor() as cur:
        cur.execute(sql_query, tuple(values))
        con.commit()
        cur.execute("""
            SELECT * from user_table WHERE user_id = %s;
        """, (u_id, ))
        f = cur.fetchone()
    return True, f

def delete_phone(con, phone_n):
    # Функция, позволяющая удалить телефон для существующего клиента.
    with con.cursor() as cur:
        cur.execute("""
            SELECT count(*) from phone WHERE number = %s;
            """, (phone_n,))
        if cur.fetchone()[0] == 0:
            return False, 'Такого телефона нет в БД'
        cur.execute("""
            DELETE FROM phone WHERE number=%s;
            """, (phone_n,))
        con.commit()
    return True, 'Телефон удалён'

def delete_user(con, u_id):
    # Функция, позволяющая удалить существующего клиента.
    with con.cursor() as cur:
        cur.execute("""
            SELECT count(*) from user_table WHERE user_id = %s;
            """, (u_id, ))
        if cur.fetchone()[0] == 0:
            return False, 'Такого пользователя нет в БД'
        cur.execute("""
            SELECT number from phone WHERE user_id = %s;
            """, (u_id,))
        for phone in map(lambda x: x[0], cur.fetchall()):
            delete_phone(con, phone)
        cur.execute("""
            DELETE from user_table WHERE user_id = %s;
            """, (u_id,))
    return True, 'Пользователь удалён'

def select_user(con, f_name = None, s_name = None, email = None, phone = None):
    # Функция, позволяющая найти клиента по его данным: имени, фамилии, email или телефону.
    select = []
    values = []

    if f_name:
        select.append("ut.first_name = %s")
        values.append(f_name)
    if s_name is not None:
        select.append("ut.second_name = %s")
        values.append(s_name)
    if email is not None:
        select.append("ut.email = %s")
        values.append(email)
    if phone is not None:
        select.append("ph.number = %s")
        values.append(phone)
    if len(select) == 0:
        return False, "Нет данных для поиска."
    sql_query = """
        SELECT ut.user_id, ut.first_name, ut.second_name, ut.email, ph.number from user_table ut 
        JOIN phone ph ON ut.user_id = ph.user_id WHERE {};
        """.format(" AND ".join(select))
    print(sql_query, values)
    with con.cursor() as cur:
        cur.execute(sql_query, tuple(values))
        f = cur.fetchall()
    return True, f


with psycopg2.connect(database="netology_db", user="postgres", password="postgres") as conn:
    print('Удаление таблиц:', delete_bd_user_phone(conn))
    print('Создание таблиц:', create_bd_user_phone(conn))

    print('Добавить пользователя 1:', add_user(conn, 'Bob', 'Dilan', 'bd@g.com'))
    print('Добавить пользователя 2:', add_user(conn, 'Dod', 'Bilan', 'db@g.com'))

    print('Добавить телефон для пользователя 1:', add_phone(conn, '12345678', 1))
    print('Добавить телефон для пользователя 1:', add_phone(conn, '11111111', 1))
    print('Добавить телефон для пользователя 2:', add_phone(conn, '22222222', 2))
    print('Добавить телефон для пользователя 3 (нет такого):', add_phone(conn, '33333333', 3))

    print('Обновить имя пользователя 2:', update_user(conn, 2, f_name='Don'))
    print('Обновить фамилию пользователя 3 (нет!):', update_user(conn, 3, s_name='Don'))

    print('Удалить пользователя 2:', delete_user(conn, 2))
    print('Удалить пользователя 3 (нет!):', delete_user(conn, 3))

    print('Выбрать пользователя по имени:', select_user(conn, 'Bob'))
    print('Выбрать пользователя по телефону:', select_user(conn, phone='11111111'))
