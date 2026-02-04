class RuntimePopupModel {
  final bool show;
  final String? title;
  final String? message;
  final bool force;
  final String? action;

  RuntimePopupModel({
    required this.show,
    this.title,
    this.message,
    this.force = false,
    this.action,
  });

  factory RuntimePopupModel.fromJson(Map<String, dynamic> json) {
    return RuntimePopupModel(
      show: json['show'] == true,
      title: json['title'] as String?,
      message: json['message'] as String?,
      force: json['force'] == true,
      action: json['action'] as String?,
    );
  }
}
