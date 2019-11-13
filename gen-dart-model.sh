# !/bin/bash
# 生成Dart Model
flutter packages pub run json_model
# 删除源文件
rm -rf jsons/*
# 将生成的文件添加到git
git add models/*