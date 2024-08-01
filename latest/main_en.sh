#!/bin/bash

# Windows のホームディレクトリを取得
# W_HOME=$(pwd | sed -r 's#(([^/]*/){5}).*#\1#')
if pwd | grep -q "OneDrive"; then
    W_HOME=$(pwd | sed -r 's#(([^/]*/){6}).*#\1#')
else
    W_HOME=$(pwd | sed -r 's#(([^/]*/){5}).*#\1#')
fi

# main.shのディレクトリを取得
HD=$(pwd)

# データ入力・グラフ作成・ ./tex/figures/graph.pdf に移動
cd ./python
python data_input.py
echo "グラフ作成中…"
python data_plot_en.py
mv graph.svg ./../pandoc/figures/graph.svg
cd "$HD"

# 撮影したクレーターの画像を ./tex/figures/crater.jpg にコピー
NEWEST_JPG=$(ls -t "$HOME""Pictures/Camera Roll/"*.jpg | head -n1)
cp "$NEWEST_JPG" ./pandoc/figures/crater.jpg

# pandoc + firefox で印刷する PDF を作成
cd ./pandoc
echo "html 作成中…"
pandoc -s index.md -o index.html -d default.yaml --metadata-file=metadata.yaml
cd "$HD"
echo
echo "生成した html"
echo "$HD""pandoc/index.html"
