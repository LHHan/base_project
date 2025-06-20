import 'package:flutter/material.dart';

class WKeepAlive extends StatefulWidget {
  const WKeepAlive({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  // ignore: library_private_types_in_public_api
  _WKeepAliveState createState() => _WKeepAliveState();
}

class _WKeepAliveState extends State<WKeepAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
