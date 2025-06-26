//usermanagement
const baseUrl2 = 'https://skillrat.com/usermgmt/';

const TriggerOtp = 'auth/jtuserotp/trigger/otp?triggerOtp=false';
const SigninUrl = 'auth/login';
const SignupUrl = 'auth/jtuserotp/trigger/sign-up?triggerOtp=false';
const userDetails = 'user/userDetails';
const updateCurrentCustomerUrl = 'usermgmt/user/userDetails';

const rolePostUrl = 'user/user';
String getNearbyRestaurantsUrl(
    double latitude, double longitude, String postalCode, int page, int size) {
  return 'business/find?latitude=$latitude&longitude=$longitude&radius=100&postalCode=$postalCode&page=$page&size=$size';
}

const addressSave = 'api/addresses/save';

//Eato
const baseUrl = 'https://skillrat.com/';

String getMenuByRestaurantIdUrl(
    String restaurantId, String search, int page, int size) {
  return 'product/api/products/filter?restaurantId=$restaurantId&attributeValue=Online&keyword=$search&page=$page&size=$size';
}

String getRestaurantsByProductNameUrl(String productName, double latitude,
    double longitude, String postalcode, int page, int size) {
  return 'product/api/products/nearby-search?latitude=$latitude&longitude=$longitude&radius=20&postalCode=$postalcode&page=$page&size=$size&searchTerm=$productName';
}

String orderHistoryUrl(int page, int size,String searchQuery) {
  return 'order/api/orders/history?page=$page&size=$size&sortBy=createdDate&direction=DESC&query=$searchQuery';
}

const createCartUrl = 'order/api/carts/create';
const getCartUrl = 'order/api/carts/get';
const clearCartUrl = 'order/api/carts/clear';
const productsAddToCartUrl = 'order/api/carts/items';
const saveAddressUrl = 'usermgmt/api/addresses/save';
const getAddressUrl = 'api/addresses/all';
const paymentUrl = 'order/payments/process';
const paymentReFund = 'order/payments/refund';
const paymentRefundStatus = 'order/payments/refunds';
const createOrderUrl = 'order/api/orders/create';
const reOrderUrl = 'order/api/orders/reorder';
const deleteAddressUrl = 'usermgmt/api/addresses';
const defaultAddressUrl = 'usermgmt/api/addresses/setdefaultAddress';
const addressSavetoCartUrl = 'order/api/carts/address?addressId';
const paymentRefundHistory = '';

String updateCartItemsUrl(String cartId) {
  return 'order/api/carts/items/$cartId';
}

String deleteCartItemsUrl(String cartId) {
  return 'order/api/carts/items/$cartId';
}
