import 'package:eato/data/model/cart/clearCart/clearCart_model.dart';

abstract class ClearCartRepository {
  Future<ClearCartModel> clearCart();
}
