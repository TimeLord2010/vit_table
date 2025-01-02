class PageNavigatorOptions {
  const PageNavigatorOptions({
    this.jumpPageOffset = 9,
    this.showEdgePages = true,
    this.showJumpPage = true,
  });

  /// How far the page jump is set. Default is 10.
  ///
  /// For more information, see docs on [showJumpPage].
  final int jumpPageOffset;

  /// Indicates if the jump page is shown.
  ///
  /// A jump page is a page which is too far to be shown, but it is being deplayed.
  ///
  /// For example, if the current page is 1, then 2 and 3 should also be shown.
  /// But to facilitate the usability, the page 10 is also shown in case the
  /// user wishes to go far ahead at one. In this example, page 10 is a page
  /// jump.
  ///
  /// By default, the page jump is 10, but this can change using the
  /// [jumpPageOffset].
  final bool showJumpPage;

  /// Indicates if the first and last pages are always shown.
  final bool showEdgePages;
}
