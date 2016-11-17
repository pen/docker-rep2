# p2-php

## Description

[killer4989/p2-php](https://github.com/killer4989/p2-php)をDockerコンテナにしただけです。

## Install

```shell
mkdir $HOME/p2
docker run -p 10080:80 -v $HOME/p2:/ext pengo/p2-php
open http://localhost:10080
```

再起動してもボリュームのデータは消しません。
最初に置かれるconf/conf.ini.php は`__DIR__`を書き換えているのでご注意を。

## 制限

ic(イメージキャッシュ)には対応していません。
