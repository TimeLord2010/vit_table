Generates a table that has adaptative columns dependending on the available
width.

![Screenshot 2024-08-14 at 22 03 28](https://github.com/user-attachments/assets/f432bc1f-e67a-4b12-9154-74871f07c249)

# Features

- Hability to customize each cell by using your own widget.
- Hide columns according to the `priority` column using the available width;
- Have a fixed height, or grow vertically according to its contents.
- Accept a sort function on each column.
- Display widget when table is empty.
- Horizontal scroll.

## Table height

If no height is set, then the table will try to expand according to the number of rows.

The height of the table widget can set using the `height` when creating a style:

```dart
style: const VitTableStyle(
  height: 150,
),
```

But if you want the table to have at least a certain amount height, then you can use the `minHeight` property:

```dart
style: const VitTableStyle(
  minHeight: 300,
),
```

## Header height

You can customize the height of the table header using the `headerHeight` property:

```dart
style: const VitTableStyle(
  header: HeaderStyle (height: 60),
),
```

## Table styling

### Decoration

You can add custom decoration to the table using the `decoration` property:

```dart
style: const VitTableStyle(
  decoration: BoxDecoration(
    border: Border.all(color: Colors.grey),
    borderRadius: BorderRadius.circular(8),
  ),
),
```

### Row styling

Customize row appearance using the `row` property:

```dart
style: const VitTableStyle(
  row: RowStyle(
    // Row styling options
  ),
),
```

### Inner bottom widget

Display a widget at the bottom of the table (inside the table) using `innerBottom`:

```dart
style: const VitTableStyle(
  innerBottom: Text('Table footer content'),
),
```

### Empty state widget

Show a custom widget when the table has no data using `onEmptyWidget`:

```dart
style: const VitTableStyle(
  onEmptyWidget: Center(
    child: Text('No data available'),
  ),
),
```

### Page navigator theme

Customize the page navigator appearance using `pageNavigatorThemeData`:

```dart
style: const VitTableStyle(
  pageNavigatorThemeData: PageNavigatorThemeData(
    // Page navigator styling options
  ),
),
```

### Custom scrollbar

Provide a custom scrollbar builder using `scrollbarBuilder`:

```dart
style: VitTableStyle(
  scrollbarBuilder: (controller, child) {
    return RawScrollbar(
      controller: controller,
      child: child,
    );
  },
),
```

## Column width

A column has 150 pixels of width by default, which can be changed by setting a value on `width` when creating a column:

```dart
VitTableColumn(title: 'Actions', width: 100),
```

### Flexible columns

Flexible columns can be achieved by setting `flex` in the column. When `flex` is set, the `width` property is treated as the minimum width:

```dart
VitTableColumn(
  title: 'Profile',
  width: 200,
  flex: 2,
),
```

This makes a column have at least the set width (200 pixels in this case), but if provided with extra horizontal space, the columns with `flex` will expand proportionally. However, if `enableHorizontalScroll` is set to true, then `flex` will have no effect.

### Cell padding

You can customize the padding of cells within a column using `cellsPadding`:

```dart
VitTableColumn(
  title: 'Name',
  cellsPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
),
```

### Column sorting

Enable sorting functionality for a column by providing an `onSort` callback:

```dart
VitTableColumn(
  title: 'Name',
  onSort: (ascending) {
    // Handle sorting logic
    print('Sort ascending: $ascending');
  },
),
```

## Priority

Priority system makes columns with the greater priority to disapear when there is not enough space.

This is system works great in environments where the user can resize the window where the flutter app is located, but not so great for mobile users.

For example:

```dart
columns: [
  VitTableColumn(title: Text('Code'), width: 60, priority: 1),
  VitTableColumn(title: Text('Name'), priority: 2), // 150 width assumed
  VitTableColumn(title: Text('Gender'), width: 100, priority: 4),
],
```

Here, all the columns will be visible if the table width has at least 310 pixels of space. If the available width is 280 pixels, then the column "Gender" will not be visible. If the available width is 100 pixels, then only the "Code" column is shown.

If `enableHorizontalScroll` is set to true, then `priority` will have no effect since columns will never vanish.

Note that the `title` parameter accepts any Widget, so you can use `Text('Title')` or any other widget for the column header.
