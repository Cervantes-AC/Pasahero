/// Shared in-memory state to simulate a backend.
/// In a real app this would be replaced with a proper state management solution
/// (e.g., Riverpod, Bloc, or Provider) backed by Firebase.
library;

enum UserRole { passenger, driver }

enum DriverStatus { online, offline }

enum RideRequestStatus { pending, accepted, declined, timeout }

// ── Notification model ────────────────────────────────────────────────────────

class AppNotification {
  final String id;
  final String title;
  final String body;
  final String type; // 'promo', 'ride', 'wallet', 'system'
  final DateTime timestamp;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.timestamp,
    this.isRead = false,
  });
}

// ── Promo model ───────────────────────────────────────────────────────────────

class PromoCode {
  final String code;
  final String description;
  final int discountAmount;
  final String expiryDate;
  final bool isUsed;

  const PromoCode({
    required this.code,
    required this.description,
    required this.discountAmount,
    required this.expiryDate,
    this.isUsed = false,
  });
}

// ── Scheduled ride model ──────────────────────────────────────────────────────

class ScheduledRide {
  final String id;
  final String pickup;
  final String dropoff;
  final String rideType;
  final DateTime scheduledAt;
  final String status; // 'upcoming', 'cancelled'

  const ScheduledRide({
    required this.id,
    required this.pickup,
    required this.dropoff,
    required this.rideType,
    required this.scheduledAt,
    required this.status,
  });
}

// ── Favorite driver model ─────────────────────────────────────────────────────

class FavoriteDriver {
  final String driverId;
  final String name;
  final double rating;
  final String vehicleType;
  final String plateNumber;
  final int totalRidesTogether;

  const FavoriteDriver({
    required this.driverId,
    required this.name,
    required this.rating,
    required this.vehicleType,
    required this.plateNumber,
    required this.totalRidesTogether,
  });
}

// ── Payment method model ──────────────────────────────────────────────────────

class PaymentMethod {
  final String id;
  final String type; // 'gcash', 'maya', 'cash', 'pasawallet'
  final String displayName;
  final String accountNumber;
  bool isPrimary;

  PaymentMethod({
    required this.id,
    required this.type,
    required this.displayName,
    required this.accountNumber,
    this.isPrimary = false,
  });
}

// ── Emergency contact model ───────────────────────────────────────────────────

class EmergencyContact {
  final String id;
  String name;
  String relationship;
  String phone;

  EmergencyContact({
    required this.id,
    required this.name,
    required this.relationship,
    required this.phone,
  });
}

// ── Main AppState singleton ───────────────────────────────────────────────────

class AppState {
  static AppState? _instance;
  static AppState get instance => _instance ??= AppState._();
  AppState._() {
    _initMockData();
  }

  // ── Auth ──────────────────────────────────────────────────────────────────
  UserRole role = UserRole.passenger;
  String passengerName = 'Juan Dela Cruz';
  String passengerPhone = '+63 912 345 6789';
  String passengerEmail = 'juan.delacruz@email.com';
  String driverName = 'Pedro Santos';
  String driverPhone = '+63 912 345 6789';

  void updatePassengerName(String name) {
    passengerName = name;
  }

  // ── Driver status ─────────────────────────────────────────────────────────
  DriverStatus driverStatus = DriverStatus.offline;
  RideRequest? pendingRequest;
  double dailyEarnings = 847.50;
  int dailyTrips = 12;
  double driverRating = 4.9;

  // ── Passenger preferences ─────────────────────────────────────────────────
  String selectedPayment = 'PasaWallet';
  String selectedRideType = 'habal-habal';

  // ── Notifications ─────────────────────────────────────────────────────────
  List<AppNotification> notifications = [];

  int get unreadNotificationCount =>
      notifications.where((n) => !n.isRead).length;

  void markAllNotificationsRead() {
    for (final n in notifications) {
      n.isRead = true;
    }
  }

  void markNotificationRead(String id) {
    final n = notifications.where((n) => n.id == id).firstOrNull;
    if (n != null) n.isRead = true;
  }

  // ── Promo codes ───────────────────────────────────────────────────────────
  List<PromoCode> promoCodes = [];
  String? activePromoCode;

  bool applyPromo(String code) {
    final promo = promoCodes
        .where((p) => p.code.toUpperCase() == code.toUpperCase() && !p.isUsed)
        .firstOrNull;
    if (promo != null) {
      activePromoCode = promo.code;
      return true;
    }
    return false;
  }

  // ── Scheduled rides ───────────────────────────────────────────────────────
  List<ScheduledRide> scheduledRides = [];

  void addScheduledRide(ScheduledRide ride) {
    scheduledRides.add(ride);
  }

  void cancelScheduledRide(String id) {
    scheduledRides.removeWhere((r) => r.id == id);
  }

  // ── Favorite drivers ──────────────────────────────────────────────────────
  List<FavoriteDriver> favoriteDrivers = [];

  void toggleFavoriteDriver(FavoriteDriver driver) {
    final exists = favoriteDrivers.any((d) => d.driverId == driver.driverId);
    if (exists) {
      favoriteDrivers.removeWhere((d) => d.driverId == driver.driverId);
    } else {
      favoriteDrivers.add(driver);
    }
  }

