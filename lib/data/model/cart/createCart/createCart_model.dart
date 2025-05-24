class CreateCartModel {
    CreateCartModel({
        required this.id,
        required this.userId,
        required this.status,
        required this.shopifyCartId,
        required this.createdAt,
        required this.updatedAt,
    });

    final int? id;
    final int? userId;
    final String? status;
    final String? shopifyCartId;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    factory CreateCartModel.fromJson(Map<String, dynamic> json){ 
        return CreateCartModel(
            id: json["id"],
            userId: json["userId"],
            status: json["status"],
            shopifyCartId: json["shopifyCartId"],
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
        );
    }

}
