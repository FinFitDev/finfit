class ContentWithLoading<T> {
  T content;
  bool isLoading = false;

  ContentWithLoading({
    required this.content,
  });

  ContentWithLoading<T> copyWith({T? content, bool? isLoading}) {
    final data = ContentWithLoading<T>(
      content: content ?? this.content,
    );
    data.isLoading = isLoading ?? this.isLoading;
    return data;
  }
}
