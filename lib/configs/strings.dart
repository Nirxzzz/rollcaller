// Non-UI constants only.
// All user-facing strings live in the ARB files under lib/l10n and are
// accessed through AppLocalizations (see lib/l10n/generated).
class KString {
  // Database
  static const String databaseName = 'rollcall.db';
  static const String studentClassTableName = 'student_class';
  static const String studentTableName = 'student';
  static const String randomCallerTableName = 'random_caller';
  static const String randomCallerRecordTableName = 'random_caller_record';
  static const String attendanceCallerTableName = 'attendance_caller';
  static const String attendanceCallerRecordTableName =
      'attendance_caller_record';
  static const String studentClassRelationTableName = 'student_class_relation';

  // WebDAV configuration keys (SharedPreferences)
  static const String webDavServerKey = 'webDavServer';
  static const String webDavUsernameKey = 'webDavUsername';
  static const String webDavPasswordKey = 'webDavPassword';
  static const String backUpHistoryKey = 'backUpHistory';
  static const String autoBackUpKey = 'autoBackUp';
  static const String backupFileName = 'rollcaller_backup';
  static const String webDavServerFolder = 'rollCaller';

  // Theme preference key (SharedPreferences)
  static const String themeModeStyleOptionKey = 'themeModeStyleOption';
}
