import 'package:igls_new/data/global/global_app.dart';
import 'package:igls_new/data/services/network/client.dart';

class DataRegister {
  final String firstname;
  final String lastname;
  final String employeeName;
  final String username;
  final String password;
  final String phone;
  final String email;
  final String? language;
  final String? gender;
  DataRegister({
    required this.firstname,
    required this.lastname,
    required this.employeeName,
    required this.username,
    required this.password,
    required this.phone,
    required this.email,
    this.language,
    this.gender,
  });

  DataRegister copyWith({
    String? firstname,
    String? lastname,
    String? employeeName,
    String? username,
    String? password,
    String? phone,
    String? email,
    String? language,
    String? gender,
  }) {
    return DataRegister(
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      employeeName: employeeName ?? this.employeeName,
      username: username ?? this.username,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      language: language ?? this.language,
      gender: gender ?? this.gender,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "EmployeeName": employeeName,
      "LoginName": username,
      "Password": password,
      "FirstName": firstname,
      "LastName": lastname,
      "Mobile": phone,
      "Email": email,
      "Language": "EN",
      "Gender": "M"
    };
  }
}

class RegisterRequest extends AbstractHttpRequest {
  RegisterRequest(
    super.path, {
    super.parameters,
    Map<String, dynamic>? super.body,
    Map<String, dynamic>? header,
  }) : super(
          headers: header ??
              {
                "Content-Type": 'application/json',
                "Authorization": 'Bearer ${globalApp.getToken}'
              },
        );
}
