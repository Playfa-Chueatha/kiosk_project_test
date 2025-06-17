// ignore_for_file: file_names, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kiosk_project_test/bloc/bloc_VisibleCategory.dart';
import 'package:kiosk_project_test/data/Data_food.dart';
import 'package:kiosk_project_test/widget/food_list_widget.dart';
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
  String? _userTappedCategoryId; // ติดตามว่าผู้ใช้กดเลือก category
  bool _hasUserTappedCategory = false;

  void _toggleSearch() {
    setState(() {
      _showSearch = !_showSearch;
      if (!_showSearch) {
        _searchText = '';
        _searchController.clear();
      }
    });
  }

  void _handleFoodListVisibleCategoryChanged(
      BuildContext context, String categoryId) {
    print("LeftPanel: Scroll => $categoryId");

    if (_userTappedCategoryId == null || _userTappedCategoryId == categoryId) {
      final visibleCategoryId =
          context.read<VisibleCategoryBloc>().state.visibleCategoryId;
      if (visibleCategoryId != categoryId) {
        context
            .read<VisibleCategoryBloc>()
            .add(UpdateVisibleCategory(categoryId));
      }
    } else {
      print("LeftPanel: Resetting tap state due to different category");
      setState(() {
        _userTappedCategoryId = null;
        _hasUserTappedCategory = false;
      });
      context
          .read<VisibleCategoryBloc>()
          .add(UpdateVisibleCategory(categoryId));
    }
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
    final double screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Container(
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.0),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: NationalFoodCategory(
                  onSelected: (selectedFoodSet) {
                    setState(() {
                      _selectedFoodSetId = selectedFoodSet.foodSetId;
                      _userTappedCategoryId = null;
                      _hasUserTappedCategory = false;
                    });

                    context
                        .read<VisibleCategoryBloc>()
                        .add(const UpdateVisibleCategory(''));
                  },
                ),
              ),
              if (_selectedFoodSetId != null)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child:
                      BlocBuilder<VisibleCategoryBloc, VisibleCategoryState?>(
                    builder: (context, state) {
                      return CategoryFood(
                        selectedFoodSetId: _selectedFoodSetId!,
                        currentVisibleCategoryId: state?.visibleCategoryId,
                      );
                    },
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child:
                      BlocBuilder<VisibleCategoryBloc, VisibleCategoryState?>(
                    builder: (context, state) {
                      return FoodList(
                        key: ValueKey(
                            'foodlist_${_searchText}_${_selectedFoodSetId ?? ''}'),
                        onFoodSelected: widget.onFoodSelected,
                        searchText: _searchText,
                        selectedFoodSetId: _selectedFoodSetId ?? '',
                        selectedFoodCatId: _hasUserTappedCategory
                            ? _userTappedCategoryId
                            : state?.visibleCategoryId,
                        onCategoryChanged: (catId) {
                          if (!_hasUserTappedCategory) {
                            _handleFoodListVisibleCategoryChanged(
                                context, catId);
                          }
                        },
                      );
                    },
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
