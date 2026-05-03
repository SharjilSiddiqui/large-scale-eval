import 'dart:math';
import '../lib/evaluation.dart';
import '../lib/config.dart';
// OR use config_client.dart if using API

final random = Random();

Map generateUser(int id) {
  final plans = ["free", "pro"];
  final regions = ["US", "IN", "EU"];

  return {
    "id": "user_$id",
    "plan": plans[random.nextInt(plans.length)],
    "region": regions[random.nextInt(regions.length)]
  };
}

void main() async {
  final featureConfig = config["featureA"];

  int enabledCount = 0;

  for (int i = 0; i < 1000; i++) {
    final user = generateUser(i);

    final isEnabled = evaluateFeature(user, featureConfig!);

    if (isEnabled) enabledCount++;
  }

  print("Enabled users: $enabledCount");
}