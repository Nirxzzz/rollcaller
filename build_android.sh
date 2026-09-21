#!/usr/bin/env bash
# RollCaller Android 一键构建脚本（新粗野主义 UI 版）
# 用法: ./build_android.sh [fat-apk]
#   默认构建 fat APK (build/app/outputs/flutter-apk/app-release.apk)
set -euo pipefail

# 检查 flutter 是否可用
if ! command -v flutter >/dev/null 2>&1; then
  echo "[ERROR] 未找到 flutter，请先安装 Flutter SDK 并加入 PATH: https://docs.flutter.dev/get-started/install"
  exit 1
fi

echo "==> Flutter 版本"
flutter --version

echo "==> 拉取依赖"
flutter pub get

echo "==> 静态检查（仅警告不阻断）"
flutter analyze || true

echo "==> 构建 Release APK"
flutter build apk --release

APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
echo ""
echo "✅ 构建完成: $APK_PATH"
echo "   安装到已连接设备: flutter install 或 adb install -r $APK_PATH"
