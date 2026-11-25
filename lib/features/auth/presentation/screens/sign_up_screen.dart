import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/core/enums/user_role.dart';
import 'package:khedma/core/theme/app_colors.dart';
import 'package:khedma/core/models/user_model.dart';
import 'package:khedma/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:khedma/features/auth/presentation/cubit/auth_state.dart';
import 'package:khedma/core/routes/app_routes.dart';
import 'package:khedma/features/worker_registration/presentation/screens/worker_registration_screen.dart';

class SignUpScreen extends StatefulWidget {
  final UserRole role;

  const SignUpScreen({super.key, required this.role});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordVisible = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  String? validateInputs() {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      return 'Please fill all fields';
    }

    if (!emailController.text.contains('@')) {
      return 'Please enter a valid email';
    }

    if (passwordController.text.length < 8) {
      return 'Password must be at least 8 characters';
    }

    return null;
  }

  void signUp() {
    final user = UserModel(
      id: '',
      name: nameController.text,
      email: emailController.text,
      phone: '',
      avatar: '',
      password: passwordController.text,
      role: widget.role,
      favorites: [],
    );

    context.read<AuthCubit>().signUp(user);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }

        if (state is AuthAuthenticated) {
          if (widget.role == UserRole.worker) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    WorkerRegistrationScreen(user: state.user),
              ),
            );
          } else {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Create account',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: 30),

                Text(
                  'Full name',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: 8),

                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Full name',
                    hintStyle: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                    prefixIcon: Image.asset(
                      'assets/images/user-round.png',
                      width: 20,
                      height: 20,
                      color: AppColors.textSecondary,
                    ),
                    filled: true,
                    fillColor: AppColors.cardBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.primaryColor),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                Text(
                  'Email address',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: 8),

                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: AppColors.textSecondary,
                    ),
                    filled: true,
                    fillColor: AppColors.cardBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.primaryColor),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                Text(
                  'Password',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: 8),

                TextField(
                  controller: passwordController,
                  obscureText: !isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: 'Create a password',
                    hintStyle: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: AppColors.textSecondary,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    filled: true,
                    fillColor: AppColors.cardBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.primaryColor),
                    ),
                  ),
                ),

                SizedBox(height: 210),

                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    bool isLoading = state is AuthLoading;

                    return SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                String? errorMessage = validateInputs();
                                if (errorMessage != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(errorMessage)),
                                  );
                                } else {
                                  signUp();
                                }
                              },
                        child: isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text('Create Account'),
                      ),
                    );
                  },
                ),

                SizedBox(height: 35),

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.login,
                          );
                        },
                        child: Text(
                          'Log in',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
