import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Account Access Information Management
class Access {
  // Helper method to get a shared preference
  Future<String?> _getSharedPreference(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  // Helper method to remove a shared preference
  Future<void> _removeSharedPreference(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  Future<String?> getUserId() => _getSharedPreference('userId');

  Future<String?> getToken() => _getSharedPreference('secureToken');

  Future<String?> getUserName() => _getSharedPreference('userName');

  Future<String?> getUserPhone() => _getSharedPreference('phoneNumber');

  Future<String?> getUserTripNumber() => _getSharedPreference('numberOfTrips');

  Future<String?> getUserEmail() => _getSharedPreference('email');

  Future<String?> getUserImageProfileUrl() => _getSharedPreference('url');

  Future<String?> getUserTokenExpiry() => _getSharedPreference('tokenExpiry');

  Future<String?> getOneStar() => _getSharedPreference('oneStar');

  Future<String?> getTwoStars() => _getSharedPreference('twoStars');

  Future<String?> getThreeStars() => _getSharedPreference('threeStars');

  Future<String?> getFourStars() => _getSharedPreference('fourStars');

  Future<String?> getFiveStars() => _getSharedPreference('fiveStars');

  Future<void> removeUserId() => _removeSharedPreference('userId');

  Future<void> removeToken() => _removeSharedPreference('secureToken');

  Future<void> removeUserName() => _removeSharedPreference('userName');

  Future<void> removeUserPhone() => _removeSharedPreference('phoneNumber');

  Future<void> removeUserTripNumber() =>
      _removeSharedPreference('numberOfTrips');

  Future<void> removeUserEmail() => _removeSharedPreference('email');

  Future<void> removeUserImageProfileUrl() => _removeSharedPreference('url');

  Future<void> removeUserTokenExpiry() =>
      _removeSharedPreference('tokenExpiry');

  Future<void> removeOneStar() => _removeSharedPreference('oneStar');

  Future<void> removeTwoStars() => _removeSharedPreference('twoStars');

  Future<void> removeThreeStars() => _removeSharedPreference('threeStars');

  Future<void> removeFourStars() => _removeSharedPreference('fourStars');

  Future<void> removeFiveStars() => _removeSharedPreference('fiveStars');
}

class DeleteAccount {
  static const String baseUrl =
      'http://transithub.runasp.net/api/Account/DeleteUser';

  static Future<bool> deleteAccount({required String userId}) async {
    try {
      var response = await http.get(Uri.parse('${baseUrl}?id=${userId}'));
      if (response.statusCode == 200) {
        return true;
      } else {
        throw false;
      }
    } catch (e) {
      throw 'Error: $e';
    }
  }
}

// User Model
class User {
  final String id;
  final String token;
  final String tokenExpiry;
  final String userName;
  final String email;
  final String phoneNumber;
  final String numberOfTrips;

  User({
    required this.id,
    required this.token,
    required this.tokenExpiry,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.numberOfTrips,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user']['id'] as String,
      token: json['token'] as String,
      tokenExpiry: json['expiration'] as String,
      userName: json['user']['userName'] as String,
      email: json['user']['email'] as String,
      phoneNumber: json['user']['phoneNumber'] as String,
      numberOfTrips: json['user']['numberOfTrips'].toString(),
    );
  }
}

//Add Account
class AddAccountManager {
  Future<void> registerUser({
    required String userName,
    required String password,
    required String email,
    required String phoneNumber,
    required String userCardId,
    required String dateOfBirth,
    required File cardImageFile,
    required Function(bool success, String message) completion,
  }) async {
    final url = Uri.parse('http://transithub.runasp.net/api/Account/register');
    var request = http.MultipartRequest('POST', url);

    request.fields['UserName'] = userName;
    request.fields['Password'] = password;
    request.fields['Email'] = email;
    request.fields['PhoneNumber'] = phoneNumber;
    request.fields['userCardId'] = userCardId;
    request.fields['DateOfBirth'] = dateOfBirth;

    try {
      var cardImage = await http.MultipartFile.fromPath(
        'file',
        cardImageFile.path,
        filename: basename(cardImageFile.path),
      );
      request.files.add(cardImage);

      var response = await request.send();

      var responseData = await response.stream.bytesToString();
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        completion(true, 'User registered successfully');
      } else {
        completion(false,
            'Failed to register user: ${response.statusCode} - $responseData');
      }
    } catch (e) {
      completion(false, 'An error occurred: $e');
    }
  }
}

class AccountSearchManager {
  Future<void> searchAccount({
    required String email,
    required Function(bool success, String message, {String? phoneNumber})
        completion,
  }) async {
    final url = Uri.parse(
        'http://transithub.runasp.net/api/Account/getUserByEmail?email=$email');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // فك ترميز JSON لاستخراج البيانات
        final data = jsonDecode(response.body);
        final phoneNumber = data['phoneNumber'] as String?;

        completion(true, 'Email exists', phoneNumber: phoneNumber);
      } else if (response.statusCode == 404) {
        completion(false, 'Email does not exist');
      } else {
        completion(false, 'Failed to get email: ${response.statusCode}');
      }
    } catch (e) {
      completion(false, 'An error occurred: $e');
    }
  }
}

