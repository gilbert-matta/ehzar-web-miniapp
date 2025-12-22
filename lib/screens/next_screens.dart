import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void nextScreen(BuildContext context, Widget page, {void Function()? onComplete}
) {
  Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 800),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Fade transition for both current and new page
        var fadeInOutTween = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut));

        return FadeTransition(
          opacity: animation.drive(fadeInOutTween),
          child: child,
        );
      },
    ),
  ).then((val) {
    (onComplete ?? () {})(); // Always calls something
  });
}


void nextScreenReturnValue(BuildContext context, Widget page, {Function(dynamic)? onValue}
    ) {
  Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 800),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Fade transition for both current and new page
        var fadeInOutTween = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut));

        return FadeTransition(
          opacity: animation.drive(fadeInOutTween),
          child: child,
        );
      },
    ),
  ).then((val) {
    if (val != null && onValue != null) {
      onValue(val); // Now this is safe
    }
  });
}

void nextScreenIOS(BuildContext context, Widget page) {
  Navigator.push(context, CupertinoPageRoute(builder: (context) => page));
}

void nextScreenCloseOthers(BuildContext context, Widget page) {
  Navigator.pushAndRemoveUntil(
    context,
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 800),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Fade transition for both current and new page
        var fadeInOutTween = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut));

        return FadeTransition(
          opacity: animation.drive(fadeInOutTween),
          child: child,
        );
      },
    ),
    (route) => false,
  );
}

void nextScreenReplace(BuildContext context, Widget page) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => page),
  );
}

void nextScreenReplaceNoAnimation(BuildContext context, Widget page) {
  Navigator.pushReplacement(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) => page,
      transitionDuration: Duration.zero,
    ),
  );
}

void nextScreenPopup(BuildContext context, Widget page) {
  Navigator.push(
    context,
    MaterialPageRoute(fullscreenDialog: true, builder: (context) => page),
  );
}

void nextScreenAnimatedBottom(BuildContext context, Widget page){
  Navigator.push(
      context, PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 500),
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var tween = Tween(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero
      ).chain(CurveTween(curve: Curves.easeOut));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  )
  );
}

void nextScreenAnimatedOpacity(BuildContext context, Widget page) {
  Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 800),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Fade transition for both current and new page
        var fadeInOutTween = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut));

        return FadeTransition(
          opacity: animation.drive(fadeInOutTween),
          child: child,
        );
      },
    ),
  );
}



void nextScreenAnimatedLeft(BuildContext context, Widget page){
  Navigator.push(
      context, PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 500),
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var tween = Tween(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero
      ).chain(CurveTween(curve: Curves.easeOut));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  )
  );
}