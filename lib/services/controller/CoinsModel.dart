class CoinsModel {
  CoinsModel({
    required this.message,
    required this.data,
    required this.offers,
    required this.status,
    required this.statusCode,
  });
  late final String message;
  late final List<Data> data;
  late final List<dynamic> offers;
  late final bool status;
  late final int statusCode;

  CoinsModel.fromJson(Map<String, dynamic> json){
    message = json['message'];
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
    offers = List.castFrom<dynamic, dynamic>(json['offers']);
    status = json['status'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    _data['offers'] = offers;
    _data['status'] = status;
    _data['statusCode'] = statusCode;
    return _data;
  }
}

class Data {
  Data({
    required this.id,
    required this.name,
    required this.coinsAmount,
    required this.price,
  });
  late final int id;
  late final String name;
  late final String coinsAmount;
  late final int price;

  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    coinsAmount = json['coinsAmount'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['coinsAmount'] = coinsAmount;
    _data['price'] = price;
    return _data;
  }
}