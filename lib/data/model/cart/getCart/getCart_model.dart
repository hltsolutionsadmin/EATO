class GetCartModel {
    GetCartModel({
        required this.id,
        required this.userId,
        required this.status,
        required this.shopifyCartId,
        required this.createdAt,
    });

    final int? id;
    final int? userId;
    final String? status;
    final String? shopifyCartId;
    final DateTime? createdAt;

    factory GetCartModel.fromJson(Map<String, dynamic> json){ 
        return GetCartModel(
            id: json["id"],
            userId: json["userId"],
            status: json["status"],
            shopifyCartId: json["shopifyCartId"],
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
        );
    }

}
