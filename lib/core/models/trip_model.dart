class TripModel {
  final int? id;
  final String uuid;
  final String? passengerId;
  final String? driverId;
  final int? routeId;
  final String? qrScanDatetime;
  final String? startDatetime;
  final String endDatetime;
  final String status;
  final double calculatedFare;
  final int? passengerRating;
  final String? passengerFeedback;
  final String pickup;
  final String dropOff;
  final String gasTier;
  final String createdAt;
  final String updatedAt;
  final bool isSynced;

  TripModel({
    this.id,
    required this.uuid,
    this.passengerId,
    this.driverId,
    this.routeId,
    this.qrScanDatetime,
    this.startDatetime,
    required this.endDatetime,
    required this.status,
    required this.calculatedFare,
    this.passengerRating,
    this.passengerFeedback,
    required this.pickup,
    required this.dropOff,
    required this.gasTier,
    required this.createdAt,
    required this.updatedAt,
    this.isSynced = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uuid': uuid,
      'passenger_id': passengerId,
      'driver_id': driverId,
      'route_id': routeId,
      'qr_scan_datetime': qrScanDatetime,
      'start_datetime': startDatetime,
      'end_datetime': endDatetime,
      'status': status,
      'calculated_fare': calculatedFare,
      'passenger_rating': passengerRating,
      'passenger_feedback': passengerFeedback,
      'pickup': pickup,
      'drop_off': dropOff,
      'gas_tier': gasTier,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'is_synced': isSynced ? 1 : 0,
    };
  }

  factory TripModel.fromMap(Map<String, dynamic> map) {
    return TripModel(
      id: map['id'],
      uuid: map['uuid'] ?? '',
      passengerId: map['passenger_id'],
      driverId: map['driver_id'],
      routeId: map['route_id'],
      qrScanDatetime: map['qr_scan_datetime'],
      startDatetime: map['start_datetime'],
      endDatetime: map['end_datetime'] ?? '',
      status: map['status'] ?? '',
      calculatedFare: (map['calculated_fare'] as num?)?.toDouble() ?? 0.0,
      passengerRating: map['passenger_rating'],
      passengerFeedback: map['passenger_feedback'],
      pickup: map['pickup'] ?? '',
      dropOff: map['drop_off'] ?? '',
      gasTier: map['gas_tier'] ?? '',
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
      isSynced: map['is_synced'] == 1,
    );
  }
}
