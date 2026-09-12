// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Roll Call System';

  @override
  String get homeTitle => 'Home';

  @override
  String get studentClassTitle => 'Classes';

  @override
  String get studentTitle => 'Students';

  @override
  String get recordsTitle => 'Records';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get homeAppBarTitle => 'Roll Call System';

  @override
  String get randomCallTab => 'Random Call';

  @override
  String get attendanceTab => 'Attendance';

  @override
  String get confirm => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get close => 'Close';

  @override
  String get refresh => 'Refresh';

  @override
  String get export => 'Export';

  @override
  String get archive => 'Archive';

  @override
  String get all => 'All';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get deleteSuccess => 'Deleted';

  @override
  String get deleteFail => 'Delete failed';

  @override
  String get addSuccess => 'Added successfully';

  @override
  String get addFailed => 'Add failed';

  @override
  String get updateSuccess => 'Updated successfully';

  @override
  String get updateFailed => 'Update failed';

  @override
  String get createSuccess => 'Created successfully';

  @override
  String get createFailed => 'Create failed';

  @override
  String get noData => 'No data...';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String loadFailed(String error) {
    return 'Error: $error';
  }

  @override
  String valueDuplicated(String value) {
    return '\"$value\" is already in use';
  }

  @override
  String notesLabel(String notes) {
    return 'Notes: $notes';
  }

  @override
  String get notesOptional => 'Notes (optional)';

  @override
  String classLabel(String name) {
    return 'Class: $name';
  }

  @override
  String get className => 'Class';

  @override
  String get name => 'Name';

  @override
  String get studentNumber => 'Student No.';

  @override
  String get createTime => 'Created';

  @override
  String createdAtLabel(String dateTime) {
    return 'Created: $dateTime';
  }

  @override
  String get noStudent => 'No students';

  @override
  String get noStudentNumber => 'No student number';

  @override
  String get startCallButtonLabel => 'Start';

  @override
  String get stopCallButtonLabel => 'Stop';

  @override
  String get chooseACaller => 'Caller';

  @override
  String get notChooseACaller => 'No caller selected';

  @override
  String callerNonRepeatable(String name) {
    return 'No repeat | $name';
  }

  @override
  String callerRepeatable(String name) {
    return '$name: repeatable';
  }

  @override
  String get pleaseChooseACaller => 'Please select a caller first';

  @override
  String get editCaller => 'Edit Caller';

  @override
  String get addCaller => 'New Caller';

  @override
  String get forbitDeleteCallerInfo =>
      'This caller has random call records and cannot be deleted. Please delete all of its records first.';

  @override
  String get confirmDeleteCallerContent =>
      'Are you sure you want to delete the selected caller? This cannot be undone.';

  @override
  String scoreValue(int score) {
    return '$score pts';
  }

  @override
  String get saveScore => 'Save Score';

  @override
  String alreadyPickedNoRepeat(String name) {
    return '$name (already picked)';
  }

  @override
  String callCount(int count) {
    return 'Picked: ${count}x';
  }

  @override
  String averageScore(String score) {
    return 'Avg: $score';
  }

  @override
  String get studentList => 'Students';

  @override
  String get pickedStudent => 'Picked';

  @override
  String get notPickedStudent => 'Not picked';

  @override
  String get searchStudent => 'Search students';

  @override
  String get attendanceStatus => 'Status';

  @override
  String totalPeople(int count) {
    return 'Total: $count';
  }

  @override
  String peopleCount(int count) {
    return '$count students';
  }

  @override
  String get attendanceStatistics => 'Statistics';

  @override
  String get forbitDeleteAttendanceCallerInfo =>
      'This caller has attendance records and cannot be deleted. Please delete all of its records first.';

  @override
  String get signInAll => 'All present';

  @override
  String get signOutAll => 'All absent';

  @override
  String studentNumberLabel(String number) {
    return 'No. $number';
  }

  @override
  String get statusPresent => 'Present';

  @override
  String get statusLate => 'Late';

  @override
  String get statusExcused => 'Excused';

  @override
  String get statusAbsent => 'Absent';

  @override
  String get studentClassAppBarTitle => 'Classes';

  @override
  String get noStudentClass => 'No classes yet';

  @override
  String get addStudentClass => 'Add Class';

  @override
  String get editStudentClass => 'Edit Class';

  @override
  String get studentClassCount => 'Enrolled';

  @override
  String get studentCount => 'Expected';

  @override
  String get teacher => 'Teacher';

  @override
  String get deleteClassWarnning =>
      'Are you sure you want to delete this class? This cannot be undone.';

  @override
  String get forbitDeleteClassWarnningDetail =>
      'This class still contains students, random callers and attendance callers and cannot be deleted. Please remove all of them first.';

  @override
  String get classFull => 'Class full';

  @override
  String get classNotFull => 'Places available';

  @override
  String get classOverQuantity => 'Over capacity';

  @override
  String get classNameRequiredLabel => 'Class name (required)';

  @override
  String get studentQuantityRequiredLabel => 'Student count (required)';

  @override
  String get teacherNameOptionalLabel => 'Teacher name (optional)';

  @override
  String get classNameRequired => 'Class name cannot be empty';

  @override
  String get studentQuantityRequired => 'Student count cannot be empty';

  @override
  String get studentAppBarTitle => 'Students';

  @override
  String get addStudent => 'Add Student';

  @override
  String get editStudent => 'Edit Student';

  @override
  String get noClassStudent => 'No class';

  @override
  String get searchStudentNumberOrName => 'Search by student no. or name...';

  @override
  String get confirmDeleteStudentContent =>
      'Are you sure you want to delete this student? This cannot be undone.';

  @override
  String get confirmDeleteStudentWarnningDetail =>
      'This student has random call or attendance records and cannot be deleted. Please delete all of the student\'s records first.';

  @override
  String importStudentsSuccess(int count) {
    return 'Successfully imported $count students';
  }

  @override
  String get importStudentsError => 'Failed to import students';

  @override
  String get pleaseGrantStoragePermission => 'Please grant storage permission';

  @override
  String templateCopied(String path) {
    return 'Template copied to: $path';
  }

  @override
  String get studentDetailTitle => 'Student Details';

  @override
  String get affiliatedClasses => 'Classes';

  @override
  String get studentNumberField => 'Student No.';

  @override
  String get studentNameField => 'Student Name';

  @override
  String get studentNumberHint => 'Enter student number (required)';

  @override
  String get studentNameHint => 'Enter student name (required)';

  @override
  String get studentNumberRequired => 'Student number cannot be empty';

  @override
  String get studentNameRequired => 'Name cannot be empty';

  @override
  String get recordAppBarTitle => 'Call Records';

  @override
  String get randomCallRecord => 'Random Call Records';

  @override
  String get attendanceCallRecord => 'Attendance Records';

  @override
  String get noRandomCallRecord => 'No random call records';

  @override
  String get noAttendanceCallRecord => 'No attendance records';

  @override
  String get tryAdjustFilter => 'Try adjusting the filters';

  @override
  String classRecordCount(String className, int count) {
    return 'Class: $className | Records: $count';
  }

  @override
  String recordCountLabel(int count) {
    return 'Records: $count';
  }

  @override
  String get archived => 'Archived';

  @override
  String get unarchived => 'Not archived';

  @override
  String get unknownStudent => 'Unknown student';

  @override
  String get unknownStudentNumber => 'Unknown no.';

  @override
  String scoreLabel(Object score) {
    return 'Score: $score';
  }

  @override
  String timeLabel(String time) {
    return 'Time: $time';
  }

  @override
  String get filterCondition => 'Filters';

  @override
  String get resetFilter => 'Reset';

  @override
  String get randomCallerLabel => 'Caller:';

  @override
  String get timeRangeLabel => 'Time range:';

  @override
  String get startTime => 'Start';

  @override
  String get endTime => 'End';

  @override
  String get to => 'to';

  @override
  String get archivedLabel => 'Archived:';

  @override
  String get dateRangePickerTitle => 'Select date range';

  @override
  String get editScore => 'Edit Score';

  @override
  String get score => 'Score';

  @override
  String get pleaseInputScore => 'Please enter a score';

  @override
  String get pleaseInputValidScore => 'Please enter a valid integer (1-10)';

  @override
  String get confirmDeleteRecordContent =>
      'Are you sure you want to delete this call record? This cannot be undone.';

  @override
  String get confirmArchive => 'Confirm Archive';

  @override
  String get confirmArchiveContent =>
      'After archiving, this caller and its records can no longer be modified. Continue?';

  @override
  String get selectCallerToExport => 'Select callers to export';

  @override
  String get pleaseSelectCallerToExport => 'Select callers to export:';

  @override
  String get pleaseSelectAtLeastOneCaller =>
      'Please select at least one caller';

  @override
  String get exportColumnOrder => 'No.';

  @override
  String get exportColumnName => 'Caller';

  @override
  String get exportColumnClassName => 'Class';

  @override
  String get exportColumnStudentNumber => 'Student No.';

  @override
  String get exportColumnStudentName => 'Name';

  @override
  String get exportColumnScore => 'Score';

  @override
  String get exportColumnAttendanceStatus => 'Status';

  @override
  String get exportColumnTime => 'Time';

  @override
  String get exportColumnRemark => 'Notes';

  @override
  String get noExportableRecords => 'No records to export';

  @override
  String get pleaseGrantStoragePermissionToExport =>
      'Storage permission is required to export files';

  @override
  String get randomRecordExportFilePrefix => 'Random_Call_Records_';

  @override
  String get attendanceRecordExportFilePrefix => 'Attendance_Records_';

  @override
  String exportSuccess(int count, String path) {
    return 'Exported $count records to: $path';
  }

  @override
  String exportFailed(String error) {
    return 'Export failed: $error';
  }

  @override
  String get callerName => 'Caller name';

  @override
  String get callerNameRequired => 'Caller name cannot be empty';

  @override
  String get noClassCannotAddCaller =>
      'No classes available. Please add a class first.';

  @override
  String get allowRepeatCalling => 'Allow repeat calling';

  @override
  String get repeatableYes => 'Repeatable: Yes';

  @override
  String get repeatableNo => 'Repeatable: No';

  @override
  String get webDavConfig => 'WebDAV Configuration';

  @override
  String get webDavServerUrl => 'WebDAV server URL';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get connectionSuccess => 'Connection successful';

  @override
  String connectionFailed(String error) {
    return 'Connection failed: $error';
  }

  @override
  String get testConnection => 'Test Connection';

  @override
  String get configSaved => 'Configuration saved';

  @override
  String get saveConfig => 'Save Configuration';

  @override
  String get backupSettings => 'Backup Settings';

  @override
  String get autoBackup => 'Auto backup';

  @override
  String get autoBackupTip =>
      'When enabled, data is backed up automatically whenever the app goes to the background';

  @override
  String get manualBackup => 'Manual Backup';

  @override
  String get selectBackupToRestoreFirst => 'Please select a backup to restore';

  @override
  String get restoreData => 'Restore';

  @override
  String get backupHistory => 'Backup History';

  @override
  String get confirmDeleteBackupContent =>
      'Are you sure you want to delete this backup? This cannot be undone.';

  @override
  String get cannotDeleteSelectedBackup =>
      'The currently selected backup cannot be deleted';

  @override
  String get deleteFileSuccess => 'Backup deleted';

  @override
  String deleteFileFailed(String error) {
    return 'Failed to delete backup: $error';
  }

  @override
  String get noBackupHistory => 'No backup history';

  @override
  String get backupSuccess => 'Backup successful';

  @override
  String get backupFailed => 'Backup failed';

  @override
  String backupFailedError(String error) {
    return 'Backup failed: $error';
  }

  @override
  String get restoreSuccess => 'Restore successful';

  @override
  String restoreFailedError(String error) {
    return 'Restore failed: $error';
  }

  @override
  String fetchWebDavConfigFailed(String error) {
    return 'Failed to load WebDAV configuration: $error';
  }

  @override
  String get backupTypeAuto => 'Auto';

  @override
  String get backupTypeManual => 'Manual';

  @override
  String get lastBackupSuccess => 'Last backup succeeded';

  @override
  String get lastBackupFailed => 'Last backup failed';

  @override
  String get themeSettings => 'Theme Settings';

  @override
  String get themeModeLabel => 'Theme mode:';

  @override
  String get followSystem => 'Follow system';

  @override
  String get languageSettings => 'Language';

  @override
  String get languageChinese => '中文';

  @override
  String get languageEnglish => 'English';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get themeStyleLabel => 'Color scheme:';

  @override
  String get themeColorRed => 'Red';

  @override
  String get themeColorOrange => 'Orange';

  @override
  String get themeColorYellow => 'Yellow';

  @override
  String get themeColorGreen => 'Green';

  @override
  String get themeColorBlue => 'Blue';

  @override
  String get themeColorIndigo => 'Indigo';

  @override
  String get themeColorPurple => 'Purple';

  @override
  String get themeColorCustom => 'Custom';

  @override
  String get customTheme => 'Custom theme';
}
