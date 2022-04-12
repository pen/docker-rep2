# proxy2chブランチ

## 概要

[php8ブランチ](https://github.com/pen/docker-rep2/tree/php8)
に
[proxy2ch](https://notabug.org/NanashiNoGombe/proxy2ch)
を追加したものです。

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

Luaスクリプトは必須ではありません。
p2data/lua/bbscgi.lua があればそれを使うようになっています。

## その他

書き込みがうまくいくかはわかりません。

proxy2chの引数は環境変数 `PX2C_FLAGS` を介して渡せます:

```
docker run -d --name rep2px2c -p 10090:80 -v $PWD/p2data:/ext -e 'PX2C_FLAGS="-c"' pengo/rep2:px2c
```

試行錯誤のためrep2コンテナを再起動するのはもどかしいかもしれません。
proxy2ch単体のビルドに興味があればこちらをどうぞ:

[pen/docker-proxy2ch](https://github.com/pen/docker-proxy2ch)
