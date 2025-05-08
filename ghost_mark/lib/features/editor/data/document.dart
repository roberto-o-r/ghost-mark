class Document {
  final String content;

  Document({required this.content}); 

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      content: json['content'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
    };
  }
}