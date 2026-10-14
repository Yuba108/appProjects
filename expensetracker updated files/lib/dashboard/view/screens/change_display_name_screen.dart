import 'package:exptracker/common/common_button.dart';
import 'package:exptracker/common/common_text_field.dart';
import 'package:exptracker/common/commoncolors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangeDisplayNameScreen extends StatefulWidget {
  const ChangeDisplayNameScreen({super.key});

  @override
  State<ChangeDisplayNameScreen> createState() =>
      _ChangeDisplayNameScreenState();
}

class _ChangeDisplayNameScreenState extends State<ChangeDisplayNameScreen> {
  late final TextEditingController displayNameController;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    displayNameController = TextEditingController(
      text: FirebaseAuth.instance.currentUser?.displayName ?? '',
    );
  }

  Future<void> _saveDisplayName() async {
    final displayName = displayNameController.text.trim();
    if (displayName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Display name can't be empty.")),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please sign in again to continue.")),
      );
      return;
    }

    if (displayName == user.displayName) {
      Navigator.pop(context, displayName);
      return;
    }

    setState(() => isSaving = true);
    try {
      await user.updateDisplayName(displayName);
      await user.reload();
      if (!mounted) return;
      Navigator.pop(context, displayName);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Couldn't update display name: $error")),
      );
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Change display name")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Commoncolors.softGreen,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "Your display name appears in your dashboard and account settings.",
              style: TextStyle(
                color: Commoncolors.darkGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 24),
          CommonTextField(
            hinttext: "Display name",
            controller: displayNameController,
            prefixIcon: Icons.person_outline,
          ),
          const SizedBox(height: 20),
          CommonButton(
            text: "Save name",
            isLoading: isSaving,
            onTap: _saveDisplayName,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    displayNameController.dispose();
    super.dispose();
  }
}
