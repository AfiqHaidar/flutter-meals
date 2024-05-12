import 'package:flutter/material.dart';
import 'package:meals/data/meal.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/filters.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/main_drawer.dart';

const kInitialFilters = {
  FilterEn.glutenFree: false,
};

class Tabs extends StatefulWidget {
  Tabs({super.key});

  @override
  State<Tabs> createState() {
    return TabsState();
  }
}

class TabsState extends State<Tabs> {
  int selectedPageIndex = 0;
  final List<Meal> favoriteMeals = [];
  Map<FilterEn, bool> selectedFilters = kInitialFilters;

  void showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void toggleMealFavorites(Meal meal) {
    final isExisting = favoriteMeals.contains(meal);

    if (isExisting) {
      setState(() {
        favoriteMeals.remove(meal);
      });
      showInfoMessage('Meal is no longer a favorite');
    } else {
      setState(() {
        favoriteMeals.add(meal);
      });
      showInfoMessage('Meal is Favorite');
    }
  }

  void selectPage(int index) {
    setState(() {
      selectedPageIndex = index;
    });
  }

  void setScreen(String indetifier) async {
    Navigator.of(context).pop();
    if (indetifier == 'filters') {
      final result = await Navigator.of(context).push<Map<FilterEn, bool>>(
        MaterialPageRoute(
          builder: (ctx) => Filter(
            currentFilters: selectedFilters,
          ),
        ),
      );

      setState(() {
        selectedFilters = result ?? kInitialFilters;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = dummyMeals.where((meal) {
      if (selectedFilters[FilterEn.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }
      return true;
    }).toList();

    Widget activePage = CategoriesScreen(
      onToggleFavorite: toggleMealFavorites,
      availableMeals: availableMeals,
    );
    var activePageTitle = 'Categories';

    if (selectedPageIndex == 1) {
      activePage = Meals(
        meals: favoriteMeals,
        onToggleFavorite: toggleMealFavorites,
      );
      activePageTitle = 'Your Favorites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(
        onSelectScreen: setScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: selectPage,
        currentIndex: selectedPageIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
