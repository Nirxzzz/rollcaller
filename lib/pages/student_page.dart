import 'dart:developer';
import 'dart:io';

import 'package:excel/excel.dart' hide Border;
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart' show FileSaver, MimeType;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart'
    show Permission, PermissionActions, PermissionStatusGetters;
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/student_class_group.dart';
import '../models/student_class_model.dart';
import '../models/student_model.dart';
import '../utils/attendance_call_record_dao.dart';
import '../utils/random_call_record_dao.dart';
import '../utils/student_class_dao.dart';
import '../utils/student_class_relation_dao.dart';
import '../utils/student_dao.dart';
import '../widgets/ai_import_dialog.dart';
import '../widgets/student_add_edit_dialog.dart';
import '../widgets/student_view_dialog.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  // 搜索框
  final TextEditingController _searchController = TextEditingController();
  // 新增学生的学号
  final TextEditingController studentNumberController = TextEditingController();
  // 新增学生的姓名
  final TextEditingController studentNameController = TextEditingController();
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );
  // [{班级:[学生]}] 班级学生列表
  late Map<int, StudentClassGroup> _classGroups;
  // 过滤后的班级学生列表
  Map<int, StudentClassGroup>? _filterClassGroups;
  // Future
  late Future<Map<int, StudentClassGroup>> _classGroupsFuture;

  @override
  void initState() {
    _classGroupsFuture = _getAllStudentsByClassNames();
    _searchController.addListener(() {
      String filter = _searchController.text;
      Map<int, StudentClassGroup> filterClassGroups = {};
      for (var entry in _classGroups.entries) {
        log(entry.toString());
        List<StudentModel> students = [];
        int classId = entry.key;
        StudentClassGroup group = entry.value;
        for (var student in group.students) {
          if (student.studentNumber.contains(filter) ||
              student.studentName.contains(filter)) {
            students.add(student);
          }
        }
        StudentClassGroup newGroup = StudentClassGroup(
          studentClass: group.studentClass,
          students: students,
          isExpanded: group.isExpanded,
        );
        filterClassGroups.putIfAbsent(classId, () => newGroup);
      }
      setState(() {
        _filterClassGroups = filterClassGroups;
      });
    });
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    _searchController.dispose();
    _refreshController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 顶部标题栏
            Container(
              padding: EdgeInsets.all(12.w),
              child: Text(
                l10n.studentAppBarTitle,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            Row(
              children: [
                // 搜索栏
                _searchWidget(),
                // 下载学生导入模板
                IconButton(
                  onPressed: () {
                    _copyStudentImportTemplateExcel();
                  },
                  icon: Icon(
                    Icons.file_copy,
                    color: Theme.of(context).colorScheme.secondary,
                    size: Theme.of(context).textTheme.headlineLarge?.fontSize,
                  ),
                ),
                // 导入学生
                IconButton(
                  onPressed: () {
                    _importStudentsFromExcel();
                  },
                  icon: Icon(
                    Icons.download,
                    color: Theme.of(context).colorScheme.secondary,
                    size: Theme.of(context).textTheme.headlineLarge?.fontSize,
                  ),
                ),
                // AI 智能导入
                IconButton(
                  onPressed: () {
                    _importStudentsFromAi();
                  },
                  icon: Icon(
                    Icons.auto_awesome,
                    color: Theme.of(context).colorScheme.primary,
                    size: Theme.of(context).textTheme.headlineLarge?.fontSize,
                  ),
                ),
              ],
            ),
            // 班级列表
            Expanded(
              child: FutureBuilder<Map<int, StudentClassGroup>>(
                future: _classGroupsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      _classGroups = snapshot.data ?? {};
                      _filterClassGroups ??= Map.from(_classGroups);

                      return SmartRefresher(
                        // 启用下拉刷新
                        enablePullDown: true,
                        // 启用上拉加载
                        enablePullUp: false,
                        // 水滴效果头部
                        header: WaterDropHeader(),
                        // 经典底部加载
                        footer: ClassicFooter(
                          loadStyle: LoadStyle.ShowWhenLoading,
                        ),
                        controller: _refreshController,
                        onRefresh: _onRefresh,
                        onLoading: _onLoading,
                        child: ListView.builder(
                          itemCount: _filterClassGroups?.length,
                          itemBuilder: (context, groupIndex) {
                            var group =
                                _filterClassGroups?[_filterClassGroups?.keys
                                    .toList()[groupIndex]]!;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _classTitleWidget(groupIndex),
                                if (group!.isExpanded)
                                  Column(
                                    children: group.students.map((student) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.h,
                                          vertical: 2.w,
                                        ),
                                        child: _studentItemWidget(student),
                                      );
                                    }).toList(),
                                  ),
                              ],
                            );
                          },
                        ),
                      );
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
      // 浮动添加按钮
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () => {
          showDialog(
            context: context,
            builder: (context) => StudentAddEditDialog(
              student: StudentModel(
                studentName: '',
                studentNumber: '',
                created: DateTime.now(),
              ),
              title: l10n.addStudent,
              isAdd: true,
            ),
          ).then((value) {
            if (value == true) {
              _refreshClassGroupData();
            }
          }),
        },
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
      ),
    );
  }

  Future<Map<int, StudentClassGroup>> _getAllStudentsByClassNames() async {
    WidgetsFlutterBinding.ensureInitialized(); // 确保初始化Flutter绑定。对于插件很重要。
    var studentDao = StudentDao(); // 创建StudentDao实例。
    Map<int, StudentClassGroup> classGroups = {};
    final List<StudentClassModel> studentClasses = [];
    // 获取所有班级数据
    WidgetsFlutterBinding.ensureInitialized(); // 确保初始化Flutter绑定。对于插件很重要。
    var classDao = StudentClassDao(); // 创建StudentClassDao实例。
    await classDao.getAllStudentClasses().then(
      (value) => studentClasses.addAll(value),
    );
    for (StudentClassModel classModel in studentClasses) {
      List<StudentModel> students = [];
      List<int> studentIds = await StudentClassRelationDao()
          .getAllStudentIdsByClassId(classModel.id!);
      for (int studentId in studentIds) {
        var student = await studentDao.getStudentById(studentId);
        // 添加学生班级信息
        var classIds = await StudentClassRelationDao()
            .getAllClassIdsByStudentId(studentId);
        for (int classId in classIds) {
          student!.classesMap[classId] = await classDao.getStudentClass(
            classId,
          );
        }
        if (student != null) {
          students.add(student);
        }
      }
      StudentClassGroup classGroup = StudentClassGroup(
        studentClass: classModel,
        students: students,
      );
      classGroups[classModel.id!] = classGroup;
    }
    // 查询有的学生没有班级
    // 所有学生
    var allStudents = await studentDao.getAllStudents();
    // 所有有班级学生
    var allStudentClassIds = Set.from(
      await StudentClassRelationDao().getAllStudentIds(),
    );
    allStudents.removeWhere(
      (student) => allStudentClassIds.contains(student.id),
    );

    var studentClass = StudentClassModel(
      // Sentinel group (id = -1) for students without a class; its label is
      // resolved via AppLocalizations.noClassStudent at display time.
      className: '',
      studentQuantity: allStudents.length,
      teacherName: '',
      notes: '',
      classQuantity: allStudents.length,
      created: DateTime.now(),
    );
    studentClass.id = -1;
    StudentClassGroup classGroup = StudentClassGroup(
      studentClass: studentClass,
      students: allStudents,
    );
    classGroups[-1] = classGroup;
    _filterClassGroups = classGroups;
    return classGroups;
  }

  void _refreshClassGroupData() async {
    setState(() {
      _classGroupsFuture = _getAllStudentsByClassNames();
    });
  }

  // AI 智能导入入口：弹窗返回导入人数后刷新并提示
  Future<void> _importStudentsFromAi() async {
    final count = await showDialog<int>(
      context: context,
      builder: (_) => const AiImportDialog(),
    );
    if (count != null && count > 0 && mounted) {
      _refreshClassGroupData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).importStudentsSuccess(count),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onInverseSurface,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.inverseSurface,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _onRefresh() async {
    _refreshClassGroupData();
    // 刷新完成
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // _refreshClassGroupData();
    // 加载完成
    _refreshController.loadComplete();
  }

  Expanded _searchWidget() {
    final l10n = AppLocalizations.of(context);
    return Expanded(
    child: Padding(
      padding: EdgeInsets.all(8.r),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: l10n.searchStudentNumberOrName,
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.zero),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 6.h, vertical: 4.w),
          filled: true,
        ),
      ),
    ),
    );
  }

  GestureDetector _classTitleWidget(int groupIndex) {
    final l10n = AppLocalizations.of(context);
    StudentClassGroup group =
        _filterClassGroups![_filterClassGroups?.keys.toList()[groupIndex]]!;
    return GestureDetector(
      onTap: () => setState(() {
        _filterClassGroups![_filterClassGroups!.keys.toList()[groupIndex]]!
                .isExpanded =
            !_filterClassGroups![_filterClassGroups!.keys.toList()[groupIndex]]!
                .isExpanded;
      }),
      child: Container(
        padding: EdgeInsets.only(
          left: 8.h,
          right: 8.h,
          top: 12.w,
          bottom: 12.w,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              group.studentClass.id == -1
                  ? l10n.noClassStudent
                  : group.studentClass.className,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Text(
              l10n.peopleCount(group.students.length),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(110),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _studentItemWidget(StudentModel student) {
    final l10n = AppLocalizations.of(context);
    final String createdDateString =
        '${student.created.year}-${student.created.month.toString().padLeft(2, '0')}-${student.created.day.toString().padLeft(2, '0')}';
    return Container(
      margin: EdgeInsets.only(
        bottom: 8.0.h,
      ),
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 2.w,
        ),
        borderRadius: BorderRadius.zero,
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).colorScheme.outline,
              offset: Offset(4.w, 4.h),
              blurRadius: 0,
            ),
          ],
        
      ),
      
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      student.studentName,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.h,
                        vertical: 2.w,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.zero,
                      ),
                      child: Text(
                        student.studentNumber,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  l10n.createdAtLabel(createdDateString),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withAlpha(100),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.visibility,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                onPressed: () {
                  // 查看功能
                  showDialog(
                    context: context,
                    builder: (context) => StudentViewDialog(student: student),
                  );
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                onPressed: () {
                  // 编辑功能
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StudentAddEditDialog(
                        student: student,
                        title: l10n.editStudent,
                        isAdd: false,
                      );
                    },
                  ).then((value) {
                    if (value == true) {
                      _refreshClassGroupData();
                    }
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.error,
                ),
                onPressed: () {
                  // 删除功能
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(l10n.confirmDelete),
                      content: Text(l10n.confirmDeleteStudentContent),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(l10n.cancel),
                        ),
                        TextButton(
                          onPressed: () async {
                            // 校验是否有随机点名记录
                            RandomCallRecordDao randomCallRecordDao =
                                RandomCallRecordDao();
                            var randomCallRecords = await randomCallRecordDao
                                .getRandomCallRecordsByStudentId(student.id!);
                            // 校验是否有签到点名记录
                            AttendanceCallRecordDao attendanceCallRecordDao =
                                AttendanceCallRecordDao();
                            var attendanceCallRecords =
                                await attendanceCallRecordDao
                                    .getAttendanceCallRecordsByStudentId(
                                      student.id!,
                                    );
                            if (randomCallRecords.isNotEmpty ||
                                attendanceCallRecords.isNotEmpty) {
                              // 有随机点名记录，提示用户先删除随机点名记录
                              // 显示SnackBar
                              if (context.mounted) {
                                Navigator.of(context).pop(); // 关闭确认弹窗
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      l10n.confirmDeleteStudentWarnningDetail,
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.onInverseSurface,
                                      ),
                                    ),
                                    backgroundColor: Theme.of(context).colorScheme.inverseSurface,
                                    duration: const Duration(seconds: 3),
                                  ),
                                );
                              }
                              return;
                            }
                            // 删除学生
                            await StudentDao().deleteStudentById(student.id);
                            // 删除学生班级关系表中相关的数据
                            await StudentClassRelationDao().deleteStudentClasses(student.id!);
                            if (context.mounted) {
                              // 刷新学生列表
                              _refreshClassGroupData();
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text(l10n.delete),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _importStudentsFromExcel() async {
    // Capture localizations before any async gap.
    final l10n = AppLocalizations.of(context);
    try {
      // 选择Excel文件
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );
      if (result == null) return; // 用户取消选择
      // 读取文件
      var bytes = File(result.files.single.path!).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      int totalCount = 0;
      // Parse the student worksheet. Headers are accepted in both languages
      // so files generated in any locale (and the bundled Chinese template)
      // always import correctly.
      const studentNumberHeaders = {'学号', 'Student No.', 'Student Number'};
      const studentNameHeaders = {'姓名', 'Name'};
      const classHeaders = {'班级', 'Class', 'Classes'};
      for (var table in excel.tables.keys) {
        // Read the header row and locate the number/name/class columns
        var firstColumn = excel.tables[table]!.rows[0];
        int studentNumberIndex = -1;
        int nameIndex = -1;
        int classNameIndex = -1;
        for (var i = 0; i < firstColumn.length; i++) {
          final header = firstColumn[i]?.value?.toString().trim() ?? '';
          if (header == l10n.studentNumber ||
              studentNumberHeaders.contains(header)) {
            studentNumberIndex = i;
          } else if (header == l10n.name ||
              studentNameHeaders.contains(header)) {
            nameIndex = i;
          } else if (header == l10n.className ||
              classHeaders.contains(header)) {
            classNameIndex = i;
          }
        }
        // Read student data starting from the second row
        for (var row in excel.tables[table]!.rows.skip(1)) {
          String studentNumber =
              row[studentNumberIndex]?.value?.toString() ?? '';
          String name = row[nameIndex]?.value?.toString() ?? '';
          String className = row[classNameIndex]?.value?.toString() ?? '';
          if (studentNumber.isEmpty || name.isEmpty || className.isEmpty) {
            // 如果有为空的信息
            continue;
          }
          // 确保班级存在
          int classId = -1;
          var studentClass = await StudentClassDao().getStudentClassByClassName(
            className,
          );
          if (studentClass == null) {
            // 班级不存在，创建新班级
            studentClass = StudentClassModel(
              className: className,
              created: DateTime.now(),
              studentQuantity: 0,
              teacherName: '',
              notes: '',
            );
            classId = await StudentClassDao().insertStudentClass(studentClass);
          } else {
            classId = studentClass.id!;
          }
          // 判断学生是否存在
          if (await StudentDao().isStudentNumberExist(studentNumber)) {
            // 获取学生信息
            var student = await StudentDao().getStudentByStudentNumber(
              studentNumber,
            );
            // 确认学生班级不包含该班级
            if (await StudentClassRelationDao().isStudentClassRelationExist(
              student?.id!,
              classId,
            )) {
              // 如果存在，跳过
              continue;
            }
            // 更新学生班级关系信息
            await StudentClassRelationDao().insertStudentClassRelation({
              'student_id': student?.id!,
              'class_id': classId,
            });
          } else {
            // 创建新学生
            var student = StudentModel(
              studentNumber: studentNumber,
              studentName: name,
              created: DateTime.now(),
            );
            int studentId = await StudentDao().insertStudent(student);
            // 更新学生班级关系信息
            await StudentClassRelationDao().insertStudentClassRelation({
              'student_id': studentId,
              'class_id': classId,
            });
          }
          totalCount++;
        }
      }
      // 显示SnackBar
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.importStudentsSuccess(totalCount),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onInverseSurface,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.inverseSurface,
            duration: const Duration(seconds: 3),
          ),
        );
      }
      _refreshClassGroupData();
    } catch (e) {
      // 显示SnackBar
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.importStudentsError,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onInverseSurface,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.inverseSurface,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _copyStudentImportTemplateExcel() {
    // Capture localizations before any async gap.
    final l10n = AppLocalizations.of(context);
    final isEnglishLocale =
        Localizations.localeOf(context).languageCode == 'en';
    final templateAssetPath = isEnglishLocale
        ? 'assets/templates/student_import_template_en.xlsx'
        : 'assets/templates/student_import_template.xlsx';
    final templateFileName = isEnglishLocale
        ? 'student_import_template_en'
        : 'student_import_template';
    // Request permission
    Permission.manageExternalStorage.request().then((status) {
      if (!status.isGranted) {
        // 处理权限拒绝
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                l10n.pleaseGrantStoragePermission,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onInverseSurface,
                ),
              ),
              backgroundColor: Theme.of(context).colorScheme.inverseSurface,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } else {
        // 权限已授予，执行文件保存操作
        rootBundle.load(templateAssetPath).then((value) {
          FileSaver.instance
              .saveFile(
                bytes: value.buffer.asUint8List(),
                name: templateFileName,
                fileExtension: "xlsx",
                mimeType: MimeType.microsoftExcel,
              )
              .then((value) {
                if(context.mounted) {
                  // 显示SnackBar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        l10n.templateCopied(value),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onInverseSurface,
                        ),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.inverseSurface,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              });
        });
      }
    });
  }
}
