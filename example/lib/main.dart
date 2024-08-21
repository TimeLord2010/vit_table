import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vit_table/data/models/vit_table_column.dart';
import 'package:vit_table/data/models/vit_table_row.dart';
import 'package:vit_table/ui/components/organisms/vit_table.dart';
import 'package:vit_table/ui/theme/vit_table_style.dart';

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
      home: Scaffold(
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
                  _largeTable(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Text('A table with multiple rows'),
                  const SizedBox(height: 5),
                  Expanded(
                    child: VitTable(
                      columns: [
                        VitTableColumn(title: 'Index'),
                      ],
                      rows: List.generate(100, (index) {
                        return VitTableRow(
                          cells: [
                            Text(index.toString()),
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  VitTable _complexTable() {
    return VitTable(
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
        VitTableColumn(title: 'Select', width: 70),
        VitTableColumn(
          title: 'Profile',
          expandable: true,
          onSort: (asc) {
            _sort(1, (profile) => profile.name);
          },
        ),
        VitTableColumn(
          title: 'Created on',
          onSort: (asc) {
            _sort(2, (profile) => profile.createdAt.toString());
          },
        ),
        VitTableColumn(title: 'Actions', width: 100),
      ],
      rows: [
        for (var profile in profiles)
          VitTableRow(
            cells: [
              Checkbox(
                  value: profile.name.startsWith('A'), onChanged: (value) {}),
              Text(profile.name),
              Text(profile.createdAt.toString()),
              const Icon(Icons.edit),
            ],
          )
      ],
    );
  }

  Widget _largeTable() {
    return VitTable(
      enableHorizontalScroll: true,
      columns: [
        VitTableColumn(title: 'Nº', width: 60),
        VitTableColumn(title: 'Id', width: 350),
        VitTableColumn(
          title: 'Name',
          expandable: true,
        ),
        VitTableColumn(title: 'Email'),
        VitTableColumn(title: 'Date', width: 100),
        VitTableColumn(title: 'Actions', width: 100),
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

  VitTable _simpleTable() {
    return VitTable(
      style: const VitTableStyle(
        height: 150,
      ),
      columns: [
        VitTableColumn(title: 'Code', width: 60, priority: 1),
        VitTableColumn(title: 'Name', priority: 2),
        VitTableColumn(title: 'Gender', width: 100, priority: 4),
        VitTableColumn(title: 'Birth', width: 100, priority: 3),
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
