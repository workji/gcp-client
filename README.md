# Google Cloud CLI の利用手順

## 前提
CloudSQLで、インスタンス作成済かつ接続するユーザも作成済

## 環境構築方法
ビルド

```
docker build -t my-cloud-cli .
```

起動

```
docker run -it my-cloud-cli
```

コンテナ内でGCP各サービスへ接続
(ここでは、CloudSQL接続のみ)
```shell
# Sign in to the gcloud CLI
gcloud auth login
OR
gcloud auth login --no-launch-browser

# select your project
gcloud projects list
gcloud config set project PROJECT_ID

# connect service
gcloud sql connect --help
#gcloud sql connect INSTANCE [--database=DATABASE, -d DATABASE]
#        [--user=USER, -u USER] [GCLOUD_WIDE_FLAG ...]

# -u optionを指定しないとrootユーザでログインになる
gcloud sql connect INSTANCE_NAME -u USER
```

## その他構築方法
自分の環境に、cloud-sdkをインストール方法<br>
（ここではwindows環境を例に）

Google Cloud CLI インストーラをダウンロード
```shell
(New-Object Net.WebClient).DownloadFile("https://dl.google.com/dl/cloudsdk/channels/rapid/GoogleCloudSDKInstaller.exe", "$env:Temp\GoogleCloudSDKInstaller.exe")

& $env:Temp\GoogleCloudSDKInstaller.exe
    
```
インストーラを起動して、画面の指示に沿って操作します。

CloudSDKのShell画面が開いたら以下コマンドを実行します。
```shell
# パッケージの名前変わる場合があるため、install前に再確認
gcloud components list

# 必要のパッケージをinstall
gcloud components install cloud_sql_proxy

# cloud_sql_proxy起動
# INSTANCE_NAME=`project:region:instance-name`の形式必要
cloud_sql_proxy -instances=INSTANCE_NAME=tcp:3306

# 起動状態確認
tasklist | findstr /i "cloud_sql_proxy"

# エラーの場合、ポート 3306 が既に別のプロセスによって使用されていることよくあるため、ポート確認
netstat -ano | findstr :3306
taskkill /F /PID <PID>

# 以下に用出力されるなら、準備OKとなります。
2024/02/20 10:33:21 Listening on 127.0.0.1:3306 for `project:region:instance-name`
2024/02/20 10:33:21 Ready for new connections
2024/02/20 10:33:21 Generated RSA key in 35.2787ms
```

データベースクライアントから接続確認
```shell
ホスト: localhost
ポート: 3306
ユーザー名: Cloud SQL インスタンスのユーザー名
パスワード: Cloud SQL インスタンスのパスワード
```






