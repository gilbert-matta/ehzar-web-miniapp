

import 'package:ahzir/index.dart';
import 'package:easy_localization/easy_localization.dart';

class RadioWidget extends StatelessWidget {
  final Object? groupValue;
  final Object value;
  final String text;
  final void Function(Object?)? onChanged;

  const RadioWidget({
    required this.groupValue,
    required this.value,
    required this.text,
    required this.onChanged,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio(activeColor: secondaryColor, fillColor: WidgetStatePropertyAll(groupValue == value ? secondaryColor : whiteColor), value: value, groupValue: groupValue, onChanged: onChanged),
        Text(text.tr(),
          style: TextStyle(
              fontSize: fontSize14,
              color: secondaryColor,
          )).tr(),
      ],
    );
  }
}
