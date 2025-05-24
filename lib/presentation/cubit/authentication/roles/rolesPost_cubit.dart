import 'package:eato/domain/usecase/authentication/rolesPost_usecase.dart';
import 'package:eato/presentation/cubit/authentication/roles/rolesPost_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RolePostCubit extends Cubit<RolePostState> {
  final RolePostUsecase rolePostUsecase;

  RolePostCubit(this.rolePostUsecase) : super(RolePostInitial());

  Future<void> postRole({String? role}) async {
    emit(RolePostLoading());
    try {
      final result = await rolePostUsecase.call(role);
      emit(RolePostSuccess(result));
    } catch (e) {
      emit(RolePostFailure(e.toString()));
    }
  }
}
