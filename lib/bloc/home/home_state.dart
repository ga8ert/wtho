import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final String? name;
  final String? surname;
  final String? photoUrl;

  const HomeLoaded({this.name, this.surname, this.photoUrl});

  @override
  List<Object?> get props => [name, surname, photoUrl];
}

class HomeLoadedEvents extends HomeState {
  final List<Map<String, dynamic>> events;
  final double userLat;
  final double userLng;
  final RangeValues ageRange;
  final double radius;
  final Set<String> selectedTypes;
  const HomeLoadedEvents({
    required this.events,
    required this.userLat,
    required this.userLng,
    this.ageRange = const RangeValues(0, 100),
    this.radius = 100,
    this.selectedTypes = const {},
  });

  @override
  List<Object?> get props => [
    events,
    userLat,
    userLng,
    ageRange,
    radius,
    selectedTypes,
  ];
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
