class CountryDbModel {
  int id;
  String country;

  CountryDbModel(this.country);

  CountryDbModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    country = json['country'];
  }
  CountryDbModel.fromMap(dynamic obj) {
    this.id = obj["id"];
    this.country = obj["country"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (id != null) {
     map["id"] = id;
    }
    map["country"] = country;

    return map;
  }

  //Getters
  int get getId => id;
  String get getCountry => country;
}