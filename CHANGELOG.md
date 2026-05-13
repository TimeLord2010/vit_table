## 3.2.1

- FIX: Fixed header misalignment when using horizontal margin in RowStyle

## 3.2.0

- FEAT: Added row reordering via drag and drop. New parameters on `VitTable`: `isReordering`, `onReorder`, `reorderMode` (`VitTableReorderMode.row`, `leading`, `trailing`), and `reorderIcon`.
- FEAT: Added `VitTableReorderMode` enum to control whether the entire row or a dedicated handle icon (leading or trailing) is the drag target.

## 3.1.0

- FEAT: Added optional `padding` parameter to `VitTable` to apply padding to the internal scroll widget.

## 3.0.5

- BUILD: Updated dependencies

## 3.0.4

- FIX: merge method from `VitTableStyle`.

## 3.0.3

- DOC: Updated documentation

## 3.0.2

- BREAKING: `VitTableStyle.headerHeight` was removed in favor of `HeaderStyle.height`.
- FEAT: Its now possible to customize the sort icon and position using `HeaderStyle` class located on `VitTableStyle`.

## 3.0.1

- DOC: Updated documentation

## 3.0.0

- BREAKING: `VitTableColumn` now accepts a `Widget` in the property "title" instead of a `String`.
- BREAKING: `VitTableColumn` no longer has property "expandable". Use new property "flex" instead.
- BREAKING: `VitTableStyle` no longer has "rowHeight". Use "minRowHeight" from `RowStyle` instead.
- FEAT: It's now possible to change multiple attributes of the table container, such as background color through `VitTableStyle.decoration`.
- FEAT: It's now possible to change multiple aspects of the row using the new style class `RowStyle` located inside `VitTableStyle`.

## 2.0.2

- BUILD: Updated dependencies

## 2.0.1

- FEAT: Added the ability to customize the scroll bar.

## 2.0.0

- REFAC: Page style properties is defined in the class `PageNavigatorStyle` instead of `VitTableStyle`.
- FEAT: Implemented "showJumpPage" and "showEdgePages".

## 1.1.0

- FEAT: `VitTableTheme` for easy passing of theme across the widget tree.

## 1.0.6

- FIX: horizontal scroll on thin spaces.

## 1.0.5

- FIX: table crashing when the widget is inside a container with finite height
  and `enableHorizontalScroll` is set to true.

## 1.0.4

- FIX: table now behaves correctly when used in container with non infinite
  height.

## 1.0.3

- FIX: handled the case where the available horizontal space is exactly 1
  pixel greather than the required amount to display all columns. In this case,
  the widget would crash.

## 1.0.2

- FIX: exports VitTable directly in `vit_table.dart`.

## 1.0.1

- FIX: imports in the default import (vit_table.dart).

## 1.0.0

- Added horizontal scroll.

## 0.0.1

- initial release.
