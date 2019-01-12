# docker-rep2

## Description

- [open774/p2-php](https://github.com/open774/p2-php)
- [2chproxy.pl](http://github.com/yama-natuki/2chproxy.pl)
- その他動作に必要なソフトウェア

をひとつのDockerコンテナにしたものです。

## Usage

```shell
mkdir rep2
docker run -d --name p2 -p 10080:80 -v $PWD/rep2:/ext pengo/rep2
open http://localhost:10080
```

この例ではrep2ディレクトリの下に各データが置かれます。
再起動してもデータが消えることはありません。


## 掲示板や検索経由で来てgithubで読んでいる方へ

Usageのとおりにして使うだけならここにあるソースは不要です。
https://cloud.docker.com/u/pengo/repository/docker/pengo/rep2
に置いたビルド済のイメージが動くことになります。
イメージの更新は不定期です。
