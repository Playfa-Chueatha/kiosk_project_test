// ignore_for_file: file_names

class FoodData {
  final String foodId;
  final String foodName;
  final String foodNameAlt;
  final double foodPrice;
  final String foodDesc;
  final int foodSorting;
  final bool active;
  final String foodSetId;
  final String foodCatId;
  final String revenueClassId;
  final String taxRateId;
  final String taxRate2Id;
  final bool priority;
  final bool printSingle;
  final bool isCommand;
  final bool foodShowOption;
  final String foodPDANumber;
  final DateTime modifyOn;
  final DateTime createOn;
  final String pureImageName;
  final String imageName;
  final int qtyLimit;
  final bool isLimit;
  final String productId;
  final bool isOutStock;
  final bool isFree;
  final bool isShow;
  final bool isShowInstruction;
  final String imageNameString;
  final int thirdPartyGroupId;
  final String foodBaseId;
  final bool isThirdParty;
  final String imageThirdParty;

  int quantity; 

  FoodData({
    required this.foodId,
    required this.foodName,
    required this.foodNameAlt,
    required this.foodPrice,
    required this.foodDesc,
    required this.foodSorting,
    required this.active,
    required this.foodSetId,
    required this.foodCatId,
    required this.revenueClassId,
    required this.taxRateId,
    required this.taxRate2Id,
    required this.priority,
    required this.printSingle,
    required this.isCommand,
    required this.foodShowOption,
    required this.foodPDANumber,
    required this.modifyOn,
    required this.createOn,
    required this.pureImageName,
    required this.imageName,
    required this.qtyLimit,
    required this.isLimit,
    required this.productId,
    required this.isOutStock,
    required this.isFree,
    required this.isShow,
    required this.isShowInstruction,
    required this.imageNameString,
    required this.thirdPartyGroupId,
    required this.foodBaseId,
    required this.isThirdParty,
    required this.imageThirdParty,
    this.quantity = 0,
  });

  
  FoodData copyWith({
    int? quantity,
  }) {
    return FoodData(
      foodId: foodId,
      foodName: foodName,
      foodNameAlt: foodNameAlt,
      foodPrice: foodPrice,
      foodDesc: foodDesc,
      foodSorting: foodSorting,
      active: active,
      foodSetId: foodSetId,
      foodCatId: foodCatId,
      revenueClassId: revenueClassId,
      taxRateId: taxRateId,
      taxRate2Id: taxRate2Id,
      priority: priority,
      printSingle: printSingle,
      isCommand: isCommand,
      foodShowOption: foodShowOption,
      foodPDANumber: foodPDANumber,
      modifyOn: modifyOn,
      createOn: createOn,
      pureImageName: pureImageName,
      imageName: imageName,
      qtyLimit: qtyLimit,
      isLimit: isLimit,
      productId: productId,
      isOutStock: isOutStock,
      isFree: isFree,
      isShow: isShow,
      isShowInstruction: isShowInstruction,
      imageNameString: imageNameString,
      thirdPartyGroupId: thirdPartyGroupId,
      foodBaseId: foodBaseId,
      isThirdParty: isThirdParty,
      imageThirdParty: imageThirdParty,
      quantity: quantity ?? this.quantity,
    );
  }

  
  factory FoodData.fromJson(Map<String, dynamic> json) {
  return FoodData(
    foodId: json['foodId'] as String? ?? '',
    foodName: json['foodName'] as String? ?? '',
    foodNameAlt: json['foodNameAlt'] as String? ?? '',
    foodPrice: (json['foodPrice'] as num?)?.toDouble() ?? 0.0,
    foodDesc: json['foodDesc'] as String? ?? '',
    foodSorting: json['foodSorting'] as int? ?? 0,
    active: json['active'] as bool? ?? false,
    foodSetId: json['foodSetId'] as String? ?? '',
    foodCatId: json['foodCatId'] as String? ?? '',
    revenueClassId: json['revenueClassId'] as String? ?? '',
    taxRateId: json['taxRateId'] as String? ?? '',
    taxRate2Id: json['taxRate2Id'] as String? ?? '',
    priority: json['priority'] as bool? ?? false,
    printSingle: json['printSingle'] as bool? ?? false,
    isCommand: json['isCommand'] as bool? ?? false,
    foodShowOption: json['foodShowOption'] as bool? ?? false,
    foodPDANumber: json['foodPDANumber'] as String? ?? '',
    modifyOn: json['modifyOn'] != null ? DateTime.parse(json['modifyOn']) : DateTime.now(),
    createOn: json['createOn'] != null ? DateTime.parse(json['createOn']) : DateTime.now(),
    pureImageName: json['pureImageName'] as String? ?? '',
    imageName: json['imageName'] as String? ?? '',
    qtyLimit: json['qtyLimit'] as int? ?? 0,
    isLimit: json['isLimit'] as bool? ?? false,
    productId: json['productId'] as String? ?? '',
    isOutStock: json['isOutStock'] as bool? ?? false,
    isFree: json['isFree'] as bool? ?? false,
    isShow: json['isShow'] as bool? ?? false,
    isShowInstruction: json['isShowInstruction'] as bool? ?? false,
    imageNameString: json['imageNameString'] as String? ?? '',
    thirdPartyGroupId: json['thirdPartyGroupId'] as int? ?? 0,
    foodBaseId: json['foodBaseId'] as String? ?? '',
    isThirdParty: json['isThirdParty'] as bool? ?? false,
    imageThirdParty: json['imageThirdParty'] as String? ?? '',
    quantity: json['quantity'] as int? ?? 0,
  );
}


  
  Map<String, dynamic> toJson() {
    return {
      'foodId': foodId,
      'foodName': foodName,
      'foodNameAlt': foodNameAlt,
      'foodPrice': foodPrice,
      'foodDesc': foodDesc,
      'foodSorting': foodSorting,
      'active': active,
      'foodSetId': foodSetId,
      'foodCatId': foodCatId,
      'revenueClassId': revenueClassId,
      'taxRateId': taxRateId,
      'taxRate2Id': taxRate2Id,
      'priority': priority,
      'printSingle': printSingle,
      'isCommand': isCommand,
      'foodShowOption': foodShowOption,
      'foodPDANumber': foodPDANumber,
      'modifyOn': modifyOn.toIso8601String(),
      'createOn': createOn.toIso8601String(),
      'pureImageName': pureImageName,
      'imageName': imageName,
      'qtyLimit': qtyLimit,
      'isLimit': isLimit,
      'productId': productId,
      'isOutStock': isOutStock,
      'isFree': isFree,
      'isShow': isShow,
      'isShowInstruction': isShowInstruction,
      'imageNameString': imageNameString,
      'thirdPartyGroupId': thirdPartyGroupId,
      'foodBaseId': foodBaseId,
      'isThirdParty': isThirdParty,
      'imageThirdParty': imageThirdParty,
      'quantity': quantity,
    };
  }
}
