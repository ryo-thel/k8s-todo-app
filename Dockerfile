# 公式のPythonランタイムをベースイメージとして使用
FROM python:3.11

# コンテナ内で作業するディレクトリを設定
WORKDIR /app

# 現在のディレクトリの内容をコンテナ内の/appにコピー
COPY . /app

# requirements.txtに指定されたパッケージをインストール
RUN pip install --trusted-host pypi.python.org -r requirements.txt

# コンテナの80番ポートを外部に公開
EXPOSE 80

# コンテナが起動した際に実行するコマンド
CMD ["gunicorn", "your_project_name.wsgi:application", "--bind", "0.0.0.0:80"]

