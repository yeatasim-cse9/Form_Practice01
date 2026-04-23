import 'package:flutter/material.dart';
import '../models/student_model.dart';
import '../widgets/submitted_data_card.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen>
    with SingleTickerProviderStateMixin {
  // ── Form Key ──
  final _formKey = GlobalKey<FormState>();

  // ── Controllers ──
  final _nameController = TextEditingController();
  final _rollController = TextEditingController();
  final _regController = TextEditingController();
  final _phoneController = TextEditingController();
  final _aboutController = TextEditingController();

  // ── Dropdown / Radio State ──
  String? _selectedBloodGroup;
  String? _selectedGender;

  // ── Submitted Data ──
  StudentModel? _submittedStudent;

  // ── Animation ──
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // ── Constants ──
  final List<String> _bloodGroups = [
    'A+',
    'A−',
    'B+',
    'B−',
    'AB+',
    'AB−',
    'O+',
    'O−',
  ];

  final List<String> _genders = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _rollController.dispose();
    _regController.dispose();
    _phoneController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  // ── Submit Handler ──
  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final student = StudentModel(
        name: _nameController.text.trim(),
        roll: _rollController.text.trim(),
        registrationNumber: _regController.text.trim(),
        bloodGroup: _selectedBloodGroup!,
        gender: _selectedGender!,
        phoneNumber: _phoneController.text.trim(),
        aboutMe: _aboutController.text.trim(),
      );

      setState(() {
        _submittedStudent = student;
      });

      // ── Reset form ──
      _formKey.currentState!.reset();
      _nameController.clear();
      _rollController.clear();
      _regController.clear();
      _phoneController.clear();
      _aboutController.clear();
      setState(() {
        _selectedBloodGroup = null;
        _selectedGender = null;
      });

      // ── Trigger animation ──
      _animationController.reset();
      _animationController.forward();

      // ── Scroll to card ──
      Future.delayed(const Duration(milliseconds: 100), () {
        Scrollable.ensureVisible(
          _cardKey.currentContext!,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  final GlobalKey _cardKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.indigo.shade700,
        title: const Text(
          'Student Registration',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purpleAccent, Colors.indigoAccent],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ── Form Card ──
            _buildFormCard(),

            // ── Submitted Data Card (animated) ──
            if (_submittedStudent != null)
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SizedBox(
                    key: _cardKey,
                    child: SubmittedDataCard(student: _submittedStudent!),
                  ),
                ),
              ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  //  Form Card
  // ─────────────────────────────────────────────────────────
  Widget _buildFormCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Form Header ──
            _buildFormHeader(),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Name Field ──
                  _buildSectionLabel('Full Name'),
                  _buildTextFormField(
                    controller: _nameController,
                    hintText: 'Enter your full name',
                    icon: Icons.person_outline,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Name is required';
                      }
                      if (value.trim().length < 2) {
                        return 'Name must be at least 2 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // ── Roll & Registration (side-by-side) ──
                  _buildSectionLabel('Roll & Registration'),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Roll Number
                      Expanded(
                        child: _buildTextFormField(
                          controller: _rollController,
                          hintText: 'Roll No.',
                          icon: Icons.format_list_numbered,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Registration Number
                      Expanded(
                        child: _buildTextFormField(
                          controller: _regController,
                          hintText: 'Reg. No.',
                          icon: Icons.app_registration,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── Blood Group ──
                  _buildSectionLabel('Blood Group'),
                  _buildDropdownField(),
                  const SizedBox(height: 16),

                  // ── Gender ──
                  _buildSectionLabel('Gender'),
                  _buildGenderSelector(),
                  const SizedBox(height: 16),

                  // ── Phone ──
                  _buildSectionLabel('Phone Number'),
                  _buildTextFormField(
                    controller: _phoneController,
                    hintText: 'Enter phone number',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Phone number is required';
                      }
                      if (value.trim().length < 10) {
                        return 'Enter a valid phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // ── About Me ──
                  _buildSectionLabel('About Me'),
                  _buildTextAreaField(),
                  const SizedBox(height: 28),

                  // ── Submit Button ──
                  _buildSubmitButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  //  Form Header
  // ─────────────────────────────────────────────────────────
  Widget _buildFormHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo.shade600, Colors.purple.shade500],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.school_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Student Form',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Fill in all required fields below',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  //  Section Label
  // ─────────────────────────────────────────────────────────
  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.indigo.shade700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  //  Text Form Field
  // ─────────────────────────────────────────────────────────
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(fontSize: 14, color: Colors.black87),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
        prefixIcon: Icon(icon, color: Colors.indigo.shade400, size: 20),
        filled: true,
        fillColor: Colors.indigo.shade50,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.indigo.shade100, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.indigo.shade500, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  //  Dropdown Field
  // ─────────────────────────────────────────────────────────
  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: _selectedBloodGroup,
      hint: Text(
        'Select blood group',
        style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
      ),
      icon: Icon(Icons.keyboard_arrow_down, color: Colors.indigo.shade400),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.bloodtype_outlined,
          color: Colors.indigo.shade400,
          size: 20,
        ),
        filled: true,
        fillColor: Colors.indigo.shade50,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.indigo.shade100, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.indigo.shade500, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
      items: _bloodGroups.map((group) {
        return DropdownMenuItem<String>(
          value: group,
          child: Text(
            group,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedBloodGroup = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a blood group';
        }
        return null;
      },
    );
  }

  // ─────────────────────────────────────────────────────────
  //  Gender Selector (Radio-style chip buttons)
  // ─────────────────────────────────────────────────────────
  Widget _buildGenderSelector() {
    return FormField<String>(
      initialValue: _selectedGender,
      validator: (value) {
        if (_selectedGender == null) {
          return 'Please select a gender';
        }
        return null;
      },
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: field.hasError
                      ? Colors.redAccent
                      : Colors.indigo.shade100,
                  width: 1.5,
                ),
              ),
              child: Row(
                children: _genders.map((gender) {
                  final bool isSelected = _selectedGender == gender;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedGender = gender;
                        });
                        field.didChange(gender);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.indigo.shade600
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isSelected
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_unchecked,
                              size: 16,
                              color: isSelected
                                  ? Colors.white
                                  : Colors.indigo.shade300,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              gender,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.indigo.shade700,
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 12),
                child: Text(
                  field.errorText!,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }

  // ─────────────────────────────────────────────────────────
  //  Textarea Field
  // ─────────────────────────────────────────────────────────
  Widget _buildTextAreaField() {
    return TextFormField(
      controller: _aboutController,
      maxLines: 4,
      keyboardType: TextInputType.multiline,
      style: const TextStyle(fontSize: 14, color: Colors.black87),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please write something about yourself';
        }
        if (value.trim().length < 10) {
          return 'Please write at least 10 characters';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: 'Tell us something about yourself...',
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
        alignLabelWithHint: true,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(bottom: 60),
          child: Icon(
            Icons.info_outline,
            color: Colors.indigo.shade400,
            size: 20,
          ),
        ),
        filled: true,
        fillColor: Colors.indigo.shade50,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.indigo.shade100, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.indigo.shade500, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  //  Submit Button
  // ─────────────────────────────────────────────────────────
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo.shade600, Colors.purple.shade500],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.indigo.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: _handleSubmit,
          icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
          label: const Text(
            'Submit',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
    );
  }
}
