//usermanagement
const baseUrl2 = 'https://skillrat.com/usermgmt/';

const TriggerOtp = 'auth/jtuserotp/trigger/sign-in?triggerOtp=false';
const SigninUrl = 'auth/login';
const SignupUrl = 'auth/jtuserotp/trigger/sign-up?triggerOtp=false';
const userDetails = 'user/userDetails';
const rolePostUrl = 'user/user';
String getNearbyRestaurantsUrl(
    double latitude, double longitude, String postalCode, int page, int size) {
  return 'business/find?latitude=$latitude&longitude=$longitude&radius=20&postalCode=$postalCode&page=$page&size=$size';
}

//Eato
const baseUrl = 'https://skillrat.com/';


String getMenuByRestaurantIdUrl(
    String restaurantId, String search, int page, int size) {
  return 'product/api/products/filter?restaurantId=$restaurantId&attributeValue=Online&keyword=$search&page=$page&size=$size';
}

const createCartUrl = 'order/api/carts/create';
const getCartUrl = 'order/api/carts/get';
const productsAddToCartUrl = 'order/api/carts/items';

String updateCartItemsUrl(String cartId) {
  return 'order/api/carts/items/$cartId';
}

String deleteCartItemsUrl(String cartId) {
  return 'order/api/carts/items/$cartId';
}
