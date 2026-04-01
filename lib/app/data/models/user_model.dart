class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String maidenName;
  final int age;
  final String gender;
  final String email;
  final String phone;
  final String username;
  final String password;
  final String birthDate;
  final String image;
  final String bloodGroup;
  final double height;
  final double weight;
  final String eyeColor;
  final HairModel hair;
  final AddressModel address;
  final String domain;
  final String ip;
  final String macAddress;
  final String university;
  final BankModel bank;
  final CompanyModel company;
  final String ein;
  final String ssn;
  final String userAgent;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.maidenName,
    required this.age,
    required this.gender,
    required this.email,
    required this.phone,
    required this.username,
    required this.password,
    required this.birthDate,
    required this.image,
    required this.bloodGroup,
    required this.height,
    required this.weight,
    required this.eyeColor,
    required this.hair,
    required this.address,
    required this.domain,
    required this.ip,
    required this.macAddress,
    required this.university,
    required this.bank,
    required this.company,
    required this.ein,
    required this.ssn,
    required this.userAgent,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int? ?? 0,
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      maidenName: json['maidenName'] as String? ?? '',
      age: json['age'] as int? ?? 0,
      gender: json['gender'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      username: json['username'] as String? ?? '',
      password: json['password'] as String? ?? '',
      birthDate: json['birthDate'] as String? ?? '',
      image: json['image'] as String? ?? '',
      bloodGroup: json['bloodGroup'] as String? ?? '',
      height: (json['height'] as num?)?.toDouble() ?? 0.0,
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      eyeColor: json['eyeColor'] as String? ?? '',
      hair: json['hair'] != null
          ? HairModel.fromJson(json['hair'] as Map<String, dynamic>)
          : HairModel(color: '', type: ''),
      address: json['address'] != null
          ? AddressModel.fromJson(json['address'] as Map<String, dynamic>)
          : AddressModel.empty(),
      domain: json['domain'] as String? ?? '',
      ip: json['ip'] as String? ?? '',
      macAddress: json['macAddress'] as String? ?? '',
      university: json['university'] as String? ?? '',
      bank: json['bank'] != null
          ? BankModel.fromJson(json['bank'] as Map<String, dynamic>)
          : BankModel(cardNumber: '', cardType: '', currency: '', iban: ''),
      company: json['company'] != null
          ? CompanyModel.fromJson(json['company'] as Map<String, dynamic>)
          : CompanyModel(name: '', address: AddressModel.empty()),
      ein: json['ein'] as String? ?? '',
      ssn: json['ssn'] as String? ?? '',
      userAgent: json['userAgent'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'maidenName': maidenName,
      'age': age,
      'gender': gender,
      'email': email,
      'phone': phone,
      'username': username,
      'password': password,
      'birthDate': birthDate,
      'image': image,
      'bloodGroup': bloodGroup,
      'height': height,
      'weight': weight,
      'eyeColor': eyeColor,
      'hair': hair.toJson(),
      'address': address.toJson(),
      'domain': domain,
      'ip': ip,
      'macAddress': macAddress,
      'university': university,
      'bank': bank.toJson(),
      'company': company.toJson(),
      'ein': ein,
      'ssn': ssn,
      'userAgent': userAgent,
    };
  }
}

class HairModel {
  final String color;
  final String type;

  HairModel({required this.color, required this.type});

  factory HairModel.fromJson(Map<String, dynamic> json) {
    return HairModel(
      color: json['color'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'color': color, 'type': type};
}

class AddressModel {
  final String address;
  final String city;
  final CoordinatesModel coordinates;

  AddressModel({
    required this.address,
    required this.city,
    required this.coordinates,
  });

  factory AddressModel.empty() => AddressModel(
        address: '',
        city: '',
        coordinates: CoordinatesModel(lat: 0.0, lng: 0.0),
      );

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      address: json['address'] as String? ?? '',
      city: json['city'] as String? ?? '',
      coordinates: json['coordinates'] != null
          ? CoordinatesModel.fromJson(
              json['coordinates'] as Map<String, dynamic>)
          : CoordinatesModel(lat: 0.0, lng: 0.0),
    );
  }

  Map<String, dynamic> toJson() => {
        'address': address,
        'city': city,
        'coordinates': coordinates.toJson(),
      };
}

class CoordinatesModel {
  final double lat;
  final double lng;

  CoordinatesModel({required this.lat, required this.lng});

  factory CoordinatesModel.fromJson(Map<String, dynamic> json) {
    return CoordinatesModel(
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {'lat': lat, 'lng': lng};
}

class BankModel {
  final String cardNumber;
  final String cardType;
  final String currency;
  final String iban;

  BankModel({
    required this.cardNumber,
    required this.cardType,
    required this.currency,
    required this.iban,
  });

  factory BankModel.fromJson(Map<String, dynamic> json) {
    return BankModel(
      cardNumber: json['cardNumber'] as String? ?? '',
      cardType: json['cardType'] as String? ?? '',
      currency: json['currency'] as String? ?? '',
      iban: json['iban'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'cardNumber': cardNumber,
        'cardType': cardType,
        'currency': currency,
        'iban': iban,
      };
}

class CompanyModel {
  final String name;
  final AddressModel address;

  CompanyModel({required this.name, required this.address});

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      name: json['name'] as String? ?? '',
      address: json['address'] != null
          ? AddressModel.fromJson(json['address'] as Map<String, dynamic>)
          : AddressModel.empty(),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'address': address.toJson(),
      };
}
