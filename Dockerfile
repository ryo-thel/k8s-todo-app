#ビルド用
FROM python:3.10-slim-buster as builder

# 標準出力のバッファリングを無効化（ログをリアルタイムに表示）
ENV PYTHONDONTWRITEBYTECODE 1

#.pycの作成を無効化（Dockerコンテナ内では不要なのでディスク容量削減のため）
ENV PYTHONUNBUFFERED 1

#gcc（コンパイラ）, postgresql（SQLデータベース）, libpq-dev（PostgreSQL用ライブラリ）
RUN apt-get update && \
    apt-get install -y gcc postgresql libpq-dev

#installのキャッシュクリア
RUN rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip

#仮想環境の構築
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

#コンテナ内にディレクトリの作成
WORKDIR /code

#コンテナ内にホストからrequirementsをコピー
COPY requirements.txt /code/

#パッケージをインストール
RUN pip install -r requirements.txt

#ランタイム用
FROM python:3.10-slim-buster

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apt-get update && \
    apt-get install -y libpq-dev && \
    rm -rf /var/lib/apt/lists/*

# 仮想環境をコピー
COPY --from=builder /opt/venv /opt/venv

WORKDIR /code
COPY . .

ENV PATH="/opt/venv/bin:$PATH"

RUN python manage.py migrate

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "todo_app.wsgi:application"]

