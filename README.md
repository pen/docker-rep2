# php8ブランチ

## 概要

[php8.xサポートのPR](https://github.com/open774/p2-php/pull/22)をフライングでコンテナ化したものです。

## 使い方

```shell
mkdir p2data
docker run -d --name rep2php8 -p 10088:80 -v $PWD/p2data:/ext pengo/rep2:php8
open http://localhost:10088
```

## 注意

ImageCacheのデータの置き方はmainブランチと互換性がありません。
