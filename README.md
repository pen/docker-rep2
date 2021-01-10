# php8ブランチ

## 概要

[php8.xサポートのPR](https://github.com/open774/p2-php/pull/22)をフライングでコンテナ化する実験です。

いくつかうまく動かないところがあるので調整中です。

## 使い方

```shell
git clone --branch php8 git://github.com/pen/docker-rep2 rep8
cd rep8
docker build -t rep8 .
mkdir rep8data
docker run -d --name rep8 -p 10088:80 -v $PWD/rep8data:/ext rep8
docker logs -f rep8
```

最後のコマンドでログを流しています。
この後Webブラウザで http://localhost:10088 を開いてください。

## 注意

ImageCacheのデータの置き方はmasterブランチと互換性がありません。
