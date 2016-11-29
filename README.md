# OSX configuration splitter

OSX の特定種類の .plist ファイルの分割をおこなうコマンドです。

OS やアプリケーションなどにおける設定変更前後の .plist ファイルの内容の変化を分析や検証しやすくすることを目的として作られています。

## 0. 動作要件

* Mac OSX
* Ruby (OSX 組み込みのものでも構いません)
* [Bundler](https://bundler.io/)

## 1. インストール手順

まず、本リポジトリを clone してください。

```
$ git clone https://github.com/co3k/osx-config-splitter.git
```

その後、プロジェクトルートに移動し、

```
$ cd ./osx-config-splitter
```

以下を実行してインストールをおこないます。

```
$ make install
```

## 2. 実行手順

いまのところは以下の種類の plist の分割にのみ対応しています。

* com.apple.airport.preferences.plist
* preferences.plist

まずこのプロジェクトルート直下に存在する dist を空にします (dist ディレクトリがなければこの手順を無視してください)。

```
rm -r ./dist/*
```

続いて、比較対象となるふたつの plist ファイルのパスを引数にして plist-splitter を実行します。

```
./plist-splitter ~/Downloads/com.apple.airport.preferences.plist ~/Downloads/com.apple.airport.preferences-2.plist
```

コマンドが正常に完了すると、 dist ディレクトリにファイル群が作られます。 com.apple.airport.preferences.plist の場合は、以下の構造でファイル群が書き出されることになります。

```
dist
├── a    # 第一引数に指定したファイルが書き出されます
│   ├── com.apple.airport.preferences.plist    # 第一引数に指定したファイルのうち、 KnownNetworks の内容以外が書き出されます
│   ├── com.apple.airport.preferences_KnownNetworks_[AP の SSID].plist    # 第一引数に指定したファイルのうち、 KnownNetworks に列挙された SSID 毎の内容が書き出されます (以下同じ)
│   ├──          :
│   └── com.apple.airport.preferences_KnownNetworks_[AP の SSID].plist
└── b    # 第二引数に指定したファイルが書き出されます
    ├── com.apple.airport.preferences.plist    # 第二引数に指定したファイルのうち、 KnownNetworks の内容以外が書き出されます
    ├── com.apple.airport.preferences_KnownNetworks_[AP の SSID].plist    # 第二引数に指定したファイルのうち、 KnownNetworks に列挙された SSID 毎の内容が書き出されます (以下同じ)
    ├──           :
    └── com.apple.airport.preferences_KnownNetworks_[AP の SSID].plist
```

これらのファイルの内容を、 diff コマンドを用いて以下のように比較します (以下の例では、 `SSID_1` という SSID の設定同士を比較します)。

```
$ diff -u ./dist/a/com.apple.airport.preferences_KnownNetworks_SSID_1.plist ./dist/b/com.apple.airport.preferences_KnownNetworks_SSID_1.plist
```

あるいは、 a ディレクトリと b ディレクトリを再帰的に比較しても構いません。

```
$ diff -ur ./dist/a ./dist/b
```
