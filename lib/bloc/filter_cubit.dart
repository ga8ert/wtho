import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class FilterState extends Equatable {
  final RangeValues ageRange;
  final double radius;
  final Set<String> selectedTypes;

  const FilterState({
    this.ageRange = const RangeValues(0, 100),
    this.radius = 100,
    this.selectedTypes = const {},
  });

  FilterState copyWith({
    RangeValues? ageRange,
    double? radius,
    Set<String>? selectedTypes,
  }) {
    return FilterState(
      ageRange: ageRange ?? this.ageRange,
      radius: radius ?? this.radius,
      selectedTypes: selectedTypes ?? this.selectedTypes,
    );
  }

  @override
  List<Object?> get props => [ageRange, radius, selectedTypes];
}

class FilterCubit extends Cubit<FilterState> {
  FilterCubit({
    RangeValues? initialAgeRange,
    double? initialRadius,
    Set<String>? initialTypes,
  }) : super(
         FilterState(
           ageRange: initialAgeRange ?? const RangeValues(0, 100),
           radius: initialRadius ?? 100,
           selectedTypes: initialTypes ?? {},
         ),
       );

  void setAgeRange(RangeValues range) {
    emit(state.copyWith(ageRange: range));
  }

  void setRadius(double radius) {
    emit(state.copyWith(radius: radius));
  }

  void toggleType(String type) {
    final types = Set<String>.from(state.selectedTypes);
    if (types.contains(type)) {
      types.remove(type);
    } else {
      types.add(type);
    }
    emit(state.copyWith(selectedTypes: types));
  }

  void clear() {
    emit(const FilterState());
  }
}
