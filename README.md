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

## Column width

A column has 150 pixels of width by default, which can be changed by setting a value on `width` when creating a column:

```dart
VitTableColumn(title: 'Actions', width: 100),
```

Expandable columns can be achieved by setting `expandable` to true in the column:

```dart
VitTableColumn(
  title: 'Profile',
  width: 200,
  expandable: true,
),
```

This make a column have at least the set width (200 pixels in this case), but if provided with extra horizontal space, the columns with `expandable: true` will expand. However, if `enableHorizontalScroll` if set to true, then `expandable` will have no effect.

## Priority

Priority system makes columns with the greater priority to disapear when there is not enough space.

This is system works great in environments where the user can resize the window where the flutter app is located, but not so great for mobile users.

For example:

```dart
columns: [
  VitTableColumn(title: 'Code', width: 60, priority: 1),
  VitTableColumn(title: 'Name', priority: 2), // 150 width assumed
  VitTableColumn(title: 'Gender', width: 100, priority: 4),
],
```

Here, all the column will be visible if the table width has at least 310 pixels of space. If the available width is 280 pixels, then the column "Gender" will not be visible. If the available width is 100 pixels, then the only table shown is "Code".

If `enableHorizontalScroll` if set to true, then `priority` will have no effect since columns will never vanish.

# Roadmap

- Header customization;
  - Accept any widget to display in the header;
  - Change the text style of the header.
  - Change the background color.
- Custom rows background color;
- Custom rows background widget;
- Custom table border color and radius;
