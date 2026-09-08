# RollCaller

English | [简体中文](README.md)

A cross-platform classroom roll-call app for teachers, built with Flutter. It supports two classroom interaction modes — **Random Calling** and **Attendance Check-in** — along with student/class management, record archiving, Excel export, and WebDAV cloud backup.

Supported platforms: Android, iOS, and Windows (desktop runs via `sqflite_common_ffi`).

---

## Features

### Random Calling
- Create multiple custom "callers", bind them to a class, and choose between **repeatable** and **non-repeatable** drawing modes
- Start/stop the random-drawing animation; call count and students' average score are shown in real time
- Score the picked student on the spot (1–10); scores can be edited later
- Picked / not-yet-picked students are shown in separate lists; in non-repeatable mode picked students are automatically excluded

### Attendance Check-in
- Four attendance statuses: **Present, Late, Excused, Absent**, each highlighted with its own color
- Search by student number or name; one-tap "mark all present" / "mark all absent"
- Attendance statistics (total count and per-status counts)

### Class & Student Management
- Class management: class name, expected student count, teacher name, notes; full/over-capacity status is shown automatically
- Student roster management: student number and name, with search by number or name
- **Bulk import students from Excel**: a ready-to-use template is bundled in the app (`assets/templates/student_import_template.xlsx`) — copy it out, fill it in, and import

### Call Records
- Random-call records and attendance records are managed separately
- Filter by caller, class, time range, and archive status
- **Archive** records: once archived, the caller and its records are locked and cannot be modified
- Export records to **Excel (.xlsx)** with columns such as index, caller name, class, student number, name, score/attendance status, time, and remarks

### Settings
- Theme switching: light / dark / follow system, with several built-in color schemes and a custom theme color
- **WebDAV cloud backup**: manually back up and restore data; browse and delete backup history
- **Auto backup**: when enabled, data is backed up to your WebDAV server every time the app goes to the background

---

## Tech Stack

| Category | Technology / Package |
| --- | --- |
| Framework | Flutter (Dart SDK ^3.10.1) |
| State management | provider |
| Local database | sqflite (mobile) / sqflite_common_ffi (desktop) |
| Screen adaptation | flutter_screenutil |
| Excel import/export | excel, file_picker, file_saver |
| Cloud backup | webdav_client, dio |
| Local preferences | shared_preferences |
| Date range picker | syncfusion_flutter_datepicker |
| Color picker | flutter_colorpicker |
| Permissions | permission_handler |
| Pull-to-refresh | pull_to_refresh |

---

## Project Structure

```
lib/
├── main.dart                  # App entry, theme loading, WebDAV auto backup
├── configs/                   # Constants & enums (strings, attendance status, backup type, theme options)
├── models/                    # Data models (student, class, callers, call records, backup, etc.)
├── pages/                     # Pages
│   ├── index_page.dart        # Bottom navigation shell (Home / Classes / Students / Records / Settings)
│   ├── home_page.dart         # Home: entry points for random calling & attendance
│   ├── random_call_page.dart  # Random calling
│   ├── attendence_page.dart   # Attendance check-in
│   ├── student_class_page.dart# Class management
│   ├── student_page.dart      # Student management (incl. Excel import)
│   ├── records_page.dart      # Records hub
│   ├── random_call_records_page.dart      # Random-call records (filter / archive / export)
│   ├── attendance_call_records_page.dart  # Attendance records
│   ├── settings_page.dart     # Settings (theme, WebDAV backup & restore)
│   └── splash_page.dart       # Splash screen
├── providers/                 # Provider state (navigation index, theme switcher)
├── utils/                     # Database helper and per-table DAOs
└── widgets/                   # Reusable dialogs (add/edit/view/delete)
```

Database tables: `student_class` (classes), `student` (students), `student_class_relation` (class–student mapping), `random_caller` / `random_caller_record` (random callers and their records), `attendance_caller` / `attendance_caller_record` (attendance callers and their records).

---

## Getting Started

### Prerequisites

- Flutter SDK (stable channel)
- Android Studio / Xcode for the corresponding platform builds
- For Windows desktop builds: Visual Studio with the "Desktop development with C++" workload

### Install & Run

```bash
# 1. Fetch dependencies
flutter pub get

# 2. Connect a device or start an emulator, then run
flutter run
```

### Build Release

```bash
# Android APK
flutter build apk --release

# Windows desktop
flutter build windows --release
```

App icons are configured via `flutter_launcher_icons` (source: `assets/images/icon.png`). After changing the icon, run:

```bash
dart run flutter_launcher_icons
```

---

## Usage Guide

1. **Create classes**: on the "Classes" tab, add a class with its name, expected student count, etc.
2. **Import students**: on the "Students" tab, add students manually or export the Excel template, fill it in, and bulk-import. Students can be assigned to classes.
3. **Start calling**: on the "Home" tab choose Random Calling or Attendance:
   - Random Calling: create a caller, select a class, tap "Start", then score the picked student after stopping.
   - Attendance: create an attendance caller, set each student's status, or use the one-tap actions.
4. **Review records**: on the "Records" tab, filter history, archive finalized records, and export them to Excel.
5. **Back up data**: on the "Settings" tab, enter your WebDAV server URL, username, and password to back up/restore manually — enabling auto backup is recommended.

> Backups are JSON files uploaded to the `/rollCaller/` folder on your WebDAV server, named like `rollcaller_backup_manual_20260909120000.json`.

---

## Notes

- All app data is stored locally in a SQLite database (`rollcall.db`). Back up to WebDAV before uninstalling the app.
- WebDAV is used only for data backup and restore; use any WebDAV-compatible service (e.g., Nextcloud, Jianguoyun) or a self-hosted server.
