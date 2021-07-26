import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/constraints.dart';
import '../../core/services/router.dart';

class MyIndexedStack extends StatefulWidget {
  final int index;
  final List<Widget> children;

  const MyIndexedStack({
    Key? key,
    required this.index,
    required this.children,
  }) : super(key: key);

  @override
  _MyIndexedStackState createState() => _MyIndexedStackState();
}

class _MyIndexedStackState extends State<MyIndexedStack>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _controller;
  bool forward = true;
  int previousPage = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: widget.index);
    _pageController.addListener(() {
      if (_pageController.position.pixels %
              _pageController.position.viewportDimension ==
          0) {
        int page = _pageController.position.pixels ~/
            _pageController.position.viewportDimension;
        if (previousPage > page) {
          for (int i = previousPage; i > page; --i) {
            context.read<RouterHistory>().popAt(i - 1);
          }
        }
        previousPage = page;
      }
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _controller.forward(from: 0.0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(MyIndexedStack oldWidget) {
    forward = widget.index > oldWidget.index;
    if (widget.index != oldWidget.index ||
        widget.children[widget.index].hashCode !=
            oldWidget.children[widget.index].hashCode) {
      if (oldWidget.index == 0 &&
          ConfigConstraints.isMobile(MediaQuery.of(context).size.width)) {
        _controller.forward(from: 0);
        Future.microtask(() => _pageController.jumpToPage(widget.index));
      } else if (widget.index == 0 &&
          ConfigConstraints.isMobile(MediaQuery.of(context).size.width)) {
        _controller.reverse(from: 1);
      } else {
        _controller.forward(from: 1);
        Future.microtask(() => _pageController.animateToPage(widget.index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut));
      }
    }
    previousPage = widget.index;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, snapshot) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: Offset.zero)
              .chain(CurveTween(curve: Curves.ease))
              .animate(_controller),
          child: PageView(
            controller: _pageController,
            children: widget.children,
          ),
        );
      },
    );
  }
}

// position: Tween(begin: const Offset(1.0, 0), end: const Offset(0, 0)).animate(_controller)
