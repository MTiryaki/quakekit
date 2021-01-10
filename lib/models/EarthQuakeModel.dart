class EarthQuakeModel{
  final String eqID;
  final String eqDate;
  final String eqTime;
  final String eqLat;
  final String eqLng;
  final String eqDepth;
  final String eqSize;
  final String eqLocationName;
  final String eqCity;

  EarthQuakeModel({
    this.eqID,
    this.eqDate,
    this.eqTime,
    this.eqLat,
    this.eqLng,
    this.eqDepth,
    this.eqSize,
    this.eqLocationName,
    this.eqCity});

  factory EarthQuakeModel.fromJson(Map<String, dynamic> json){
    return EarthQuakeModel(
        eqID: json['eqID'],
        eqDate: json['eqDate'],
        eqTime: json['eqTime'],
        eqLat: json['eqLat'],
        eqLng: json['eqLng'],
        eqDepth: json['eqDepth'],
        eqSize: json['eqSize'],
        eqLocationName: json['eqLocationName'],
        eqCity: json['eqCity']
    );
  }
}