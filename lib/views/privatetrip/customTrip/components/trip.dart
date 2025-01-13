class Trip {
  final int tripID;
  final String namaTrip;
  final String alamat;
  final String deskripsi;
  final String meetingPoint;
  final double price;
  final String startDate;
  final String endDate;
  final String? rating;
  final String tripType;
  final int capacity;
  final String picture;

  Trip({
    required this.tripID,
    required this.namaTrip,
    required this.alamat,
    required this.deskripsi,
    required this.meetingPoint,
    required this.price,
    required this.startDate,
    required this.endDate,
    required this.rating,
    required this.tripType,
    required this.capacity,
    required this.picture,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      tripID: json['tripID'],
      namaTrip: json['namaTrip'],
      alamat: json['alamat'],
      deskripsi: json['deskripsi'],
      meetingPoint: json['meeting_point'],
      price: json['price'].toDouble(),
      startDate: json['start_date'],
      endDate: json['end_date'],
      rating: json['rating'],
      tripType: json['trip_type'],
      capacity: json['capacity'],
      picture: json['picture'],
    );
  }
}
