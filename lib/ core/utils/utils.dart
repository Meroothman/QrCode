class ValidationUtils {
  /// Check if text is a valid URL
  static bool isLink(String text) {
    if (text.isEmpty) return false;

    // Comprehensive URL pattern that handles various URL formats
    final linkPattern = RegExp(
      r'^(https?:\/\/)?([\w\-]+(\.[\w\-]+)+)([\/\?\#][^\s]*)?$',
      caseSensitive: false,
    );

    // Check for common URL patterns without protocol
    final commonDomainPattern = RegExp(
      r'^([\w\-]+(\.[\w\-]+){2,})([\/\?\#][^\s]*)?$',
      caseSensitive: false,
    );

    return linkPattern.hasMatch(text) || commonDomainPattern.hasMatch(text);
  }

  /// Validate if string is not empty
  static bool isNotEmpty(String? text) {
    return text != null && text.trim().isNotEmpty;
  }
}

class DateTimeUtils {
  /// Format DateTime to readable string
  static String formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/'
        '${dateTime.month.toString().padLeft(2, '0')}/'
        '${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

class TextUtils {
  /// Truncate text with ellipsis
  static String truncate(String text, {int maxLength = 30}) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
}