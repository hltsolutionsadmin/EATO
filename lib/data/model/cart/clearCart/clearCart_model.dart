
class ClearCartModel {
    ClearCartModel({
        required this.message,
        required this.status,
        required this.data,
    });

    final String? message;
    final String? status;
    final int? data;

    factory ClearCartModel.fromJson(Map<String, dynamic> json){ 
        return ClearCartModel(
            message: json["message"],
            status: json["status"],
            data: json["data"],
        );
    }

}
