class UserModel{
  final String uID;
  final String uName;
  final String uSurname;
  final String uPhoneNo;
  final String uMail;
  final String uGender;
  final String uBirthdate;
  final String uBloodType;
  final String uCity;
  final String uDistrict;
  final String uNeighborhood;
  final String uBuilding;
  final String uFloor;
  final String uCondo;
  final String uAddress;
  final String uSMSCode;
  final String uType;
  final bool uIsActive;
  final int createEpoch;
  final int updateEpoch;

  UserModel({
      this.uID,
      this.uName,
      this.uSurname,
      this.uPhoneNo,
      this.uMail,
      this.uGender,
      this.uBirthdate,
      this.uBloodType,
      this.uCity,
      this.uDistrict,
      this.uNeighborhood,
      this.uBuilding,
      this.uFloor,
      this.uCondo,
      this.uAddress,
      this.uSMSCode,
      this.uType,
      this.uIsActive,
      this.createEpoch,
      this.updateEpoch});

  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(
      uID: json['uID'],
      uName: json['uName'],
      uSurname: json['uSurname'],
      uPhoneNo: json['uPhoneNo'],
        uMail: json['uMail'],
        uGender: json['uGender'],
        uBirthdate: json['uBirthdate'],
        uBloodType: json['uBloodType'],
        uCity: json['uCity'],
        uDistrict: json['uDistrict'],
        uNeighborhood: json['uNeighborhood'],
        uBuilding: json['uBuilding'],
        uFloor: json['uFloor'],
        uCondo: json['uCondo'],
        uAddress: json['uAddress'],
        uSMSCode: json['uSMSCode'],
        uType: json['uType'],
        uIsActive: json['uIsActive'],
        createEpoch: json['createEpoch'],
        updateEpoch: json['updateEpoch']
    );
  }
}