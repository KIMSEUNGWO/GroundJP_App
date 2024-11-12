
class InvalidData {

  final String field;
  final String message;

  InvalidData.fromJson(Map<String, dynamic> json):
    field = json['field'],
    message = json['message'];

  InvalidData(this.field, this.message);
}