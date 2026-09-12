import 'dart:io';

import 'package:excel/excel.dart' hide Border;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/random_call_record.dart';
import '../models/random_caller_group.dart';
import '../models/random_caller_model.dart';
import '../models/student_class_model.dart';
import '../models/student_model.dart';
import '../utils/random_call_record_dao.dart';
import '../utils/random_caller_dao.dart';
import '../utils/student_class_dao.dart';
import '../utils/student_class_relation_dao.dart';
import '../utils/student_dao.dart';

class RandomCallRecordsPage extends StatefulWidget {
  const RandomCallRecordsPage({super.key});

  @override
  State<StatefulWidget> createState() => _RandomRecordsState();
}

class _RandomRecordsState extends State<RandomCallRecordsPage> {
  // 筛选条件是否展开
  bool _isFilterExpanded = true;

  // 全部点名器
  Map<int, RandomCallerModel> _allCallers = {};
  // 全部班级
  Map<int, StudentClassModel> _allClasses = {};
  // 按点名器分组记录
  Map<int, RandomCallerGroupModel> _groupedRecords = {};
  Map<int, RandomCallerGroupModel> _filteredRecords = {};
  // 筛选条件：选中的点名器
  int? _selectedCallerId;
  // 筛选条件：选中的班级
  int? _selectedClassId;
  // 筛选条件：日期范围
  DateTime? _startDate;
  // 筛选条件：结束日期
  DateTime? _endDate;
  // 筛选条件：是否归档
  bool? _isArchiveFilter;
  // 获取所有点名器所有信息Future
  late Future<Map<int, RandomCallerGroupModel>> _allRandomCallerGroupFuture;
  final TextEditingController scoreController = TextEditingController();

  @override
  dispose() {
    super.dispose();
    scoreController.dispose();
  }

