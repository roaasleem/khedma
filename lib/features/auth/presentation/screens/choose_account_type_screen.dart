import 'package:flutter/material.dart';
import 'package:khedma/core/theme/app_colors.dart';
import 'package:khedma/core/enums/user_role.dart';
import 'package:khedma/features/auth/presentation/screens/sign_up_screen.dart';

class ChooseAccountTypeScreen extends StatefulWidget {
  const ChooseAccountTypeScreen({super.key});

  @override
  State<ChooseAccountTypeScreen> createState() =>
      _ChooseAccountTypeScreenState();
}

class _ChooseAccountTypeScreenState extends State<ChooseAccountTypeScreen> {
  String? selectedAccountType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 24, right: 24, top: 20),
            child: Text(
              'How will you use Khedma?',
              textAlign: TextAlign.start,
              softWrap: true,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 36,
                fontWeight: .bold,
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.only(left: 24, right: 24),
            child: Text(
              'Choose your account type. A better home starts with the right connection.',
              textAlign: TextAlign.start,
              softWrap: true,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
            ),
          ),
          SizedBox(height: 75),
          GestureDetector(
            onTap: () {
              setState(() {
                selectedAccountType = 'Customer';
              });
            },
            child: Container(
              height: 146,
              width: 342,
              decoration: BoxDecoration(
                color: selectedAccountType == 'Customer'
                    ? AppColors.primaryLight
                    : AppColors.cardBackground,
                border: Border.all(
                  color: selectedAccountType == 'Customer'
                      ? AppColors.primaryColor
                      : Colors.transparent,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image.asset(
                      'assets/images/house.png',
                      width: 27,
                      height: 27,
                    ),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'I’m a Customer',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: .bold,
                          ),
                        ),
                        SizedBox(height: 7),
                        Text(
                          'Find trusted experts for repairs, projects and everyday home care.',
                          textAlign: TextAlign.start,
                          softWrap: true,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 14),
                  Icon(
                    selectedAccountType == 'Customer'
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    size: 22,
                    color: selectedAccountType == 'Customer'
                        ? AppColors.primaryColor
                        : AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              setState(() {
                selectedAccountType = 'Worker';
              });
            },
            child: Container(
              height: 146,
              width: 342,
              decoration: BoxDecoration(
                color: selectedAccountType == 'Worker'
                    ? AppColors.primaryLight
                    : AppColors.cardBackground,
                border: Border.all(
                  color: selectedAccountType == 'Worker'
                      ? AppColors.primaryColor
                      : Colors.transparent,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image.asset(
                      'assets/images/hard-hat.png',
                      width: 27,
                      height: 27,
                    ),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'I’m a Worker',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: .bold,
                          ),
                        ),
                        SizedBox(height: 7),
                        Text(
                          'Showcase your skills, meet new customers and grow your business.',
                          textAlign: TextAlign.start,
                          softWrap: true,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 14),
                  Icon(
                    selectedAccountType == 'Worker'
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    size: 22,
                    color: selectedAccountType == 'Worker'
                        ? AppColors.primaryColor
                        : AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 70),
          SizedBox(
            width: 342,
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                if (selectedAccountType == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select an account type')),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUpScreen(
                        role: selectedAccountType == 'Customer'
                            ? UserRole.customer
                            : UserRole.worker,
                      ),
                    ),
                  );
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Continue',
                    style: TextStyle(
                      color: AppColors.border,
                      fontSize: 16,
                      fontWeight: .bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, color: AppColors.border),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
