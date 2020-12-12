# docker-rep2

## 概要

- [open774/p2-php](https://github.com/open774/p2-php)
- [2chproxy.pl](http://github.com/yama-natuki/2chproxy.pl)
- その他動作に必要なソフトウェア

をひとつのDockerコンテナにしたものです。

## 使い方

```shell
mkdir p2data
docker run -d --name rep2 -p 10080:80 -v $PWD/p2data:/ext pengo/rep2
open http://localhost:10080
```

この例ではディレクトリp2dataの下に各データを作ります。
再起動してもデータが消えることはありません。

### arm64(Raspberry Piなど)で動かしたい

GitHub Container Registryにarm64(とamd64)用のイメージを置きました。
こちらを利用する場合は上記のdockerコマンドを以下のように変えてください。

```shell
docker run -d --name rep2 -p 10080:80 -v $PWD/p2data:/ext ghcr.io/pen/rep2
```

## 掲示板や検索経由で来た方へ

上記の手順で使うだけならビルド済のイメージが使われるため、ソースのダウンロードは不要です。
ただし更新は不定期です。
