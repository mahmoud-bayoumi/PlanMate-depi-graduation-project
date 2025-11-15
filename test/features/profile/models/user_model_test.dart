import 'package:flutter_test/flutter_test.dart';
import 'package:planmate_app/features/profile/models/user_model.dart';

void main() {
  group('UserModel', () {
    // Sample data for testing
    final testUserData = {
      'userId': 'user1',
      'firstName': 'First1',
      'lastName': 'Last1',
      'email': 'user1@example.com',
      'birthDate': '01-01-1990',
      'profileImageUrl': 'https://example.com/image1.png',
    };

    final testUser = UserModel(
      userId: 'user1',
      firstName: 'First1',
      lastName: 'Last1',
      email: 'user1@example.com',
      birthDate: '01-01-1990',
      profileImageUrl: 'https://example.com/image1.png',
    );

    // TEST 1: Create UserModel from Map
    test('should create UserModel from map correctly', () {
      final result = UserModel.fromMap(testUserData);

      expect(result.userId, 'user1');
      expect(result.firstName, 'First1');
      expect(result.lastName, 'Last1');
      expect(result.email, 'user1@example.com');
      expect(result.birthDate, '01-01-1990');
      expect(result.profileImageUrl, 'https://example.com/image1.png');
    });

    // TEST 2: Create UserModel from Map without profile image
    test('should create UserModel from map with null profileImageUrl', () {
      final dataWithoutImage = {
        'userId': 'user2',
        'firstName': 'First2',
        'lastName': 'Last2',
        'email': 'user2@example.com',
        'birthDate': '02-02-1992',
      };

      final result = UserModel.fromMap(dataWithoutImage);

      expect(result.userId, 'user2');
      expect(result.firstName, 'First2');
      expect(result.profileImageUrl, null);
    });

    // TEST 3: Convert UserModel to Map
    test('should convert UserModel to map correctly', () {
      final result = testUser.toMap();

      expect(result['userId'], 'user1');
      expect(result['firstName'], 'First1');
      expect(result['lastName'], 'Last1');
      expect(result['email'], 'user1@example.com');
      expect(result['birthDate'], '01-01-1990');
      expect(result['profileImageUrl'], 'https://example.com/image1.png');
    });

    // TEST 4: fullName getter returns correct result
    test('should return correct full name', () {
      final result = testUser.fullName;

      expect(result, 'First1 Last1');
    });

    // TEST 5: copyWith method creates new instance with updated values
    test('should create new UserModel with updated values using copyWith', () {
      final result = testUser.copyWith(
        firstName: 'First1Updated',
        lastName: 'Last1Updated',
      );

      expect(result.firstName, 'First1Updated');
      expect(result.lastName, 'Last1Updated');
      expect(result.userId, 'user1');
      expect(result.email, 'user1@example.com');
      expect(result.birthDate, '01-01-1990');
    });

    // TEST 6: copyWith with no parameters returns same values
    test('should return same values when copyWith is called without parameters', () {
      final result = testUser.copyWith();

      expect(result.userId, testUser.userId);
      expect(result.firstName, testUser.firstName);
      expect(result.lastName, testUser.lastName);
      expect(result.email, testUser.email);
      expect(result.birthDate, testUser.birthDate);
      expect(result.profileImageUrl, testUser.profileImageUrl);
    });
  });
}
