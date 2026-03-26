import 'package:base_project_getx/app/data/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserModel', () {
    final validJson = {
      'id': 1,
      'firstName': 'Terry',
      'lastName': 'Medhurst',
      'maidenName': 'Smitham',
      'age': 50,
      'gender': 'male',
      'email': 'atuny0@sohu.com',
      'phone': '+63 791 675 8914',
      'username': 'atuny0',
      'password': '9uQFF1Lh',
      'birthDate': '2000-12-25',
      'image': 'https://robohash.org/1',
      'bloodGroup': '0 AB',
      'height': 189.0,
      'weight': 75.4,
      'eyeColor': 'Green',
      'hair': {'color': 'Black', 'type': 'Strands'},
      'address': {
        'address': '1745 T Street',
        'city': 'Washington',
        'coordinates': {'lat': 38.8, 'lng': -77.0},
      },
      'domain': 'slashdot.org',
      'ip': '117.29.86.254',
      'macAddress': '13:69:BA:56:A3:74',
      'university': 'Capitol University',
      'bank': {
        'cardNumber': '5108754631764712',
        'cardType': 'maestro',
        'currency': 'Peso',
        'iban': 'NO17 0695 2754 967',
      },
      'company': {
        'name': 'Blanda-O\'Keefe and Sons',
        'address': {
          'address': '629 Debbie Drive',
          'city': 'Nashville',
          'coordinates': {'lat': 36.2, 'lng': -86.5},
        },
      },
      'ein': '20-9487066',
      'ssn': '661-64-2976',
      'userAgent': 'Mozilla/5.0',
    };

    test('fromJson parses all top-level fields correctly', () {
      final user = UserModel.fromJson(validJson);

      expect(user.id, 1);
      expect(user.firstName, 'Terry');
      expect(user.lastName, 'Medhurst');
      expect(user.age, 50);
      expect(user.email, 'atuny0@sohu.com');
      expect(user.username, 'atuny0');
    });

    test('fromJson parses nested HairModel', () {
      final user = UserModel.fromJson(validJson);

      expect(user.hair.color, 'Black');
      expect(user.hair.type, 'Strands');
    });

    test('fromJson parses nested AddressModel', () {
      final user = UserModel.fromJson(validJson);

      expect(user.address.city, 'Washington');
      expect(user.address.address, '1745 T Street');
      expect(user.address.coordinates.lat, 38.8);
      expect(user.address.coordinates.lng, -77.0);
    });

    test('fromJson parses nested BankModel', () {
      final user = UserModel.fromJson(validJson);

      expect(user.bank.cardNumber, '5108754631764712');
      expect(user.bank.cardType, 'maestro');
      expect(user.bank.currency, 'Peso');
    });

    test('fromJson parses nested CompanyModel', () {
      final user = UserModel.fromJson(validJson);

      expect(user.company.name, "Blanda-O'Keefe and Sons");
      expect(user.company.address.city, 'Nashville');
    });

    test('fromJson uses empty string when domain is null', () {
      final json = Map<String, dynamic>.from(validJson);
      json['domain'] = null;

      final user = UserModel.fromJson(json);
      expect(user.domain, '');
    });

    test('toJson round-trips correctly', () {
      final original = UserModel.fromJson(validJson);
      final json = original.toJson();
      final restored = UserModel.fromJson(json);

      expect(restored.id, original.id);
      expect(restored.firstName, original.firstName);
      expect(restored.email, original.email);
      expect(restored.hair.color, original.hair.color);
      expect(restored.address.city, original.address.city);
      expect(restored.bank.cardNumber, original.bank.cardNumber);
    });

    test('HairModel toJson contains correct keys', () {
      final user = UserModel.fromJson(validJson);
      final hairJson = user.hair.toJson();

      expect(hairJson.containsKey('color'), isTrue);
      expect(hairJson.containsKey('type'), isTrue);
    });

    test('CoordinatesModel parses int lat/lng as double', () {
      final json = Map<String, dynamic>.from(validJson);
      json['address'] = {
        'address': '123 Main St',
        'city': 'TestCity',
        'coordinates': {'lat': 10, 'lng': 20},
      };

      final user = UserModel.fromJson(json);
      expect(user.address.coordinates.lat, isA<double>());
      expect(user.address.coordinates.lng, isA<double>());
    });
  });
}
