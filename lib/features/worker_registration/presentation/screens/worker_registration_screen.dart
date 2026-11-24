import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/core/theme/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:khedma/features/worker_registration/presentation/cubit/worker_registration_cubit.dart';
import 'package:khedma/features/worker_registration/presentation/cubit/worker_registration_state.dart';
import 'package:khedma/core/models/user_model.dart';

import 'dart:io';

class WorkerRegistrationScreen extends StatefulWidget {
  final UserModel user;

  const WorkerRegistrationScreen({super.key, required this.user});

  @override
  State<WorkerRegistrationScreen> createState() =>
      _WorkerRegistrationScreenState();
}

class _WorkerRegistrationScreenState extends State<WorkerRegistrationScreen> {
  final nameController = TextEditingController();
  final specialtyController = TextEditingController();
  final experienceController = TextEditingController();
  final bioController = TextEditingController();
  final areaController = TextEditingController();
  final priceController = TextEditingController();
  final phoneController = TextEditingController();

  String? selectedProfession;
  File? profileImage;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.user.name;
  }

  @override
  void dispose() {
    nameController.dispose();
    specialtyController.dispose();
    experienceController.dispose();
    bioController.dispose();
    areaController.dispose();
    priceController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final XFile? pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      setState(() {
        profileImage = File(pickedImage.path);
      });
    }
  }

  void submitWorker(BuildContext context) {
    final workerData = {
      'userId': widget.user.id,
      'name': nameController.text.trim(),
      'job': selectedProfession ?? '',
      'specialty': '',
      'experience': int.tryParse(experienceController.text) ?? 0,
      'area': areaController.text.trim(),
      'price': int.tryParse(priceController.text) ?? 0,
      'phone': phoneController.text.trim(),
      'bio': bioController.text.trim(),
      'rating': 0.0,
      'status': 'pending',
      'avatar': '',
      'available': false,
      'portfolioImages': [],
      'reviews': [],
    };

    context.read<WorkerRegistrationCubit>().registerWorker(
      workerData: workerData,
    );
  }

  Widget buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    Widget? prefixIcon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            prefixIcon: prefixIcon,
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WorkerRegistrationCubit(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: Text(
            'Join as a Worker',
            style: TextStyle(color: AppColors.textPrimary),
          ),
        ),
        body: BlocConsumer<WorkerRegistrationCubit, WorkerRegistrationState>(
          listener: (context, state) {
            if (state is WorkerRegistrationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Your request has been submitted successfully'),
                ),
              );
            }

            if (state is WorkerRegistrationError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        "Fill in your details and we'll review your request",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 14),
                      GestureDetector(
                        onTap: pickImage,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 55,
                              backgroundColor: AppColors.primaryLight,
                              backgroundImage: profileImage != null
                                  ? FileImage(profileImage!)
                                  : null,
                              child: profileImage == null
                                  ? Image.asset(
                                      'assets/icons/user-round.png',
                                      width: 38,
                                      height: 38,
                                      color: AppColors.primaryColor,
                                    )
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                radius: 18,
                                backgroundColor: AppColors.primaryColor,
                                child: Image.asset(
                                  'assets/icons/camera.png',
                                  width: 15,
                                  height: 15,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 24),
                        child: Column(
                          children: [
                            buildTextField(
                              label: 'Full Name',
                              hint: 'Enter your full name',
                              controller: nameController,
                              prefixIcon: Image.asset(
                                'assets/icons/user-round (1).png',
                                width: 18,
                                height: 18,
                              ),
                            ),
                            SizedBox(height: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Profession',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 8),
                                DropdownButtonFormField<String>(
                                  initialValue: selectedProfession,
                                  hint: Text(
                                    'Select your profession',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: AppColors.cardBackground,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: AppColors.border,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: AppColors.border,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  ),
                                  items:
                                      [
                                        'Plumber',
                                        'Electrician',
                                        'Carpenter',
                                        'AC Technician',
                                        'Appliance Repair Technician',
                                        'Painter',
                                        'Cleaner',
                                        'Home Maintenance',
                                        'Gardener',
                                        'Pest Control',
                                        'Other',
                                      ].map((profession) {
                                        return DropdownMenuItem(
                                          value: profession,
                                          child: Text(profession),
                                        );
                                      }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedProfession = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            buildTextField(
                              label: 'Years of Experience',
                              hint: 'Enter years of experience',
                              controller: experienceController,
                              keyboardType: TextInputType.number,
                            ),
                            SizedBox(height: 16),
                            buildTextField(
                              label: 'Bio',
                              hint: 'Tell us about your work',
                              controller: bioController,
                              maxLines: 4,
                            ),
                            SizedBox(height: 16),
                            buildTextField(
                              label: 'Location',
                              hint: 'Enter your area',
                              controller: areaController,
                            ),
                            SizedBox(height: 16),
                            buildTextField(
                              label: 'Price (EGP per visit)',
                              hint: 'Enter your price',
                              controller: priceController,
                              keyboardType: TextInputType.number,
                            ),
                            SizedBox(height: 16),
                            buildTextField(
                              label: 'Phone Number',
                              hint: 'Enter your phone number',
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              prefixIcon: Image.asset(
                                'assets/icons/phone.png',
                                width: 18,
                                height: 18,
                              ),
                            ),
                            SizedBox(height: 14),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: state is WorkerRegistrationLoading
                                    ? null
                                    : () => submitWorker(context),
                                child: state is WorkerRegistrationLoading
                                    ? CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : Text('Submit Request'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
