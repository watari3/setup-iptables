#!/bin/sh

### 更新
sudo apt -y update
sudo apt -y upgrade
### 必要なアプリのインストール
sudo apt -y install git git-lfs fdclone emacs net-tools apt-file curl ipset
### 定義ファイルの更新
sudo apt-file update
