
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:ahzir/index.dart';

class ExpansionTileWidget extends StatefulWidget {
  IconData? icon;
  Color? iconColor;
  double? iconSize;
  String? title;
  EdgeInsetsGeometry? contentPadding;
  EdgeInsetsGeometry? titlePadding;
  List<Widget> children;
  bool isExpanded;
  void Function()? onTapAlert;
  final Function()? onOpenExpansion;

  ExpansionTileWidget({
    required this.children,
    this.icon,
    this.iconColor,
    this.iconSize,
    this.title,
    this.contentPadding,
    this.titlePadding,
    this.isExpanded = false,
    this.onTapAlert,
    this.onOpenExpansion,
    super.key
  });

  @override
  State<ExpansionTileWidget> createState() => _ExpansionTileWidgetState();
}

class _ExpansionTileWidgetState extends State<ExpansionTileWidget> {
  bool _isExpanded = false;
  late ExpandedTileController _controller;

  @override
  void initState() {
    _isExpanded = widget.isExpanded;
    _controller = ExpandedTileController(isExpanded: _isExpanded);
    // TODO: implement initState
    super.initState();
  }

  @override
  void didUpdateWidget(ExpansionTileWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if the newsList has changed
    if (widget.isExpanded != oldWidget.isExpanded) {
      setState(() {
        _isExpanded = widget.isExpanded;
        _controller = ExpandedTileController(isExpanded: widget.isExpanded);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return ExpandedTile(
        controller: _controller,
        contentseparator: 0,
        theme: ExpandedTileThemeData(
            headerColor: whiteOpacity5,
            headerPadding: EdgeInsets.symmetric(vertical: 10),
            headerSplashColor: Colors.transparent,
            contentBackgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.zero,
            titlePadding: EdgeInsets.symmetric(horizontal: 10.0),
            // contentRadius: 12.0,
            trailingPadding: EdgeInsets.zero,
            leadingPadding: EdgeInsets.zero,
            footerPadding: EdgeInsets.zero,
            contentSeparatorColor: Colors.transparent,
        ),
        title: Column(
          children: [
          SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 35,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    children: [
                      widget.title != null ? Text("${widget.title}", style: TextStyle(
                        // fontFamily: ibmPlexSans500,
                        fontSize: fontSize14,
                        // color: whiteF5
                      ),).tr() : Container(),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(_isExpanded ? Icons.arrow_drop_up: Icons.arrow_drop_down, color: whiteColor)
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        content: Column(
          children: widget.children,
        ),
        trailing: const SizedBox(),
        onTap: () async {
          setState(() {
            _isExpanded = _controller.isExpanded;
          });
          widget.onOpenExpansion?.call();
        },
    );
  }
}
