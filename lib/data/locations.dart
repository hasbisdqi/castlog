class LocationData {
  final String name;
  final double lat;
  final double lng;

  const LocationData({
    required this.name,
    required this.lat,
    required this.lng,
  });
}

const List<LocationData> dummyLocations = [
  LocationData(
    name: 'CastLog Basecamp (UPN Campus)',
    lat: -7.782383704688537,
    lng: 110.41586606343337,
  ),
  LocationData(
    name: 'Emerald Tackle Station (Minimarket)',
    lat: -7.783139925317062,
    lng: 110.41454302410676,
  ),
  LocationData(
    name: 'Angler Dining Hall (Kantin)',
    lat: -7.782466604443315,
    lng: 110.41618756029608,
  ),
  LocationData(
    name: 'Community Center (Masjid)',
    lat: -7.781581023250215,
    lng: 110.41502197824055,
  ),
  LocationData(
    name: 'Angler Lodging (Kos)',
    lat: -7.780829957491809,
    lng: 110.41722718735446,
  ),
];
