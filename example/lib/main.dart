import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vit_table/data/models/vit_table_column.dart';
import 'package:vit_table/data/models/vit_table_reorder_mode.dart';
import 'package:vit_table/data/models/vit_table_row.dart';
import 'package:vit_table/ui/components/organisms/vit_table.dart';
import 'package:vit_table/ui/theme/header_style.dart';
import 'package:vit_table/ui/theme/page_navigator_options.dart';
import 'package:vit_table/ui/theme/page_navigator_theme.dart';
import 'package:vit_table/ui/theme/vit_table_style.dart';
import 'package:vit_table/ui/theme/vit_table_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Profile> profiles = [
    Profile('Administrator', DateTime.now()),
    Profile('Manager', DateTime(2020, 1, 18)),
    Profile('Student', DateTime(2024, 3, 5)),
  ];

  bool isAscSort = true;
  int? sortColumnIndex;

  bool enablePageNavigator = false;
  int currentPage = 0;

  List<String> reorderableItems = [
    'Alpha',
    'Beta',
    'Gamma',
    'Delta',
    'Epsilon'
  ];
  VitTableReorderMode reorderMode = VitTableReorderMode.row;
  IconData reorderIconData = Icons.drag_handle;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VitTable demo',
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: PointerDeviceKind.values.toSet(),
      ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: VitTableTheme(
        data: VitTableStyle(
            decoration: BoxDecoration(
              color: Colors.white,
              border: BoxBorder.all(
                color: const Color.fromARGB(255, 183, 183, 183),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            header: HeaderStyle(
              sortIcon: (isAscending) {
                if (isAscending != null) {
                  return AnimatedRotation(
                    duration: const Duration(milliseconds: 200),
                    turns: isAscending ? 0.5 : 0,
                    child: const Icon(Icons.south_rounded),
                  );
                }
                return const Icon(
                  Icons.south_rounded,
                  color: Color.fromARGB(46, 0, 0, 0),
                );
              },
            )),
        child: Scaffold(
          body: PageView(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Simple table example:'),
                    const SizedBox(height: 5),
                    _simpleTable(),
                    const SizedBox(height: 30),
                    const Text('Complex table example:'),
                    const SizedBox(height: 5),
                    _complexTable(),
                    const SizedBox(height: 30),
                    const Text('Large table'),
                    const SizedBox(height: 5),
                    _wideTable(),
                    const SizedBox(height: 30),
                    const Text('Reorderable table:'),
                    const SizedBox(height: 5),
                    _reorderableSection(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _largeTable(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column _largeTable() {
    var totalRows = 300;
    var desiredPages = 15;
    var pageSize = totalRows ~/ desiredPages;
    return Column(
      children: [
        Row(
          children: [
            const Text('A table with multiple rows'),
            const Spacer(),
            Switch.adaptive(
              value: enablePageNavigator,
              onChanged: (value) {
                setState(() {
                  enablePageNavigator = value;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 5),
        Expanded(
          child: VitTable(
            enableHorizontalScroll: true,
            columns: [
              VitTableColumn(title: const Text('Index')),
              VitTableColumn(title: const Text('Enabled'), flex: 1),
              VitTableColumn(title: const Text('Number')),
            ],
            rows: List.generate(pageSize, (index) {
              var random = Random();
              var rowId = (currentPage * pageSize) + index + 1;
              return VitTableRow(
                cells: [
                  Text(rowId.toString()),
                  Text(random.nextBool().toString()),
                  Text(random.nextInt(1000).toString()),
                ],
              );
            }),
            style: const VitTableStyle(
              pageNavigatorThemeData: PageNavigatorThemeData(
                options: PageNavigatorOptions(
                  showEdgePages: true,
                ),
              ),
            ),
            pageCount: desiredPages,
            currentPageIndex: currentPage,
            onPageSelected: enablePageNavigator
                ? (pageIndex) {
                    setState(() {
                      currentPage = pageIndex;
                    });
                  }
                : null,
          ),
        ),
      ],
    );
  }

  VitTable _complexTable() {
    return VitTable(
      enableHorizontalScroll: true,
      style: const VitTableStyle(
        innerBottom: SizedBox(
          height: 40,
          child: Center(
            child: Icon(Icons.add),
          ),
        ),
      ),
      sortColumnIndex: sortColumnIndex,
      isAscSort: isAscSort,
      columns: [
        VitTableColumn(title: const Text('Select'), width: 70),
        VitTableColumn(
          title: const Text('Profile'),
          flex: 1,
          onSort: (asc) {
            _sort(1, (profile) => profile.name);
          },
        ),
        VitTableColumn(
          title: const Text('Created on'),
          onSort: (asc) {
            _sort(2, (profile) => profile.createdAt.toString());
          },
        ),
        VitTableColumn(title: const Text('Actions'), width: 100),
      ],
      rows: [
        for (var profile in profiles)
          VitTableRow(
            cells: [
              Checkbox(
                value: profile.name.startsWith('A'),
                onChanged: (value) {},
              ),
              Text(profile.name),
              Text(profile.createdAt.toString()),
              const Icon(Icons.edit),
            ],
          )
      ],
    );
  }

  Widget _wideTable() {
    return VitTable(
      enableHorizontalScroll: true,
      columns: [
        VitTableColumn(title: const Text('Nº'), width: 60),
        VitTableColumn(title: const Text('Id'), width: 350),
        VitTableColumn(
          title: const Text('Name'),
          flex: 1,
        ),
        VitTableColumn(title: const Text('Email')),
        VitTableColumn(title: const Text('Date'), width: 100),
        VitTableColumn(title: const Text('Actions'), width: 100),
      ],
      rows: const [
        VitTableRow(
          cells: [
            Text('1'),
            Text('e90624df-5d34-5a72-b16f-916a442e8810'),
            Text('Dale Logan'),
            Text('zojpi@huw.ve'),
            Text('10/3/2116'),
            Icon(Icons.edit),
          ],
        ),
        VitTableRow(
          cells: [
            Text('2'),
            Text('7857197a-c9ac-590e-b443-76832759a260'),
            Text('Gavin Nguyen'),
            Text('vapu@ruico.tg'),
            Text('5/3/2024'),
            Icon(Icons.edit),
          ],
        ),
      ],
    );
  }

  void _sort(int index, String Function(Profile) valueGetter) {
    sortColumnIndex = index;
    isAscSort = !isAscSort;
    int Function(Profile, Profile) sortFn;
    if (isAscSort) {
      sortFn = (a, b) => valueGetter(a).compareTo(valueGetter(b));
    } else {
      sortFn = (a, b) => valueGetter(b).compareTo(valueGetter(a));
    }
    profiles.sort(sortFn);
    setState(() {});
  }

  static const _reorderIcons = [
    (Icons.drag_handle, 'drag_handle'),
    (Icons.unfold_more, 'unfold_more'),
    (Icons.swap_vert, 'swap_vert'),
    (Icons.menu, 'menu'),
  ];

  Widget _reorderableSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SegmentedButton<VitTableReorderMode>(
              segments: const [
                ButtonSegment(
                  value: VitTableReorderMode.leading,
                  icon: Icon(Icons.first_page),
                  label: Text('Leading'),
                ),
                ButtonSegment(
                  value: VitTableReorderMode.row,
                  icon: Icon(Icons.select_all),
                  label: Text('Row'),
                ),
                ButtonSegment(
                  value: VitTableReorderMode.trailing,
                  icon: Icon(Icons.last_page),
                  label: Text('Trailing'),
                ),
              ],
              selected: {reorderMode},
              onSelectionChanged: (value) =>
                  setState(() => reorderMode = value.first),
            ),
            if (reorderMode != VitTableReorderMode.row)
              DropdownButton<IconData>(
                value: reorderIconData,
                items: [
                  for (final (icon, label) in _reorderIcons)
                    DropdownMenuItem(
                      value: icon,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(icon),
                          const SizedBox(width: 8),
                          Text(label),
                        ],
                      ),
                    ),
                ],
                onChanged: (value) => setState(() => reorderIconData = value!),
              ),
          ],
        ),
        const SizedBox(height: 8),
        VitTable(
          isReordering: true,
          reorderMode: reorderMode,
          reorderIcon: reorderMode != VitTableReorderMode.row
              ? Icon(reorderIconData)
              : null,
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (newIndex > oldIndex) newIndex -= 1;
              final item = reorderableItems.removeAt(oldIndex);
              reorderableItems.insert(newIndex, item);
            });
          },
          columns: [
            VitTableColumn(title: const Text('Position'), width: 100),
            VitTableColumn(title: const Text('Name'), flex: 1),
          ],
          rows: [
            for (var (index, name) in reorderableItems.indexed)
              VitTableRow(cells: [Text('${index + 1}'), Text(name)]),
          ],
        ),
      ],
    );
  }

  VitTable _simpleTable() {
    return VitTable(
      enableHorizontalScroll: true,
      scrollbarBuilder: (controller, child) {
        return RawScrollbar(
          controller: controller,
          thumbVisibility: true,
          thickness: 8.0,
          radius: const Radius.circular(4),
          child: child,
        );
      },
      style: const VitTableStyle(
        height: 150,
      ),
      columns: [
        VitTableColumn(title: const Text('Code'), width: 60, priority: 1),
        VitTableColumn(title: const Text('Name'), priority: 2),
        VitTableColumn(title: const Text('Gender'), width: 100, priority: 4),
        VitTableColumn(title: const Text('Birth'), width: 100, priority: 3),
      ],
      rows: const [
        VitTableRow(
          cells: [
            Text('1'),
            Text('Roy Williamson'),
            Text('Male'),
            Text('6/13/2001'),
          ],
        ),
        VitTableRow(
          cells: [
            Text('2'),
            Text('Thomas Casey'),
            Text('Male'),
            Text('5/27/1988'),
          ],
        ),
        VitTableRow(
          cells: [
            Text('3'),
            Text('Josephine Floyd'),
            Text('Male'),
            Text('12/9/1986'),
          ],
        ),
        VitTableRow(
          cells: [
            Text('4'),
            Text('Susan Harvey'),
            Text('Female'),
            Text('9/24/1999'),
          ],
        ),
      ],
    );
  }
}

class Profile {
  String name;
  DateTime createdAt;

  Profile(this.name, this.createdAt);
}
