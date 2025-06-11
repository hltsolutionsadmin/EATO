class DeleteAddressModel {
    DeleteAddressModel({
        required this.success,
        required this.data,
        required this.message,
    });

    final bool? success;
    final dynamic data;
    final String? message;

    factory DeleteAddressModel.fromJson(Map<String, dynamic> json){ 
        return DeleteAddressModel(
            success: json["success"],
            data: json["data"],
            message: json["message"],
        );
    }

}
