// ignore_for_file: file_names

class FoodSet {
  final String foodSetId;
  final String foodSetName;
  final String foodSetChar;
  final int foodSetSorting;
  final bool isThirdParty;
  final bool active;

  FoodSet({
    required this.foodSetId,
    required this.foodSetName,
    required this.foodSetChar,
    required this.foodSetSorting,
    required this.isThirdParty,
    required this.active,
  });

  factory FoodSet.fromJson(Map<String, dynamic> json) {
    return FoodSet(
      foodSetId: json['foodSetId'] as String? ?? '',
      foodSetName: json['foodSetName'] as String? ?? '',
      foodSetChar: json['foodSetChar'] as String? ?? '',
      foodSetSorting: json['foodSetSorting'] as int? ?? 0,
      isThirdParty: json['isThirdParty'] as bool? ?? false,
      active: json['active'] as bool? ?? false,
    );
  }

  @override
  String toString() {
    return 'FoodSet(foodSetId: $foodSetId, foodSetName: $foodSetName, foodSetChar: $foodSetChar, foodSetSorting: $foodSetSorting, isThirdParty: $isThirdParty, active: $active)';
  }
}