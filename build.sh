#!/usr/bin/env bash
if [[ -f "dist.zip" ]]; then
    rm -f "dist.zip"
fi
### 清空构建
#flutter clean
## 构建APK
#flutter build apk
## 构建IPA
#flutter build ios
# 添加压缩包
if [[ ! -d "dist" ]]; then
   mkdir "dist"
fi
# 复制apk到dist目录
cp -r build/app/outputs/apk/release/app-release.apk dist/
# 复制ipa到dist目录
cp -r build/ios/iphoneos/Runner.app dist/
# 压缩文件
zip -r dist.zip dist
# 删除dist目录
rm -rf dist