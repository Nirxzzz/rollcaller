import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/attendance_caller_model.dart';
import '../models/student_class_model.dart';
import '../utils/attendance_caller_dao.dart';
import '../utils/student_class_dao.dart';

class AttendanceCallerAddEditDialog extends StatefulWidget {
  final AttendanceCallerModel attendanceCaller;
  final String title;
  final bool isAdd;

  const AttendanceCallerAddEditDialog({
    super.key,
    required this.attendanceCaller,
    required this.title,
    required this.isAdd,
  });

  @override
  State<StatefulWidget> createState() {
    return _AttendanceCallerAddEditDialogState();
  }
}

class _AttendanceCallerAddEditDialogState
    extends State<AttendanceCallerAddEditDialog> {
  final TextEditingController _attendanceCallerNameController =
      TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final GlobalKey _formKey = GlobalKey<FormState>();
  int _selectedStudentClassId = -1;
  bool _isAdd = false;
  Map<int, StudentClassModel>? _allStudentClassesMap = {};

  @override
  initState() {
    super.initState();
    _selectedStudentClassId = widget.attendanceCaller.classId;
    _isAdd = widget.isAdd;
    _attendanceCallerNameController.text =
        widget.attendanceCaller.attendanceCallerName;
    _notesController.text = widget.attendanceCaller.notes;
  }

  @override
  dispose() {
    super.dispose();
    _attendanceCallerNameController.dispose();
    _notesController.dispose();
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
      future: _getAllStudentClassesMap(),
      builder: (context, snapshot) {
        final l10n = AppLocalizations.of(context);
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            _allStudentClassesMap = snapshot.data;
            if (_selectedStudentClassId == -1 &&
                _allStudentClassesMap!.isNotEmpty) {
              _selectedStudentClassId = _allStudentClassesMap!.keys.first;
            }
            return AlertDialog(
              title: Text(widget.title),
              content: Form(
                key: _formKey,
                child: SizedBox(
                  width: double.maxFinite,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      _buildAttendanceCallerNameField(),
                      _buildNotesField(l10n.notesOptional),
                      _buildClassIdField(),
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
                  onPressed: () {
                    if (_allStudentClassesMap!.isEmpty) {
                      // 显示SnackBar
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              l10n.noClassCannotAddCaller,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onInverseSurface,
                              ),
                            ),
                            backgroundColor: Theme.of(context).colorScheme.inverseSurface,
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      }
                      Navigator.of(context).pop(false);
                      return;
                    }
                    _saveAttendanceCaller(context);
                  },
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

  TextFormField _buildAttendanceCallerNameField() {
    final l10n = AppLocalizations.of(context);
    bool isAttendanceCallerNameUnique = true;

    return TextFormField(
      controller: _attendanceCallerNameController,
      decoration: InputDecoration(labelText: l10n.callerName),
      autovalidateMode: AutovalidateMode.onUnfocus,
      onChanged: (value) {
        WidgetsFlutterBinding.ensureInitialized(); // 确保初始化Flutter绑定。对于插件很重要。
        AttendanceCallerDao attendanceCallerDao = AttendanceCallerDao();
        attendanceCallerDao.isAttendanceCallerNameExist(value).then((v) {
          if (v) {
            if (!_isAdd &&
                widget.attendanceCaller.attendanceCallerName ==
                    _attendanceCallerNameController.text) {
              isAttendanceCallerNameUnique = true;
            } else {
              isAttendanceCallerNameUnique = false;
            }
          } else {
            isAttendanceCallerNameUnique = true;
          }
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return l10n.callerNameRequired;
        }
        if (!isAttendanceCallerNameUnique) {
          return l10n.valueDuplicated(value);
        }
        return null;
      },
    );
  }

  TextField _buildNotesField(String label) {
    return TextField(
      decoration: InputDecoration(labelText: label),
      controller: _notesController,
    );
  }

  Widget _buildClassIdField() {
    final l10n = AppLocalizations.of(context);
    if (_allStudentClassesMap!.isEmpty) {
      return Text(l10n.noClassCannotAddCaller);
    }

    return RadioGroup<int>(
      groupValue: _selectedStudentClassId,
      onChanged: _isAdd
          ? (value) {
              setState(() {
                _selectedStudentClassId = value!;
              });
            }
          : (value) {
              null;
            },
      child: Column(
        children: _allStudentClassesMap!.values
            .map(
              (e) => RadioListTile<int>(
                value: e.id!,
                title: Text(
                  e.className,
                ),
                fillColor: WidgetStateProperty.all(
                  _isAdd ? Theme.of(context).colorScheme.onSurface : Theme.of(context).disabledColor,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  void _saveAttendanceCaller(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if ((_formKey.currentState as FormState).validate()) {
      widget.attendanceCaller.attendanceCallerName =
          _attendanceCallerNameController.text;
      widget.attendanceCaller.classId = _selectedStudentClassId;
      widget.attendanceCaller.notes = _notesController.text;
      if (_isAdd) {
        // 新增点名器
        widget.attendanceCaller.created = DateTime.now();
        AttendanceCallerDao()
            .insertAttendanceCaller(widget.attendanceCaller)
            .then((value) {
              if (context.mounted) {
                if (value != 0) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    SnackBar(
                      content: Text(
                        l10n.addSuccess,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onInverseSurface,
                        ),
                      ),
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.inverseSurface,
                    ),
                  );
                  Navigator.of(context).pop(true);
                } else {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    SnackBar(
                      content: Text(
                        l10n.addFailed,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onInverseSurface,
                        ),
                      ),
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.inverseSurface,
                    ),
                  );
                  Navigator.of(context).pop(false);
                }
              }
            });
      } else {
        AttendanceCallerDao()
            .updateAttendanceCaller(widget.attendanceCaller)
            .then((value) {
              if (context.mounted) {
                if (value != 0) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    SnackBar(
                      content: Text(
                        l10n.updateSuccess,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onInverseSurface,
                        ),
                      ),
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.inverseSurface,
                    ),
                  );
                  Navigator.of(context).pop(true);
                } else {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    SnackBar(
                      content: Text(
                        l10n.updateFailed,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onInverseSurface,
                        ),
                      ),
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.inverseSurface,
                    ),
                  );
                  Navigator.of(context).pop(false);
                }
              }
            });
      }
    }
  }
}
