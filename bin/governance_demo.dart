import '../lib/governance.dart';

void main() {
  final flag = FeatureFlag(
    name: "featureA",
    rollout: 50,
    rules: [
      {"field": "plan", "value": "pro"}
    ],
    owner: "team-alpha",
    createdAt: DateTime.now(),
    expiresAt: DateTime.now().add(Duration(days: 7)),
  );

  print("\n--- Admin Update ---");
  updateFlag(flag, "sharjil", "admin", 70);

  print("\n--- Unauthorized User ---");
  updateFlag(flag, "guest", "viewer", 80);

  print("\n--- Invalid Rollout ---");
  updateFlag(flag, "sharjil", "admin", 150);

  print("\n--- Expired Flag ---");
  final expiredFlag = FeatureFlag(
    name: "old_feature",
    rollout: 30,
    rules: [],
    owner: "team-beta",
    createdAt: DateTime.now().subtract(Duration(days: 10)),
    expiresAt: DateTime.now().subtract(Duration(days: 1)),
  );

  updateFlag(expiredFlag, "sharjil", "admin", 90);
}