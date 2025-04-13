DateTime? dateTimeParseNullish(String? value) {
  if (value == null) return null;
  try {
    return DateTime.parse(value).toLocal();
  } catch (e) {
    return null;
  }
}
