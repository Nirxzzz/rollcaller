// AI 名单导入对话框：文本粘贴 / 照片识别 → 预览编辑 → 确认导入
import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../configs/strings.dart';
import '../l10n/generated/app_localizations.dart';
import '../models/student_class_model.dart';
import '../models/student_model.dart';
import '../services/ai_import_service.dart';
import '../utils/student_class_dao.dart';
import '../utils/student_class_relation_dao.dart';
import '../utils/student_dao.dart';
import 'brutal/brutal_widgets.dart';

/// 返回成功导入的学生人数；取消时返回 null
class AiImportDialog extends StatefulWidget {
  const AiImportDialog({super.key});

  @override
  State<AiImportDialog> createState() => _AiImportDialogState();
}

class _AiImportDialogState extends State<AiImportDialog> {
  static const int _newClassValue = -1;
  static const int _maxImageBytes = 6 * 1024 * 1024;

  List<StudentClassModel> _classes = [];
  int? _selectedClassId;
  bool _newClassMode = false;
  final TextEditingController _newClassNameController = TextEditingController();

  bool _imageMode = false;
  final TextEditingController _textController = TextEditingController();
  Uint8List? _imageBytes;

  bool _parsing = false;
  String? _error;
  List<AiStudent> _students = [];

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  @override
  void dispose() {
    _textController.dispose();
    _newClassNameController.dispose();
    super.dispose();
  }

