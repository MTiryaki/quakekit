class MeetingAreaModel{
  final String maID;
  final String mID;
  final String maTitle;
  final double maLat;
  final double maLng;
  final String maCity;
  final String maDistrict;
  final String maNeighborhood;

  MeetingAreaModel({
    this.maID,
    this.mID,
    this.maTitle,
    this.maLat,
    this.maLng,
    this.maCity,
    this.maDistrict,
    this.maNeighborhood});

  factory MeetingAreaModel.fromJson(Map<String, dynamic> json){
    return MeetingAreaModel(
        maID: json['maID'],
        mID: json['mID'],
        maTitle: json['maTitle'],
        maLat: json['maLat'],
        maLng: json['maLng'],
        maCity: json['maCity'],
        maDistrict: json['maDistrict'],
        maNeighborhood: json['maNeighborhood']
    );
  }
}