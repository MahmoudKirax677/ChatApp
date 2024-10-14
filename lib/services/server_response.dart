class ServerResponse<T> {

  bool success;
  T? data;
  int? statusCode;
  String? message;
  var validation;
  int? count;

  ServerResponse({
    this.success = false,
    this.data,
    this.statusCode,
    this.message,
    this.count,
    this.validation
  });

}
