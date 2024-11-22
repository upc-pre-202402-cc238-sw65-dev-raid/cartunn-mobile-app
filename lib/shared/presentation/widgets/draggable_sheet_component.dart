import 'package:flutter/material.dart';

class DraggableSheetComponent extends StatefulWidget {
  final Widget child;

  const DraggableSheetComponent({super.key, required this.child});

  @override
  State<DraggableSheetComponent> createState() =>
      _DraggableSheetComponentState();
}

class _DraggableSheetComponentState extends State<DraggableSheetComponent> {
  final controller = DraggableScrollableController();
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    controller.addListener(_onKeyboardVisibilityChange);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onKeyboardVisibilityChange() {
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    if (keyboardVisible != _isKeyboardVisible) {
      setState(() {
        _isKeyboardVisible = keyboardVisible;
      });
      if (keyboardVisible) {
        controller.animateTo(
          0.8,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        controller.animateTo(
          0.7,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return DraggableScrollableSheet(
          controller: controller,
          initialChildSize: 0.7,
          minChildSize: 0.3,
          maxChildSize: 0.95,
          snap: true,
          builder: (context, scrollController) {
            return DecoratedBox(
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: Offset(0, 1),
                  ),
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(22),
                  topRight: Radius.circular(22),
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _topButtonIndicator(),
                      widget.child,
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _topButtonIndicator() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Center(
        child: Container(
          width: 100,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.black45,
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