  Future<void> _loadClasses() async {
    final classes = await StudentClassDao().getAllStudentClasses();
    if (!mounted) return;
    setState(() {
      _classes = classes;
      _selectedClassId = classes.isNotEmpty ? classes.first.id : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
          width: 2,
        ),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 480.w,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题
              Text(
                l10n.aiImportTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 4.h),
              Text(
                l10n.aiImportIntro,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SizedBox(height: 8.h),

              // 目标班级
              _buildClassSelector(l10n),
              SizedBox(height: 8.h),

              // 输入方式切换
              Row(
                children: [
                  Expanded(
                    child: BrutalButton(
                      label: l10n.aiImportPasteText,
                      expand: true,
                      color: !_imageMode
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.surface,
                      foregroundColor: !_imageMode
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.outline,
                      onPressed: () => setState(() {
                        _imageMode = false;
                        _error = null;
                      }),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: BrutalButton(
                      label: l10n.aiImportPickImage,
                      expand: true,
                      color: _imageMode
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.surface,
                      foregroundColor: _imageMode
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.outline,
                      onPressed: () => setState(() {
                        _imageMode = true;
                        _error = null;
                      }),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),

              // 输入区
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!_imageMode)
                        TextField(
                          controller: _textController,
                          maxLines: 6,
                          decoration: InputDecoration(
                            hintText: l10n.aiImportPasteHint,
                          ),
                        )
                      else ...[
                        BrutalButton(
                          label: l10n.aiImportPickImage,
                          icon: Icons.image,
                          color: Theme.of(context).colorScheme.secondary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onSecondary,
                          onPressed: _pickImage,
                        ),
                        if (_imageBytes != null) ...[
                          SizedBox(height: 8.h),
                          ClipRect(
                            child: Image.memory(
                              _imageBytes!,
                              height: 140.h,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ],
                      if (_error != null) ...[
                        SizedBox(height: 8.h),
                        Text(
                          _error!,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.error,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8.h),

              // 识别按钮 / 识别中
              if (_parsing)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 8.w),
                    Text(l10n.aiImportParsing,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                )
              else
                BrutalButton(
                  label: l10n.aiImportRecognize,
                  icon: Icons.auto_awesome,
                  color: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Theme.of(context).colorScheme.onSecondary,
                  onPressed: _recognize,
                ),

              // 预览区
              if (_students.isNotEmpty) ...[
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(l10n.aiImportPreviewTitle,
                          style: Theme.of(context).textTheme.titleSmall),
                    ),
                    TextButton(
                      onPressed: () => setState(() {
                        final all =
                            _students.every((s) => s.selected);
                        for (final s in _students) {
                          s.selected = !all;
                        }
                      }),
                      child: Text(l10n.aiImportSelectAll),
                    ),
                  ],
                ),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _students.length,
                    itemBuilder: (context, index) {
                      final s = _students[index];
                      return Row(
                        children: [
                          Checkbox(
                            value: s.selected,
                            onChanged: (v) =>
                                setState(() => s.selected = v ?? true),
                          ),
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              key: ValueKey('name_$index'),
                              initialValue: s.studentName,
                              onChanged: (v) => s.studentName = v.trim(),
                              decoration: const InputDecoration(
                                  isDense: true, filled: false),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              key: ValueKey('no_$index'),
                              initialValue: s.studentNumber,
                              onChanged: (v) => s.studentNumber = v.trim(),
                              decoration: const InputDecoration(
                                  isDense: true, filled: false, hintText: '学号'),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
              SizedBox(height: 8.h),

              // 底部按钮
              Row(
                children: [
                  Expanded(
                    child: BrutalButton(
                      label: l10n.cancel,
                      color: Theme.of(context).colorScheme.surface,
                      foregroundColor: Theme.of(context).colorScheme.outline,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    flex: 2,
                    child: BrutalButton(
                      label: l10n.aiImportConfirm(
                          _students.where((s) => s.selected).length),
                      icon: Icons.save,
                      color: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      onPressed:
                          _students.isEmpty || _parsing ? null : _importSelected,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---- 班级选择 ----
  Widget _buildClassSelector(AppLocalizations l10n) {
    final items = <DropdownMenuItem<int?>>[
      for (final c in _classes)
        DropdownMenuItem<int?>(value: c.id, child: Text(c.className)),
      const DropdownMenuItem<int?>(
        value: _newClassValue,
        child: Text('＋ 新建班级'),
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<int?>(
          initialValue: _newClassMode ? _newClassValue : _selectedClassId,
          items: items,
          decoration: InputDecoration(labelText: l10n.className),
          onChanged: (value) {
            setState(() {
              if (value == _newClassValue) {
                _newClassMode = true;
              } else {
                _newClassMode = false;
                _selectedClassId = value;
              }
            });
          },
        ),
        if (_newClassMode) ...[
          SizedBox(height: 8.h),
          TextField(
            controller: _newClassNameController,
            decoration: InputDecoration(labelText: l10n.className),
          ),
        ],
      ],
    );
  }

  // ---- 选图 ----
  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result == null || !mounted) return;
    final bytes = result.files.single.bytes;
    if (bytes == null) return;
    if (bytes.length > _maxImageBytes) {
      setState(() => _error = AppLocalizations.of(context).aiImportFileTooLarge);
      return;
    }
    setState(() {
      _imageBytes = bytes;
      _error = null;
    });
  }

  // ---- 识别 ----
  Future<void> _recognize() async {
    setState(() {
      _error = null;
      _students = [];
    });
    try {
      final students = await AiImportService.recognize(
        text: _imageMode ? null : _textController.text,
        base64Image:
            _imageMode && _imageBytes != null ? base64Encode(_imageBytes!) : null,
      );
      if (!mounted) return;
      if (students.isEmpty) {
        setState(() {
          _error = AppLocalizations.of(context).aiImportNoResult;
        });
        return;
      }
      setState(() => _students = students);
    } on AiImportException catch (e) {
      if (!mounted) return;
      setState(() {
        switch (e.message) {
          case 'NO_CONFIG':
            _error = AppLocalizations.of(context).aiImportNeedConfig;
            break;
          case 'EMPTY_INPUT':
            _error = AppLocalizations.of(context).aiImportNoResult;
            break;
          case 'AUTH_FAILED':
            _error = 'API Key 验证失败（401），请到设置中检查';
            break;
          case 'NO_JSON':
          case 'JSON_PARSE':
          case 'BAD_RESPONSE':
            _error = 'AI 返回内容无法解析，请重试';
            break;
          default:
            _error = e.message;
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    }
  }

  // ---- 导入 ----
  Future<void> _importSelected() async {
    final l10n = AppLocalizations.of(context);
    // 解析目标班级
    int classId;
    if (_newClassMode) {
      final name = _newClassNameController.text.trim();
      if (name.isEmpty) return;
      var cls = await StudentClassDao().getStudentClassByClassName(name);
      if (cls == null) {
        classId = await StudentClassDao().insertStudentClass(StudentClassModel(
          className: name,
          created: DateTime.now(),
          studentQuantity: 0,
          teacherName: '',
          notes: '',
        ));
      } else {
        classId = cls.id!;
      }
    } else {
      classId = _selectedClassId!;
    }

    int count = 0;
    int autoNo = 0;
    for (final s in _students.where((s) => s.selected)) {
      if (s.studentName.isEmpty) continue;
      String number = s.studentNumber.trim();
      if (number.isEmpty) {
        // 缺学号时自动生成全局唯一的三位序号
        do {
          autoNo++;
          number = autoNo.toString().padLeft(3, '0');
        } while (await StudentDao().isStudentNumberExist(number));
      }
      if (await StudentDao().isStudentNumberExist(number)) {
        final existing = await StudentDao().getStudentByStudentNumber(number);
        if (existing == null) continue;
        final inClass =
            await StudentClassRelationDao().isStudentClassRelationExist(
          existing.id!,
          classId,
        );
        if (!inClass) {
          await StudentClassRelationDao().insertStudentClassRelation({
            'student_id': existing.id!,
            'class_id': classId,
          });
          count++;
        }
      } else {
        final studentId = await StudentDao().insertStudent(StudentModel(
          studentName: s.studentName,
          studentNumber: number,
          created: DateTime.now(),
        ));
        await StudentClassRelationDao().insertStudentClassRelation({
          'student_id': studentId,
          'class_id': classId,
        });
        count++;
      }
    }

    if (!mounted) return;
    if (count > 0) {
      Navigator.of(context).pop(count);
    } else {
      setState(() {
        _error = l10n.aiImportNoResult;
      });
    }
  }
}