// User Image
class UserImageManager {
  static const String baseUrl = 'http://transithub.runasp.net/api/UserImage';

  // Function to upload user profile image
  static Future<void> uploadUserImage(
    File file,
    Function(bool success, String message) completion,
  ) async {
    String? userId = await Access().getUserId();
    try {
      var url = Uri.parse('$baseUrl/CreateUserImg?UserId=$userId');
      var request = http.MultipartRequest('POST', url);
      var imageProfile = await http.MultipartFile.fromPath(
        'file',
        file.path,
        filename: basename(file.path),
      );
      request.files.add(imageProfile);
      var response = await request.send();
      if (response.statusCode == 202 ||
          response.statusCode == 201 ||
          response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        var responseBody = responseData.body;
        var jsonResponse = json.decode(responseBody);
        final imageUrl = jsonResponse['url'];
        completion(true, imageUrl);
      } else {
        completion(false, 'Failed to upload image');
      }
    } catch (e) {
      completion(false, 'Error: $e');
    }
  }

  // Function to get user profile image by ID
  static Future<String?> getUserImageById({required String userId}) async {
    try {
      var response = await http.get(Uri.parse(
          'http://transithub.runasp.net/api/UserImage/GetImgeById?id=${userId}'));
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['url'] != null) {
          final imageUrl = responseData['url'];
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('url', imageUrl);
          return imageUrl;
        } else {
          throw 'Image URL not found in response';
        }
      } else {
        throw 'Failed to retrieve image';
      }
    } catch (e) {
      throw 'Error: $e';
    }
  }

  // Function to update user profile image
  static Future<String?> updateUserImage(File file) async {
    String? userId = await Access().getUserId();
    try {
      var url = Uri.parse('$baseUrl/UpdateUserImage?UserId=$userId');
      var request = http.MultipartRequest('POST', url);
      var imageProfile = await http.MultipartFile.fromPath(
        'file',
        file.path,
        filename: basename(file.path),
      );
      request.files.add(imageProfile);
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        var responseBody = responseData.body;
        var jsonResponse = json.decode(responseBody);
        final imageUrl = jsonResponse['url'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('url', imageUrl);
        return null;
      } else {
        throw 'Failed to upload image';
      }
    } catch (e) {
      throw 'Error: $e';
    }
  }
}

// Login Manager
class LoginManager {
  final http.Client client;

  LoginManager(this.client);

