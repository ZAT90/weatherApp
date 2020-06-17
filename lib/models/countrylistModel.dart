class CountryListModel {
  String city;
  String admin;
  String country;
  String populationProper;
  String iso2;
  String capital;
  String lat;
  String lng;
  String population;

  CountryListModel(
      {this.city,
      this.admin,
      this.country,
      this.populationProper,
      this.iso2,
      this.capital,
      this.lat,
      this.lng,
      this.population});

  CountryListModel.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    admin = json['admin'];
    country = json['country'];
    populationProper = json['population_proper'];
    iso2 = json['iso2'];
    capital = json['capital'];
    lat = json['lat'];
    lng = json['lng'];
    population = json['population'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    data['admin'] = this.admin;
    data['country'] = this.country;
    data['population_proper'] = this.populationProper;
    data['iso2'] = this.iso2;
    data['capital'] = this.capital;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['population'] = this.population;
    return data;
  }
}
