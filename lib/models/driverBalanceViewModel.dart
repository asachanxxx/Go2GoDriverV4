class DriverBalanceViewModel {
  final int driverId;
  final double balance;

  DriverBalanceViewModel({
    required this.driverId,
    required this.balance,
  });

  factory DriverBalanceViewModel.fromJson(Map<String, dynamic> json) {
    return DriverBalanceViewModel(
      driverId: json['DriverId'],
      balance: json['Balance'],
    );
  }
}