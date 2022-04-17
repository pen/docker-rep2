# proxy2chブランチ

## 概要

[php8ブランチ](https://github.com/pen/docker-rep2/tree/php8)
に
[proxy2ch](https://notabug.org/NanashiNoGombe/proxy2ch)
を追加したものです。

また、プロキシのオプションを環境変数で指定できるようにしました。


## 使い方

```shell
mkdir -p p2data
docker run -d --name rep2px2c -p 10090:80 -v $PWD/p2data:/ext pengo/rep2:px2c
open http://localhost:10090
```

プロキシを選択するには
`設定>ユーザー設定編集>ETC>プロキシ`
のポート番号を編集してください。

- 9080 proxy2ch
- 8080 2chproxy.pl


## 環境変数によるオプション指定

### proxy2ch

環境変数`PX2C_FLAGS`で指定できます。

```shell
docker run -d --name rep2px2c -p 10090:80 -v $PWD/p2data:/ext -e 'PX2C_FLAGS="-c --chunked"' pengo/rep2:px2c
```

「`PX2C_USER_AGENT`で`-a`相当」のように、個別に指定できる環境変数もあります。詳しくは[こちら](https://github.com/pen/docker-rep2/blob/px2c/rootfs/etc/service/proxy2ch/run)を読んでください。


### 2chproxy.pl

2chproxy.confに書ける設定は、同じ名前に`NCPX_`をつけた環境変数でも渡せます(`USER_AGENT`→`NCPX_USER_AGENT`)。


## docker composeを使った起動

docker-compose.yaml を次の内容で作ります:

```yaml
version: '2'
services:
  rep2px2c:
    image: pengo/rep2:px2c
    volumes:
      - $PWD/p2data:/ext
    ports:
      - "10090:80"
    environment:
      PX2C_ACCEPT_CONNECT: 1
      PX2C_API_USAGE: post
      PX2C_BBSCGI_LUA: lua/sample.lua
      PX2C_BBSCGI_UTF8: api
      PX2C_BBSCGI_REMOVE_HEADERS: Upgrade-Insecure-Requests
```

`docker compose up -d`でバックグラウンドで起動。
設定を変えたら`docker compose up --force-recreate -d`で再起動してすぐに試せます。

proxy2chと2chproxy.plの切り替えは前述した設定画面のポート番号変更で行ってください。


## その他

実行例・設定例はどれも、うまく読み書きできることを確認したものではありません。
