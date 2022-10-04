import 'task_constant.dart';

class  TaskModel {
  final int? id;
  final String? value;
  final String? state;

  const TaskModel({
    this.id,
    this.value,
    this.state,
  });

  Map<String, dynamic> toMap() {
    return {
      taskValue: value,
      taskState: state,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map[taskId],
      value: map[taskValue],
      state: map[taskState],
    );
  }
}
