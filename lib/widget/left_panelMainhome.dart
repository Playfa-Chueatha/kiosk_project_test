// ignore_for_file: file_names, avoid_print

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kiosk_project_test/data/Data_food.dart';
import 'package:kiosk_project_test/widget/Food.dart';
import 'package:kiosk_project_test/widget/food_set.dart';
import 'package:kiosk_project_test/widget/SearchToggleWidget.dart';
import 'package:kiosk_project_test/widget/cetagoryfood.dart';

class LeftPanel extends StatefulWidget {
  final void Function(FoodData) onFoodSelected;
  const LeftPanel({
    super.key,
    required this.onFoodSelected,
  });

  @override
  State<LeftPanel> createState() => _LeftPanelState();
}

class _LeftPanelState extends State<LeftPanel> {
  bool _showSearch = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  String? _selectedFoodSetId;

  void _toggleSearch() {
    setState(() {
      _showSearch = !_showSearch;
      if (!_showSearch) {
        _searchText = '';
        _searchController.clear();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        FontAwesomeIcons.chevronLeft,
                        color: Colors.black,
                        size: 24,
                      ),
                      label: const Text(
                        'Back',
                        style: TextStyle(color: Colors.black, fontSize: 24),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFF6F6F6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SearchToggleWidget(
                      showSearch: _showSearch,
                      searchController: _searchController,
                      onToggle: _toggleSearch,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(20),
                child: NationalFoodCategory(
                  onSelected: (selectedFoodSet) {
                   
                    print('หมวด: ${selectedFoodSet.foodSetName}');
                    print('ID: ${selectedFoodSet.foodSetId}');
                    setState(() {
                      _selectedFoodSetId = selectedFoodSet.foodSetId;
                    });
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(20),
                child: CategoryFood(),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: FoodListWidget(
                    key: ValueKey(_searchText),
                    onFoodSelected: widget.onFoodSelected,
                    searchText: _searchText,
                    selectedFoodSetId: _selectedFoodSetId ?? '',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
