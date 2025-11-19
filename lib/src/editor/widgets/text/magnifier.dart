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

    // 1. This is the "pointer" location relative to the
    //    magnifier widget's own top-left corner.
    const focalPointOffset = Offset(0, 60);

    // 2. Calculate the global top-left position for the magnifier widget
    //    so that its "pointer" (focalPointOffset) lands
    //    exactly on the dragGlobalPosition.
    final magnifierGlobalPosition = dragGlobalPosition - focalPointOffset;

    const borderColor = Color(0xFF2D64F6);

    return Positioned(
      left: magnifierGlobalPosition.dx - magnifierSize.width / 2,
      top: magnifierGlobalPosition.dy - magnifierSize.height / 2,
      child: const IgnorePointer(
        child: RawMagnifier(
          clipBehavior: Clip.hardEdge,
          decoration: MagnifierDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              side: BorderSide(
                color: borderColor,
                width: 2,
              ),
            ),
          ),
          size: magnifierSize,
          // 4. THE FIX: Pass the *internal* offset. This tells
          //    RawMagnifier "this is where my pointer is".
          focalPointOffset: focalPointOffset,
          magnificationScale: 1.5,
        ),
      ),
    );
  }
}
