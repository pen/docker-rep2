# docker-rep2

## Description

- [open774/p2-php](https://github.com/open774/p2-php)
- [2chproxy.pl](http://github.com/yama-natuki/2chproxy.pl)
- その他動作に必要なソフトウェア

をひとつのDockerコンテナにします。

## Usage

```shell
mkdir rep2
docker run -d --name p2 -p 10080:80 -v $PWD/rep2:/ext pengo/rep2
open http://localhost:10080
```

起動時、ボリュームディレクトリ下に各データが置かれます。
既にあるものを消すことはありません。
