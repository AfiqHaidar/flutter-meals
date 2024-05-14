import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/providers/meals_provider.dart';

enum FilterEn {
  glutenFree,
}

class FiltersNotifier extends StateNotifier<Map<FilterEn, bool>> {
  FiltersNotifier()
      : super({
          FilterEn.glutenFree: false,
        });

  void setFilter(FilterEn filter, bool isActive) {
    state = {
      ...state,
      filter: isActive,
    };
  }

  void setFilters(Map<FilterEn, bool> chosenFilters) {
    state = chosenFilters;
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<FilterEn, bool>>(
        (ref) => FiltersNotifier());

final filteredMealsProvider = Provider((ref) {
  final meals = ref.watch(mealsProvider);
  final activeFilters = ref.watch(filtersProvider);
  return meals.where((meal) {
    if (activeFilters[FilterEn.glutenFree]! && !meal.isGlutenFree) {
      return false;
    }
    return true;
  }).toList();
});
