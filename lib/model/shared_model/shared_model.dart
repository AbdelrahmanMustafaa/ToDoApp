const String generalName ='';

class SharedModel {
  final String? name;

  const SharedModel({
    this.name,
  });

  Map<String, dynamic> toMap() {
    return {
     generalName :name,
    };
  }

  factory SharedModel.fromMap(Map<String, dynamic> map) {
    return SharedModel(
      name: map[generalName],

    );
  }




}
