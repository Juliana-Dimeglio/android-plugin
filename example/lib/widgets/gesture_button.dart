import '../utils/colors_constants.dart';
import '../utils/numeric_constants.dart';
import 'package:flutter/material.dart';

class GestureButton extends StatelessWidget {
  final Function() onTap;
  final String buttonText;

  const GestureButton({
    Key? key,
    required this.onTap,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(
        NumericConstants.marginGestureDetector,
      ),
      height: NumericConstants.heightGestureDetector,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          NumericConstants.borderRadiusGestureDetector,
        ),
        color: ColorsConstants.gestureDetectorColor,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: NumericConstants.verticalPaddingCheckPermission,
            horizontal: NumericConstants.horizontalPaddingCheckPermission,
          ),
          child: Text(
            buttonText,
            style: TextStyle(
              color: Colors.grey.shade300,
              fontWeight: FontWeight.bold,
              fontSize: NumericConstants.fontSizePermissionButton,
            ),
          ),
        ),
      ),
    );
  }
}
