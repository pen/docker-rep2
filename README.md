# docker-rep2

## 概要

- [open774/p2-php](https://github.com/open774/p2-php)
- [2chproxy.pl](http://github.com/yama-natuki/2chproxy.pl)
- その他動作に必要なソフトウェア

をひとつのコンテナにしたものです。

## 使い方

```shell
mkdir p2data
docker run -d --name rep2 -p 18080:80 -v $PWD/p2data:/ext pengo/rep2
open http://localhost:18080
```

この例ではディレクトリp2dataの下に各データを作ります。
再起動してもデータが消えることはありません。

## 掲示板や検索経由でGitHubに来た方へ

上記の手順で使うならソースのダウンロードは不要です。
イメージの更新は不定期です。
