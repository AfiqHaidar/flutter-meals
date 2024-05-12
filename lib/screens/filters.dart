import 'package:flutter/material.dart';
// import 'package:meals/screens/tabs.dart';
// import 'package:meals/widgets/main_drawer.dart';

enum FilterEn {
  glutenFree,
}

class Filter extends StatefulWidget {
  Filter({super.key, required this.currentFilters});

  final Map<FilterEn, bool> currentFilters;

  @override
  State<Filter> createState() {
    return FilterState();
  }
}

class FilterState extends State<Filter> {
  var glutenFreeFilter = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    glutenFreeFilter = widget.currentFilters[FilterEn.glutenFree]!;
  }

  // void setScreen(String indetifier) {
  //   Navigator.of(context).pop();
  //   if (indetifier == 'meals') {
  //     Navigator.of(context).pushReplacement(
  //       MaterialPageRoute(
  //         builder: (ctx) => Tabs(),
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Filters'),
      ),
      // drawer: MainDrawer(
      //   onSelectScreen: setScreen,
      // ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          if (didPop) return;
          Navigator.of(context).pop({
            FilterEn.glutenFree: glutenFreeFilter,
          });
        },
        child: Column(
          children: [
            SwitchListTile(
              value: glutenFreeFilter,
              onChanged: (isChecked) {
                setState(() {
                  glutenFreeFilter = isChecked;
                });
              },
              title: Text(
                'Gluten',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              subtitle: Text(
                'Only include gluten-free meals',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
