# first handon
FROM python:3.11-slim

ENV PYTHONUNBUFFERED True

ENV APP_HOME /app
WORKDIR $APP_HOME
COPY . ./

# pymysqlのインストール
RUN pip install Flask gunicorn sqlalchemy pymysql

CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 main:app


import os
from flask import Flask, render_template
import sqlalchemy

app = Flask(__name__)
@app.route('/')
def get_database_list():
    # 環境変数から接続情報を取得
    # db_user = os.environ["DB_USER"]
    # db_pass = os.environ["DB_PASS"]
    # db_name = os.environ["DB_NAME"]
    # unix_socket_path = os.environ["INSTANCE_UNIX_SOCKET"]
    db_host = "10.159.160.3"
    db_user = "root"
    db_pass = ""
    db_port = "3306"
    #db_name = "DB_NAME"
    # unix_socket_path = "/cloudsql/thinking-bonbon-413902:asia-northeast1:tmp-dev-sql"    # Cloud SQLに接続
    # Cloud SQLに接続
    engine = sqlalchemy.create_engine(
        sqlalchemy.engine.url.URL.create(
            drivername="mysql+pymysql",
            username=db_user,
            host=db_host,
            password=db_pass,
            port=db_port
            # database=db_name,
            # query={"unix_socket": unix_socket_path},
        ),
    )

    # 接続を取得
    with engine.connect() as connection:
        # クエリを実行してデータベース一覧を取得
        query = sqlalchemy.text("SHOW DATABASES")
        result = connection.execute(query)
        return [row[0] for row in result]



# def index():
#     # データベース一覧を取得してテンプレートに渡す
#     database_list = get_database_list()
#     return render_template('index.html', databases=database_list)

if __name__ == '__main__':
    app.run(debug=True, host="0.0.0.0", port=int(os.environ.get("PORT", 8080)))
