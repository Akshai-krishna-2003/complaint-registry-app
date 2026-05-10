import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:registry/src/common/app_theme.dart';
import 'package:registry/src/common/widgets/app_buttons.dart';
import 'package:registry/src/common/widgets/app_snackbar.dart';
import 'package:registry/src/common/widgets/app_text_field.dart';
import 'package:registry/src/features/auth/data/auth_service.dart';
import 'package:registry/src/features/complaints/data/complaint_service.dart';

class RegisterComplaintScreen extends StatefulWidget {
  const RegisterComplaintScreen({super.key});

  @override
  State<RegisterComplaintScreen> createState() =>
      _RegisterComplaintScreenState();
}

class _RegisterComplaintScreenState extends State<RegisterComplaintScreen> {
  final _formKey = GlobalKey<FormState>();
  final ComplaintService _complaintService = ComplaintService();

  // Auto‑filled
  String _studentId = '';
  String _studentName = '';
  String _email = '';

  // Form
  String _selectedComplaintType = 'Academic Issue';
  final _locationCtrl = TextEditingController();
  final _accusedCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();

  // Image
  File? _imageFile;
  final _picker = ImagePicker();

  bool _isLoading = false;
  bool _isUploading = false;

  final List<String> _complaintTypes = [
    'Academic Issue',
    'Faculty Complaint',
    'Hostel Complaint',
    'WiFi or Internet Issue',
    'Library Complaint',
    'Cafeteria Complaint',
    'Transport Complaint',
    'Bullying or Harassment Complaint',
    'Exam Related Complaint',
    'Maintenance Issue',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final data = await AuthService.getSavedUser();
    setState(() {
      _studentId = data['student_id'] ?? '';
      _studentName = data['student_name'] ?? '';
      _email = data['email'] ?? '';
    });
  }

  // ---- IMAGE PICKERS ----
  Future<void> _pickFromCamera() async {
    final picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked != null) setState(() => _imageFile = File(picked.path));
  }

  Future<void> _pickFromGallery() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _imageFile = File(picked.path));
  }

  // ---- SUBMIT ----
  Future<void> _submitComplaint() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final complaintId = await _complaintService.createComplaint(
        studentId: _studentId,
        studentName: _studentName,
        email: _email,
        complaintType: _selectedComplaintType,
        location: _locationCtrl.text.trim(),
        accusedPerson: _accusedCtrl.text.trim().isEmpty
            ? null
            : _accusedCtrl.text.trim(),
        description: _descriptionCtrl.text.trim(),
      );

      if (_imageFile != null && mounted) {
        setState(() => _isUploading = true);
        final bytes = await _imageFile!.readAsBytes();
        final ext = _imageFile!.path.split('.').last;
        final url = await _complaintService.uploadEvidence(
          complaintId: complaintId,
          fileName: 'evidence.$ext',
          fileBytes: bytes,
        );
        await _complaintService.setEvidenceUrl(
          complaintId: complaintId,
          evidenceUrl: url,
        );
      }

      if (!mounted) return;
      AppSnackbar.success(context, 'Complaint registered successfully!');
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.error(context, 'Failed to submit complaint: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isUploading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _locationCtrl.dispose();
    _accusedCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register Complaint')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---- Section Title: Your Details ----
              _sectionTitle('Your Details'),
              const SizedBox(height: 16),
              _readOnlyField('Student ID', Icons.badge_outlined, _studentId),
              const SizedBox(height: 16),
              _readOnlyField(
                'Student Name',
                Icons.person_outline,
                _studentName,
              ),
              const SizedBox(height: 16),
              _readOnlyField('Email', Icons.email_outlined, _email),
              const SizedBox(height: 32),

              // ---- Section Title: Complaint Info ----
              _sectionTitle('Complaint Information'),
              const SizedBox(height: 16),

              // Complaint Type
              _buildDropdown(),
              const SizedBox(height: 20),

              // Location
              AppTextField(
                controller: _locationCtrl,
                label: 'Location',
                hint: 'e.g., Building B, Room 201',
                prefixIcon: const Icon(
                  Icons.location_on_outlined,
                  color: AppTheme.primary,
                ),
                validator: (v) => v!.isEmpty ? 'Location required' : null,
              ),
              const SizedBox(height: 20),

              // Accused Person (optional)
              AppTextField(
                controller: _accusedCtrl,
                label: 'Accused Person (optional)',
                prefixIcon: const Icon(
                  Icons.person_outlined,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 20),

              // Description
              AppTextField(
                controller: _descriptionCtrl,
                label: 'Description',
                maxLines: 5,
                prefixIcon: const Icon(
                  Icons.description_outlined,
                  color: AppTheme.primary,
                ),
                validator: (v) =>
                    v!.isEmpty ? 'Please describe the complaint' : null,
              ),
              const SizedBox(height: 32),

              // ---- Section Title: Evidence ----
              _sectionTitle('Evidence (optional)'),
              const SizedBox(height: 16),

              // Image Picker
              _buildImagePicker(),
              const SizedBox(height: 40),

              // Submit
              AppPrimaryButton(
                label: (_isUploading)
                    ? 'Uploading image...'
                    : (_isLoading)
                    ? 'Submitting...'
                    : 'Submit Complaint',
                isLoading: _isLoading,
                icon: const Icon(Icons.send_rounded, size: 20),
                onPressed: _submitComplaint,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---- Helper widgets ----

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w700,
        color: AppTheme.primary,
      ),
    );
  }

  Widget _readOnlyField(String label, IconData icon, String value) {
    return AppTextField(
      controller: TextEditingController(text: value),
      label: label,
      readOnly: true,
      prefixIcon: Icon(icon, color: AppTheme.primary),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedComplaintType,
      decoration: InputDecoration(
        labelText: 'Complaint Type',
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFD9DCDE)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFD9DCDE)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppTheme.primary, width: 2),
        ),
        prefixIcon: const Icon(
          Icons.category_outlined,
          color: AppTheme.primary,
        ),
      ),
      items: _complaintTypes
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (v) => setState(() => _selectedComplaintType = v!),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      children: [
        // Preview
        if (_imageFile != null)
          Container(
            width: double.infinity,
            height: 180,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
              image: DecorationImage(
                image: FileImage(_imageFile!),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => setState(() => _imageFile = null),
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.black45,
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Buttons row
        Row(
          children: [
            Expanded(
              child: _pickerButton(
                icon: Icons.camera_alt_rounded,
                label: 'Take Photo',
                onTap: _pickFromCamera,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _pickerButton(
                icon: Icons.photo_library_rounded,
                label: 'From Gallery',
                onTap: _pickFromGallery,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _pickerButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, color: AppTheme.primary, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
