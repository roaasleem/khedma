
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:khedma/core/models/worker_model.dart';
import 'package:khedma/core/enums/worker_status.dart';
import 'package:khedma/core/theme/app_colors.dart';

import 'package:khedma/features/worker_dashboard/presentation/cubit/worker_dashboard_cubit.dart';

class EditWorkerProfileScreen extends StatefulWidget {
  final WorkerModel worker;

  const EditWorkerProfileScreen({
    super.key,
    required this.worker,
  });

  @override
  State<EditWorkerProfileScreen> createState() =>
      _EditWorkerProfileScreenState();
}

class _EditWorkerProfileScreenState
    extends State<EditWorkerProfileScreen> {

  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _professionController;
  late TextEditingController _experienceController;
  late TextEditingController _areaController;
  late TextEditingController _phoneController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _nameController =
        TextEditingController(text: widget.worker.name);

    _bioController =
        TextEditingController(text: widget.worker.bio);

    _professionController =
        TextEditingController(text: widget.worker.profession);

    _experienceController =
        TextEditingController(
          text: widget.worker.experience.toString(),
        );

    _areaController =
        TextEditingController(text: widget.worker.area);

    _phoneController =
        TextEditingController(text: widget.worker.phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _professionController.dispose();
    _experienceController.dispose();
    _areaController.dispose();
    _phoneController.dispose();

    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final workerData = widget.worker.toJson();

    workerData['name'] = _nameController.text.trim();
    workerData['bio'] = _bioController.text.trim();
    workerData['job'] = _professionController.text.trim();
    workerData['experience'] =
        int.parse(_experienceController.text.trim());
    workerData['area'] = _areaController.text.trim();
    workerData['phone'] = _phoneController.text.trim();

    final isRejected =
        widget.worker.status == WorkerStatus.rejected;

    if (isRejected) {
      workerData['status'] = WorkerStatus.pending.name;
    }

    final success = await context
        .read<WorkerDashboardCubit>()
        .updateWorkerProfile(
          widget.worker.id,
          workerData,
        );

    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isRejected
                ? 'Your application has been resubmitted'
                : 'Profile updated successfully',
          ),
        ),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Failed to update profile. Please try again.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRejected =
        widget.worker.status == WorkerStatus.rejected;

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Edit profile',
          style: theme.textTheme.titleLarge?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Center(
                child: CircleAvatar(
                  radius: 35,
                  backgroundColor: AppColors.primaryLight,
                  backgroundImage:
                      widget.worker.avatar.isNotEmpty
                          ? NetworkImage(widget.worker.avatar)
                          : null,
                  child: widget.worker.avatar.isEmpty
                      ? const Icon(
                          Icons.person,
                          size: 40,
                          color: AppColors.primaryColor,
                        )
                      : null,
                ),
              ),

              const SizedBox(height: 20),

              _buildLabel('Full Name'),
              _buildTextField(
                controller: _nameController,
                hint: 'Enter your full name',
                icon: Icons.person_outline,
              ),

              const SizedBox(height: 10),

              _buildLabel('Bio'),
              _buildTextField(
                controller: _bioController,
                hint: 'Add your bio',
                maxLines: 3,
                maxLength: 200,
              ),

              const SizedBox(height: 10),

              _buildLabel('Profession'),
              _buildTextField(
                controller: _professionController,
                hint: 'Enter your profession',
              ),

              const SizedBox(height: 10),

              _buildLabel('Years of Experience'),
              _buildTextField(
                controller: _experienceController,
                hint: 'Enter years of experience',
                keyboardType: TextInputType.number,
                isNumber: true,
              ),

              const SizedBox(height: 10),

              _buildLabel('Location'),
              _buildTextField(
                controller: _areaController,
                hint: 'Enter your location',
              ),
              const SizedBox(height: 10),

              _buildLabel('Phone Number'),
              _buildTextField(
                controller: _phoneController,
                hint: 'Enter your phone number',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveChanges,
                  child: _isSaving
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            color: AppColors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          isRejected ? 'Resubmit' : 'Save Changes',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    IconData? icon,
    int maxLines = 1,
    int? maxLength,
    TextInputType keyboardType = TextInputType.text,
    bool isDropdown = false,
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: keyboardType,

      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        }

        if (isNumber && int.tryParse(value.trim()) == null) {
          return 'Please enter a valid number';
        }

        return null;
      },

      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: AppColors.hintText,
          fontSize: 13,
        ),

        prefixIcon: icon != null
            ? Icon(
                icon,
                size: 18,
                color: AppColors.textSecondary,
              )
            : null,

        suffixIcon: isDropdown
            ? const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.textSecondary,
              )
            : null,

        filled: true,
        fillColor: AppColors.cardBackground,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColors.border,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColors.border,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColors.primaryColor,
          ),
        ),
      ),
    );
  }
}
