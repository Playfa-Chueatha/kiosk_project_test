// ignore_for_file: file_names, avoid_print

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kiosk_project_test/data/Data_food.dart';
import 'package:kiosk_project_test/widget/Food.dart';
import 'package:kiosk_project_test/widget/food_set.dart';
import 'package:kiosk_project_test/widget/SearchToggleWidget.dart';
import 'package:kiosk_project_test/widget/cetagoryfood.dart'; // CategoryFood

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
  String? _selectedFoodCatId; // หมวดหมู่ที่ถูกเลือกจาก CategoryFood
  String? _currentVisibleFoodCatId; // หมวดหมู่ที่มองเห็นใน FoodListWidget (จากการ scroll)

  void _toggleSearch() {
    setState(() {
      _showSearch = !_showSearch;
      if (!_showSearch) {
        _searchText = '';
        _searchController.clear();
      }
    });
  }

  void _handleCategorySelected(String categoryId) {
    setState(() {
      _selectedFoodCatId = categoryId;
      // เมื่อผู้ใช้แตะ category ใน CategoryFood
      // เราจะให้ FoodListWidget เลื่อนไปยัง category นั้น
      // ไม่ต้องอัปเดต _currentVisibleFoodCatId ที่นี่ เพราะ FoodListWidget จะแจ้งกลับมาเอง
    });
  }

  void _handleVisibleCategoryChanged(String categoryId) {
    setState(() {
      _currentVisibleFoodCatId = categoryId;
      // อัปเดต _selectedFoodCatId เพื่อให้ CategoryFood ไฮไลท์ถูกต้อง
      // เฉพาะเมื่อ _selectedFoodCatId ยังไม่ตรงกับหมวดหมู่ที่มองเห็นปัจจุบัน
      if (_selectedFoodCatId != categoryId) {
        _selectedFoodCatId = categoryId;
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
    final double screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Container(
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.0),
              Padding(
                padding: const EdgeInsets.fromLTRB(20,10,20,10),
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
                padding: const EdgeInsets.fromLTRB(20,10,20,10),
                child: NationalFoodCategory(
                  onSelected: (selectedFoodSet) {
                    print('หมวด: ${selectedFoodSet.foodSetName}');
                    print('ID: ${selectedFoodSet.foodSetId}');
                    setState(() {
                      _selectedFoodSetId = selectedFoodSet.foodSetId;
                      _selectedFoodCatId = null; // รีเซ็ตเมื่อเปลี่ยน FoodSet
                      _currentVisibleFoodCatId = null; // รีเซ็ตเมื่อเปลี่ยน FoodSet
                    });
                  },
                ),
              ),
              if (_selectedFoodSetId != null)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: CategoryFood(
                    selectedFoodSetId: _selectedFoodSetId!,
                    onCategorySelected: _handleCategorySelected,
                    currentVisibleCategoryId: _currentVisibleFoodCatId, // ส่งหมวดหมู่ที่มองเห็นไปให้ CategoryFood
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: FoodListWidget(
                    key: ValueKey(_searchText + (_selectedFoodSetId ?? '')),
                    onFoodSelected: widget.onFoodSelected,
                    searchText: _searchText,
                    selectedFoodSetId: _selectedFoodSetId ?? '',
                    selectedFoodCatId: _selectedFoodCatId, // ส่งหมวดหมู่ที่ถูกเลือกจาก CategoryFood
                    onCategoryChanged: _handleVisibleCategoryChanged, // รับ Callback จาก FoodListWidget
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