# php8ブランチ

## 概要

[mikoimさんのphp8対応版](https://github.com/mikoim/p2-php/tree/php8-merge)をフライングでコンテナ化したものです。

## 使い方

```shell
mkdir p2data
docker run -d --name rep2php8 -p 10088:80 -v $PWD/p2data:/ext pengo/rep2:php8
open http://localhost:10088
```

## 設定

2chproxy.conf に書ける設定は、対応する環境変数`NCPX_*`でも渡せます。

```yaml
version: '2'
services:
  rep2php8
    image: pengo/rep2:php8
    volumes:
      - $PWD/testvol:/ext
    ports:
      - "10088:80"
    environment:
      NCPX_USER_AGENT: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:99.0) Gecko/20100101 Firefox/99.0
```

## 注意

ImageCacheのデータの置き方はmainブランチと互換性がありません。
