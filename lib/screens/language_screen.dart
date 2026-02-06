import 'package:flutter/material.dart';
import 'package:khmer_cultur_app/widgets/bottom_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedLanguage = 'ខ្មែរ'; // Default to Khmer
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference();
  }

  Future<void> _loadLanguagePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString('selected_language');
      if (savedLanguage != null) {
        setState(() {
          _selectedLanguage = savedLanguage;
        });
      }
    } catch (e) {
      // Handle error silently, use default
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveLanguagePreference(String language) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selected_language', language);
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              language == 'ខ្មែរ' 
                  ? 'ភាសាត្រូវបានផ្លាស់ប្តូរទៅជាភាសាខ្មែរ'
                  : 'Language changed to English',
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save language preference'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _selectLanguage(String language) {
    if (_selectedLanguage != language) {
      setState(() {
        _selectedLanguage = language;
      });
      _saveLanguagePreference(language);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, color: Color(0xFF2C2C2C), size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Language',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C2C2C),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Language Options
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          const SizedBox(height: 24),
                          _buildLanguageOption(
                            flag: '🇰🇭',
                            language: 'ខ្មែរ',
                            isSelected: _selectedLanguage == 'ខ្មែរ',
                            onTap: () => _selectLanguage('ខ្មែរ'),
                          ),
                          const SizedBox(height: 16),
                          _buildLanguageOption(
                            flag: '🇬🇧',
                            language: 'ENGLISH',
                            isSelected: _selectedLanguage == 'ENGLISH',
                            onTap: () => _selectLanguage('ENGLISH'),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
    );
  }

  Widget _buildLanguageOption({
    required String flag,
    required String language,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(
              flag,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                language,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2C2C2C),
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 24,
              )
            else
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade400, width: 2),
                ),
              ),
          ],
        ),
      ),
    );
  }
}


