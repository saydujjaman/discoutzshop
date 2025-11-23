import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late Map<String, dynamic> userData;
  bool isLoading = true;

  // Controllers
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController locationController;
  late TextEditingController passwordController; // Added for password

  String selectedGender = 'Male';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');

    if (userJson != null) {
      userData = jsonDecode(userJson);
    } else {
      userData = {
        'name': 'Nolan Curtis',
        'email': 'nolan@gmail.com',
        'gender': 'Male',
        'phone': '+880 1934567890',
        'city': 'Mohammadpur, Dhaka',
        'password': '123456', // fallback (in real app, handle securely)
      };
    }

    nameController = TextEditingController(text: userData['name'] ?? '');
    emailController = TextEditingController(text: userData['email'] ?? '');
    phoneController = TextEditingController(text: userData['phone'] ?? '');
    locationController = TextEditingController(text: userData['city'] ?? '');
    passwordController = TextEditingController(text: userData['password'] ?? '');
    selectedGender = userData['gender'] ?? 'Male';

    setState(() => isLoading = false);
  }

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();

    userData['name'] = nameController.text.trim();
    userData['email'] = emailController.text.trim();
    userData['gender'] = selectedGender;
    userData['phone'] = phoneController.text.trim();
    userData['city'] = locationController.text.trim();
    userData['password'] = passwordController.text; // Save new password

    await prefs.setString('user', jsonEncode(userData));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile & password updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    locationController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "User Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Profile Picture Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.grey[200],
                                child: Icon(Icons.person, size: 60, color: Colors.grey[600]),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.orange,
                                  child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          const Text("or", style: TextStyle(fontSize: 18, color: Colors.grey)),
                          const SizedBox(width: 16),
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey[200],
                            child: Icon(Icons.person_outline, size: 50, color: Colors.grey[400]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),

                      // Full Name
                      _buildEditableField("Full Name", nameController),
                      const SizedBox(height: 20),

                      // Email
                      _buildEditableField("You Mail", emailController),
                      const SizedBox(height: 20),

                      // Gender
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Gender", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(child: _buildGenderButton("Male", selectedGender == "Male")),
                          const SizedBox(width: 12),
                          Expanded(child: _buildGenderButton("Female", selectedGender == "Female")),
                          const SizedBox(width: 12),
                          Expanded(child: _buildGenderButton("Other", selectedGender == "Other")),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Phone Number
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Phone Number", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          prefixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(width: 12),
                              Image.asset(
                                'assets/images/bd.png',
                                width: 28,
                                height: 28,
                                errorBuilder: (_, __, ___) => const Icon(Icons.flag, size: 28),
                              ),
                              const SizedBox(width: 8),
                              const Text("+880", style: TextStyle(color: Colors.black87)),
                              const SizedBox(width: 8),
                              Container(height: 30, width: 1, color: Colors.grey[400]),
                              const SizedBox(width: 12),
                            ],
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Location
                      _buildEditableFieldWithIcon("Location", locationController, Icons.location_on),
                      const SizedBox(height: 20),

                      // Password - Now Fully Editable
                      _buildEditableField("Password", passwordController, obscureText: true),
                      const SizedBox(height: 20),

                      const SizedBox(height: 100), // Space for Save button
                    ],
                  ),
                ),

                // Save & Exit Button
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: ElevatedButton(
                    onPressed: _saveUserData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 5,
                    ),
                    child: const Text(
                      "Save & exit",
                      style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  // Reusable editable field (with optional obscureText for password)
  Widget _buildEditableField(String label, TextEditingController controller, {bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildEditableFieldWithIcon(String label, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.orange),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderButton(String text, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => selectedGender = text),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange.withOpacity(0.1) : Colors.transparent,
          border: Border.all(color: isSelected ? Colors.orange : Colors.grey.shade300, width: isSelected ? 2 : 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: isSelected ? Colors.orange : Colors.grey.shade700, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}