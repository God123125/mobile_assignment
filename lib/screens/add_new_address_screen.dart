import 'package:flutter/material.dart';
import 'package:khmer_cultur_app/widgets/bottom_nav.dart';

class AddNewAddressScreen extends StatefulWidget {
  const AddNewAddressScreen({super.key});

  @override
  State<AddNewAddressScreen> createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  final TextEditingController _addressController = TextEditingController(
    text: "3235 Royal Ln. Mesa, New Jersy 34567",
  );
  final TextEditingController _streetController = TextEditingController(text: "Hason Nagar");
  final TextEditingController _postCodeController = TextEditingController(text: "34567");
  final TextEditingController _apartmentController = TextEditingController(text: "345");

  String _selectedLabel = "Home";

  @override
  void dispose() {
    _addressController.dispose();
    _streetController.dispose();
    _postCodeController.dispose();
    _apartmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Map Section
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(color: Colors.blueGrey.shade100),
              child: Stack(
                children: [
                  // Back Button
                  Positioned(
                    top: 16,
                    left: 16,
                    child: IconButton(
                      icon: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.arrow_back, color: Colors.white, size: 20),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  // Map Marker with Tooltip
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Tooltip
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade800,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "Move to edit location",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        // Map Marker
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade300, width: 3),
                          ),
                          child: Icon(Icons.location_on, color: Colors.white, size: 30),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Address Form Section
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ADDRESS Field
                      _buildLabel("ADDRESS"),
                      SizedBox(height: 8),
                      _buildAddressField(controller: _addressController),
                      SizedBox(height: 20),

                      // STREET and POST CODE Fields (Side by Side)
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel("STREET"),
                                SizedBox(height: 8),
                                _buildInputField(controller: _streetController),
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel("POST CODE"),
                                SizedBox(height: 8),
                                _buildInputField(controller: _postCodeController),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      // APPARTMENT Field
                      _buildLabel("APPARTMENT"),
                      SizedBox(height: 8),
                      _buildInputField(controller: _apartmentController),
                      SizedBox(height: 20),

                      // LABEL AS Section
                      _buildLabel("LABEL AS"),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildLabelButton(
                              label: "Home",
                              isSelected: _selectedLabel == "Home",
                              onTap: () {
                                setState(() {
                                  _selectedLabel = "Home";
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _buildLabelButton(
                              label: "Work",
                              isSelected: _selectedLabel == "Work",
                              onTap: () {
                                setState(() {
                                  _selectedLabel = "Work";
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _buildLabelButton(
                              label: "Other",
                              isSelected: _selectedLabel == "Other",
                              onTap: () {
                                setState(() {
                                  _selectedLabel = "Other";
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      // Save Location Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: Text(
                            "SAVE LOCATION",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 3),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2C2C2C),
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildInputField({required TextEditingController controller}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildAddressField({required TextEditingController controller}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          prefixIcon: Icon(Icons.location_on, color: Color(0xFF2C2C2C), size: 24),
        ),
      ),
    );
  }

  Widget _buildLabelButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : Color(0xFF2C2C2C),
            ),
          ),
        ),
      ),
    );
  }
}
