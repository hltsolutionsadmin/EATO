class UpdateCartItemsModel {
    UpdateCartItemsModel({
        required this.id,
        required this.productId,
        required this.quantity,
        required this.price,
        required this.createdAt,
        required this.updatedAt,
    });

    final int? id;
    final int? productId;
    final int? quantity;
    final double? price;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    factory UpdateCartItemsModel.fromJson(Map<String, dynamic> json){ 
        return UpdateCartItemsModel(
            id: json["id"],
            productId: json["productId"],
            quantity: json["quantity"],
            price: json["price"],
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
        );
    }

}
