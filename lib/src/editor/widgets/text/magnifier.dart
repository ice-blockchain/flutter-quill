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
    const magnifierSize = Size(120, 60);

    // 1. This is the "pointer" location relative to the
    //    magnifier widget's own top-left corner.
    final focalPointOffset = Offset(
      0,
      magnifierSize.height,
    );

    // 2. Calculate the global top-left position for the magnifier widget
    //    so that its "pointer" (focalPointOffset) lands
    //    exactly on the dragGlobalPosition.
    final magnifierGlobalPosition = dragGlobalPosition - focalPointOffset;

    return Positioned(
      left: magnifierGlobalPosition.dx - magnifierSize.width / 2,
      top: magnifierGlobalPosition.dy - magnifierSize.height / 2,
      child: IgnorePointer(
        child: RawMagnifier(
          clipBehavior: Clip.hardEdge,
          decoration: MagnifierDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Colors.grey, width: 1),
            ),
            shadows: const [
              BoxShadow(
                color: Colors.black26,
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
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
