# RollCaller 点名系统

[English](README.en.md) | 简体中文

一款面向教师的跨平台课堂点名应用，基于 Flutter 开发，支持 **随机点名** 与 **签到点名** 两种课堂互动模式，并提供学生/班级管理、点名记录归档与 Excel 导出、WebDAV 云端备份等功能。

支持 Android、iOS、Windows（桌面端通过 `sqflite_common_ffi` 运行）。

---

## 🧱 新粗野主义 UI（Neo-Brutalism）定制版

本分支将默认外观重设计为 **新粗野主义风格**：粗黑描边、硬边偏移投影（无模糊）、高饱和撞色、直角、粗体字。业务逻辑与原版完全一致。

- 设计系统：`lib/configs/brutal_theme.dart`（颜色 / 描边 / 硬投影 / ThemeData）
- 通用组件：`lib/widgets/brutal/brutal_widgets.dart`（`BrutalBox`、`BrutalButton`）
- 主题切换、深浅色模式、自定义主题色（DIY 取色）全部保留

### 一键构建

```bash
# Android（输出 build/app/outputs/flutter-apk/app-release.apk）
./build_android.sh
```

```bat
:: Windows（输出 build\windows\x64\runner\Release\rollcaller.exe）
build_windows.bat
```

环境要求：Flutter SDK（stable）+ Android Studio / Visual Studio（C++ 桌面开发工作负载）。

---

## 功能特性

### 随机点名
- 自定义多个「点名器」，可绑定班级，支持 **可重复 / 不可重复** 两种抽取模式
- 开始/停止随机抽取动画，实时显示抽取次数与学生平均分
- 抽取后当场评分（1–10 分），支持后续修改分数
- 已抽取 / 未抽取学生分栏展示，不可重复模式下自动排除已抽学生

<p align="center">
  <img src="assets/readme/Screenshot_2026-09-12-22-47-43-634_com.ieening.rollcall.jpg" width="46%" alt="随机点名" />
</p>

### 签到点名
- 四种签到状态：**已签到、迟到、请假、未签到**，颜色区分一目了然
- 支持按学号/姓名搜索，一键全部签到 / 一键全部未签
- 签到统计（总人数、各状态人数)

<p align="center">
  <img src="assets/readme/Screenshot_2026-09-12-22-48-15-163_com.ieening.rollcall.jpg" width="46%" alt="签到点名" />
</p>

### 班级与学生管理
- 教学班级管理：班级名称、应有人数、任课教师、备注，自动显示满员/超员状态
- 学生名单管理：学号、姓名，支持按学号或姓名搜索
- **Excel 批量导入学生**：应用内提供导入模板（`assets/templates/student_import_template.xlsx`），一键复制模板后填写导入

<p align="center">
  <img src="assets/readme/Screenshot_2026-09-12-22-48-19-273_com.ieening.rollcall.jpg" width="45%" alt="班级管理" />
  <img src="assets/readme/Screenshot_2026-09-12-22-48-21-285_com.ieening.rollcall.jpg" width="45%" alt="学生名单管理" />
</p>

### 点名记录
- 随机点名记录、签到点名记录分开管理
- 按点名器、班级、时间范围、归档状态多条件筛选
- 记录 **归档** 功能：归档后点名器及记录锁定，不可修改
- 记录导出为 **Excel（.xlsx）** 文件，包含序号、点名器、班级、学号、姓名、分数/出席情况、时间、备注等列

<p align="center">
  <img src="assets/readme/Screenshot_2026-09-12-22-48-23-912_com.ieening.rollcall.jpg" width="45%" alt="随机点名记录" />
  <img src="assets/readme/Screenshot_2026-09-12-22-48-26-180_com.ieening.rollcall.jpg" width="45%" alt="签到点名记录" />
</p>

### 设置
- 主题切换：浅色 / 深色 / 跟随系统，内置多种配色并支持自定义主题色
- **多语言**：简体中文 / English，可手动切换或跟随系统语言
- **WebDAV 云备份**：手动备份 / 恢复数据，支持查看与删除备份历史
- **自动备份**：开启后每次应用切到后台时自动备份到 WebDAV 服务器

