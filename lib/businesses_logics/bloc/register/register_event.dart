part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterPressed extends RegisterEvent {
  final String firstname;
  final String lastname;
  final String employeeName;
  final String username;
  final String password;
  final String phone;
  final String email;
  final String? language;
  final String? gender;
  const RegisterPressed({
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
  @override
  List<Object> get props => [
        firstname,
        lastname,
        employeeName,
        username,
        password,
        phone,
        email,
      ];
}
