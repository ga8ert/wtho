import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeRefreshRequested extends HomeEvent {}

class LoadEventsWithLocation extends HomeEvent {
  const LoadEventsWithLocation();
}

class UpdateEventFilters extends HomeEvent {
  final RangeValues ageRange;
  final double radius;
  final Set<String> selectedTypes;
  const UpdateEventFilters({
    required this.ageRange,
    required this.radius,
    required this.selectedTypes,
  });

  @override
  List<Object?> get props => [ageRange, radius, selectedTypes];
}