<p align="center">
  <img src="assets/readme/Screenshot_2026-09-12-22-48-31-152_com.ieening.rollcall.jpg" width="46%" alt="设置" />
</p>

---

## 技术栈

| 类别 | 技术 / 依赖 |
| --- | --- |
| 框架 | Flutter（Dart SDK ^3.10.1） |
| 状态管理 | provider |
| 本地数据库 | sqflite（移动端）/ sqflite_common_ffi（桌面端） |
| 屏幕适配 | flutter_screenutil |
| Excel 导入导出 | excel、file_picker、file_saver |
| 云备份 | webdav_client、dio |
| 本地配置 | shared_preferences |
| 日期选择 | syncfusion_flutter_datepicker |
| 颜色选择 | flutter_colorpicker |
| 权限管理 | permission_handler |
| 下拉刷新 | pull_to_refresh |

---

## 项目结构

```
lib/
├── main.dart                  # 应用入口、主题加载、WebDAV 自动备份
├── configs/                   # 常量、枚举（字符串、签到状态、备份类型、主题选项）
├── models/                    # 数据模型（学生、班级、点名器、点名记录、备份等）
├── pages/                     # 页面
│   ├── index_page.dart        # 底部导航容器（首页/班级/学生/记录/设置）
│   ├── home_page.dart         # 首页：随机点名 / 签到点名入口
│   ├── random_call_page.dart  # 随机点名
│   ├── attendence_page.dart   # 签到点名
│   ├── student_class_page.dart# 班级管理
│   ├── student_page.dart      # 学生管理（含 Excel 导入）
│   ├── records_page.dart      # 记录管理入口
│   ├── random_call_records_page.dart      # 随机点名记录（筛选/归档/导出）
│   ├── attendance_call_records_page.dart  # 签到点名记录
│   ├── settings_page.dart     # 设置（主题、WebDAV 备份与恢复）
│   └── splash_page.dart       # 启动页
├── providers/                 # Provider 状态（导航索引、主题切换）
├── utils/                     # 数据库 helper 与各表 DAO
└── widgets/                   # 可复用对话框（增删改查、查看详情）
```

数据库表：`student_class`（班级）、`student`（学生）、`student_class_relation`（班级-学生关系）、`random_caller` / `random_caller_record`（随机点名器及记录）、`attendance_caller` / `attendance_caller_record`（签到点名器及记录）。

---

## 快速开始

### 环境要求

- Flutter SDK（stable 渠道）
- Android Studio / Xcode（对应平台构建）
- Windows 桌面构建需安装 Visual Studio（含 C++ 桌面开发工作负载）

### 安装与运行

```bash
# 1. 拉取依赖
flutter pub get

# 2. 连接设备或启动模拟器后运行
flutter run
```

### 打包构建

```bash
# Android APK
flutter build apk --release

# Windows 桌面端
flutter build windows --release
```

应用图标通过 `flutter_launcher_icons` 配置（源文件 `assets/images/icon.png`），修改后执行：

```bash
dart run flutter_launcher_icons
```

---

## 使用说明

1. **创建班级**：在「班级」页添加教学班级，填写班级名称、应有人数等信息。
2. **导入学生**：在「学生」页点击添加，或使用菜单导出 Excel 模板、批量填写后导入；学生可分配到班级。
3. **开始点名**：在「首页」选择随机点名或签到点名：
   - 随机点名：先新建点名器并选择班级，点击「开始随机抽取」，停止后为被抽中学生评分。
   - 签到点名：新建签到点名器后，逐人设置签到状态，或使用一键签到。
4. **查看记录**：在「记录」页按条件筛选、归档历史记录，并可导出 Excel 存档。
5. **数据备份**：在「设置」页填写 WebDAV 服务器地址、用户名、密码，即可手动备份/恢复；建议开启自动备份。

> 备份文件为 JSON 格式，统一上传至 WebDAV 服务器的 `/rollCaller/` 目录，文件名形如 `rollcaller_backup_manual_20260909120000.json`。

---

## 说明

- 应用数据默认存储于本地 SQLite 数据库（`rollcall.db`），卸载应用前请先通过 WebDAV 备份。
- WebDAV 仅用于数据备份与恢复，请使用支持 WebDAV 协议的网盘/自建服务（如 Nextcloud、坚果云等）。
