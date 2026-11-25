import 'package:flutter/material.dart';
import 'package:khedma/core/theme/app_colors.dart';
import 'package:khedma/features/auth/presentation/screens/choose_account_type_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.white,
              AppColors.primaryLight,
              AppColors.primaryColor,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/khdma_logo.png',
                  width: 300,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 138),
                SizedBox(
                  width: 334,
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cardBackground,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChooseAccountTypeScreen(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Get Started',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 16,
                            fontWeight: .bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward,
                          color: AppColors.primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 18),
                Text(
                  'Made for your home. Built on trust.',
                  style: TextStyle(color: AppColors.primaryLight, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
