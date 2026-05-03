int hashUser(String userId) {
  int hash = 0;
  for (int i = 0; i < userId.length; i++) {
    hash = (hash << 5) - hash + userId.codeUnitAt(i);
    hash = hash & 0x7fffffff;
  }
  return hash.abs();
}

bool isInRollout(String userId, int percentage) {
  final bucket = hashUser(userId) % 100;
  return bucket < percentage;
}

bool evaluateFeature(Map user, Map featureConfig, {bool debug = false}) {
  // Rule match
  for (var rule in featureConfig["rules"]) {
    if (user[rule["field"]] == rule["value"]) {
      if (debug) print("Matched rule: $rule");
      return true;
    }
  }

  // Rollout fallback
  final rollout = isInRollout(user["id"], featureConfig["rollout"]);

  if (debug) print("Rollout result: $rollout");

  return rollout;
}

Map<String, dynamic> evaluateFeatureDetailed(
  Map<String, dynamic> user,
  Map<String, dynamic> featureConfig,
  {bool debug = false}
) {
  final rules = featureConfig["rules"] as List;

  // Rule match
  for (var rule in rules) {
    if (user[rule["field"]] == rule["value"]) {
      if (debug) print("Matched rule: $rule");

      return {
        "enabled": true,
        "reason": "rule",
        "rule": rule
      };
    }
  }

  // Rollout fallback
  final rollout = isInRollout(
    user["id"],
    featureConfig["rollout"]
  );

  if (debug) print("Rollout result: $rollout");

  return {
    "enabled": rollout,
    "reason": rollout ? "rollout" : "none"
  };
}