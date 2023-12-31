///
/// unordered_list.dart
/// lib/core/widgets
///
///
///

import 'package:flutter/material.dart';

class UnorderedListWidget extends StatelessWidget {
  const UnorderedListWidget(this.texts, {super.key, this.style});
  final List<String> texts;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final widgetList = <Widget>[];
    for (var text in texts) {
      // Add list item
      widgetList.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("• "),
          Expanded(
            child: Text(
              text,
              style: style,
            ),
          ),
        ],
      ));
      // Add space between items
      widgetList.add(const SizedBox(height: 5.0));
    }

    return Column(children: widgetList);
  }
}
