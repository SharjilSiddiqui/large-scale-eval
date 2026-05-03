import 'dart:math';
import '../lib/evaluation.dart';
import '../lib/config.dart';
// OR use config_client.dart if using API

final random = Random();

Map<String, dynamic> generateUser(int id) {
  final plans = ["free", "pro"];
  final regions = ["US", "IN", "EU"];

  return {
    "id": "user_$id",
    "plan": plans[random.nextInt(plans.length)],
    "region": regions[random.nextInt(regions.length)]
  };
}

void main() async {
  final featureConfig = config["featureA"] as Map<String, dynamic>;

  int ruleMatch = 0;
  int rolloutMatch = 0;

  final rules = featureConfig["rules"] as List;

  for (int i = 0; i < 1000; i++) {
    final user = generateUser(i);

    bool matchedRule = false;

    for (var rule in rules) {
      if (user[rule["field"]] == rule["value"]) {
        matchedRule = true;
        break;
      }
    }

    final result = evaluateFeatureDetailed(user, featureConfig);

    if (result["reason"] == "rule") {
  ruleMatch++;
} else if (result["reason"] == "rollout") {
  rolloutMatch++;
}
  }

  print("Rule matched users: $ruleMatch");
  print("Rollout users: $rolloutMatch");
  print("Total enabled: ${ruleMatch + rolloutMatch}");
}