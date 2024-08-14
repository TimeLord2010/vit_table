import 'package:flutter/material.dart';
import 'package:vit_table/data/models/table_row_model.dart';
import 'package:vit_table/data/models/vit_table_column.dart';
import 'package:vit_table/ui/components/organisms/vit_table.dart';
import 'package:vit_table/ui/theme/vit_table_style.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VitTable demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
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
            ],
          ),
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
      columns: [
        VitTableColumn(title: 'Select', width: 70),
        VitTableColumn(title: 'Profile', expandable: true),
        VitTableColumn(title: 'Actions', width: 100),
      ],
      rows: [
        TableRowModel(
          cells: [
            Checkbox(value: true, onChanged: (value) {}),
            const Text('Administrator'),
            const Icon(Icons.edit),
          ],
        ),
        TableRowModel(
          cells: [
            Checkbox(value: false, onChanged: (value) {}),
            const Text('Manager'),
            const Icon(Icons.edit),
          ],
        ),
      ],
    );
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
        TableRowModel(
          cells: [
            Text('1'),
            Text('Roy Williamson'),
            Text('Male'),
            Text('6/13/2001'),
          ],
        ),
        TableRowModel(
          cells: [
            Text('2'),
            Text('Thomas Casey'),
            Text('Male'),
            Text('5/27/1988'),
          ],
        ),
        TableRowModel(
          cells: [
            Text('3'),
            Text('Josephine Floyd'),
            Text('Male'),
            Text('12/9/1986'),
          ],
        ),
        TableRowModel(
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
