
class Notice {

  final String title;
  final String content;
  final DateTime createDate;

  Notice.fromJson(Map<String, dynamic> json):
    title = json['title'],
    content = json['content'],
    createDate = DateTime.parse(json['createDate']);

  Notice(this.title, this.content, this.createDate);
}