class GeoPoint {
  /// Latitude coordinate
  final double latitude;
  final String locationName;

  /// Longitude coordinate
  final double longitude;

  /// Create a new GeoPoint with the given coordinates
  const GeoPoint({
    required this.latitude,
    required this.longitude,
    required this.locationName,
  });

  @override
  String toString() => 'GeoPoint(latitude: $latitude, longitude: $longitude)';
}
