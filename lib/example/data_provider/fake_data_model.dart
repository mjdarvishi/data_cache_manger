//Fake data model
class FaKeData {
  String name;
  int age;

  FaKeData(this.name, this.age);

  factory FaKeData.fromJson(Map<String, dynamic> json) => FaKeData(
    json['name'] as String,
    json['age'] as int,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{'name': name, 'age': age};
  @override
  String toString()=>'The name is $name and the age is $age';
}