  Future<void> loginUser({
    required String userEmail,
    required String password,
    required Function(bool success, String message) completion,
  }) async {
    final url = Uri.parse('http://transithub.runasp.net/api/Account/login');

    var userLog = {
      'UserEmail': userEmail,
      'Password': password,
    };

    try {
      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userLog),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData.containsKey('user') &&
            responseData.containsKey('token') &&
            responseData.containsKey('expiration')) {
          final user = User.fromJson(responseData);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('userId', user.id);
          await prefs.setString('secureToken', user.token);
          await prefs.setString('tokenExpiry', user.tokenExpiry);
          await prefs.setString('userName', user.userName);
          await prefs.setString('email', user.email);
          await prefs.setString('phoneNumber', user.phoneNumber);
          await prefs.setString('numberOfTrips', user.numberOfTrips);

          // Confirm successful data storage
          print('Stored User ID: ${prefs.getString('userId')}');
          print('Stored Token: ${prefs.getString('secureToken')}');
          print('Stored Token Expiry: ${prefs.getString('tokenExpiry')}');
          print('Stored Username: ${prefs.getString('userName')}');
          print('Stored Email: ${prefs.getString('email')}');
          print('Stored Phone Number: ${prefs.getString('phoneNumber')}');
          print('Stored Number of Trips: ${prefs.getString('numberOfTrips')}');

          completion(true, 'User logged in successfully');
        } else {
          completion(false, 'Invalid response format');
        }
      } else {
        String errorMessage = 'Failed to login: ${response.statusCode}';
        try {
          final errorData = jsonDecode(response.body);
          errorMessage += ' - ${errorData['title']}';
          errorMessage += ' - ${errorData['detail']}';
        } catch (e) {
          errorMessage += ' - Unable to parse error details';
        }
        completion(false, errorMessage);
      }
    } catch (e) {
      completion(false, 'An error occurred: $e');
    }
  }
}

