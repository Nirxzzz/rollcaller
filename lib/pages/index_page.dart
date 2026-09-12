import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/generated/app_localizations.dart';
import 'home_page.dart';
import 'records_page.dart';
import 'settings_page.dart';
import 'student_class_page.dart';
import '../providers/current_index_provider.dart';
import 'student_page.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  static const List<Widget> tabBodies = [
    HomePage(),
    StudentClassPage(),
    StudentPage(),
    RecordPage(),
    SettingsPage(),
  ];

  List<BottomNavigationBarItem> _buildBottomTabs(AppLocalizations l10n) {
    return [
      BottomNavigationBarItem(icon: const Icon(Icons.home), label: l10n.homeTitle),
      BottomNavigationBarItem(
        icon: const Icon(Icons.group),
        label: l10n.studentClassTitle,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.person),
        label: l10n.studentTitle,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.access_time),
        label: l10n.recordsTitle,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.settings),
        label: l10n.settingsTitle,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Consumer<CurrentIndexProvider>(
      builder:
          (
            BuildContext context,
            CurrentIndexProvider currentIndexProvider,
            Widget? child,
          ) {
            final int currentIndex = currentIndexProvider.currentIndex;
            return Scaffold(
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: currentIndex,
                items: _buildBottomTabs(l10n),
                onTap: (index) => {currentIndexProvider.currentIndex = index},
              ),
              body: tabBodies[currentIndex],
            );
          },
    );
  }
}
