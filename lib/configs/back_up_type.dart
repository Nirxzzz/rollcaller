enum BackUpType {
  auto,
  manual,
}

// Backup type extension
extension BackUpTypeExtension on BackUpType {
  // Stable token embedded in backup file names (must never be localized).
  String get fileToken {
    switch (this) {
      case BackUpType.auto:
        return 'auto';
      case BackUpType.manual:
        return 'manual';
    }
  }

  int get toInt {
    switch (this) {
      case BackUpType.auto:
        return 1;
      case BackUpType.manual:
        return 2;
    }
  }

  static BackUpType fromInt(int value) {
    switch (value) {
      case 1:
        return BackUpType.auto;
      case 2:
        return BackUpType.manual;

      default:
        return BackUpType.auto;
    }
  }

  // Parses the type token from a backup file name. Accepts the current
  // ASCII tokens and the legacy Chinese tokens used by older backups.
  static BackUpType fromString(String value) {
    switch (value) {
      case 'manual':
      case '手动备份':
        return BackUpType.manual;
      case 'auto':
      case '自动备份':
      default:
        return BackUpType.auto;
    }
  }
}
