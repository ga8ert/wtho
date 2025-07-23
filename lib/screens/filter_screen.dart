import 'package:flutter/material.dart';
import 'package:wtho/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/filter_cubit.dart';

class FilterResult {
  final RangeValues ageRange;
  final double radius;
  final Set<String> selectedTypes;
  FilterResult({
    required this.ageRange,
    required this.radius,
    required this.selectedTypes,
  });
}

class FilterScreen extends StatelessWidget {
  final RangeValues initialAgeRange;
  final double initialRadius;
  final Set<String> initialTypes;
  final Map<String, String> typeNameKeys;
  const FilterScreen({
    Key? key,
    required this.initialAgeRange,
    required this.initialRadius,
    required this.initialTypes,
    required this.typeNameKeys,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FilterCubit(
        initialAgeRange: initialAgeRange,
        initialRadius: initialRadius,
        initialTypes: initialTypes,
      ),
      child: const _FilterBody(),
    );
  }
}

class _FilterBody extends StatelessWidget {
  const _FilterBody();

  String getLocalizedField(BuildContext context, String key) {
    final l = AppLocalizations.of(context)!;
    switch (key) {
      case 'event_type_social_bar':
        return l.event_type_social_bar;
      case 'event_type_social_hangout':
        return l.event_type_social_hangout;
      case 'event_type_social_neighbors':
        return l.event_type_social_neighbors;
      case 'event_type_social_coffee':
        return l.event_type_social_coffee;
      case 'event_type_social_newcomers':
        return l.event_type_social_newcomers;
      case 'event_type_social_introverts':
        return l.event_type_social_introverts;
      case 'event_type_social_movie_pizza':
        return l.event_type_social_movie_pizza;
      case 'event_type_social_memes_tea':
        return l.event_type_social_memes_tea;
      case 'event_type_social_talk':
        return l.event_type_social_talk;
      case 'event_type_social_relax':
        return l.event_type_social_relax;
      case 'event_type_sport_company':
        return l.event_type_sport_company;
      case 'event_type_sport_play':
        return l.event_type_sport_play;
      case 'event_type_sport_gym':
        return l.event_type_sport_gym;
      case 'event_type_sport_morning':
        return l.event_type_sport_morning;
      case 'event_type_sport_trip':
        return l.event_type_sport_trip;
      case 'event_type_sport_beach':
        return l.event_type_sport_beach;
      case 'event_type_sport_dog':
        return l.event_type_sport_dog;
      case 'event_type_sport_cafe':
        return l.event_type_sport_cafe;
      case 'event_type_games_board':
        return l.event_type_games_board;
      case 'event_type_games_night':
        return l.event_type_games_night;
      case 'event_type_games_standup':
        return l.event_type_games_standup;
      case 'event_type_games_karaoke':
        return l.event_type_games_karaoke;
      case 'event_type_games_cook':
        return l.event_type_games_cook;
      case 'event_type_games_creative':
        return l.event_type_games_creative;
      case 'event_type_games_language':
        return l.event_type_games_language;
      case 'event_type_games_quest':
        return l.event_type_games_quest;
      case 'event_type_chill_picnic':
        return l.event_type_chill_picnic;
      case 'event_type_chill_yard':
        return l.event_type_chill_yard;
      case 'event_type_chill_morning_coffee':
        return l.event_type_chill_morning_coffee;
      case 'event_type_chill_blanket':
        return l.event_type_chill_blanket;
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.filters),
        actions: [
          TextButton(
            onPressed: () {
              context.read<FilterCubit>().clear();
            },
            child: Text(
              AppLocalizations.of(context)!.reset_filters,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<FilterCubit, FilterState>(
          builder: (context, state) => SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context)!.age),
                RangeSlider(
                  values: state.ageRange,
                  min: 0,
                  max: 100,
                  divisions: 100,
                  labels: RangeLabels(
                    state.ageRange.start.round().toString(),
                    state.ageRange.end.round().toString(),
                  ),
                  onChanged: (values) {
                    context.read<FilterCubit>().setAgeRange(values);
                  },
                ),
                const SizedBox(height: 8),
                Text(AppLocalizations.of(context)!.radius),
                Slider(
                  value: state.radius,
                  min: 0,
                  max: 100,
                  divisions: 100,
                  label: state.radius.round().toString(),
                  onChanged: (value) {
                    context.read<FilterCubit>().setRadius(value);
                  },
                ),
                const SizedBox(height: 8),
                Text(AppLocalizations.of(context)!.meeting_type),
                Wrap(
                  spacing: 8,
                  children:
                      (context
                                  .findAncestorWidgetOfExactType<FilterScreen>()
                                  ?.typeNameKeys
                                  .entries ??
                              [])
                          .map((entry) {
                            final type = entry.key;
                            final label = getLocalizedField(
                              context,
                              entry.value,
                            );
                            final selected = state.selectedTypes.contains(type);
                            return FilterChip(
                              label: Text(label),
                              selected: selected,
                              onSelected: (v) {
                                context.read<FilterCubit>().toggleType(type);
                              },
                            );
                          })
                          .toList(),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(
                        FilterResult(
                          ageRange: state.ageRange,
                          radius: state.radius,
                          selectedTypes: state.selectedTypes,
                        ),
                      );
                    },
                    child: Text(AppLocalizations.of(context)!.filters),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
