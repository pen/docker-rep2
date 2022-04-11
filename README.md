# proxy2chブランチ

## 概要

[php8ブランチ](https://github.com/pen/docker-rep2/tree/php8)
にproxy2chを内蔵したものです。

## 使い方

いまのところDockerhubにはありませんので各自でbuildしてください。

```shell
docker build -t rep2px2c .
```

Luaスクリプトは p2data/lua/bbscgi.lua があれば有効に、なりそれを使うようになっています。

```
mkdir -p p2data/lua
cp どこか/sample.lua p2data/lua/bbscgi.lua
```

ローカルのイメージを指定して起動します。

```
docker run -d --name rep2px2c -p 10090:80 -v $PWD/p2data:/ext rep2px2c
open http://localhost:10090
```

プロキシをproxy2chにする場合は
`設定>ユーザー設定編集>ETC>プロキシ`
のポート番号を9080にしてください。
8080(のまま)にすれば2chproxy.plを使い(続け)ます。



## その他

書き込みがうまくいくかはわかりません。

proxy2chの引数は環境変数 `PX2C_FLAGS` を介して渡せます(ex. `docker run ... -e 'PX2C_FLAGS="-c"'`)。
が、試行錯誤して頻繁に再起動するならrep2コンテナの内蔵はもどかしいかもしれません。

proxy2ch単体のビルドに興味があればこちらをどうぞ:

[pen/docker-proxy2ch](https://github.com/pen/docker-proxy2ch)
