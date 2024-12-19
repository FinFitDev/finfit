enum ACTIVITY_TYPE { WALKING, RUNNING, BIKE_RIDING, SWIMMING }

class ActivityMetadata {
  final String icon;
  final String name;

  const ActivityMetadata({required this.icon, required this.name});
}
