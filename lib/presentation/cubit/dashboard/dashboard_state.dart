abstract class DashBoardState {}

class DashBoardInitial extends DashBoardState {}

class DashBoardLoading extends DashBoardState {}

class DashBoardLocationFetched extends DashBoardState {
  final String latitude;
  final String longitude;
  final String address;
  final dynamic place;

  DashBoardLocationFetched({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.place,
  });
}

class DashBoardError extends DashBoardState {
  final String message;

  DashBoardError(this.message);
}
