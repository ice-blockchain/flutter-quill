import 'package:flutter/cupertino.dart';

// Custom font style with smaller fontSize (13.0 instead of 15.0)
const TextStyle _kToolbarButtonFontStyle = TextStyle(
  inherit: false,
  fontSize: 13,
  letterSpacing: -0.13,
  fontWeight: FontWeight.w400,
);

const CupertinoDynamicColor _kToolbarTextColor = CupertinoDynamicColor.withBrightness(
  color: CupertinoColors.black,
  darkColor: CupertinoColors.white,
);

const CupertinoDynamicColor _kToolbarPressedColor = CupertinoDynamicColor.withBrightness(
  color: Color(0x10000000),
  darkColor: Color(0x10FFFFFF),
);

// Value measured from screenshot of iOS 16.0.2
const EdgeInsets _kToolbarButtonPadding = EdgeInsets.symmetric(vertical: 18, horizontal: 16);

/// A button in the style of the iOS text selection toolbar buttons with custom fontSize.
///
/// This is a custom implementation that uses a smaller fontSize (13.0) compared
/// to the standard CupertinoTextSelectionToolbarButton (15.0).
class CustomCupertinoTextSelectionToolbarButton extends StatefulWidget {
  /// Create an instance of [CustomCupertinoTextSelectionToolbarButton].
  const CustomCupertinoTextSelectionToolbarButton({
    required Widget this.child,
    super.key,
    this.onPressed,
  })  : text = null,
        buttonItem = null;

  /// Create an instance of [CustomCupertinoTextSelectionToolbarButton] whose child is
  /// a [Text] widget styled like the default iOS text selection toolbar button.
  const CustomCupertinoTextSelectionToolbarButton.text({
    required this.text,
    super.key,
    this.onPressed,
  })  : buttonItem = null,
        child = null;

  /// Create an instance of [CustomCupertinoTextSelectionToolbarButton] from the given
  /// [ContextMenuButtonItem].
  CustomCupertinoTextSelectionToolbarButton.buttonItem({
    required ContextMenuButtonItem this.buttonItem,
    super.key,
  })  : child = null,
        text = null,
        onPressed = buttonItem.onPressed;

  /// The child of this button.
  ///
  /// Usually a [Text] or an [Icon].
  final Widget? child;

  /// Called when this button is pressed.
  final VoidCallback? onPressed;

  /// The buttonItem used to generate the button when using
  /// [CustomCupertinoTextSelectionToolbarButton.buttonItem].
  final ContextMenuButtonItem? buttonItem;

  /// The text used in the button's label when using
  /// [CustomCupertinoTextSelectionToolbarButton.text].
  final String? text;

  /// Returns the default button label String for the button of the given
  /// [ContextMenuButtonItem]'s [ContextMenuButtonType].
  static String getButtonLabel(BuildContext context, ContextMenuButtonItem buttonItem) {
    if (buttonItem.label != null) {
      return buttonItem.label!;
    }

    assert(debugCheckHasCupertinoLocalizations(context));
    final localizations = CupertinoLocalizations.of(context);
    return switch (buttonItem.type) {
      ContextMenuButtonType.cut => localizations.cutButtonLabel,
      ContextMenuButtonType.copy => localizations.copyButtonLabel,
      ContextMenuButtonType.paste => localizations.pasteButtonLabel,
      ContextMenuButtonType.selectAll => localizations.selectAllButtonLabel,
      ContextMenuButtonType.lookUp => localizations.lookUpButtonLabel,
      ContextMenuButtonType.searchWeb => localizations.searchWebButtonLabel,
      ContextMenuButtonType.share => localizations.shareButtonLabel,
      ContextMenuButtonType.liveTextInput => 'Scan Text',
      ContextMenuButtonType.delete || ContextMenuButtonType.custom => '',
    };
  }

  @override
  State<StatefulWidget> createState() => _CustomCupertinoTextSelectionToolbarButtonState();
}

class _CustomCupertinoTextSelectionToolbarButtonState
    extends State<CustomCupertinoTextSelectionToolbarButton> {
  bool isPressed = false;

  void _onTapDown(TapDownDetails details) {
    setState(() => isPressed = true);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => isPressed = false);
    widget.onPressed?.call();
  }

  void _onTapCancel() {
    setState(() => isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final content = _getContentWidget(context);
    final Widget child = CupertinoButton(
      color: isPressed ? _kToolbarPressedColor.resolveFrom(context) : CupertinoColors.transparent,
      borderRadius: null,
      disabledColor: CupertinoColors.transparent,
      // This CupertinoButton does not actually handle the onPressed callback,
      // this is only here to correctly enable/disable the button (see
      // GestureDetector comment below).
      onPressed: widget.onPressed,
      padding: _kToolbarButtonPadding,
      // There's no foreground fade on iOS toolbar anymore, just the background
      // is darkened.
      pressedOpacity: 1,
      child: content,
    );

    if (widget.onPressed != null) {
      // As it's needed to change the CupertinoButton's backgroundColor when
      // pressed, not its opacity, this GestureDetector handles both the
      // onPressed callback and the backgroundColor change.
      return GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: child,
      );
    } else {
      return child;
    }
  }

  Widget _getContentWidget(BuildContext context) {
    if (widget.child != null) {
      return widget.child!;
    }
    return Text(
      widget.text ??
          CustomCupertinoTextSelectionToolbarButton.getButtonLabel(context, widget.buttonItem!),
      overflow: TextOverflow.ellipsis,
      style: _kToolbarButtonFontStyle.copyWith(
        color: widget.onPressed != null
            ? _kToolbarTextColor.resolveFrom(context)
            : CupertinoColors.inactiveGray,
      ),
    );
  }
}
