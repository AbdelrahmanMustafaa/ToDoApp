
import 'grateful_constant.dart';

class GratefulModel {
  final int? id;
  final String? value;

  const GratefulModel({
    this.id,
    this.value,
  });

  Map<String, dynamic> toMap() {
    return {
      gratefulValue: value,
    };
  }

  factory GratefulModel.fromMap(Map<String, dynamic> map) {
    return GratefulModel(
      id: map[gratefulId],
      value: map[gratefulValue],

    );
  }
}
