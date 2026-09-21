import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../l10n/generated/app_localizations.dart';
import '../widgets/brutal/brutal_widgets.dart';
import 'attendence_page.dart';
import 'random_call_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 0表示随机点名，1表示签到点名
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: 4.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top title
              Container(
                padding: EdgeInsets.all(12.w),
                child: Text(
                  l10n.homeAppBarTitle,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 随机点名按钮
                  _buildRandomRollCallButton(scheme),
                  _buildAttendenceButton(scheme),
                ],
              ),
              _selectedIndex == 0 ? RandomCallPage() : AttendencePage(),
            ],
          ),
        ),
      ),
    );
  }

  Expanded _buildRandomRollCallButton(ColorScheme scheme) {
    final selected = _selectedIndex == 0;
    return Expanded(
      flex: 1,
      child: Container(
        margin: EdgeInsets.only(left: 8.w, right: 4.w),
        child: BrutalButton(
          label: AppLocalizations.of(context).randomCallTab,
          icon: Icons.shuffle,
          color: selected ? scheme.primary : scheme.surface,
          foregroundColor: selected ? scheme.onPrimary : scheme.outline,
          onPressed: () {
            setState(() {
              _selectedIndex = 0;
            });
            // 随机点名功能
          },
        ),
      ),
    );
  }

  Expanded _buildAttendenceButton(ColorScheme scheme) {
    final selected = _selectedIndex == 1;
    return Expanded(
      flex: 1,
      child: Container(
        margin: EdgeInsets.only(left: 4.w, right: 8.w),
        child: BrutalButton(
          label: AppLocalizations.of(context).attendanceTab,
          icon: Icons.check_circle,
          color: selected ? scheme.primary : scheme.surface,
          foregroundColor: selected ? scheme.onPrimary : scheme.outline,
          onPressed: () {
            setState(() {
              _selectedIndex = 1;
            });
            // 签到点名功能
          },
        ),
      ),
    );
  }
}
