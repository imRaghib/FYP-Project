class Booking {
  String venueId;
  String vendorUID;
  List venueImages;
  String venueLocation;
  String venueName;
  int venuePrice;
  String venueDescription;
  String venueAddress;
  double venueCapacity;
  double venueParking;
  int venueRating;
  int venueFeedback;
  String vendorNumber;
  List inActiveDates;
  String vendorName;
  Map<String, int> menus;

  Booking({
    this.venueId = '',
    this.vendorUID = '',
    this.venueImages = const [],
    this.venueLocation = '',
    this.venueName = '',
    this.venuePrice = 0,
    this.venueDescription = '',
    this.venueAddress = '',
    this.venueCapacity = 0,
    this.venueParking = 0,
    this.venueRating = 0,
    this.venueFeedback = 0,
    this.vendorNumber = '',
    this.inActiveDates = const [],
    this.vendorName = '',
    this.menus = const {},
  });
}
