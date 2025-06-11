class FoodCategory {
  final String foodCatId;
  final String foodCatName;
  final int foodCatSorting;
  final String foodCatDesc;
  final String foodCatColor;
  final String foodCatIcon;
  final bool priority;
  final int foodCatParent;
  final bool active;

  FoodCategory({
    required this.foodCatId,
    required this.foodCatName,
    required this.foodCatSorting,
    required this.foodCatDesc,
    required this.foodCatColor,
    required this.foodCatIcon,
    required this.priority,
    required this.foodCatParent,
    required this.active,
  });

  factory FoodCategory.fromJson(Map<String, dynamic> json) {
  return FoodCategory(
    foodCatId: json['foodCatId'] ?? '',
    foodCatName: json['foodCatName'] ?? '',
    foodCatSorting: (json['foodCatSorting'] ?? 0) is int ? json['foodCatSorting'] : int.tryParse(json['foodCatSorting'].toString()) ?? 0,
    foodCatDesc: json['foodCatDesc'] ?? '',
    foodCatColor: json['foodCatColor'] ?? '',
    foodCatIcon: json['foodCatIcon'] ?? '',
    priority: json['priority'] ?? false,
    foodCatParent: (json['foodCatParent'] ?? 0) is int ? json['foodCatParent'] : int.tryParse(json['foodCatParent'].toString()) ?? 0,
    active: json['active'] ?? false,
  );
}


  Map<String, dynamic> toJson() {
    return {
      'foodCatId': foodCatId,
      'foodCatName': foodCatName,
      'foodCatSorting': foodCatSorting,
      'foodCatDesc': foodCatDesc,
      'foodCatColor': foodCatColor,
      'foodCatIcon': foodCatIcon,
      'priority': priority,
      'foodCatParent': foodCatParent,
      'active': active,
    };
  }
}
