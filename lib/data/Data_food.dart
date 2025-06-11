class FoodData {
  final String foodId;              //รหัสสินค้า
  final String foodName;            //ชื่อเมนู
  final String foodNameAlt;         //ชื่อภาษาอื่น
  final double foodPrice;           //ราคา
  final String foodDesc;            //คำอธิบาย
  final int foodSorting;            //
  final bool active;                //สถานะการขาย
  final String foodSetId;           //น่าจะไอดีอาหารประเทศไหน
  final String foodCatId;           //ไอดีหมวดหมู่อาหาร
  final String revenueClassId;      // 
  final String taxRateId;           //
  final String taxRate2Id;          //
  final bool priority;              // ลำดับความสำคัญในการแสดงผล เช่น เมนูแนะนำหรือเปล่า?
  final bool printSingle;           //
  final bool isCommand;             //
  final bool foodShowOption;        //
  final String foodPDANumber;       //
  final DateTime modifyOn;          //วันที่แก้ไขล่าสุด
  final DateTime createOn;          //วันที่สร้างเมนู
  final String pureImageName;       //
  final String imageName;           //ลิงค์รูปภาพจากอินเทอร์เน็ต
  final int qtyLimit;               //จำกัดการสั่ง
  final bool isLimit;               //จำกัดการขาย
  final String productId;           //Id ในฐานข้อมูล ทำไมมี 2 เลข?
  final bool isOutStock;            //หมดสต็อก?
  final bool isFree;                //ฟรี?
  final bool isShow;                //แสดงให้ลูกค้าเห็นมั้ย
  final bool isShowInstruction;     //
  final String imageNameString;     //
  final int thirdPartyGroupId;      //
  final String foodBaseId;          //
  final bool isThirdParty;          //ร้านอาหารภายนอกมั้ย มั้ง?
  final String? plu;                //รหัสสินค้าสำหรับเครื่องคิดเงิน POS
  final String imageThirdParty;     //
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
    this.plu,
    required this.imageThirdParty,
    this.quantity = 1,
  });

  factory FoodData.fromJson(Map<String, dynamic> json) {
    return FoodData(
      foodId: json['foodId'] ?? '',
      foodName: json['foodName'] ?? '',
      foodNameAlt: json['foodNameAlt'] ?? '',
      foodPrice: (json['foodPrice'] is int)
          ? (json['foodPrice'] as int).toDouble()
          : (json['foodPrice'] ?? 0.0),
      foodDesc: json['foodDesc'] ?? '',
      foodSorting: json['foodSorting'] ?? 0,
      active: json['active'] ?? false,
      foodSetId: json['foodSetId'] ?? '',
      foodCatId: json['foodCatId'] ?? '',
      revenueClassId: json['revenueClassId'] ?? '',
      taxRateId: json['taxRateId'] ?? '',
      taxRate2Id: json['taxRate2Id'] ?? '',
      priority: json['priority'] ?? false,
      printSingle: json['printSingle'] ?? false,
      isCommand: json['isCommand'] ?? false,
      foodShowOption: json['foodShowOption'] ?? false,
      foodPDANumber: json['foodPDANumber'] ?? '',
      modifyOn: DateTime.tryParse(json['modifyOn'] ?? '') ?? DateTime.now(),
      createOn: DateTime.tryParse(json['createOn'] ?? '') ?? DateTime.now(),
      pureImageName: json['pureImageName'] ?? '',
      imageName: json['imageName'] ?? '',
      qtyLimit: json['qtyLimit'] ?? 0,
      isLimit: json['isLimit'] ?? false,
      productId: json['productId'] ?? '',
      isOutStock: json['isOutStock'] ?? false,
      isFree: json['isFree'] ?? false,
      isShow: json['isShow'] ?? false,
      isShowInstruction: json['isShowInstruction'] ?? false,
      imageNameString: json['imageNameString'] ?? '',
      thirdPartyGroupId: json['thirdPartyGroupId'] ?? 0,
      foodBaseId: json['foodBaseId'] ?? '',
      isThirdParty: json['isThirdParty'] ?? false,
      plu: json['plu'], 
      imageThirdParty: json['imageThirdParty'] ?? '',
    );
  }
}
