# this is for build under ubuntu

# get source from stable
$ git clone

# build-depのためソースパッケージを有効化
$ sudo sed -i 's/# deb-src/deb-src/' /etc/apt/sources.list
# build-depのためソースパッケージを有効化
$ sudo apt update
# カーネルビルドに必要なパッケージをインストール
$ sudo apt build-dep -y linux
# make menuconfigに必要な追加パッケージをインストール
$ sudo apt install libncurses-dev

# out-of-treeビルド（ソースコードと生成物を分離したビルド）の為のディレクトリを作成
$ mkdir ../build
# 既存のコンフィグをコピー＆ビルド用ディレクトリに必要なものを生成
$ make olddefconfig O=../build
# 以降、ソースコードの変更を伴わない場合、基本的にはビルド用ディレクトリで作業
$ cd ../build
# 不要なモジュールを無効化
$ make localmodconfig
# 個別に機能の選択 
$ make menuconfig

# カーネル本体＆モジュールのビルド
$ LOCALVERSION=-mybuild make -j8

##################################################
# if install in ubuntu
# モジュールのインストール
$ sudo make modules_install
# カーネル本体のインストール(GRUBのエントリ生成もしてくれる）
$ sudo make install
# 再起動後、必要に応じてgrubでビルドしたカーネルを選択
$ sudo reboot
##################################################

