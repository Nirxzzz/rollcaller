import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/attendance_caller_model.dart';
import '../models/student_class_model.dart';
import '../utils/student_class_dao.dart';

class AttendanceCallerViewDialog extends StatelessWidget {
  final AttendanceCallerModel attendanceCaller;

  const AttendanceCallerViewDialog({super.key, required this.attendanceCaller});

  Future<StudentClassModel> _getStudentClass() async {
    StudentClassDao studentClassDao = StudentClassDao();
    return await studentClassDao.getStudentClass(attendanceCaller.classId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<StudentClassModel>(
      future: _getStudentClass(),
      builder: (context, snapshot) {
        final l10n = AppLocalizations.of(context);
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          var studentClass = snapshot.data;
          final created = attendanceCaller.created;
          final createdText =
              '${created.year}-${created.month.toString().padLeft(2, '0')}-${created.day.toString().padLeft(2, '0')} '
              '${created.hour.toString().padLeft(2, '0')}:${created.minute.toString().padLeft(2, '0')}:${created.second.toString().padLeft(2, '0')}';
          return AlertDialog(
            title: Text(attendanceCaller.attendanceCallerName),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.classLabel(studentClass?.className ?? ''),
                  textAlign: TextAlign.left,
                ),
                Text(
                  l10n.notesLabel(attendanceCaller.notes),
                  textAlign: TextAlign.left,
                ),
                // Creation time
                Text(
                  l10n.createdAtLabel(createdText),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.close),
              ),
            ],
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
