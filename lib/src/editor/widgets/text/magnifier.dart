import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef QuillMagnifierBuilder = Widget Function(Offset dragGlobalPosition);

Widget defaultQuillMagnifierBuilder(Offset dragGlobalPosition) =>
    QuillMagnifier(dragGlobalPosition: dragGlobalPosition);

class QuillMagnifier extends StatelessWidget {
  const QuillMagnifier({required this.dragGlobalPosition, super.key});

  // Global position where the text is (where the magnifier should point to)
  final Offset dragGlobalPosition;

  @override
  Widget build(BuildContext context) {
    const magnifierSize = Size(80, 40);

    // This is the "pointer" location relative to the
    // magnifier widget's own top-left corner.
    const focalPointOffset = Offset(0, 60);

    // Calculate the global top-left position for the magnifier widget
    // so that its "pointer" (focalPointOffset) lands
    // exactly on the dragGlobalPosition.
    final magnifierGlobalPosition = dragGlobalPosition - focalPointOffset;

    final isAndroid = defaultTargetPlatform == TargetPlatform.android;

    return Positioned(
      left: magnifierGlobalPosition.dx - magnifierSize.width / 2,
      top: magnifierGlobalPosition.dy - magnifierSize.height / 2,
      child: IgnorePointer(
        child: RawMagnifier(
          clipBehavior: Clip.hardEdge,
          decoration: MagnifierDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(isAndroid ? 40 : 25),
              ),
              side: isAndroid
                  ? BorderSide.none
                  : const BorderSide(
                      color: Color(0xFF2D64F6),
                      width: 2,
                    ),
            ),
            shadows: isAndroid
                ? const [
                    BoxShadow(
                      blurRadius: 1.5,
                      offset: Offset(0, 2),
                      spreadRadius: 0.75,
                      color: Color.fromARGB(25, 0, 0, 0),
                    ),
                  ]
                : null,
          ),
          size: isAndroid ? const Size(77.37, 37.9) : magnifierSize,
          focalPointOffset: focalPointOffset,
          magnificationScale: isAndroid ? 1.25 : 1.5,
          child: isAndroid
              ? const ColoredBox(
                  color: Color.fromARGB(8, 158, 158, 158),
                )
              : null,
        ),
      ),
    );
  }
}
