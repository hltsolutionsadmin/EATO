class ClearCartModel {
    ClearCartModel({
        required this.message,
        required this.data,
        required this.count,
    });

    final String? message;
    final String? data;
    final int? count;

    factory ClearCartModel.fromJson(Map<String, dynamic> json){ 
        return ClearCartModel(
            message: json["message"],
            data: json["data"],
            count: json["count"],
        );
    }

}
