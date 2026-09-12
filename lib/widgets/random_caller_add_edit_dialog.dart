import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/random_caller_model.dart';
import '../models/student_class_model.dart';
import '../utils/random_caller_dao.dart';
import '../utils/student_class_dao.dart';

class RandomCallerAddEditDialog extends StatefulWidget {
  final RandomCallerModel randomCaller;
  final String title;
  final bool isAdd;

  const RandomCallerAddEditDialog({
    super.key,
    required this.randomCaller,
    required this.title,
    required this.isAdd,
  });

  @override
  State<StatefulWidget> createState() {
    return _RandomCallerAddEditDialogState();
  }
}

class _RandomCallerAddEditDialogState extends State<RandomCallerAddEditDialog> {
  final TextEditingController _randomCallerNameController =
      TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final GlobalKey _formKey = GlobalKey<FormState>();
  int _selectedStudentClassId = -1;
  bool _isAdd = false;
  bool _isDuplicate = false;
  Map<int, StudentClassModel>? _allStudentClassesMap = {};

  @override
  initState() {
    super.initState();
    _selectedStudentClassId = widget.randomCaller.classId;
    _isDuplicate = widget.randomCaller.isDuplicate == 1;
    _isAdd = widget.isAdd;
    _randomCallerNameController.text = widget.randomCaller.randomCallerName;
    _notesController.text = widget.randomCaller.notes;
  }

  @override
  dispose() {
    _randomCallerNameController.dispose();
    _notesController.dispose();
    super.dispose();
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
                      _buildRollCallerNameField(),
                      _buildNotesField(l10n.notesOptional),
                      _buildIsDuplicateField(),
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
                    _saveRandomCaller(context);
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

  TextFormField _buildRollCallerNameField() {
    final l10n = AppLocalizations.of(context);
    bool isRollCallerNameUnique = true;

    return TextFormField(
      controller: _randomCallerNameController,
      decoration: InputDecoration(labelText: l10n.callerName),
      autovalidateMode: AutovalidateMode.onUnfocus,
      onChanged: (value) {
        WidgetsFlutterBinding.ensureInitialized(); // 确保初始化Flutter绑定。对于插件很重要。
        RandomCallerDao randomCallerDao = RandomCallerDao();
        randomCallerDao.isRollCallerNameExist(value).then((v) {
          if (v) {
            if (!_isAdd &&
                widget.randomCaller.randomCallerName ==
                    _randomCallerNameController.text) {
              isRollCallerNameUnique = true;
            } else {
              isRollCallerNameUnique = false;
            }
          } else {
            isRollCallerNameUnique = true;
          }
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return l10n.callerNameRequired;
        }
        if (!isRollCallerNameUnique) {
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
                  style: TextStyle(color: _isAdd ? Theme.of(context).colorScheme.onSurface : Theme.of(context).disabledColor),
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

  void _saveRandomCaller(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if ((_formKey.currentState as FormState).validate()) {
      widget.randomCaller.randomCallerName = _randomCallerNameController.text;
      widget.randomCaller.classId = _selectedStudentClassId;
      widget.randomCaller.isDuplicate = _isDuplicate ? 1 : 0;
      widget.randomCaller.notes = _notesController.text;
      if (_isAdd) {
        // 新增点名器
        widget.randomCaller.created = DateTime.now();
        RandomCallerDao().insertRandomCaller(widget.randomCaller).then((value) {
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
        RandomCallerDao().updateRandomCaller(widget.randomCaller).then((value) {
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

  CheckboxListTile _buildIsDuplicateField() {
    final l10n = AppLocalizations.of(context);
    return CheckboxListTile(
      title: Text(l10n.allowRepeatCalling),
      value: _isDuplicate,
      onChanged: _isAdd
          ? (value) {
              setState(() {
                _isDuplicate = value!;
              });
            }
          : null,
    );
  }
}
