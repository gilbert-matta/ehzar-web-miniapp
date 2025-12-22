
import 'package:flutter/material.dart';

horizontalScroll({required BuildContext context, ScrollController? controller, required List<Widget> widget}){
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    // color: primaryColor,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: controller,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: widget,
      ),
    ),
  );
}

verticalScroll({required BuildContext context, ScrollController? controller, required List<Widget> widget}){
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    // color: primaryColor,
    child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      controller: controller,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: widget,
      ),
    ),
  );
}