// Update Password
class UpdatePasswordManager {
  Future<void> updatePassword({
    required String email,
    required String password,
  }) async {
    final url =
        Uri.parse('http://transithub.runasp.net/api/Account/UpdatePassword');

    Map<String, dynamic> passwordData = {
      'email': email,
      'password': password,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(passwordData),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['succeeded'] == true) {
          print('Password updated successfully');
        } else {
          print('Failed to update password: ${responseData['errors']}');
        }
      } else {
        print('Failed to update password: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }
}

// Rate
class RateManager {
  Future<void> addRate({
    required String travelerId,
    required String oneStar,
    required String twoStars,
    required String threeStars,
    required String fourStars,
    required String fiveStars,
  }) async {
    final url = Uri.parse('http://transithub.runasp.net/api/Rate/addrate');

    Map<String, String> rateDetails = {
      'OneStar': oneStar,
      'TwoStars': twoStars,
      'ThreeStars': threeStars,
      'FourStars': fourStars,
      'FiveStars': fiveStars,
    };

    Map<String, dynamic> requestBody = {
      'UserId': travelerId,
      'OneStar': oneStar,
      'TwoStars': twoStars,
      'ThreeStars': threeStars,
      'FourStars': fourStars,
      'FiveStars': fiveStars,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 202 ||
          response.statusCode == 200 ||
          response.statusCode == 200) {
        print('Rate added successfully');
      } else {
        print('Failed to add rate: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  Future<void> getRate({required String Id}) async {
    final url =
        Uri.parse('http://transithub.runasp.net/api/Rate/getrate?userId=$Id');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        String oneStar = responseData['oneStar'] ?? '0';
        String twoStars = responseData['twoStars'] ?? '0';
        String threeStars = responseData['threeStars'] ?? '0';
        String fourStars = responseData['fourStars'] ?? '0';
        String fiveStars = responseData['fiveStars'] ?? '0';
        String travelerId = responseData['userId'] ?? '';
        print('User Rate: $responseData');

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('oneStar', oneStar);
        await prefs.setString('twoStars', twoStars);
        await prefs.setString('threeStars', threeStars);
        await prefs.setString('fourStars', fourStars);
        await prefs.setString('fiveStars', fiveStars);
        await prefs.setString('userId', travelerId);
      } else {
        print('Failed to get rate: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }
}

// Local Trip
class LocalTripManager {
  // Function to create local trip
  Future<void> createLocalTrip({
    required String from,
    required String to,
    required String VichelType,
    required String position,
  }) async {
    final url =
        Uri.parse('http://transithub.runasp.net/api/LocalTrip/CreateLocalTrip');
    String? userId = await Access().getUserId();
    if (userId == null) {
      print('User ID is null. Cannot create local trip.');
      return;
    }

    Map<String, String> localTrip = {
      'From': from,
      'To': to,
      'VichelType': VichelType,
      'UserId': userId,
      'Position': position,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(localTrip),
      );

      if (response.statusCode == 202 ||
          response.statusCode == 200 ||
          response.statusCode == 201) {
        print('Local trip created successfully');
        final responseData = jsonDecode(response.body);
        print('Response data: $responseData');
      } else {
        print('Failed to create local trip: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  // Function to get local trip and search
  Future<List<Map<String, dynamic>>> getAllLocalTrips() async {
    final url = Uri.parse(
        'http://transithub.runasp.net/api/LocalTrip/GetAllLocalTrips');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData
            .map((trip) => trip as Map<String, dynamic>)
            .toList();
      } else {
        throw Exception('Failed to get trips: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }
}

//general Trip

class TripManager {
  final String baseUrl = 'http://transithub.runasp.net/api/Trip';

  // Function to add trip
  Future<void> addTrip({
    required String startLocation,
    required String endLocation,
    required String dateOfTrip,
    required String viechelType,
  }) async {
    final url = Uri.parse('$baseUrl/AddTrip');
    String? userId = await Access().getUserId();
    if (userId == null) {
      print('User ID is null. Cannot add trip.');
      return;
    }
    Map<String, dynamic> tripDetail = {
      'startLocation': startLocation,
      'endLocation': endLocation,
      'dateOfTrip': dateOfTrip,
      'viechelType': viechelType,
      'userId': userId,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(tripDetail),
      );

      if (response.statusCode == 202 ||
          response.statusCode == 200 ||
          response.statusCode == 201) {
        print('Trip added successfully');
        final responseData = jsonDecode(response.body);
        print('Response data: $responseData');
      } else {
        print('Failed to add trip: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

// Function to get trip with user details
  Future<List<Map<String, dynamic>>> getAllTripsWithUserDetails() async {
    final url = Uri.parse('$baseUrl/gettripwithuser');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData
            .map((trip) => trip as Map<String, dynamic>)
            .toList();
      } else {
        throw Exception(
            'Failed to get trips with user details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

// Function to search trip
  Future<List<Map<String, dynamic>>> searchTrip({
    required String from,
    required String to,
  }) async {
    final url = Uri.parse('$baseUrl/searchtrip?from=$from&to=$to');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData
            .map((trip) => trip as Map<String, dynamic>)
            .toList();
      } else {
        throw Exception('Failed to search trips: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }
}

class QrCreateManager {
  Future<void> createQR({
    required String qrCode,
    required String senderId,
    required String carrierId,
    required String price,
  }) async {
    final url = Uri.parse('http://transithub.runasp.net/api/QRCode/CreateQR');

    Map<String, String> qrDetails = {
      'QRCode': qrCode,
      'SenderId': senderId,
      'CarrierId': carrierId,
      'Price': price,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(qrDetails),
      );

      if (response.statusCode == 200) {
        print('QR code created successfully');
        final responseData = jsonDecode(response.body);
        print('Response data: $responseData');
      } else {
        print('Failed to create QR code: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }
}

class QrScanManager {
  Future<void> scanQR({
    required String qrCode,
    required String senderId,
    required String carrierId,
  }) async {
    final url = Uri.parse('http://transithub.runasp.net/api/QRCode/ScanQR');

    Map<String, String> qrDeta = {
      'QRCode': qrCode,
      'SenderId': senderId,
      'CarrierId': carrierId,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(qrDeta),
      );

      if (response.statusCode == 200) {
        print('QR code scanned successfully');
        final responseData = jsonDecode(response.body);
        print('Response data: $responseData');
      } else {
        print('Failed to scan QR code: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }
}
