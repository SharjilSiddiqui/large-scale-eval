class FeatureFlag {
  final String name;
  int rollout;
  final List<Map<String, dynamic>> rules;
  final String owner;
  final DateTime createdAt;
  final DateTime? expiresAt;
  bool isActive;

  FeatureFlag({
    required this.name,
    required this.rollout,
    required this.rules,
    required this.owner,
    required this.createdAt,
    this.expiresAt,
    this.isActive = true,
  });
}

// 🔐 Governance rules
bool canModifyFlag(String role) {
  return role == "admin" || role == "owner";
}

bool isExpired(FeatureFlag flag) {
  if (flag.expiresAt == null) return false;
  return DateTime.now().isAfter(flag.expiresAt!);
}

bool isValidRollout(int rollout) {
  return rollout >= 0 && rollout <= 100;
}

bool canDeleteFlag(String role) {
  return role == "admin";
}

// 📜 Audit log
void logAudit(String action, String user, String flagName) {
  print("[AUDIT] $action by $user on $flagName at ${DateTime.now()}");
}

// ⚙️ Safe update
void updateFlag(
  FeatureFlag flag,
  String user,
  String role,
  int newRollout,
) {
  print("Current rollout: ${flag.rollout}");

  // ❌ Permission check
  if (!canModifyFlag(role)) {
    print("❌ Permission denied");
    return;
  }

  // ❌ Expiry check
  if (isExpired(flag)) {
    print("❌ Cannot modify expired flag");
    return;
  }

  // ✅ ADD HERE (validation before update)
  if (!isValidRollout(newRollout)) {
    print("❌ Invalid rollout value");
    return;
  }

  // ✅ Safe update
  flag.rollout = newRollout;

  logAudit("UPDATE", user, flag.name);

  print("Updated rollout: ${flag.rollout}");
  print("✅ Flag updated safely");
}

void deleteFlag(FeatureFlag flag, String user, String role) {
  if (!canDeleteFlag(role)) {
    print("❌ Only admin can delete flags");
    return;
  }

  logAudit("DELETE", user, flag.name);
  print("🗑 Flag deleted");
}