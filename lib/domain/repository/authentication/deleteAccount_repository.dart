import 'package:eato/data/model/authentication/deleteAccount_model.dart';

abstract class DeleteAccountRepository {
  Future<DeleteAccountModel> deleteAccount();
}
