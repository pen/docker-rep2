# php8ブランチ

## 概要

[mikoimさんのphp8対応版](https://github.com/mikoim/p2-php/tree/php8-merge)をフライングでコンテナ化したものです。

## 使い方

```shell
mkdir p2data
docker run -d --name rep2php8 -p 10088:80 -v $PWD/p2data:/ext pengo/rep2:php8
open http://localhost:10088
```

## 注意

ImageCacheのデータの置き方はmainブランチと互換性がありません。
