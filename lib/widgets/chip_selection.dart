import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ChipSelection extends StatefulWidget {
  final List<String> widgetList;

  ChipSelection({super.key, required this.widgetList});

  @override
  State<StatefulWidget> createState() =>
      _ChipSelectionWidget(widgetList: widgetList);
}

class _ChipSelectionWidget extends State<ChipSelection> {
  List<String> widgetList;

  _ChipSelectionWidget({required this.widgetList});

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new MasonryGridView.count(
        crossAxisCount: 2,
        controller: new ScrollController(keepScrollOffset: false),
        shrinkWrap: true,
        itemCount: widgetList.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          return Align(
            alignment: Alignment.topLeft,
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide(color: Colors.grey, width: 1),
              ),
              child: Padding(
                padding: EdgeInsets.all(6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.access_time), Text(widgetList[index])],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
