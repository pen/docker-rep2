# docker-p2-php

## Description

[killer4989/p2-php](https://github.com/killer4989/p2-php)
をDockerのコンテナにしたものです。

## Install

```shell
mkdir $HOME/p2
docker run -d --name p2 -p 10080:80 -v $HOME/p2:/ext pengo/p2-php
open http://localhost:10080
```

起動時にボリュームディレクトリにあるファイルを消すことはありません。
再利用し、不足があれば初期ファイルを置きなおします。

conf/conf.ini.php だけ、オリジナルの`__DIR__`を書き換えています。

## 制限

ic(イメージキャッシュ)には対応していません。
