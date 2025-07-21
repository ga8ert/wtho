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
      case 'event_type_aquapark':
        return l.event_type_aquapark;
      case 'event_type_art_gallery':
        return l.event_type_art_gallery;
      case 'event_type_bbq':
        return l.event_type_bbq;
      case 'event_type_bowling':
        return l.event_type_bowling;
      case 'event_type_library':
        return l.event_type_library;
      case 'event_type_bike':
        return l.event_type_bike;
      case 'event_type_boardgames':
        return l.event_type_boardgames;
      case 'event_type_exhibition':
        return l.event_type_exhibition;
      case 'event_type_gastro':
        return l.event_type_gastro;
      case 'event_type_beach':
        return l.event_type_beach;
      case 'event_type_yoga':
        return l.event_type_yoga;
      case 'event_type_karaoke':
        return l.event_type_karaoke;
      case 'event_type_karting':
        return l.event_type_karting;
      case 'event_type_quest':
        return l.event_type_quest;
      case 'event_type_coworking':
        return l.event_type_coworking;
      case 'event_type_concert':
        return l.event_type_concert;
      case 'event_type_lasertag':
        return l.event_type_lasertag;
      case 'event_type_picnic':
        return l.event_type_picnic;
      case 'event_type_masterclass':
        return l.event_type_masterclass;
      case 'event_type_museum':
        return l.event_type_museum;
      case 'event_type_movie':
        return l.event_type_movie;
      case 'event_type_ferris':
        return l.event_type_ferris;
      case 'event_type_pub':
        return l.event_type_pub;
      case 'event_type_park':
        return l.event_type_park;
      case 'event_type_hiking':
        return l.event_type_hiking;
      case 'event_type_restaurant':
        return l.event_type_restaurant;
      case 'event_type_skating':
        return l.event_type_skating;
      case 'event_type_safari':
        return l.event_type_safari;
      case 'event_type_gym':
        return l.event_type_gym;
      case 'event_type_party':
        return l.event_type_party;
      case 'event_type_private':
        return l.event_type_private;
      case 'event_type_other':
        return l.event_type_other;
      case 'event_type_aquapark_emoji':
        return l.event_type_aquapark_emoji;
      case 'event_type_art_gallery_emoji':
        return l.event_type_art_gallery_emoji;
      case 'event_type_bbq_emoji':
        return l.event_type_bbq_emoji;
      case 'event_type_bowling_emoji':
        return l.event_type_bowling_emoji;
      case 'event_type_library_emoji':
        return l.event_type_library_emoji;
      case 'event_type_bike_emoji':
        return l.event_type_bike_emoji;
      case 'event_type_boardgames_emoji':
        return l.event_type_boardgames_emoji;
      case 'event_type_exhibition_emoji':
        return l.event_type_exhibition_emoji;
      case 'event_type_gastro_emoji':
        return l.event_type_gastro_emoji;
      case 'event_type_beach_emoji':
        return l.event_type_beach_emoji;
      case 'event_type_yoga_emoji':
        return l.event_type_yoga_emoji;
      case 'event_type_karaoke_emoji':
        return l.event_type_karaoke_emoji;
      case 'event_type_karting_emoji':
        return l.event_type_karting_emoji;
      case 'event_type_quest_emoji':
        return l.event_type_quest_emoji;
      case 'event_type_coworking_emoji':
        return l.event_type_coworking_emoji;
      case 'event_type_concert_emoji':
        return l.event_type_concert_emoji;
      case 'event_type_lasertag_emoji':
        return l.event_type_lasertag_emoji;
      case 'event_type_picnic_emoji':
        return l.event_type_picnic_emoji;
      case 'event_type_masterclass_emoji':
        return l.event_type_masterclass_emoji;
      case 'event_type_museum_emoji':
        return l.event_type_museum_emoji;
      case 'event_type_movie_emoji':
        return l.event_type_movie_emoji;
      case 'event_type_ferris_emoji':
        return l.event_type_ferris_emoji;
      case 'event_type_pub_emoji':
        return l.event_type_pub_emoji;
      case 'event_type_park_emoji':
        return l.event_type_park_emoji;
      case 'event_type_hiking_emoji':
        return l.event_type_hiking_emoji;
      case 'event_type_restaurant_emoji':
        return l.event_type_restaurant_emoji;
      case 'event_type_skating_emoji':
        return l.event_type_skating_emoji;
      case 'event_type_safari_emoji':
        return l.event_type_safari_emoji;
      case 'event_type_gym_emoji':
        return l.event_type_gym_emoji;
      case 'event_type_party_emoji':
        return l.event_type_party_emoji;
      case 'event_type_private_emoji':
        return l.event_type_private_emoji;
      case 'event_type_other_emoji':
        return l.event_type_other_emoji;
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
