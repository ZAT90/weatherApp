class CityDbModel {
  int id;
  String city;

  CityDbModel(this.city);

  CityDbModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    city = json['city'];
  }
  CityDbModel.fromMap(dynamic obj) {
    this.id = obj["id"];
    this.city = obj["city"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (id != null) {
      map["id"] = id;
    }
    map["city"] = city;

    return map;
  }

  //Getters
  int get getId => id;
  String get getCity => city;
}
