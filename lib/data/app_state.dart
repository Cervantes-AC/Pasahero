/// Shared in-memory state to simulate a backend.
/// In a real app this would be replaced with a proper state management solution.
library;

enum UserRole { passenger, driver }

enum DriverStatus { online, offline }

enum RideRequestStatus { pending, accepted, declined, timeout }

class AppState {
  static AppState? _instance;
  static AppState get instance => _instance ??= AppState._();
  AppState._();

  // Current user role
  UserRole role = UserRole.passenger;

  // Driver status
  DriverStatus driverStatus = DriverStatus.offline;

  // Simulated active ride request (driver side)
  RideRequest? pendingRequest;

  // Daily earnings (driver side)
  double dailyEarnings = 847.50;
  int dailyTrips = 12;
  double driverRating = 4.9;

  // Passenger payment method
  String selectedPayment = 'GCash';

  // Selected ride type
  String selectedRideType = 'habal-habal';
}

class RideRequest {
  final String id;
  final String passengerName;
  final String pickup;
  final String dropoff;
  final double fare;
  final double distance;
  final String eta;
  final int passengerRating;

  const RideRequest({
    required this.id,
    required this.passengerName,
    required this.pickup,
    required this.dropoff,
    required this.fare,
    required this.distance,
    required this.eta,
    required this.passengerRating,
  });
}

const mockRideRequest = RideRequest(
  id: 'req_001',
  passengerName: 'Ana Reyes',
  pickup: 'SM City Cebu, North Reclamation Area',
  dropoff: 'Ayala Center Cebu, Cebu Business Park',
  fare: 65.0,
  distance: 4.2,
  eta: '3 mins',
  passengerRating: 5,
);
