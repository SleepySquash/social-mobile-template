import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RouterHistory extends ChangeNotifier {
  ValueNotifier<List<Widget>> history = ValueNotifier<List<Widget>>([]);

  int length = 0;
  Widget? placeholder;
  Widget root;

  RouterHistory({required this.root, this.placeholder});

  void push(Widget widget) {
    ++length;
    history.value.add(widget);
    history.notifyListeners();
  }

  void replace(Widget widget) {
    length = 1;
    history.value.clear();
    history.value.add(widget);
    history.notifyListeners();
  }

  void pop() {
    --length;
    Future.delayed(const Duration(milliseconds: 300), () {
      history.value.removeLast();
      history.notifyListeners();
    });
    history.notifyListeners();
  }

  void popAt(int index) {
    if (index > history.value.length) return;
    --length;
    history.value.removeAt(index);
    history.notifyListeners();
  }

  void clear() {
    length = 0;
    history.value.clear();
    history.notifyListeners();
  }
}