  @override
  initState() {
    super.initState();
    _allRandomCallerGroupFuture = _getAllRandomCallerGroups();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _allRandomCallerGroupFuture,
      builder: (context, snapshot) {
        final l10n = AppLocalizations.of(context);
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text(l10n.loadFailed('${snapshot.error}')));
        } else {
          _groupedRecords = snapshot.data!;
          return Expanded(
            child: Column(
              children: [
                // 筛选区域
                _buildSelectersWidget(),
                // 学生列表区域
                Expanded(
                  child: _filteredRecords.isEmpty
                      ? SingleChildScrollView(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.inbox_outlined,
                                  size:
                                      Theme.of(
                                        context,
                                      ).textTheme.headlineLarge!.fontSize! *
                                      4,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withAlpha(100),
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  l10n.noRandomCallRecord,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge!
                                      .copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface.withAlpha(100),
                                      ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  l10n.tryAdjustFilter,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface.withAlpha(100),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _filteredRecords.length,
                          itemBuilder: (context, index) {
                            final group = _filteredRecords.values
                                .toList()[index];
                            final cls = group.studentClassModel;

                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.h,
                                vertical: 4.w,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainer,
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                child: Column(
                                  children: [
                                    // 分组标题
                                    ListTile(
                                      title: Text(
                                        group
                                            .randomCallerModel
                                            .randomCallerName,
                                        style:
                                            group.randomCallerModel.isArchive ==
                                                1
                                            ? Theme.of(
                                                context,
                                              ).textTheme.titleLarge!.copyWith(
                                                color: Theme.of(
                                                  context,
                                                ).disabledColor,
                                              )
                                            : Theme.of(
                                                context,
                                              ).textTheme.titleLarge!.copyWith(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                              ),
                                      ),
                                      subtitle: Text(
                                        l10n.classRecordCount(
                                          cls.className,
                                          group.allRecords.length,
                                        ),
                                        style:
                                            group.randomCallerModel.isArchive ==
                                                1
                                            ? Theme.of(
                                                context,
                                              ).textTheme.titleMedium!.copyWith(
                                                color: Theme.of(
                                                  context,
                                                ).disabledColor,
                                              )
                                            : Theme.of(
                                                context,
                                              ).textTheme.titleMedium!.copyWith(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.tertiary,
                                              ),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // 归档按钮
                                          if (group
                                                  .randomCallerModel
                                                  .isArchive ==
                                              0)
                                            IconButton(
                                              icon: Icon(
                                                Icons.archive_outlined,
                                                size:
                                                    Theme.of(context)
                                                        .textTheme
                                                        .titleMedium!
                                                        .fontSize! *
                                                    1.5,
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.secondary,
                                              ),
                                              onPressed: () =>
                                                  _showArchiveConfirmationDialog(
                                                    group.randomCallerModel,
                                                  ),
                                              tooltip: l10n.archive,
                                            ),
                                          if (group
                                                  .randomCallerModel
                                                  .isArchive ==
                                              1)
                                            Text(
                                              l10n.archived,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge!
                                                  .copyWith(
                                                    color: Theme.of(
                                                      context,
                                                    ).disabledColor,
                                                  ),
                                            ),
                                          Icon(
                                            size:
                                                Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .fontSize! *
                                                1.5,
                                            group.isExpanded
                                                ? Icons.expand_less
                                                : Icons.expand_more,
                                            color:
                                                group
                                                        .randomCallerModel
                                                        .isArchive ==
                                                    1
                                                ? Theme.of(
                                                    context,
                                                  ).disabledColor
                                                : Theme.of(
                                                    context,
                                                  ).colorScheme.tertiary,
                                          ),
                                        ],
                                      ),
                                      onTap: () => _toggleGroupExpanded(index),
                                    ),

                                    // 展开时显示记录列表
                                    if (group.isExpanded)
                                      if (group.allRecords.isEmpty)
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 32.h,
                                            horizontal: 16.w,
                                          ),
                                          child: Text(
                                            l10n.noRandomCallRecord,
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                                  color: Theme.of(
                                                    context,
                                                  ).disabledColor,
                                                ),
                                          ),
                                        )
                                      else
                                        ListView.builder(
                                          padding: EdgeInsets.only(top: 16.h),
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: group.allRecords.length,
                                          itemBuilder: (context, recordIndex) {
                                            final RandomCallRecordModel record =
                                                group.allRecords[recordIndex];
                                            final student = group
                                                .students[record.studentId];

                                            return Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 16.h,
                                                vertical: 4.w,
                                              ),
                                              child: Card(
                                                margin: EdgeInsets.symmetric(
                                                  horizontal: 16.h,
                                                  vertical: 4.w,
                                                ),
                                                color:
                                                    group
                                                            .randomCallerModel
                                                            .isArchive ==
                                                        1
                                                    ? null
                                                    : Theme.of(context)
                                                          .colorScheme
                                                          .secondaryContainer,
                                                child: Padding(
                                                  padding: EdgeInsets.all(12.w),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .baseline,
                                                            textBaseline:
                                                                TextBaseline
                                                                    .alphabetic,
                                                            children: [
                                                              Text(
                                                                student?.studentName ??
                                                                    l10n
                                                                        .unknownStudent,
                                                                style: Theme.of(context)
                                                                    .textTheme
                                                                    .titleMedium
                                                                    ?.copyWith(
                                                                      color:
                                                                          group.randomCallerModel.isArchive ==
                                                                              1
                                                                          ? Theme.of(
                                                                              context,
                                                                            ).disabledColor
                                                                          : Theme.of(
                                                                              context,
                                                                            ).colorScheme.onSecondaryContainer,
                                                                    ),
                                                              ),
                                                              SizedBox(
                                                                width: 12.w,
                                                              ),
                                                              Text(
                                                                student?.studentNumber ??
                                                                    l10n
                                                                        .unknownStudentNumber,
                                                                style: Theme.of(context)
                                                                    .textTheme
                                                                    .bodySmall
                                                                    ?.copyWith(
                                                                      color:
                                                                          group.randomCallerModel.isArchive ==
                                                                              1
                                                                          ? Theme.of(
                                                                              context,
                                                                            ).disabledColor
                                                                          : Theme.of(
                                                                              context,
                                                                            ).colorScheme.onSecondaryContainer,
                                                                    ),
                                                              ),
                                                            ],
                                                          ),
                                                          Text(
                                                            l10n.scoreLabel(
                                                              record.score,
                                                            ),
                                                            style: TextStyle(
                                                              fontSize:
                                                                  Theme.of(
                                                                        context,
                                                                      )
                                                                      .textTheme
                                                                      .bodyMedium
                                                                      ?.fontSize,
                                                              color:
                                                                  group
                                                                          .randomCallerModel
                                                                          .isArchive ==
                                                                      1
                                                                  ? Theme.of(
                                                                      context,
                                                                    ).disabledColor
                                                                  : (record.score >=
                                                                            8
                                                                        ? Colors
                                                                              .green
                                                                              .shade900
                                                                        : Colors
                                                                              .orange
                                                                              .shade900),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        l10n.classLabel(
                                                          group
                                                              .studentClassModel
                                                              .className,
                                                        ),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall
                                                            ?.copyWith(
                                                              color:
                                                                  group
                                                                          .randomCallerModel
                                                                          .isArchive ==
                                                                      1
                                                                  ? Theme.of(
                                                                      context,
                                                                    ).disabledColor
                                                                  : Theme.of(
                                                                          context,
                                                                        )
                                                                        .colorScheme
                                                                        .onSecondaryContainer,
                                                            ),
                                                      ),
                                                      Text(
                                                        l10n.timeLabel(
                                                          record.created
                                                              .toString()
                                                              .substring(0, 19),
                                                        ),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall
                                                            ?.copyWith(
                                                              color:
                                                                  group
                                                                          .randomCallerModel
                                                                          .isArchive ==
                                                                      1
                                                                  ? Theme.of(
                                                                      context,
                                                                    ).disabledColor
                                                                  : Theme.of(
                                                                          context,
                                                                        )
                                                                        .colorScheme
                                                                        .onSecondaryContainer,
                                                            ),
                                                      ),

                                                      // 操作按钮（只有未归档的记录才显示）
                                                      if (group
                                                              .randomCallerModel
                                                              .isArchive ==
                                                          0)
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            TextButton.icon(
                                                              onPressed: () {
                                                                _showEditScoreDialog(
                                                                  record,
                                                                );
                                                              },
                                                              icon: Icon(
                                                                Icons.edit,
                                                                color: Theme.of(
                                                                  context,
                                                                ).colorScheme.tertiary,
                                                                size: Theme.of(context)
                                                                    .textTheme
                                                                    .bodyMedium
                                                                    ?.fontSize,
                                                              ),
                                                              label: Text(
                                                                l10n.edit,
                                                                style: Theme.of(context)
                                                                    .textTheme
                                                                    .bodyMedium
                                                                    ?.copyWith(
                                                                      color: Theme.of(
                                                                        context,
                                                                      ).colorScheme.tertiary,
                                                                    ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 8.w,
                                                            ),
                                                            TextButton.icon(
                                                              onPressed: () {
                                                                _showDeleteConfirmationDialog(
                                                                  record,
                                                                );
                                                              },
                                                              icon: Icon(
                                                                Icons.delete,
                                                                color: Theme.of(
                                                                  context,
                                                                ).colorScheme.error,
                                                                size: Theme.of(context)
                                                                    .textTheme
                                                                    .bodyMedium
                                                                    ?.fontSize,
                                                              ),
                                                              label: Text(
                                                                l10n.delete,
                                                                style: Theme.of(context)
                                                                    .textTheme
                                                                    .bodyMedium
                                                                    ?.copyWith(
                                                                      color: Theme.of(
                                                                        context,
                                                                      ).colorScheme.error,
                                                                    ),
                                                              ),
                                                              style: TextButton.styleFrom(
                                                                foregroundColor:
                                                                    Theme.of(
                                                                          context,
                                                                        )
                                                                        .colorScheme
                                                                        .error,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  // 筛选区域
  GestureDetector _buildSelectersWidget() {
    final l10n = AppLocalizations.of(context);
    // 筛选条件区域
    return GestureDetector(
      onTap: () {
        setState(() {
          _isFilterExpanded = !_isFilterExpanded;
        });
      },
      child: Card(
        margin: EdgeInsets.all(8.0.w),
        child: Column(
          children: [
            // 筛选条件标题和展开/折叠按钮
            Padding(
              padding: EdgeInsets.all(12.0.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.filterCondition,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),

                  TextButton.icon(
                    onPressed: _resetFilters,
                    icon: const Icon(Icons.refresh),
                    label: Text(
                      l10n.resetFilter,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _showExportDialog,
                    icon: const Icon(Icons.file_upload),
                    label: Text(
                      l10n.export,
                    ),
                  ),
                  Icon(
                    _isFilterExpanded ? Icons.expand_less : Icons.expand_more,
                  ),
                ],
              ),
            ),

            // 展开时显示筛选内容
            AnimatedCrossFade(
              firstChild: const SizedBox(height: 0, width: 0),
              secondChild: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.0.h,
                  vertical: 0.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 点名器筛选
                    Row(
                      children: [
                        SizedBox(
                          width: 100.w,
                          child: Text(
                            l10n.randomCallerLabel,
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            height: 60.h,
                            child: DropdownButtonFormField<int>(
                              initialValue: _selectedCallerId,
                              hint: Text(
                                l10n.all,
                              ),
                              items: [
                                DropdownMenuItem(
                                  value: null,
                                  child: Text(
                                    l10n.all,
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                                ..._allCallers.values.toList().map(
                                  (caller) => DropdownMenuItem(
                                    value: caller.id,
                                    child: Text(
                                      caller.randomCallerName,
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedCallerId = value;
                                  // 执行筛选
                                  _applyFilters();
                                });
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8.0.h,
                                ),
                              ),
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),

                    // 班级筛选
                    Row(
                      children: [
                        SizedBox(
                          width: 100.w,
                          child: Text(
                            l10n.classLabel(''),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            height: 60.h,
                            child: DropdownButtonFormField<int>(
                              initialValue: _selectedClassId,
                              hint: Text(
                                l10n.all,
                              ),
                              items: [
                                DropdownMenuItem(
                                  value: null,
                                  child: Text(
                                    l10n.all,
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                                ..._allClasses.values.toList().map(
                                  (cls) => DropdownMenuItem(
                                    value: cls.id,
                                    child: Text(
                                      cls.className,
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedClassId = value;
                                  // 执行筛选
                                  _applyFilters();
                                });
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8.0.h,
                                ),
                              ),
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),

                    // 时间范围筛选
                    Row(
                      children: [
                        SizedBox(
                          width: 100.w,
                          child: Text(
                            l10n.timeRangeLabel,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 60.h, // 与DropdownButtonFormField高度一致
                            child: TextButton(
                              onPressed: () {
                                _showDateRangePicker();
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              child: Container(
                                padding: EdgeInsets.all(10.w),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.outline,
                                  ),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                alignment: Alignment.centerLeft,
                                height: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _startDate != null
                                          ? '${_startDate!.year}-${_startDate!.month.toString().padLeft(2, '0')}-${_startDate!.day.toString().padLeft(2, '0')}'
                                          : l10n.startTime,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurface,
                                          ),
                                    ),
                                    Text(
                                      l10n.to,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelMedium,
                                    ),
                                    Text(
                                      _endDate != null
                                          ? '${_endDate!.subtract(const Duration(days: 1)).year}-${_endDate!.subtract(const Duration(days: 1)).month.toString().padLeft(2, '0')}-${_endDate!.subtract(const Duration(days: 1)).day.toString().padLeft(2, '0')}'
                                          : l10n.endTime,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurface,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),

                    // 归档状态筛选
                    Row(
                      children: [
                        SizedBox(
                          width: 100.w,
                          child: Text(
                            l10n.archivedLabel,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            height: 60.h,
                            child: DropdownButtonFormField<bool?>(
                              initialValue: _isArchiveFilter,
                              hint: Text(l10n.all),
                              items: [
                                DropdownMenuItem(
                                  value: null,
                                  child: Text(
                                    l10n.all,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                        ),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: false,
                                  child: Text(
                                    l10n.unarchived,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                        ),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: true,
                                  child: Text(
                                    l10n.archived,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                        ),
                                  ),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _isArchiveFilter = value;
                                  // 执行筛选
                                  _applyFilters();
                                });
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8.0.h,
                                  vertical: 12.0.w,
                                ),
                              ),
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                  ],
                ),
              ),
              crossFadeState: _isFilterExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
          ],
        ),
      ),
    );
  }

  // 显示时间范围选择器弹窗
  void _showDateRangePicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final l10n = AppLocalizations.of(context);
        return AlertDialog(
          title: Text(l10n.dateRangePickerTitle),
          content: SizedBox(
            height: 400.h,
            width: MediaQuery.of(context).size.width * 0.8,
            child: SfDateRangePicker(
              confirmText: l10n.confirm,
              cancelText: l10n.cancel,
              view: DateRangePickerView.month,
              selectionMode: DateRangePickerSelectionMode.range,
              initialSelectedRange: _startDate != null && _endDate != null
                  ? PickerDateRange(
                      _startDate,
                      _endDate?.subtract(const Duration(days: 1)),
                    )
                  : null,
              onSelectionChanged: _onDateRangeSelected,
              minDate: DateTime(2020),
              maxDate: DateTime.now(),
              showActionButtons: true,
              backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
              // 设置选中样式
              selectionColor: Theme.of(context).colorScheme.primary,
              rangeSelectionColor: Theme.of(
                context,
              ).colorScheme.primary.withAlpha(100),
              onCancel: () {
                Navigator.pop(context);
              },
              onSubmit: (range) {
                if (range is PickerDateRange) {
                  setState(() {
                    _startDate = range.startDate;
                    _endDate = range.endDate?.add(
                      const Duration(days: 1),
                    ); // 包含所选结束日期的整天
                    _applyFilters();
                  });
                  Navigator.pop(context);
                }
              },
            ),
          ),
        );
      },
    );
  }

  // 处理日期范围选择
  void _onDateRangeSelected(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      final PickerDateRange range = args.value as PickerDateRange;
      setState(() {
        _startDate = range.startDate;
        _endDate = range.endDate?.add(const Duration(days: 1)); // 包含所选结束日期的整天
        _applyFilters();
      });
    }
  }

  // 重置筛选条件
  void _resetFilters() {
    setState(() {
      _selectedCallerId = null;
      _selectedClassId = null;
      _startDate = null;
      _endDate = null;
      _isArchiveFilter = null; // 重置归档筛选
      _applyFilters();
    });
  }

  // 切换分组展开/折叠状态
  void _toggleGroupExpanded(int index) {
    setState(() {
      _filteredRecords.values.toList()[index].isExpanded = !_filteredRecords
          .values
          .toList()[index]
          .isExpanded;
    });
  }

  Future<Map<int, RandomCallerGroupModel>> _getAllRandomCallerGroups() async {
    Map<int, RandomCallerGroupModel> randomCallerGroupsMap = {};
    // 获取所有班级信息，筛选按钮需要
    _allClasses = {
      for (var studentClass in await StudentClassDao().getAllStudentClasses())
        studentClass.id!: studentClass,
    };
    // 获取全部签到点名器
    List<RandomCallerModel> allRandomCallers = await RandomCallerDao()
        .getAllRandomCallers();
    // 保存全部签到点名器
    _allCallers = {
      for (var randomCaller in allRandomCallers) randomCaller.id!: randomCaller,
    };
    for (var selectedCaller in _allCallers.values) {
      // 获取班级信息
      StudentClassModel studentClass = _allClasses[selectedCaller.classId]!;
      // 获取班级学生
      List<StudentModel> students = [];
      List<int> studentIds = await StudentClassRelationDao()
          .getAllStudentIdsByClassId(studentClass.id!);
      for (int studentId in studentIds) {
        var student = await StudentDao().getStudentById(studentId);
        if (student != null) {
          students.add(student);
        }
      }
      // 获取签到记录
      List<RandomCallRecordModel> records = await RandomCallRecordDao()
          .getRecordsByCallerId(callerId: selectedCaller.id!);
      // 构建签到记录映射
      Map<int, List<RandomCallRecordModel>> randomCallRecords = {};
      for (var student in students) {
        randomCallRecords[student.id!] = [];
      }

      for (RandomCallRecordModel record in records) {
        randomCallRecords[record.studentId]!.add(record);
      }
      randomCallerGroupsMap[selectedCaller.id!] = RandomCallerGroupModel(
        randomCallerModel: selectedCaller,
        students: {for (var student in students) student.id!: student},
        studentClassModel: studentClass,
        randomCallRecords: randomCallRecords,
      );
    }
    // 初始筛选记录
    _filteredRecords = randomCallerGroupsMap;
    // 构建并返回分组模型
    return randomCallerGroupsMap;
  }

  void _applyFilters() {
    var filterRecords = _groupedRecords.entries.where((group) {
      // 点名器筛选
      if (_selectedCallerId != null &&
          group.value.randomCallerModel.id != _selectedCallerId) {
        return false;
      }
      // 班级筛选
      if (_selectedClassId != null &&
          group.value.studentClassModel.id != _selectedClassId) {
        return false;
      }
      // 归档状态筛选
      if (_isArchiveFilter != null &&
          (group.value.randomCallerModel.isArchive == 1) != _isArchiveFilter) {
        return false;
      }
      // 时间筛选
      if (_startDate != null || _endDate != null) {
        bool hasMatchingRecord = false;
        for (final record in group.value.randomCallRecords.values.expand(
          (records) => records,
        )) {
          bool matchesStart =
              _startDate == null || record.created.isAfter(_startDate!);
          bool matchesEnd =
              _endDate == null || record.created.isBefore(_endDate!);
          if (matchesStart && matchesEnd) {
            hasMatchingRecord = true;
            break;
          }
        }
        if (!hasMatchingRecord) {
          return false;
        }
      }
      return true;
    });
    setState(() {
      _filteredRecords = Map.fromEntries(filterRecords);
    });
  }

  void _showEditScoreDialog(RandomCallRecordModel record) {
    scoreController.text = record.score.toString();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final l10n = AppLocalizations.of(context);
        return AlertDialog(
          title: Text(l10n.editScore),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: scoreController,
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.onUnfocus,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: l10n.score,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.pleaseInputScore;
                    }
                    int num = int.tryParse(value)!;
                    if (num <= 0 || num > 10) {
                      return l10n.pleaseInputValidScore;
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                final newScore = int.tryParse(scoreController.text);
                if (newScore != null) {
                  // 更新分数
                  record.score = newScore;
                  // 保存到数据库
                  RandomCallRecordDao().update(record).then((value) {
                    if (value > 0) {
                      // 刷新数据
                      setState(() {
                        _filteredRecords[record.randomCallerId]!
                                .randomCallRecords[record.studentId]!
                                .where((element) => element.id == record.id)
                                .toList()
                                .first =
                            record;
                        _groupedRecords[record.randomCallerId]!
                                .randomCallRecords[record.studentId]!
                                .where((element) => element.id == record.id)
                                .toList()
                                .first =
                            record;
                      });
                    }
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text(l10n.save),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(RandomCallRecordModel record) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final l10n = AppLocalizations.of(context);
        return AlertDialog(
          title: Text(l10n.confirmDelete),
          content: Text(l10n.confirmDeleteRecordContent),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                // 删除记录数据
                RandomCallRecordDao().delete(record.id!).then((value) {
                  if (value > 0) {
                    // 刷新数据
                    setState(() {
                      _filteredRecords[record.randomCallerId]!
                          .randomCallRecords[record.studentId]!
                          .removeWhere((element) => element.id == record.id);
                      _groupedRecords[record.randomCallerId]!
                          .randomCallRecords[record.studentId]!
                          .removeWhere((element) => element.id == record.id);
                    });
                  }
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );
  }
  // 显示归档确认对话框

  void _showArchiveConfirmationDialog(RandomCallerModel randomCallerModel) {
    showDialog(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        return AlertDialog(
          title: Text(l10n.confirmArchive),
          content: Text(l10n.confirmArchiveContent),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                // 归档点名器
                randomCallerModel.isArchive = 1;
                RandomCallerDao().updateRandomCaller(randomCallerModel).then((
                  value,
                ) {
                  if (value > 0) {
                    // 刷新数据
                    setState(() {
                      _filteredRecords[randomCallerModel.id]!
                              .randomCallerModel
                              .isArchive =
                          1;
                      _groupedRecords[randomCallerModel.id]!
                              .randomCallerModel
                              .isArchive =
                          1;
                    });
                  }
                });
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: Text(l10n.confirmArchive),
            ),
          ],
        );
      },
    );
  }

  // 选择点名器导出的对话框
  Future<void> _showExportDialog() async {
    // 状态变量用于跟踪选中的点名器
    Set<int> selectedCallerIds = {};

    // 显示选择对话框
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        final l10n = AppLocalizations.of(context);
        return AlertDialog(
          title: Text(l10n.selectCallerToExport),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l10n.pleaseSelectCallerToExport),
                    SizedBox(height: 12.h),
                    ..._allCallers.values.toList().map((caller) {
                      return CheckboxListTile(
                        title: Text(caller.randomCallerName),
                        subtitle: Text(
                          l10n.classLabel(
                            _allClasses[caller.classId]?.className ?? '',
                          ),
                        ),
                        value: selectedCallerIds.contains(caller.id),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              selectedCallerIds.add(caller.id!);
                            } else {
                              selectedCallerIds.remove(caller.id);
                            }
                          });
                        },
                      );
                    }),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                if (selectedCallerIds.isNotEmpty) {
                  _exportToExcel(selectedCallerIds);
                } else {
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    SnackBar(
                      content: Text(
                        l10n.pleaseSelectAtLeastOneCaller,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Text(l10n.export),
            ),
          ],
        );
      },
    );
  }

  // 导出数据到Excel文件
  Future<void> _exportToExcel(Set<int> selectedCallerIds) async {
    final l10n = AppLocalizations.of(context);
    try {
      // 创建一个新的Excel文件
      Excel excelFile = Excel.createExcel();
      // 统计导出的记录数量
      int totalExportedRecords = 0;
      // 为每个选中的点名器创建一个工作表
      for (int callerId in selectedCallerIds) {
        // 找到对应的点名器
        RandomCallerModel? caller;
        try {
          caller = _allCallers[callerId];
        } catch (e) {
          // 点名器不存在，跳过
          continue;
        }
        // 获取该点名器的所有记录
        List<RandomCallRecordModel> records =
            _groupedRecords[callerId]!.allRecords;
        // 没有记录跳过，不保存该点名器的工作表
        if (records.isEmpty) continue;

        // 创建工作表，表名使用点名器名称
        String sheetName = caller!.randomCallerName;
        // 确保表名不超过Excel限制的31个字符
        if (sheetName.length > 31) {
          sheetName = sheetName.substring(0, 31);
        }
        // 创建或获取工作表
        Sheet sheet = excelFile[sheetName];
        // 设置表头
        sheet.appendRow([
          TextCellValue(l10n.exportColumnOrder),
          TextCellValue(l10n.exportColumnName),
          TextCellValue(l10n.exportColumnClassName),
          TextCellValue(l10n.exportColumnStudentNumber),
          TextCellValue(l10n.exportColumnStudentName),
          TextCellValue(l10n.exportColumnScore),
          TextCellValue(l10n.exportColumnTime),
          TextCellValue(l10n.exportColumnRemark),
        ]);

        // 导出每条记录
        for (int i = 0; i < records.length; i++) {
          RandomCallRecordModel record = records[i];
          // 获取学生信息
          StudentModel student =
              _groupedRecords[callerId]!.students[record.studentId]!;
          // 获取班级信息
          StudentClassModel cls = _groupedRecords[callerId]!.studentClassModel;

          sheet.appendRow([
            TextCellValue((i + 1).toString()),
            TextCellValue(caller.randomCallerName),
            TextCellValue(cls.className),
            TextCellValue(student.studentNumber),
            TextCellValue(student.studentName),
            TextCellValue(record.score.toString()),
            TextCellValue(record.created.toIso8601String()),
            TextCellValue(record.notes),
          ]);
          totalExportedRecords++;
        }
      }
      // 如果没有导出任何记录，显示提示
      if (totalExportedRecords == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.noExportableRecords,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onInverseSurface,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.inverseSurface,
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }
      // 请求存储权限
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                l10n.pleaseGrantStoragePermissionToExport,
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

      // 保存Excel文件

      String fileName =
          '${l10n.randomRecordExportFilePrefix}${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, '0')}${DateTime.now().day.toString().padLeft(2, '0')}_${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}.xlsx';
      String downloadsPath = '';
      // 根据不同平台获取下载路径
      if (Platform.isAndroid || Platform.isIOS) {
        var directory = await getDownloadsDirectory();
        downloadsPath = join(directory!.path, fileName);
      } else if (Platform.isWindows) {
        downloadsPath = join((await getDownloadsDirectory())!.path, fileName);
      } else if (Platform.isMacOS) {
        downloadsPath = join((await getDownloadsDirectory())!.path, fileName);
      }
      excelFile.delete('Sheet1');
      var fileBytes = excelFile.save();
      // 确保目录存在，保存Excel文件
      File(downloadsPath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes!);
      // 显示导出成功信息
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            showCloseIcon: true,
            content: Text(
              l10n.exportSuccess(totalExportedRecords, downloadsPath),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onInverseSurface,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.inverseSurface,
            duration: const Duration(seconds: 10),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        // 显示导出失败信息
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.exportFailed(e.toString()),
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
}
