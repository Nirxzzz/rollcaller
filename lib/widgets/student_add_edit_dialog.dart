import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/student_class_model.dart';
import '../models/student_model.dart';
import '../utils/student_class_dao.dart';
import '../utils/student_class_relation_dao.dart';
import '../utils/student_dao.dart';

class StudentAddEditDialog extends StatefulWidget {
  final StudentModel student;
  final String title;
  final bool isAdd;

  const StudentAddEditDialog({
    super.key,
    required this.student,
    required this.title,
    required this.isAdd,
  });

  @override
  State<StatefulWidget> createState() {
    return _StudentAddEditDialogState();
  }
}

class _StudentAddEditDialogState extends State<StudentAddEditDialog> {
  final TextEditingController _studentNameController = TextEditingController();
  final TextEditingController _studentNumberController =
      TextEditingController();
  final GlobalKey _formKey = GlobalKey<FormState>();

  Future<Map<int, StudentClassModel>>? _allStudentClassesMapFuture;

  // 选中的班级{id:bool}
  Map<int, bool>? _selectedClasses;
  // 所有班级消息
  late Map<int, StudentClassModel> _allStudentClassesMap;

  bool _isAdd = false;
  @override
  void initState() {
    super.initState();
    _allStudentClassesMapFuture = _getAllStudentClassesMap();
    _isAdd = widget.isAdd;
    _studentNameController.text = widget.student.studentName;
    _studentNumberController.text = widget.student.studentNumber;
  }

  @override
  dispose() {
    super.dispose();
    _studentNameController.dispose();
    _studentNumberController.dispose();
  }

  Future<Map<int, StudentClassModel>> _getAllStudentClassesMap() async {
    Map<int, StudentClassModel> allStudentClassesMap = {};
    StudentClassDao studentClassDao = StudentClassDao();
    return await studentClassDao.getAllStudentClasses().then((value) {
      for (var element in value) {
        allStudentClassesMap[element.id!] = element;
      }
      return allStudentClassesMap;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<int, StudentClassModel>>(
      future: _allStudentClassesMapFuture,
      builder: (context, snapshot) {
        final l10n = AppLocalizations.of(context);
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            _allStudentClassesMap = snapshot.data!;
            if (_selectedClasses == null) {
              _selectedClasses = {};
              for (var element in _allStudentClassesMap.keys) {
                _selectedClasses![element] = false;
              }
              // 初始化学生所在的班级（可能有多个班级）
              if (widget.student.allClasses.isNotEmpty) {
                for (StudentClassModel element in widget.student.allClasses) {
                  _selectedClasses![element.id!] = true;
                }
              }
            }
            return AlertDialog(
              title: Text(widget.title),
              content: Form(
                key: _formKey,
                child: SizedBox(
                  width: double.maxFinite,
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    children: [
                      // 学生学号
                      _buildStudentNumberField(),
                      // 学生姓名
                      _buildStudengNameField(),
                      SizedBox(height: 4.h),
                      // Class selection
                      Text(l10n.affiliatedClasses),
                      _buildClassSelectField(),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(l10n.cancel),
                ),
                TextButton(
                  onPressed: () => _saveOnPressed(context),
                  child: Text(l10n.save),
                ),
              ],
            );
          }
        }
        return const CircularProgressIndicator();
      },
    );
  }

  TextFormField _buildStudentNumberField() {
    final l10n = AppLocalizations.of(context);
    bool isStudentNumberUnique = true;
    return TextFormField(
      decoration: InputDecoration(
        labelText: l10n.studentNumberField,
        hintText: l10n.studentNumberHint,
      ),
      controller: _studentNumberController,
      autovalidateMode: AutovalidateMode.onUnfocus,
      onChanged: (value) {
        WidgetsFlutterBinding.ensureInitialized(); // 确保初始化Flutter绑定。对于插件很重要。
        var studentDao = StudentDao(); // 创建StudentstudentDao实例。
        studentDao
            .isStudentNumberExist(value)
            .then(
              (onValue) => {
                if (onValue)
                  {
                    if (!_isAdd &&
                        (_studentNumberController.text ==
                            widget.student.studentNumber))
                      isStudentNumberUnique = true
                    else
                      isStudentNumberUnique = false,
                  }
                else
                  isStudentNumberUnique = true,
              },
            );
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return l10n.studentNumberRequired;
        }
        if (!isStudentNumberUnique) {
          return l10n.valueDuplicated(value);
        }
        return null; // 如果没有找到重复值，返回null表示验证通过
      },
    );
  }

