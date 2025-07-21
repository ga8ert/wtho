import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../screens/filter_screen.dart';
import 'package:wtho/l10n/app_localizations.dart';

class FilterButton extends StatelessWidget {
  final RangeValues ageRange;
  final double radius;
  final Set<String> selectedTypes;
  final Map<String, String> typeNameKeys;
  final void Function(FilterResult result) onResult;
  final double iconSize;
  final EdgeInsetsGeometry? padding;

  const FilterButton({
    Key? key,
    required this.ageRange,
    required this.radius,
    required this.selectedTypes,
    required this.typeNameKeys,
    required this.onResult,
    this.iconSize = 20,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(CupertinoIcons.eye, color: Colors.blue, size: iconSize),
      tooltip: AppLocalizations.of(context)!.filters,
      padding: padding ?? const EdgeInsets.all(8),
      onPressed: () async {
        final result = await Navigator.of(context).push<FilterResult>(
          MaterialPageRoute(
            builder: (_) => FilterScreen(
              initialAgeRange: ageRange,
              initialRadius: radius,
              initialTypes: selectedTypes,
              typeNameKeys: typeNameKeys,
            ),
          ),
        );
        if (result != null) {
          onResult(result);
        }
      },
    );
  }
}
