@echo off
rem RollCaller Windows 一键构建脚本（新粗野主义 UI 版）
rem 前置要求: 已安装 Flutter SDK 与 Visual Studio（含 "使用 C++ 的桌面开发" 工作负载）

where flutter >nul 2>nul
if errorlevel 1 (
  echo [ERROR] 未找到 flutter，请先安装 Flutter SDK 并加入 PATH
  exit /b 1
)

echo ==^> Flutter 版本
flutter --version

echo ==^> 拉取依赖
flutter pub get

echo ==^> 静态检查（仅警告不阻断）
flutter analyze

echo ==^> 构建 Windows Release
flutter build windows --release

echo.
echo [OK] 构建完成: build\windows\x64\runner\Release\rollcaller.exe
echo     整个 Release 目录即可分发（exe + dll + data）
