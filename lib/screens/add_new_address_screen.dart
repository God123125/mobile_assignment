// import 'package:flutter/material.dart';
// import 'package:khmer_cultur_app/widgets/bottom_nav.dart';

// class AddNewAddressScreen extends StatefulWidget {
//   const AddNewAddressScreen({super.key});

//   @override
//   State<AddNewAddressScreen> createState() => _AddNewAddressScreenState();
// }

// class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
//   final TextEditingController _addressController = TextEditingController(
//     text: "3235 Royal Ln. Mesa, New Jersy 34567",
//   );
//   final TextEditingController _streetController = TextEditingController(text: "Hason Nagar");
//   final TextEditingController _postCodeController = TextEditingController(text: "34567");
//   final TextEditingController _apartmentController = TextEditingController(text: "345");

//   String _selectedLabel = "Home";

//   @override
//   void dispose() {
//     _addressController.dispose();
//     _streetController.dispose();
//     _postCodeController.dispose();
//     _apartmentController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Map Section
//             Container(
//               height: MediaQuery.of(context).size.height * 0.4,
//               decoration: BoxDecoration(color: Colors.blueGrey.shade100),
//               child: Stack(
//                 children: [
//                   // Back Button
//                   Positioned(
//                     top: 16,
//                     left: 16,
//                     child: IconButton(
//                       icon: Container(
//                         width: 40,
//                         height: 40,
//                         decoration: BoxDecoration(
//                           color: Colors.grey.shade800,
//                           shape: BoxShape.circle,
//                         ),
//                         child: Icon(Icons.arrow_back, color: Colors.white, size: 20),
//                       ),
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                     ),
//                   ),
//                   // Map Marker with Tooltip
//                   Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         // Tooltip
//                         Container(
//                           padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                           decoration: BoxDecoration(
//                             color: Colors.grey.shade800,
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Text(
//                             "Move to edit location",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 12,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 8),
//                         // Map Marker
//                         Container(
//                           width: 50,
//                           height: 50,
//                           decoration: BoxDecoration(
//                             color: Colors.blue,
//                             shape: BoxShape.circle,
//                             border: Border.all(color: Colors.grey.shade300, width: 3),
//                           ),
//                           child: Icon(Icons.location_on, color: Colors.white, size: 30),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Address Form Section
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // ADDRESS Field
//                       _buildLabel("ADDRESS"),
//                       SizedBox(height: 8),
//                       _buildAddressField(controller: _addressController),
//                       SizedBox(height: 20),

//                       // STREET and POST CODE Fields (Side by Side)
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 _buildLabel("STREET"),
//                                 SizedBox(height: 8),
//                                 _buildInputField(controller: _streetController),
//                               ],
//                             ),
//                           ),
//                           SizedBox(width: 16),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 _buildLabel("POST CODE"),
//                                 SizedBox(height: 8),
//                                 _buildInputField(controller: _postCodeController),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 20),

//                       // APPARTMENT Field
//                       _buildLabel("APPARTMENT"),
//                       SizedBox(height: 8),
//                       _buildInputField(controller: _apartmentController),
//                       SizedBox(height: 20),

//                       // LABEL AS Section
//                       _buildLabel("LABEL AS"),
//                       SizedBox(height: 12),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: _buildLabelButton(
//                               label: "Home",
//                               isSelected: _selectedLabel == "Home",
//                               onTap: () {
//                                 setState(() {
//                                   _selectedLabel = "Home";
//                                 });
//                               },
//                             ),
//                           ),
//                           SizedBox(width: 12),
//                           Expanded(
//                             child: _buildLabelButton(
//                               label: "Work",
//                               isSelected: _selectedLabel == "Work",
//                               onTap: () {
//                                 setState(() {
//                                   _selectedLabel = "Work";
//                                 });
//                               },
//                             ),
//                           ),
//                           SizedBox(width: 12),
//                           Expanded(
//                             child: _buildLabelButton(
//                               label: "Other",
//                               isSelected: _selectedLabel == "Other",
//                               onTap: () {
//                                 setState(() {
//                                   _selectedLabel = "Other";
//                                 });
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 30),
//                       // Save Location Button
//                       SizedBox(
//                         width: double.infinity,
//                         height: 50,
//                         child: ElevatedButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blue,
//                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                             elevation: 0,
//                           ),
//                           child: Text(
//                             "SAVE LOCATION",
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                               letterSpacing: 1,
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavBar(currentIndex: 3),
//     );
//   }

//   Widget _buildLabel(String text) {
//     return Text(
//       text,
//       style: TextStyle(
//         fontSize: 12,
//         fontWeight: FontWeight.bold,
//         color: Color(0xFF2C2C2C),
//         letterSpacing: 0.5,
//       ),
//     );
//   }

