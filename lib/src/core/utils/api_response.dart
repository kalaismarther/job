class ApiResponse<T> {
  final T data;
  final bool success;

  ApiResponse({required this.data, required this.success});
}