  TextFormField _buildStudengNameField() {
    final l10n = AppLocalizations.of(context);
    return TextFormField(
      decoration: InputDecoration(
        labelText: l10n.studentNameField,
        hintText: l10n.studentNameHint,
      ),
      controller: _studentNameController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return l10n.studentNameRequired;
        }
        return null;
      },
    );
  }

  Column _buildClassSelectField() {
    return Column(
      children: List.generate(_allStudentClassesMap.length, (index) {
        return CheckboxListTile(
          value: _selectedClasses![_allStudentClassesMap.keys.toList()[index]],
          title: Text(
            _allStudentClassesMap[_allStudentClassesMap.keys.toList()[index]]!
                .className,
          ),
          onChanged: (value) {
            setState(() {
              _selectedClasses![_allStudentClassesMap.keys.toList()[index]] =
                  value!;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          dense: true,
        );
      }),
    );
  }

  void _saveOnPressed(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    if ((_formKey.currentState as FormState).validate()) {
      WidgetsFlutterBinding.ensureInitialized(); // 确保初始化Flutter绑定。对于插件很重要。
      var studentDao = StudentDao(); // 创建StudentstudentDao实例。
      // 更新学生信息
      widget.student.studentNumber = _studentNumberController.text;
      widget.student.studentName = _studentNameController.text;
      List<int> classIds = [];
      _selectedClasses!.forEach((key, value) {
        if (value) {
          classIds.add(key);
        }
      });
      // 更新学生班级关系
      widget.student.classesMap = {};
      for (int classId in classIds) {
        widget.student.classesMap[classId] = _allStudentClassesMap[classId]!;
      }
      // 判断是新增还是修改
      if (_isAdd) {
        // 新增学生
        widget.student.created = DateTime.now();
        int id = await studentDao.insertStudent(widget.student);
        // 添加学生列表成功
        if (id != 0) {
          // 添加学生班级关系
          widget.student.id = id;
          await StudentClassRelationDao().insertStudentClasses(
            widget.student.id!,
            classIds,
          );
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  l10n.createSuccess,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onInverseSurface,
                  ),
                ),
                backgroundColor: Theme.of(context).colorScheme.inverseSurface,
              ),
            );
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  l10n.createFailed,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onInverseSurface,
                  ),
                ),
                backgroundColor: Theme.of(context).colorScheme.inverseSurface,
              ),
            );
          }
        }
      } else {
        // 修改学生
        int status = await studentDao.updateStudentById(widget.student);
        if (status != 0) {
          // 删除该学生所有的班级关系
          await StudentClassRelationDao().deleteStudentClasses(
            widget.student.id!,
          );
          // 添加该学生的班级关系
          await StudentClassRelationDao().insertStudentClasses(
            widget.student.id!,
            classIds,
          );
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  l10n.updateSuccess,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onInverseSurface,
                  ),
                ),
                backgroundColor: Theme.of(context).colorScheme.inverseSurface,
              ),
            );
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  l10n.updateFailed,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onInverseSurface,
                  ),
                ),
                backgroundColor: Theme.of(context).colorScheme.inverseSurface,
              ),
            );
          }
        }
      }
    }
    if (context.mounted) {
      Navigator.of(context).pop(true); // 关闭弹窗
    }
  }
}
