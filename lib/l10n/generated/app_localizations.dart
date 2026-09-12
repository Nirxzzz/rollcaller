import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Roll Call System'**
  String get appTitle;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @studentClassTitle.
  ///
  /// In en, this message translates to:
  /// **'Classes'**
  String get studentClassTitle;

  /// No description provided for @studentTitle.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get studentTitle;

  /// No description provided for @recordsTitle.
  ///
  /// In en, this message translates to:
  /// **'Records'**
  String get recordsTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @homeAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Roll Call System'**
  String get homeAppBarTitle;

  /// No description provided for @randomCallTab.
  ///
  /// In en, this message translates to:
  /// **'Random Call'**
  String get randomCallTab;

  /// No description provided for @attendanceTab.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get attendanceTab;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @archive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archive;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @deleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get deleteSuccess;

  /// No description provided for @deleteFail.
  ///
  /// In en, this message translates to:
  /// **'Delete failed'**
  String get deleteFail;

  /// No description provided for @addSuccess.
  ///
  /// In en, this message translates to:
  /// **'Added successfully'**
  String get addSuccess;

  /// No description provided for @addFailed.
  ///
  /// In en, this message translates to:
  /// **'Add failed'**
  String get addFailed;

  /// No description provided for @updateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Updated successfully'**
  String get updateSuccess;

  /// No description provided for @updateFailed.
  ///
  /// In en, this message translates to:
  /// **'Update failed'**
  String get updateFailed;

  /// No description provided for @createSuccess.
  ///
  /// In en, this message translates to:
  /// **'Created successfully'**
  String get createSuccess;

  /// No description provided for @createFailed.
  ///
  /// In en, this message translates to:
  /// **'Create failed'**
  String get createFailed;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data...'**
  String get noData;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// No description provided for @loadFailed.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String loadFailed(String error);

  /// No description provided for @valueDuplicated.
  ///
  /// In en, this message translates to:
  /// **'\"{value}\" is already in use'**
  String valueDuplicated(String value);

  /// No description provided for @notesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes: {notes}'**
  String notesLabel(String notes);

  /// No description provided for @notesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get notesOptional;

  /// No description provided for @classLabel.
  ///
  /// In en, this message translates to:
  /// **'Class: {name}'**
  String classLabel(String name);

  /// No description provided for @className.
  ///
  /// In en, this message translates to:
  /// **'Class'**
  String get className;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @studentNumber.
  ///
  /// In en, this message translates to:
  /// **'Student No.'**
  String get studentNumber;

  /// No description provided for @createTime.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get createTime;

  /// No description provided for @createdAtLabel.
  ///
  /// In en, this message translates to:
  /// **'Created: {dateTime}'**
  String createdAtLabel(String dateTime);

  /// No description provided for @noStudent.
  ///
  /// In en, this message translates to:
  /// **'No students'**
  String get noStudent;

  /// No description provided for @noStudentNumber.
  ///
  /// In en, this message translates to:
  /// **'No student number'**
  String get noStudentNumber;

  /// No description provided for @startCallButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get startCallButtonLabel;

  /// No description provided for @stopCallButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stopCallButtonLabel;

  /// No description provided for @chooseACaller.
  ///
  /// In en, this message translates to:
  /// **'Caller'**
  String get chooseACaller;

  /// No description provided for @notChooseACaller.
  ///
  /// In en, this message translates to:
  /// **'No caller selected'**
  String get notChooseACaller;

  /// No description provided for @callerNonRepeatable.
  ///
  /// In en, this message translates to:
  /// **'No repeat | {name}'**
  String callerNonRepeatable(String name);

  /// No description provided for @callerRepeatable.
  ///
  /// In en, this message translates to:
  /// **'{name}: repeatable'**
  String callerRepeatable(String name);

  /// No description provided for @pleaseChooseACaller.
  ///
  /// In en, this message translates to:
  /// **'Please select a caller first'**
  String get pleaseChooseACaller;

  /// No description provided for @editCaller.
  ///
  /// In en, this message translates to:
  /// **'Edit Caller'**
  String get editCaller;

  /// No description provided for @addCaller.
  ///
  /// In en, this message translates to:
  /// **'New Caller'**
  String get addCaller;

  /// No description provided for @forbitDeleteCallerInfo.
  ///
  /// In en, this message translates to:
  /// **'This caller has random call records and cannot be deleted. Please delete all of its records first.'**
  String get forbitDeleteCallerInfo;

  /// No description provided for @confirmDeleteCallerContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the selected caller? This cannot be undone.'**
  String get confirmDeleteCallerContent;

  /// No description provided for @scoreValue.
  ///
  /// In en, this message translates to:
  /// **'{score} pts'**
  String scoreValue(int score);

  /// No description provided for @saveScore.
  ///
  /// In en, this message translates to:
  /// **'Save Score'**
  String get saveScore;

  /// No description provided for @alreadyPickedNoRepeat.
  ///
  /// In en, this message translates to:
  /// **'{name} (already picked)'**
  String alreadyPickedNoRepeat(String name);

  /// No description provided for @callCount.
  ///
  /// In en, this message translates to:
  /// **'Picked: {count}x'**
  String callCount(int count);

  /// No description provided for @averageScore.
  ///
  /// In en, this message translates to:
  /// **'Avg: {score}'**
  String averageScore(String score);

  /// No description provided for @studentList.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get studentList;

  /// No description provided for @pickedStudent.
  ///
  /// In en, this message translates to:
  /// **'Picked'**
  String get pickedStudent;

  /// No description provided for @notPickedStudent.
  ///
  /// In en, this message translates to:
  /// **'Not picked'**
  String get notPickedStudent;

  /// No description provided for @searchStudent.
  ///
  /// In en, this message translates to:
  /// **'Search students'**
  String get searchStudent;

  /// No description provided for @attendanceStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get attendanceStatus;

  /// No description provided for @totalPeople.
  ///
  /// In en, this message translates to:
  /// **'Total: {count}'**
  String totalPeople(int count);

  /// No description provided for @peopleCount.
  ///
  /// In en, this message translates to:
  /// **'{count} students'**
  String peopleCount(int count);

  /// No description provided for @attendanceStatistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get attendanceStatistics;

  /// No description provided for @forbitDeleteAttendanceCallerInfo.
  ///
  /// In en, this message translates to:
  /// **'This caller has attendance records and cannot be deleted. Please delete all of its records first.'**
  String get forbitDeleteAttendanceCallerInfo;

  /// No description provided for @signInAll.
  ///
  /// In en, this message translates to:
  /// **'All present'**
  String get signInAll;

  /// No description provided for @signOutAll.
  ///
  /// In en, this message translates to:
  /// **'All absent'**
  String get signOutAll;

  /// No description provided for @studentNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'No. {number}'**
  String studentNumberLabel(String number);

  /// No description provided for @statusPresent.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get statusPresent;

  /// No description provided for @statusLate.
  ///
  /// In en, this message translates to:
  /// **'Late'**
  String get statusLate;

  /// No description provided for @statusExcused.
  ///
  /// In en, this message translates to:
  /// **'Excused'**
  String get statusExcused;

  /// No description provided for @statusAbsent.
  ///
  /// In en, this message translates to:
  /// **'Absent'**
  String get statusAbsent;

  /// No description provided for @studentClassAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Classes'**
  String get studentClassAppBarTitle;

  /// No description provided for @noStudentClass.
  ///
  /// In en, this message translates to:
  /// **'No classes yet'**
  String get noStudentClass;

  /// No description provided for @addStudentClass.
  ///
  /// In en, this message translates to:
  /// **'Add Class'**
  String get addStudentClass;

  /// No description provided for @editStudentClass.
  ///
  /// In en, this message translates to:
  /// **'Edit Class'**
  String get editStudentClass;

  /// No description provided for @studentClassCount.
  ///
  /// In en, this message translates to:
  /// **'Enrolled'**
  String get studentClassCount;

  /// No description provided for @studentCount.
  ///
  /// In en, this message translates to:
  /// **'Expected'**
  String get studentCount;

  /// No description provided for @teacher.
  ///
  /// In en, this message translates to:
  /// **'Teacher'**
  String get teacher;

  /// No description provided for @deleteClassWarnning.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this class? This cannot be undone.'**
  String get deleteClassWarnning;

  /// No description provided for @forbitDeleteClassWarnningDetail.
  ///
  /// In en, this message translates to:
  /// **'This class still contains students, random callers and attendance callers and cannot be deleted. Please remove all of them first.'**
  String get forbitDeleteClassWarnningDetail;

  /// No description provided for @classFull.
  ///
  /// In en, this message translates to:
  /// **'Class full'**
  String get classFull;

  /// No description provided for @classNotFull.
  ///
  /// In en, this message translates to:
  /// **'Places available'**
  String get classNotFull;

  /// No description provided for @classOverQuantity.
  ///
  /// In en, this message translates to:
  /// **'Over capacity'**
  String get classOverQuantity;

  /// No description provided for @classNameRequiredLabel.
  ///
  /// In en, this message translates to:
  /// **'Class name (required)'**
  String get classNameRequiredLabel;

  /// No description provided for @studentQuantityRequiredLabel.
  ///
  /// In en, this message translates to:
  /// **'Student count (required)'**
  String get studentQuantityRequiredLabel;

  /// No description provided for @teacherNameOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Teacher name (optional)'**
  String get teacherNameOptionalLabel;

  /// No description provided for @classNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Class name cannot be empty'**
  String get classNameRequired;

  /// No description provided for @studentQuantityRequired.
  ///
  /// In en, this message translates to:
  /// **'Student count cannot be empty'**
  String get studentQuantityRequired;

  /// No description provided for @studentAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get studentAppBarTitle;

  /// No description provided for @addStudent.
  ///
  /// In en, this message translates to:
  /// **'Add Student'**
  String get addStudent;

  /// No description provided for @editStudent.
  ///
  /// In en, this message translates to:
  /// **'Edit Student'**
  String get editStudent;

  /// No description provided for @noClassStudent.
  ///
  /// In en, this message translates to:
  /// **'No class'**
  String get noClassStudent;

  /// No description provided for @searchStudentNumberOrName.
  ///
  /// In en, this message translates to:
  /// **'Search by student no. or name...'**
  String get searchStudentNumberOrName;

  /// No description provided for @confirmDeleteStudentContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this student? This cannot be undone.'**
  String get confirmDeleteStudentContent;

  /// No description provided for @confirmDeleteStudentWarnningDetail.
  ///
  /// In en, this message translates to:
  /// **'This student has random call or attendance records and cannot be deleted. Please delete all of the student\'s records first.'**
  String get confirmDeleteStudentWarnningDetail;

  /// No description provided for @importStudentsSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully imported {count} students'**
  String importStudentsSuccess(int count);

  /// No description provided for @importStudentsError.
  ///
  /// In en, this message translates to:
  /// **'Failed to import students'**
  String get importStudentsError;

  /// No description provided for @pleaseGrantStoragePermission.
  ///
  /// In en, this message translates to:
  /// **'Please grant storage permission'**
  String get pleaseGrantStoragePermission;

  /// No description provided for @templateCopied.
  ///
  /// In en, this message translates to:
  /// **'Template copied to: {path}'**
  String templateCopied(String path);

  /// No description provided for @studentDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Student Details'**
  String get studentDetailTitle;

  /// No description provided for @affiliatedClasses.
  ///
  /// In en, this message translates to:
  /// **'Classes'**
  String get affiliatedClasses;

  /// No description provided for @studentNumberField.
  ///
  /// In en, this message translates to:
  /// **'Student No.'**
  String get studentNumberField;

  /// No description provided for @studentNameField.
  ///
  /// In en, this message translates to:
  /// **'Student Name'**
  String get studentNameField;

  /// No description provided for @studentNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Enter student number (required)'**
  String get studentNumberHint;

  /// No description provided for @studentNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter student name (required)'**
  String get studentNameHint;

  /// No description provided for @studentNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Student number cannot be empty'**
  String get studentNumberRequired;

  /// No description provided for @studentNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty'**
  String get studentNameRequired;

  /// No description provided for @recordAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Call Records'**
  String get recordAppBarTitle;

  /// No description provided for @randomCallRecord.
  ///
  /// In en, this message translates to:
  /// **'Random Call Records'**
  String get randomCallRecord;

  /// No description provided for @attendanceCallRecord.
  ///
  /// In en, this message translates to:
  /// **'Attendance Records'**
  String get attendanceCallRecord;

  /// No description provided for @noRandomCallRecord.
  ///
  /// In en, this message translates to:
  /// **'No random call records'**
  String get noRandomCallRecord;

  /// No description provided for @noAttendanceCallRecord.
  ///
  /// In en, this message translates to:
  /// **'No attendance records'**
  String get noAttendanceCallRecord;

  /// No description provided for @tryAdjustFilter.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting the filters'**
  String get tryAdjustFilter;

  /// No description provided for @classRecordCount.
  ///
  /// In en, this message translates to:
  /// **'Class: {className} | Records: {count}'**
  String classRecordCount(String className, int count);

  /// No description provided for @recordCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Records: {count}'**
  String recordCountLabel(int count);

  /// No description provided for @archived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get archived;

  /// No description provided for @unarchived.
  ///
  /// In en, this message translates to:
  /// **'Not archived'**
  String get unarchived;

  /// No description provided for @unknownStudent.
  ///
  /// In en, this message translates to:
  /// **'Unknown student'**
  String get unknownStudent;

  /// No description provided for @unknownStudentNumber.
  ///
  /// In en, this message translates to:
  /// **'Unknown no.'**
  String get unknownStudentNumber;

  /// No description provided for @scoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Score: {score}'**
  String scoreLabel(Object score);

  /// No description provided for @timeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time: {time}'**
  String timeLabel(String time);

  /// No description provided for @filterCondition.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filterCondition;

  /// No description provided for @resetFilter.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get resetFilter;

  /// No description provided for @randomCallerLabel.
  ///
  /// In en, this message translates to:
  /// **'Caller:'**
  String get randomCallerLabel;

  /// No description provided for @timeRangeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time range:'**
  String get timeRangeLabel;

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get startTime;

  /// No description provided for @endTime.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get endTime;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'to'**
  String get to;

  /// No description provided for @archivedLabel.
  ///
  /// In en, this message translates to:
  /// **'Archived:'**
  String get archivedLabel;

  /// No description provided for @dateRangePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Select date range'**
  String get dateRangePickerTitle;

  /// No description provided for @editScore.
  ///
  /// In en, this message translates to:
  /// **'Edit Score'**
  String get editScore;

  /// No description provided for @score.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score;

  /// No description provided for @pleaseInputScore.
  ///
  /// In en, this message translates to:
  /// **'Please enter a score'**
  String get pleaseInputScore;

  /// No description provided for @pleaseInputValidScore.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid integer (1-10)'**
  String get pleaseInputValidScore;

  /// No description provided for @confirmDeleteRecordContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this call record? This cannot be undone.'**
  String get confirmDeleteRecordContent;

  /// No description provided for @confirmArchive.
  ///
  /// In en, this message translates to:
  /// **'Confirm Archive'**
  String get confirmArchive;

  /// No description provided for @confirmArchiveContent.
  ///
  /// In en, this message translates to:
  /// **'After archiving, this caller and its records can no longer be modified. Continue?'**
  String get confirmArchiveContent;

  /// No description provided for @selectCallerToExport.
  ///
  /// In en, this message translates to:
  /// **'Select callers to export'**
  String get selectCallerToExport;

  /// No description provided for @pleaseSelectCallerToExport.
  ///
  /// In en, this message translates to:
  /// **'Select callers to export:'**
  String get pleaseSelectCallerToExport;

  /// No description provided for @pleaseSelectAtLeastOneCaller.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one caller'**
  String get pleaseSelectAtLeastOneCaller;

  /// No description provided for @exportColumnOrder.
  ///
  /// In en, this message translates to:
  /// **'No.'**
  String get exportColumnOrder;

  /// No description provided for @exportColumnName.
  ///
  /// In en, this message translates to:
  /// **'Caller'**
  String get exportColumnName;

  /// No description provided for @exportColumnClassName.
  ///
  /// In en, this message translates to:
  /// **'Class'**
  String get exportColumnClassName;

  /// No description provided for @exportColumnStudentNumber.
  ///
  /// In en, this message translates to:
  /// **'Student No.'**
  String get exportColumnStudentNumber;

  /// No description provided for @exportColumnStudentName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get exportColumnStudentName;

  /// No description provided for @exportColumnScore.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get exportColumnScore;

  /// No description provided for @exportColumnAttendanceStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get exportColumnAttendanceStatus;

  /// No description provided for @exportColumnTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get exportColumnTime;

  /// No description provided for @exportColumnRemark.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get exportColumnRemark;

  /// No description provided for @noExportableRecords.
  ///
  /// In en, this message translates to:
  /// **'No records to export'**
  String get noExportableRecords;

  /// No description provided for @pleaseGrantStoragePermissionToExport.
  ///
  /// In en, this message translates to:
  /// **'Storage permission is required to export files'**
  String get pleaseGrantStoragePermissionToExport;

  /// No description provided for @randomRecordExportFilePrefix.
  ///
  /// In en, this message translates to:
  /// **'Random_Call_Records_'**
  String get randomRecordExportFilePrefix;

  /// No description provided for @attendanceRecordExportFilePrefix.
  ///
  /// In en, this message translates to:
  /// **'Attendance_Records_'**
  String get attendanceRecordExportFilePrefix;

  /// No description provided for @exportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Exported {count} records to: {path}'**
  String exportSuccess(int count, String path);

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed: {error}'**
  String exportFailed(String error);

  /// No description provided for @callerName.
  ///
  /// In en, this message translates to:
  /// **'Caller name'**
  String get callerName;

  /// No description provided for @callerNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Caller name cannot be empty'**
  String get callerNameRequired;

  /// No description provided for @noClassCannotAddCaller.
  ///
  /// In en, this message translates to:
  /// **'No classes available. Please add a class first.'**
  String get noClassCannotAddCaller;

  /// No description provided for @allowRepeatCalling.
  ///
  /// In en, this message translates to:
  /// **'Allow repeat calling'**
  String get allowRepeatCalling;

  /// No description provided for @repeatableYes.
  ///
  /// In en, this message translates to:
  /// **'Repeatable: Yes'**
  String get repeatableYes;

  /// No description provided for @repeatableNo.
  ///
  /// In en, this message translates to:
  /// **'Repeatable: No'**
  String get repeatableNo;

  /// No description provided for @webDavConfig.
  ///
  /// In en, this message translates to:
  /// **'WebDAV Configuration'**
  String get webDavConfig;

  /// No description provided for @webDavServerUrl.
  ///
  /// In en, this message translates to:
  /// **'WebDAV server URL'**
  String get webDavServerUrl;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @connectionSuccess.
  ///
  /// In en, this message translates to:
  /// **'Connection successful'**
  String get connectionSuccess;

  /// No description provided for @connectionFailed.
  ///
  /// In en, this message translates to:
  /// **'Connection failed: {error}'**
  String connectionFailed(String error);

  /// No description provided for @testConnection.
  ///
  /// In en, this message translates to:
  /// **'Test Connection'**
  String get testConnection;

  /// No description provided for @configSaved.
  ///
  /// In en, this message translates to:
  /// **'Configuration saved'**
  String get configSaved;

  /// No description provided for @saveConfig.
  ///
  /// In en, this message translates to:
  /// **'Save Configuration'**
  String get saveConfig;

  /// No description provided for @backupSettings.
  ///
  /// In en, this message translates to:
  /// **'Backup Settings'**
  String get backupSettings;

  /// No description provided for @autoBackup.
  ///
  /// In en, this message translates to:
  /// **'Auto backup'**
  String get autoBackup;

  /// No description provided for @autoBackupTip.
  ///
  /// In en, this message translates to:
  /// **'When enabled, data is backed up automatically whenever the app goes to the background'**
  String get autoBackupTip;

  /// No description provided for @manualBackup.
  ///
  /// In en, this message translates to:
  /// **'Manual Backup'**
  String get manualBackup;

  /// No description provided for @selectBackupToRestoreFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select a backup to restore'**
  String get selectBackupToRestoreFirst;

  /// No description provided for @restoreData.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restoreData;

  /// No description provided for @backupHistory.
  ///
  /// In en, this message translates to:
  /// **'Backup History'**
  String get backupHistory;

  /// No description provided for @confirmDeleteBackupContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this backup? This cannot be undone.'**
  String get confirmDeleteBackupContent;

  /// No description provided for @cannotDeleteSelectedBackup.
  ///
  /// In en, this message translates to:
  /// **'The currently selected backup cannot be deleted'**
  String get cannotDeleteSelectedBackup;

  /// No description provided for @deleteFileSuccess.
  ///
  /// In en, this message translates to:
  /// **'Backup deleted'**
  String get deleteFileSuccess;

  /// No description provided for @deleteFileFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete backup: {error}'**
  String deleteFileFailed(String error);

  /// No description provided for @noBackupHistory.
  ///
  /// In en, this message translates to:
  /// **'No backup history'**
  String get noBackupHistory;

  /// No description provided for @backupSuccess.
  ///
  /// In en, this message translates to:
  /// **'Backup successful'**
  String get backupSuccess;

  /// No description provided for @backupFailed.
  ///
  /// In en, this message translates to:
  /// **'Backup failed'**
  String get backupFailed;

  /// No description provided for @backupFailedError.
  ///
  /// In en, this message translates to:
  /// **'Backup failed: {error}'**
  String backupFailedError(String error);

  /// No description provided for @restoreSuccess.
  ///
  /// In en, this message translates to:
  /// **'Restore successful'**
  String get restoreSuccess;

  /// No description provided for @restoreFailedError.
  ///
  /// In en, this message translates to:
  /// **'Restore failed: {error}'**
  String restoreFailedError(String error);

  /// No description provided for @fetchWebDavConfigFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load WebDAV configuration: {error}'**
  String fetchWebDavConfigFailed(String error);

  /// No description provided for @backupTypeAuto.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get backupTypeAuto;

  /// No description provided for @backupTypeManual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get backupTypeManual;

  /// No description provided for @lastBackupSuccess.
  ///
  /// In en, this message translates to:
  /// **'Last backup succeeded'**
  String get lastBackupSuccess;

  /// No description provided for @lastBackupFailed.
  ///
  /// In en, this message translates to:
  /// **'Last backup failed'**
  String get lastBackupFailed;

  /// No description provided for @themeSettings.
  ///
  /// In en, this message translates to:
  /// **'Theme Settings'**
  String get themeSettings;

  /// No description provided for @themeModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Theme mode:'**
  String get themeModeLabel;

  /// No description provided for @followSystem.
  ///
  /// In en, this message translates to:
  /// **'Follow system'**
  String get followSystem;

  /// No description provided for @languageSettings.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSettings;

  /// No description provided for @languageChinese.
  ///
  /// In en, this message translates to:
  /// **'中文'**
  String get languageChinese;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @themeStyleLabel.
  ///
  /// In en, this message translates to:
  /// **'Color scheme:'**
  String get themeStyleLabel;

  /// No description provided for @themeColorRed.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get themeColorRed;

  /// No description provided for @themeColorOrange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get themeColorOrange;

  /// No description provided for @themeColorYellow.
  ///
  /// In en, this message translates to:
  /// **'Yellow'**
  String get themeColorYellow;

  /// No description provided for @themeColorGreen.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get themeColorGreen;

  /// No description provided for @themeColorBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get themeColorBlue;

  /// No description provided for @themeColorIndigo.
  ///
  /// In en, this message translates to:
  /// **'Indigo'**
  String get themeColorIndigo;

  /// No description provided for @themeColorPurple.
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get themeColorPurple;

  /// No description provided for @themeColorCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get themeColorCustom;

  /// No description provided for @customTheme.
  ///
  /// In en, this message translates to:
  /// **'Custom theme'**
  String get customTheme;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
