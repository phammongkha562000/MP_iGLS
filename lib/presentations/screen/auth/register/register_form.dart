import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/register/register_bloc.dart';
import 'package:igls_new/presentations/common/export_common.dart';
import 'package:igls_new/presentations/widgets/export_widget.dart';
import 'package:igls_new/presentations/common/strings.dart' as strings;

class FormRegister extends StatefulWidget {
  const FormRegister({super.key});

  @override
  State<FormRegister> createState() => _FormRegisterState();
}

class _FormRegisterState extends State<FormRegister> {
  final List<String?> errors = [];
  final _formkeyRegister = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  bool _obscureText = true;

  String? firstname;
  String? lastName;
  String? username;
  String? password;
  String? confirmPassword;
  String? phone;
  String? email;

  @override
  void initState() {
    setState(() {
      firstNameController.text = "";
      lastNameController.text = "";
      userNameController.text = "";
      passwordController.text = "";
      confirmPasswordController.text = "";
      phoneController.text = "";
      emailController.text = "";
    });

    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    userNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formkeyRegister,
        child: MultiBlocListener(
          listeners: [
            BlocListener<RegisterBloc, RegisterState>(
              listener: (context, state) {
                if (state is RegisterLoading) {
                  const Loading();
                } else if (state is RegisterSuccess) {
                  return;
                } else if (state is RegisterFailure) {}
              },
            )
          ],
          child: BlocBuilder<RegisterBloc, RegisterState>(
            builder: (context, state) {
              if (state is RegisterInitial) {
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.sizeOf(context).width * 0.02),
                          child: Column(
                            children: [
                              const HeightSpacer(height: 0.01),
                              buildRow1(context),
                              const HeightSpacer(height: 0.02),
                              buildUserName(),
                              const HeightSpacer(height: 0.02),
                              buildPassword(),
                              const HeightSpacer(height: 0.02),
                              buildConfirmPassword(),
                              const HeightSpacer(height: 0.02),
                              buildPhone(),
                              const HeightSpacer(height: 0.02),
                              buildEmail(),
                              const HeightSpacer(height: 0.02),
                              state.isError
                                  ? Row(
                                      children: [
                                        Image.asset(
                                          'assets/icon/error.png',
                                          height: 20,
                                          width: 20,
                                          color: Colors.red,
                                        ),
                                        const SizedBox(
                                          width: 13,
                                        ),
                                        Text(
                                          state.error ?? '',
                                          style: styleTextError,
                                        ),
                                      ],
                                    )
                                  : const SizedBox(),
                              const HeightSpacer(height: 0.02),
                              // FormError(errors: errors),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: -1,
                      child: ElevatedButtonWidget(
                        text: "register",
                        onPressed: () {
                          if (_formkeyRegister.currentState!.validate()) {
                            if (errors.isEmpty) {
                              BlocProvider.of<RegisterBloc>(context)
                                  .add(RegisterPressed(
                                firstname: firstNameController.text,
                                lastname: lastNameController.text,
                                employeeName:
                                    "${lastNameController.text} ${firstNameController.text}",
                                username: userNameController.text,
                                password: passwordController.text,
                                phone: phoneController.text,
                                email: emailController.text,
                              ));
                              // showDialog(
                              //     context: context,
                              //     builder: (context) =>
                              //         const SuccessFull(text: "DONE"));
                            }
                          }
                        },
                      ),
                    )
                  ],
                );
              }
              if (state is RegisterLoading) {
                return Column(
                  children: [
                    const HeightSpacer(height: 0.01),
                    buildRow1(context),
                    const HeightSpacer(height: 0.02),
                    buildUserName(),
                    const HeightSpacer(height: 0.02),
                    buildPassword(),
                    const HeightSpacer(height: 0.02),
                    buildConfirmPassword(),
                    const HeightSpacer(height: 0.02),
                    buildPhone(),
                    const HeightSpacer(height: 0.02),
                    buildEmail(),
                    const HeightSpacer(height: 0.02),
                  ],
                );
              }
              return const Center(child: Loading());
            },
          ),
        ),
      ),
    );
  }

  Widget buildRow1(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: TextFormField(
            controller: firstNameController,
            onSaved: (newValue) => firstname = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                // removeError(error: erNullFirstName.tr());
              }
              firstname = value;
            },
            validator: (value) {
              if (value!.isEmpty) {
                // addError(error: erNullFirstName.tr());
              }
              return null;
            },
            decoration: InputDecoration(
                labelText: "1_name".tr(),
                hintText: "1_name".tr(),
                labelStyle: styleLabelInput,
                hintStyle: styleHintInput,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                suffixIcon: const Icon(
                  Icons.person,
                  color: defaultColor,
                )),
          ),
        ),
        Expanded(
          flex: 0,
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.05,
          ),
        ),
        Expanded(
          flex: 4,
          child: TextFormField(
            controller: lastNameController,
            onSaved: (newValue) => lastName = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                // removeError(error: erNullSecondName.tr());
              }
              lastName = value;
            },
            validator: (value) {
              if (value!.isEmpty) {
                // addError(error: erNullSecondName.tr());
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: "2_name".tr(),
              hintText: "2_name".tr(),
              labelStyle: styleLabelInput,
              hintStyle: styleHintInput,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: const Icon(
                Icons.person,
                color: defaultColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildUserName() {
    return TextFormField(
      controller: userNameController,
      onSaved: (newValue) => username = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          // removeError(error: erNullUserName.tr());
        }
        username = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          // addError(error: erNullUserName.tr());
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "username".tr(),
        hintText: "Enter your user name".tr(),
        labelStyle: styleLabelInput,
        hintStyle: styleHintInput,
        suffixIcon: const Icon(
          Icons.person,
          color: defaultColor,
        ),
      ),
    );
  }

  Widget buildPassword() {
    return TextFormField(
      obscureText: _obscureText,
      controller: passwordController,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          // removeError(error: erNullPassword.tr());
        }
        password = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          // addError(error: erNullPassword.tr());
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "password".tr(),
        hintText: "Enter your password".tr(),
        labelStyle: styleLabelInput,
        hintStyle: styleHintInput,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          icon: Icon(
            _obscureText ? Icons.lock : Icons.lock_open,
            color: defaultColor,
          ),
        ),
      ),
    );
  }

  Widget buildConfirmPassword() {
    return TextFormField(
      obscureText: _obscureText,
      keyboardType: TextInputType.visiblePassword,
      controller: confirmPasswordController,
      onSaved: (newValue) => confirmPassword = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: '5067'.tr());
        }
        if (value == passwordController.text) {
          removeError(error: strings.erPassNotMatch.tr());
        }
        confirmPassword = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: '5067'.tr());
        }
        if (value != passwordController.text) {
          addError(error: strings.erPassNotMatch.tr());
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "confirmPass".tr(),
        hintText: "Enter your password".tr(),
        labelStyle: styleLabelInput,
        hintStyle: styleHintInput,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          icon: Icon(
            _obscureText ? Icons.lock : Icons.lock_open,
            color: defaultColor,
          ),
        ),
      ),
    );
  }

  Widget buildPhone() {
    return TextFormField(
      controller: phoneController,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      onSaved: (newValue) => phone = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          // removeError(error: erNullPhone.tr());
        }
        phone = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          // addError(error: erNullPhone.tr());
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "phone".tr(),
        hintText: "Enter your number phone".tr(),
        labelStyle: styleLabelInput,
        hintStyle: styleHintInput,
        suffixIcon: const Icon(
          Icons.phone,
          color: defaultColor,
        ),
      ),
    );
  }

  Widget buildEmail() {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          // removeError(error: erNullEmail.tr());
        }
        email = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          // addError(error: erNullEmail.tr());
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "email".tr(),
        // hintText: "Enter your your email".tr(),
        labelStyle: styleLabelInput,
        hintStyle: styleHintInput,
        suffixIcon: const Icon(
          Icons.email,
          color: defaultColor,
        ),
      ),
    );
  }
}
