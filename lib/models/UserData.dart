class UserData {
  List<UserInfo> _data;

  List<UserInfo> get data => _data;

  UserData({List<UserInfo> data}) {
    this._data = data;
  }

  UserData.fromJson(Map<dynamic, dynamic> json) {
    if (json['data'] != null) {
      _data = List<UserInfo>();
      json['data'].forEach((v) {
        _data.add(UserInfo.fromJson(v));
      });
    }
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = Map<dynamic, dynamic>();
    if (this._data != null) {
      data['data'] = this._data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserInfo {
  dynamic _avatar;
  dynamic _bio;
  dynamic _firstName;
  dynamic _id;
  dynamic _lastName;
  dynamic _title;

  UserInfo(
      {dynamic avatar,
      dynamic bio,
      dynamic firstName,
      dynamic id,
      dynamic lastName,
      dynamic title}) {
    this._avatar = avatar;
    this._bio = bio;
    this._firstName = firstName;
    this._id = id;
    this._lastName = lastName;
    this._title = title;
  }

  dynamic get avatar => _avatar;

  dynamic get bio => _bio;

  dynamic get firstName => _firstName;

  dynamic get id => _id;

  dynamic get lastName => _lastName;

  dynamic get title => _title;

  UserInfo.fromJson(Map<dynamic, dynamic> json) {
    _avatar = json['avatar'];
    _bio = json['bio'];
    _firstName = json['firstName'];
    _id = json['id'];
    _lastName = json['lastName'];
    _title = json['title'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = Map<dynamic, dynamic>();
    data['avatar'] = this._avatar;
    data['bio'] = this._bio;
    data['firstName'] = this._firstName;
    data['id'] = this._id;
    data['lastName'] = this._lastName;
    data['title'] = this._title;
    return data;
  }
}
