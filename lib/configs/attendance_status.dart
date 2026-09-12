import 'dart:ui';

import '../l10n/generated/app_localizations.dart';

// Attendance status enum
enum AttendanceStatus {
  present,
  late,
  excused,
  absent,
}

// Attendance status extension
extension AttendanceStatusExtension on AttendanceStatus {
  String label(AppLocalizations l10n) {
    switch (this) {
      case AttendanceStatus.present:
        return l10n.statusPresent;
      case AttendanceStatus.late:
        return l10n.statusLate;
      case AttendanceStatus.excused:
        return l10n.statusExcused;
      case AttendanceStatus.absent:
        return l10n.statusAbsent;
    }
  }

  int get toInt {
    switch (this) {
      case AttendanceStatus.present:
        return 1;
      case AttendanceStatus.late:
        return 2;
      case AttendanceStatus.excused:
        return 3;
      case AttendanceStatus.absent:
        return 4;
    }
  }

  Color get statusColor {
    switch (this) {
      case AttendanceStatus.present:
        return const Color(0xFF81C784); // green
      case AttendanceStatus.late:
        return const Color(0xFFFFD54F); // yellow
      case AttendanceStatus.excused:
        return const Color(0xFF64B5F6); // blue
      case AttendanceStatus.absent:
        return const Color(0xFFEF5350); // red
    }
  }

  static AttendanceStatus fromInt(int value) {
    switch (value) {
      case 1:
        return AttendanceStatus.present;
      case 2:
        return AttendanceStatus.late;
      case 3:
        return AttendanceStatus.excused;
      case 4:
        return AttendanceStatus.absent;
      default:
        return AttendanceStatus.absent;
    }
  }
}
