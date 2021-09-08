import '../utils/numeric_constants.dart';
import '../utils/string_constants.dart';

import 'package:flutter/material.dart';

class CoordinatesCard extends StatefulWidget {
  final bool isStopped;
  final Object? data;
  final bool hasData;

  const CoordinatesCard({
    Key? key,
    required this.data,
    required this.hasData,
    required this.isStopped,
  }) : super(key: key);

  @override
  _CoordinatesCardState createState() => _CoordinatesCardState();
}

class _CoordinatesCardState extends State<CoordinatesCard> {
  @override
  Widget build(BuildContext context) {
    return widget.hasData
        ? Container(
            padding: const EdgeInsets.all(
              NumericConstants.paddingCoordinates,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
              ),
            ),
            child: !widget.isStopped
                ? Column(
                    children: [
                      Text(
                        widget.data.toString().split("%").first,
                        style: TextStyle(
                          fontSize: NumericConstants.fontSizeLocationText,
                        ),
                      ),
                      Text(
                        widget.data.toString().split("%").last,
                        style: TextStyle(
                          fontSize: NumericConstants.fontSizeLocationText,
                        ),
                      ),
                    ],
                  )
                : Text(
                    widget.data.toString(),
                    style: TextStyle(
                      fontSize: NumericConstants.fontSizeLocationText,
                    ),
                  ),
          )
        : Container(
            padding: const EdgeInsets.all(
              NumericConstants.paddingCoordinates,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
              ),
            ),
            child: const Text(
              StringConstants.locationNotFound,
              style: TextStyle(
                fontSize: NumericConstants.fontSizeLocationText,
              ),
            ),
          );
  }
}
