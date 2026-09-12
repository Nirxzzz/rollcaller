import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/random_caller_model.dart';
import '../models/student_class_model.dart';
import '../utils/student_class_dao.dart';

class RandomCallerViewDialog extends StatelessWidget {
  final RandomCallerModel randomCaller;

  const RandomCallerViewDialog({super.key, required this.randomCaller});

  Future<StudentClassModel> _getStudentClass() async {
    StudentClassDao studentClassDao = StudentClassDao();
    return await studentClassDao.getStudentClass(randomCaller.classId);
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
          return AlertDialog(
            title: Text(randomCaller.randomCallerName),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.classLabel(studentClass?.className ?? ''),
                  textAlign: TextAlign.left,
                ),
                Text(
                  randomCaller.isDuplicate == 1
                      ? l10n.repeatableYes
                      : l10n.repeatableNo,
                  textAlign: TextAlign.left,
                ),
                Text(
                  l10n.notesLabel(randomCaller.notes),
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
