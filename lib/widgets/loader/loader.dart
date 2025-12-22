

import 'package:ahzir/widgets/loader/animated_loader.dart';
import 'package:flutter/material.dart';

class LoaderWidget {
  static final LoaderWidget _singleton = LoaderWidget._internal();

  factory LoaderWidget() {
    return _singleton;
  }

  LoaderWidget._internal();

  OverlayEntry? _overlayEntry;

  void show(BuildContext context) {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: 0,
        right: 0,
        top: 0,
        bottom: 0,
        child: Container(
          color: Colors.black.withOpacity(0.3),
          child: const Center(
            child: AnimatedLoader(),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void remove() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
