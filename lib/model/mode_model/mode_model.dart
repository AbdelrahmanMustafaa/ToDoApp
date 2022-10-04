import 'mode_constant.dart';

class ModeModel {
  final int? id;
  final String? value;

  const ModeModel({
    this.id,
    this.value,
  });

  Map<String, dynamic> toMap() {
    return {
      modeValue: value,
    };
  }

  factory ModeModel.fromMap(Map<String, dynamic> map) {
    return ModeModel(
      id: map[modeId],
      value: map[modeValue],

    );
  }
}
