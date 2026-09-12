// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '点名系统';

  @override
  String get homeTitle => '首页';

  @override
  String get studentClassTitle => '班级';

  @override
  String get studentTitle => '学生';

  @override
  String get recordsTitle => '记录';

  @override
  String get settingsTitle => '设置';

  @override
  String get homeAppBarTitle => '点名系统';

  @override
  String get randomCallTab => '随机点名';

  @override
  String get attendanceTab => '签到点名';

  @override
  String get confirm => '确定';

  @override
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String get delete => '删除';

  @override
  String get edit => '编辑';

  @override
  String get close => '关闭';

  @override
  String get refresh => '刷新';

  @override
  String get export => '导出';

  @override
  String get archive => '归档';

  @override
  String get all => '全部';

  @override
  String get yes => '是';

  @override
  String get no => '否';

  @override
  String get deleteSuccess => '删除成功';

  @override
  String get deleteFail => '删除失败';

  @override
  String get addSuccess => '添加成功';

  @override
  String get addFailed => '添加失败';

  @override
  String get updateSuccess => '更新成功';

  @override
  String get updateFailed => '更新失败';

  @override
  String get createSuccess => '新增成功';

  @override
  String get createFailed => '新增失败';

  @override
  String get noData => '暂无数据...';

  @override
  String get confirmDelete => '确认删除';

  @override
  String loadFailed(String error) {
    return '失败: $error';
  }

  @override
  String valueDuplicated(String value) {
    return '$value重复使用';
  }

  @override
  String notesLabel(String notes) {
    return '备注: $notes';
  }

  @override
  String get notesOptional => '备注（选填）';

  @override
  String classLabel(String name) {
    return '班级: $name';
  }

  @override
  String get className => '班级';

  @override
  String get name => '姓名';

  @override
  String get studentNumber => '学号';

  @override
  String get createTime => '创建时间';

  @override
  String createdAtLabel(String dateTime) {
    return '创建时间: $dateTime';
  }

  @override
  String get noStudent => '暂无学生';

  @override
  String get noStudentNumber => '没有学号';

  @override
  String get startCallButtonLabel => '开始随机抽取';

  @override
  String get stopCallButtonLabel => '停止抽取';

  @override
  String get chooseACaller => '选择点名器';

  @override
  String get notChooseACaller => '无选中点名器';

  @override
  String callerNonRepeatable(String name) {
    return '不可重复 | $name';
  }

  @override
  String callerRepeatable(String name) {
    return '$name：可重复';
  }

  @override
  String get pleaseChooseACaller => '请先选择点名器';

  @override
  String get editCaller => '编辑点名器';

  @override
  String get addCaller => '新增点名器';

  @override
  String get forbitDeleteCallerInfo => '该点名器下有随机点名记录，无法删除。请先删除该点名器下的所有随机点名记录。';

  @override
  String get confirmDeleteCallerContent => '确定要删除选中的点名器吗？此操作不可撤销。';

  @override
  String scoreValue(int score) {
    return '$score分';
  }

  @override
  String get saveScore => '保存评分';

  @override
  String alreadyPickedNoRepeat(String name) {
    return '$name已抽取，不可重复选择';
  }

  @override
  String callCount(int count) {
    return '抽取：$count次';
  }

  @override
  String averageScore(String score) {
    return '平均分: $score';
  }

  @override
  String get studentList => '学生列表';

  @override
  String get pickedStudent => '已抽取学生';

  @override
  String get notPickedStudent => '未抽取学生';

  @override
  String get searchStudent => '搜索学生';

  @override
  String get attendanceStatus => '签到状态';

  @override
  String totalPeople(int count) {
    return '共$count人';
  }

  @override
  String peopleCount(int count) {
    return '$count人';
  }

  @override
  String get attendanceStatistics => '签到统计';

  @override
  String get forbitDeleteAttendanceCallerInfo =>
      '该点名器下有签到点名记录，无法删除。请先删除该点名器下的所有签到点名记录。';

  @override
  String get signInAll => '一键签到';

  @override
  String get signOutAll => '一键未签';

  @override
  String studentNumberLabel(String number) {
    return '学号：$number';
  }

  @override
  String get statusPresent => '已签到';

  @override
  String get statusLate => '迟到';

  @override
  String get statusExcused => '请假';

  @override
  String get statusAbsent => '未签到';

  @override
  String get studentClassAppBarTitle => '教学班级';

  @override
  String get noStudentClass => '暂无班级';

  @override
  String get addStudentClass => '添加班级';

  @override
  String get editStudentClass => '编辑班级';

  @override
  String get studentClassCount => '班级已有人数';

  @override
  String get studentCount => '学生应有人数';

  @override
  String get teacher => '教师';

  @override
  String get deleteClassWarnning => '确定要删除班级吗？此操作不可恢复。';

  @override
  String get forbitDeleteClassWarnningDetail =>
      '该班级下还有学生、随机点名器、签到点名器，无法删除。请先删除班级下的所有学生、随机点名器、签到点名器。';

  @override
  String get classFull => '班级人数已满';

  @override
  String get classNotFull => '班级人数未满';

  @override
  String get classOverQuantity => '班级人数超员';

  @override
  String get classNameRequiredLabel => '班级名称（必填）';

  @override
  String get studentQuantityRequiredLabel => '学生数量（必填）';

  @override
  String get teacherNameOptionalLabel => '教师姓名（可选）';

  @override
  String get classNameRequired => '班级名称不能为空';

  @override
  String get studentQuantityRequired => '学生人数不能为空';

  @override
  String get studentAppBarTitle => '学生名单管理';

  @override
  String get addStudent => '添加学生';

  @override
  String get editStudent => '编辑学生';

  @override
  String get noClassStudent => '无班级学生';

  @override
  String get searchStudentNumberOrName => '搜索学号或姓名...';

  @override
  String get confirmDeleteStudentContent => '确定要删除该学生吗？此操作不可恢复。';

  @override
  String get confirmDeleteStudentWarnningDetail =>
      '该学生下有随机点名记录或签到点名记录，无法删除。请先删除该学生下的所有随机点名记录或签到点名记录。';

  @override
  String importStudentsSuccess(int count) {
    return '成功导入 $count 个学生';
  }

  @override
  String get importStudentsError => '导入学生错误';

  @override
  String get pleaseGrantStoragePermission => '请授予存储权限';

  @override
  String templateCopied(String path) {
    return '模板文件已复制到：$path';
  }

  @override
  String get studentDetailTitle => '学生信息详情';

  @override
  String get affiliatedClasses => '所在班级';

  @override
  String get studentNumberField => '学生学号';

  @override
  String get studentNameField => '学生姓名';

  @override
  String get studentNumberHint => '请输入学生学号（必填）';

  @override
  String get studentNameHint => '请输入学生姓名（必填）';

  @override
  String get studentNumberRequired => '学号不能为空';

  @override
  String get studentNameRequired => '姓名不能为空';

  @override
  String get recordAppBarTitle => '点名记录管理';

  @override
  String get randomCallRecord => '随机点名记录';

  @override
  String get attendanceCallRecord => '签到点名记录';

  @override
  String get noRandomCallRecord => '暂无随机点名记录';

  @override
  String get noAttendanceCallRecord => '暂无签到点名记录';

  @override
  String get tryAdjustFilter => '请尝试调整筛选条件';

  @override
  String classRecordCount(String className, int count) {
    return '班级: $className | 记录数：$count';
  }

  @override
  String recordCountLabel(int count) {
    return '记录数：$count';
  }

  @override
  String get archived => '已归档';

  @override
  String get unarchived => '未归档';

  @override
  String get unknownStudent => '未知学生';

  @override
  String get unknownStudentNumber => '未知学号';

  @override
  String scoreLabel(Object score) {
    return '分数: $score';
  }

  @override
  String timeLabel(String time) {
    return '时间：$time';
  }

  @override
  String get filterCondition => '筛选条件';

  @override
  String get resetFilter => '重置';

  @override
  String get randomCallerLabel => '点名器: ';

  @override
  String get timeRangeLabel => '时间范围: ';

  @override
  String get startTime => '开始时间';

  @override
  String get endTime => '结束时间';

  @override
  String get to => '至';

  @override
  String get archivedLabel => '是否归档: ';

  @override
  String get dateRangePickerTitle => '选择时间范围';

  @override
  String get editScore => '编辑分数';

  @override
  String get score => '分数';

  @override
  String get pleaseInputScore => '请输入分数';

  @override
  String get pleaseInputValidScore => '请输入有效的整数（1-10）';

  @override
  String get confirmDeleteRecordContent => '确定要删除这条点名记录吗？此操作不可恢复。';

  @override
  String get confirmArchive => '确认归档';

  @override
  String get confirmArchiveContent => '归档后该点名器及记录将不可修改且无法撤销，是否继续？';

  @override
  String get selectCallerToExport => '选择需要导出的点名器';

  @override
  String get pleaseSelectCallerToExport => '请选择需要导出的点名器: ';

  @override
  String get pleaseSelectAtLeastOneCaller => '请至少选择一个点名器';

  @override
  String get exportColumnOrder => '序号';

  @override
  String get exportColumnName => '点名器名称';

  @override
  String get exportColumnClassName => '班级名称';

  @override
  String get exportColumnStudentNumber => '学生学号';

  @override
  String get exportColumnStudentName => '学生姓名';

  @override
  String get exportColumnScore => '分数';

  @override
  String get exportColumnAttendanceStatus => '出席情况';

  @override
  String get exportColumnTime => '点名时间';

  @override
  String get exportColumnRemark => '备注';

  @override
  String get noExportableRecords => '没有找到可导出的记录';

  @override
  String get pleaseGrantStoragePermissionToExport => '请授予存储权限才能导出文件';

  @override
  String get randomRecordExportFilePrefix => '随机点名记录_';

  @override
  String get attendanceRecordExportFilePrefix => '签到点名记录_';

  @override
  String exportSuccess(int count, String path) {
    return '导出成功！共导出 $count 条记录到文件: $path';
  }

  @override
  String exportFailed(String error) {
    return '导出失败：$error';
  }

  @override
  String get callerName => '点名器名称';

  @override
  String get callerNameRequired => '点名器名称不能为空';

  @override
  String get noClassCannotAddCaller => '暂无班级，无法添加点名器，请先添加班级';

  @override
  String get allowRepeatCalling => '是否允许重复点名';

  @override
  String get repeatableYes => '重复点名: 是';

  @override
  String get repeatableNo => '重复点名: 否';

  @override
  String get webDavConfig => 'WebDAV配置';

  @override
  String get webDavServerUrl => 'WebDAV服务器地址';

  @override
  String get username => '用户名';

  @override
  String get password => '密码';

  @override
  String get connectionSuccess => '连接成功';

  @override
  String connectionFailed(String error) {
    return '连接失败：$error';
  }

  @override
  String get testConnection => '测试连接';

  @override
  String get configSaved => '配置已保存';

  @override
  String get saveConfig => '保存配置';

  @override
  String get backupSettings => '备份设置';

  @override
  String get autoBackup => '自动备份';

  @override
  String get autoBackupTip => '若打开自动备份则每次应用置于后台时自动备份';

  @override
  String get manualBackup => '手动备份';

  @override
  String get selectBackupToRestoreFirst => '请先选择要恢复的备份';

  @override
  String get restoreData => '恢复数据';

  @override
  String get backupHistory => '备份历史';

  @override
  String get confirmDeleteBackupContent => '确定要删除此备份吗？此操作不可撤销。';

  @override
  String get cannotDeleteSelectedBackup => '当前选中备份不能删除';

  @override
  String get deleteFileSuccess => '删除文件成功';

  @override
  String deleteFileFailed(String error) {
    return '删除文件失败：$error';
  }

  @override
  String get noBackupHistory => '暂无备份历史';

  @override
  String get backupSuccess => '备份成功';

  @override
  String get backupFailed => '备份失败';

  @override
  String backupFailedError(String error) {
    return '备份失败：$error';
  }

  @override
  String get restoreSuccess => '恢复成功';

  @override
  String restoreFailedError(String error) {
    return '恢复失败：$error';
  }

  @override
  String fetchWebDavConfigFailed(String error) {
    return '获取WebDav配置失败：$error';
  }

  @override
  String get backupTypeAuto => '自动备份';

  @override
  String get backupTypeManual => '手动备份';

  @override
  String get lastBackupSuccess => '上次备份成功';

  @override
  String get lastBackupFailed => '上次备份失败';

  @override
  String get themeSettings => '主题设置';

  @override
  String get themeModeLabel => '主题模式:';

  @override
  String get followSystem => '跟随系统';

  @override
  String get light => '浅色';

  @override
  String get dark => '深色';

  @override
  String get themeStyleLabel => '主题风格:';

  @override
  String get themeColorRed => '红色';

  @override
  String get themeColorOrange => '橙色';

  @override
  String get themeColorYellow => '黄色';

  @override
  String get themeColorGreen => '绿色';

  @override
  String get themeColorBlue => '蓝色';

  @override
  String get themeColorIndigo => '青色';

  @override
  String get themeColorPurple => '紫色';

  @override
  String get themeColorCustom => '自定义';

  @override
  String get customTheme => '自定义主题';
}
