class PaymentModel {
    PaymentModel({
        required this.message,
        required this.status,
    });

    final String? message;
    final String? status;

    factory PaymentModel.fromJson(Map<String, dynamic> json){ 
        return PaymentModel(
            message: json["message"],
            status: json["status"],
        );
    }

}