  bool isDriverFavorite(String driverId) =>
      favoriteDrivers.any((d) => d.driverId == driverId);

  // ── Payment methods ───────────────────────────────────────────────────────
  List<PaymentMethod> paymentMethods = [];

  void addPaymentMethod(PaymentMethod method) {
    paymentMethods.add(method);
  }

  void removePaymentMethod(String id) {
    paymentMethods.removeWhere((m) => m.id == id);
  }

  void setPrimaryPayment(String id) {
    for (final m in paymentMethods) {
      m.isPrimary = m.id == id;
    }
  }

  // ── Emergency contacts ────────────────────────────────────────────────────
  List<EmergencyContact> emergencyContacts = [];

  void addEmergencyContact(EmergencyContact contact) {
    emergencyContacts.add(contact);
  }

  void removeEmergencyContact(String id) {
    emergencyContacts.removeWhere((c) => c.id == id);
  }

  void updateEmergencyContact(EmergencyContact updated) {
    final idx = emergencyContacts.indexWhere((c) => c.id == updated.id);
    if (idx != -1) emergencyContacts[idx] = updated;
  }

  // ── Mock data init ────────────────────────────────────────────────────────
  void _initMockData() {
    // Notifications
    notifications = [
      AppNotification(
        id: 'n1',
        title: '₱10 off your next ride!',
        body: 'Use code PASAHERO10 before April 30. Limited slots only.',
        type: 'promo',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      AppNotification(
        id: 'n2',
        title: 'Ride completed',
        body: 'Your ride with Pedro Santos has been completed. Total: ₱45.',
        type: 'ride',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: true,
      ),
      AppNotification(
        id: 'n3',
        title: 'PasaWallet topped up',
        body: '₱500 has been added to your PasaWallet via GCash.',
        type: 'wallet',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        isRead: true,
      ),
      AppNotification(
        id: 'n4',
        title: 'New feature: Schedule a Ride',
        body: 'You can now schedule rides up to 7 days in advance!',
        type: 'system',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
      ),
      AppNotification(
        id: 'n5',
        title: 'Driver rated you 5 stars!',
        body: 'Pedro Santos gave you a 5-star rating. Keep it up!',
        type: 'ride',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        isRead: true,
      ),
    ];

    // Promo codes
    promoCodes = [
      const PromoCode(
        code: 'PASAHERO10',
        description: '₱10 off your next ride',
        discountAmount: 10,
        expiryDate: 'Apr 30, 2026',
      ),
      const PromoCode(
        code: 'NEWUSER20',
        description: '₱20 off for new users',
        discountAmount: 20,
        expiryDate: 'May 15, 2026',
      ),
      const PromoCode(
        code: 'WEEKEND15',
        description: '₱15 off on weekends',
        discountAmount: 15,
        expiryDate: 'May 31, 2026',
      ),
    ];

    // Scheduled rides
    scheduledRides = [
      ScheduledRide(
        id: 'sr1',
        pickup: '123 Mabolo, Valencia City',
        dropoff: 'Robinsons Place',
        rideType: 'habal-habal',
        scheduledAt: DateTime.now().add(const Duration(hours: 2)),
        status: 'upcoming',
      ),
    ];

    // Favorite drivers
    favoriteDrivers = [
      const FavoriteDriver(
        driverId: '1',
        name: 'Pedro Santos',
        rating: 4.9,
        vehicleType: 'habal-habal',
        plateNumber: 'ABC 1234',
        totalRidesTogether: 8,
      ),
    ];

    // Payment methods
    paymentMethods = [
      PaymentMethod(
        id: 'pm1',
        type: 'pasawallet',
        displayName: 'PasaWallet',
        accountNumber: '₱500.00 balance',
        isPrimary: true,
      ),
      PaymentMethod(
        id: 'pm2',
        type: 'gcash',
        displayName: 'GCash',
        accountNumber: '0912 345 6789',
      ),
      PaymentMethod(
        id: 'pm3',
        type: 'maya',
        displayName: 'Maya',
        accountNumber: '0912 345 6789',
      ),
      PaymentMethod(
        id: 'pm4',
        type: 'cash',
        displayName: 'Cash',
        accountNumber: 'Pay on Ride',
      ),
    ];

    // Emergency contacts
    emergencyContacts = [
      EmergencyContact(
        id: 'ec1',
        name: 'Maria Dela Cruz',
        relationship: 'Spouse',
        phone: '+63 917 123 4567',
      ),
      EmergencyContact(
        id: 'ec2',
        name: 'Pedro Dela Cruz',
        relationship: 'Brother',
        phone: '+63 918 234 5678',
      ),
    ];
  }
}

// ── Ride request model ────────────────────────────────────────────────────────

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
  pickup: 'Robinsons Place, Valencia City',
  dropoff: 'Paseo de Santa Rosa, Valencia City',
  fare: 65.0,
  distance: 4.2,
  eta: '3 mins',
  passengerRating: 5,
);