//   Widget _buildInputField({required TextEditingController controller}) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.grey.shade100,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: TextField(
//         controller: controller,
//         style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
//         decoration: InputDecoration(
//           contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//           border: InputBorder.none,
//           enabledBorder: InputBorder.none,
//           focusedBorder: InputBorder.none,
//         ),
//       ),
//     );
//   }

//   Widget _buildAddressField({required TextEditingController controller}) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.grey.shade100,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: TextField(
//         controller: controller,
//         style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
//         decoration: InputDecoration(
//           contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//           border: InputBorder.none,
//           enabledBorder: InputBorder.none,
//           focusedBorder: InputBorder.none,
//           prefixIcon: Icon(Icons.location_on, color: Color(0xFF2C2C2C), size: 24),
//         ),
//       ),
//     );
//   }

//   Widget _buildLabelButton({
//     required String label,
//     required bool isSelected,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.symmetric(vertical: 12),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.blue : Colors.grey.shade100,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Center(
//           child: Text(
//             label,
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//               color: isSelected ? Colors.white : Color(0xFF2C2C2C),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:khmer_cultur_app/bases/user_session.dart';
import 'package:khmer_cultur_app/models/auth/address_model.dart';
import 'package:khmer_cultur_app/models/auth/update_info_model.dart';
import 'package:khmer_cultur_app/services/auth_service.dart';

class AddNewAddressScreen extends StatefulWidget {
  const AddNewAddressScreen({super.key});

  @override
  State<AddNewAddressScreen> createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  // ================= CONTROLLERS =================
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _provinceController = TextEditingController();
  final TextEditingController _countryController = TextEditingController(
    text: "Cambodia",
  );

  // ================= MAP =================

  double _lat = 11.5564; // Phnom Penh default
  double _lng = 104.9282;

  String _selectedLabel = "Home";
  bool _isLoading = false;

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _provinceController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location services are disabled.")),
      );
      return;
    }

    // Check for location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location permissions are denied")),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Location permissions are permanently denied. Please enable them in settings.",
          ),
        ),
      );
      return;
    }

    // Get the current position
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _lat = position.latitude;
      _lng = position.longitude;
    });
  }

  Future<void> _saveAddress() async {
    if (_streetController.text.isEmpty ||
        _cityController.text.isEmpty ||
        _provinceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = await UserSession.getCurrentUser();

      if (user == null) throw Exception("User not found");

      final newAddress = AddressModel(
        street: _streetController.text,
        city: _cityController.text,
        province: _provinceController.text,
        country: _countryController.text,
        lat: _lat,
        lng: _lng,
      );
      final List<AddressModel> updatedAddresses = [...user.address, newAddress];

      final request = UpdateInfoModel(
        id: user.id,
        name: user.name,
        email: user.email,
        phone: user.phone,
        address: updatedAddresses,
      );

      final response = await AuthService().updateUserInfo(request);

      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Address added successfully"),backgroundColor: Colors.green,),
        );

        Navigator.pop(context, true); // return success
      } else {
        throw Exception("API failed");
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            // ================= GOOGLE MAP =================
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(_lat, _lng),
                        zoom: 14,
                      ),
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      onMapCreated: (controller) {},
                      onTap: (LatLng position) {
                        setState(() {
                          _lat = position.latitude;
                          _lng = position.longitude;
                        });
                      },
                      markers: {
                        Marker(
                          markerId: const MarkerId("selected"),
                          position: LatLng(_lat, _lng),
                        ),
                      },
                    ),
                  ),
                  // Back button
                  Positioned(
                    top: 16,
                    left: 16,
                    child: CircleAvatar(
                      backgroundColor: Colors.black87,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ================= FORM =================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.blue),
                        SizedBox(width: 10),
                        Text("Information"),
                      ],
                    ),
                    SizedBox(height: 10),
                    _buildLabel("Street"),
                    _buildInputField(
                      controller: _streetController,
                      hint: "Enter your street",
                    ),

                    _buildLabel("City"),
                    _buildInputField(
                      controller: _cityController,
                      hint: "Enter your city",
                    ),

                    _buildLabel("Province"),
                    _buildInputField(
                      controller: _provinceController,
                      hint: "Enter your province",
                    ),

                    _buildLabel("Country"),
                    _buildInputField(
                      controller: _countryController,
                      hint: "Enter your country",
                    ),

                    const SizedBox(height: 16),

                    _buildLabel("Label as"),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(child: _buildLabelButton("Home")),
                        const SizedBox(width: 12),
                        Expanded(child: _buildLabelButton("Work")),
                        const SizedBox(width: 12),
                        Expanded(child: _buildLabelButton("Other")),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // ================= SAVE BUTTON =================
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveAddress,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Save Location",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 1,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= WIDGETS =================
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    String? hint, // <-- add a hint parameter
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint, // <-- set the placeholder here
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildLabelButton(String label) {
    final isSelected = _selectedLabel == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLabel = label;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueAccent : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(14),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
