# proxy2chブランチ

## 概要

[php8ブランチ](https://github.com/pen/docker-rep2/tree/php8)
に
[proxy2ch](https://notabug.org/NanashiNoGombe/proxy2ch)
を追加したものです。

また、プロキシの設定を環境変数で行えるようにしました。


## 使い方

```shell
mkdir -p p2data
docker run -d --name rep2px2c -p 10090:80 -v $PWD/p2data:/ext pengo/rep2:px2c
open http://localhost:10090
```

プロキシをproxy2chにする場合は
`設定>ユーザー設定編集>ETC>プロキシ`
のポート番号を9080にしてください。

8080(のまま)にすれば2chproxy.plを使い(続け)ます。


## 環境変数による設定変更

### proxy2ch

環境変数`PX2C_FLAGS`で渡せます。

```shell
docker run -d --name rep2px2c -p 10090:80 -v $PWD/p2data:/ext -e 'PX2C_FLAGS="-c --chunked"' pengo/rep2:px2c
```

「`PX2C_USER_AGENT` で `-a` 相当」のように、個別に指定する環境変数もあります。詳しくは[こちら](https://github.com/pen/docker-rep2/blob/px2c/rootfs/etc/service/proxy2ch/run)を読んでください。

「p2data/lua/bbscgi.lua があればそれを使う仕様」はなくなりました。
`PX2C_BBSCGI_LUA` でボリュームのトップからの相対パスを指定してください。

### 2chproxy.pl

2chproxy.conf に書ける設定FOOが、対応する環境変数`NCPX_FOO`でも渡せます。

## docker composeを使った試行錯誤

docker-compose.yaml を次の内容で作ります:

```yaml
version: '2'

services:
  rep2px2c:
    image: pengo/rep2:rep2px2c
    volumes:
      - $PWD/p2data:/ext
    ports:
      - "10090:80"
    environment:
      PX2C_USER_AGENT: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36"
      PX2C_BBSCGI_LUA: lua/sample.lua
      NCPX_USER_AGENT: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36"
```

environment: のところで各プロキシのオプションを変更できます。
書き換えたら `docker compose up -d` で起動・再起動するので、すぐに試すことができます。

proxy2chと2chproxy.plの切り替えは前述した設定画面のポート番号の変更で行ってください。
