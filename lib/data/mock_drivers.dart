class Driver {
  final String id;
  final String name;
  final double rating;
  final int totalRides;
  final String eta;
  final int fare;
  final String vehicleType;
  final String plateNumber;
  final String distance;

  const Driver({
    required this.id,
    required this.name,
    required this.rating,
    required this.totalRides,
    required this.eta,
    required this.fare,
    required this.vehicleType,
    required this.plateNumber,
    required this.distance,
  });
}

class DriverDetail extends Driver {
  final String vehicleName;
  final String verifiedDate;
  final bool helmetsAvailable;

  const DriverDetail({
    required super.id,
    required super.name,
    required super.rating,
    required super.totalRides,
    required super.eta,
    required super.fare,
    required super.vehicleType,
    required super.plateNumber,
    required super.distance,
    required this.vehicleName,
    required this.verifiedDate,
    required this.helmetsAvailable,
  });
}

const mockDrivers = [
  Driver(
    id: '1',
    name: 'Pedro Santos',
    rating: 4.9,
    totalRides: 1250,
    eta: '3 mins',
    fare: 45,
    vehicleType: 'habal-habal',
    plateNumber: 'ABC 1234',
    distance: '0.8 km',
  ),
  Driver(
    id: '2',
    name: 'Maria Garcia',
    rating: 4.8,
    totalRides: 980,
    eta: '5 mins',
    fare: 42,
    vehicleType: 'habal-habal',
    plateNumber: 'XYZ 5678',
    distance: '1.2 km',
  ),
  Driver(
    id: '3',
    name: 'Juan Reyes',
    rating: 4.7,
    totalRides: 756,
    eta: '7 mins',
    fare: 48,
    vehicleType: 'rela',
    plateNumber: 'DEF 9012',
    distance: '1.8 km',
  ),
  Driver(
    id: '4',
    name: 'Rosa Mendoza',
    rating: 4.9,
    totalRides: 1420,
    eta: '4 mins',
    fare: 44,
    vehicleType: 'bao-bao',
    plateNumber: 'GHI 3456',
    distance: '1.0 km',
  ),
];

const driverDetails = {
  '1': DriverDetail(
    id: '1',
    name: 'Pedro Santos',
    rating: 4.9,
    totalRides: 1250,
    eta: '3 mins',
    fare: 45,
    vehicleType: 'habal-habal',
    plateNumber: 'ABC 1234',
    distance: '0.8 km',
    vehicleName: 'Honda TMX 155',
    verifiedDate: 'January 2024',
    helmetsAvailable: true,
  ),
  '2': DriverDetail(
    id: '2',
    name: 'Maria Garcia',
    rating: 4.8,
    totalRides: 980,
    eta: '5 mins',
    fare: 42,
    vehicleType: 'habal-habal',
    plateNumber: 'XYZ 5678',
    distance: '1.2 km',
    vehicleName: 'Yamaha Sniper 150',
    verifiedDate: 'March 2024',
    helmetsAvailable: true,
  ),
  '3': DriverDetail(
    id: '3',
    name: 'Juan Reyes',
    rating: 4.7,
    totalRides: 756,
    eta: '7 mins',
    fare: 48,
    vehicleType: 'rela',
    plateNumber: 'DEF 9012',
    distance: '1.8 km',
    vehicleName: 'Honda Wave with Sidecar',
    verifiedDate: 'February 2024',
    helmetsAvailable: true,
  ),
  '4': DriverDetail(
    id: '4',
    name: 'Rosa Mendoza',
    rating: 4.9,
    totalRides: 1420,
    eta: '4 mins',
    fare: 44,
    vehicleType: 'bao-bao',
    plateNumber: 'GHI 3456',
    distance: '1.0 km',
    vehicleName: 'Kawasaki Barako Tricycle',
    verifiedDate: 'December 2023',
    helmetsAvailable: false,
  ),
};

class Review {
  final String id;
  final String passengerName;
  final int rating;
  final String comment;
  final String date;

  const Review({
    required this.id,
    required this.passengerName,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

const mockReviews = [
  Review(
    id: '1',
    passengerName: 'Maria Santos',
    rating: 5,
    comment: 'Very professional and safe driver. Highly recommended!',
    date: '2 days ago',
  ),
  Review(
    id: '2',
    passengerName: 'Juan Reyes',
    rating: 5,
    comment: 'Fast and courteous service. Will book again!',
    date: '1 week ago',
  ),
  Review(
    id: '3',
    passengerName: 'Ana Cruz',
    rating: 4,
    comment: 'Good driver but arrived a bit late. Overall great experience.',
    date: '2 weeks ago',
  ),
  Review(
    id: '4',
    passengerName: 'Carlos Garcia',
    rating: 5,
    comment: 'Smooth ride and very friendly driver!',
    date: '3 weeks ago',
  ),
];
