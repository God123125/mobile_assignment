// import 'package:flutter/material.dart';
// import 'package:khmer_cultur_app/bases/user_session.dart';
// import 'package:khmer_cultur_app/models/auth/address_model.dart';
// import 'package:khmer_cultur_app/models/auth/user_model.dart';
// import 'package:khmer_cultur_app/screens/add_new_address_screen.dart';
// import 'package:khmer_cultur_app/services/address_service.dart';
// import 'package:khmer_cultur_app/widgets/bottom_nav.dart';

// class AddressScreen extends StatefulWidget {
//   const AddressScreen({super.key});

//   @override
//   State<AddressScreen> createState() => _AddressScreenState();
// }

// class _AddressScreenState extends State<AddressScreen> {

//   int? selectedIndex;
//   String? savedAddress;

//   @override
//   void initState() {
//     super.initState();
//     _loadSavedAddress();
//   }

//   /// Load saved address from local storage
//   Future<void> _loadSavedAddress() async {
//     final saved = await AddressStorageService.getSelectedAddress();
//     if (saved != null) {
//       setState(() {
//         savedAddress = saved;
//       });
//     }
//   }

//   /// Select address
//   Future<void> _selectAddress(AddressModel address, int index) async {

//     final selectedAddress =
//         "${address.street}, ${address.city}, ${address.province}, ${address.country}";

//     await AddressStorageService.saveSelectedAddress(selectedAddress);

//     setState(() {
//       selectedIndex = index;
//       savedAddress = selectedAddress;
//     });

//     Navigator.pop(context, selectedAddress);
//   }

//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(
//       backgroundColor: Colors.white,

//       body: SafeArea(
//         child: FutureBuilder<UserModel?>(
//           future: UserSession.getCurrentUser(),
//           builder: (context, snapshot) {

//             if (!snapshot.hasData) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             final user = snapshot.data!;
//             final List<AddressModel> addresses = user.address;

//             return Column(
//               children: [

//                 /// HEADER
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 16,
//                   ),
//                   child: Row(
//                     children: [

//                       IconButton(
//                         icon: Container(
//                           width: 40,
//                           height: 40,
//                           decoration: BoxDecoration(
//                             color: Colors.grey.shade200,
//                             shape: BoxShape.circle,
//                           ),
//                           child: const Icon(
//                             Icons.arrow_back,
//                             color: Color(0xFF2C2C2C),
//                             size: 20,
//                           ),
//                         ),
//                         onPressed: () => Navigator.pop(context),
//                       ),

//                       const SizedBox(width: 16),

//                       const Text(
//                         "My Address",
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF2C2C2C),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 /// ADDRESS LIST
//                 Expanded(
//                   child: addresses.isEmpty
//                       ? const Center(child: Text("No Address"))
//                       : ListView.builder(
//                           padding: const EdgeInsets.symmetric(horizontal: 20),
//                           itemCount: addresses.length,
//                           itemBuilder: (context, index) {

//                             final address = addresses[index];

//                             final fullAddress =
//                                 "${address.street}, ${address.city}, ${address.province}, ${address.country}";

//                             final isSelected = savedAddress == fullAddress;

//                             return Padding(
//                               padding: const EdgeInsets.only(bottom: 16),

//                               child: GestureDetector(
//                                 onTap: () => _selectAddress(address, index),

//                                 child: Container(
//                                   padding: const EdgeInsets.all(12),

//                                   decoration: BoxDecoration(
//                                     color: isSelected
//                                         ? Colors.blue.shade50
//                                         : Colors.grey.shade50,

//                                     borderRadius: BorderRadius.circular(12),

//                                     border: Border.all(
//                                       color: isSelected
//                                           ? Colors.blue
//                                           : Colors.transparent,
//                                       width: 1.5,
//                                     ),
//                                   ),

//                                   child: Row(
//                                     children: [

//                                       /// RADIO
//                                       Radio<int>(
//                                         value: index,
//                                         groupValue: isSelected ? index : null,
//                                         onChanged: (value) =>
//                                             _selectAddress(address, index),
//                                       ),

//                                       const SizedBox(width: 10),

//                                       /// ADDRESS INFO
//                                       Expanded(
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,

//                                           children: [

//                                             Text(
//                                               "Address ${index + 1}",
//                                               style: const TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),

//                                             const SizedBox(height: 4),

//                                             Text(address.street),

//                                             Text(
//                                                 "${address.city}, ${address.province}, ${address.country}"),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                 ),

//                 /// ADD NEW ADDRESS BUTTON
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 16,
//                   ),

//                   child: SizedBox(
//                     width: double.infinity,
//                     height: 50,

//                     child: ElevatedButton(
//                       onPressed: () {

//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>
//                                 const AddNewAddressScreen(),
//                           ),
//                         );
//                       },

//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,

//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),

//                       child: const Text(
//                         "ADD NEW ADDRESS",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                           letterSpacing: 1,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),

//       bottomNavigationBar: const BottomNavBar(currentIndex: 3),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:khmer_cultur_app/bases/user_session.dart';
import 'package:khmer_cultur_app/models/auth/address_model.dart';
import 'package:khmer_cultur_app/models/auth/user_model.dart';
import 'package:khmer_cultur_app/screens/add_new_address_screen.dart';
import 'package:khmer_cultur_app/services/address_service.dart';
import 'package:khmer_cultur_app/widgets/bottom_nav.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  int? selectedIndex;
  String? savedAddress;

  @override
  void initState() {
    super.initState();
    _loadSavedAddress();
  }

  /// Load saved address
  Future<void> _loadSavedAddress() async {
    final saved = await AddressStorageService.getSelectedAddress();

    if (saved != null) {
      setState(() {
        savedAddress = saved;
      });
    }
  }

  /// Select address and save locally
  Future<void> _selectAddress(AddressModel address, int index) async {
    final selectedAddress =
        "${address.street}, ${address.city}, ${address.province}, ${address.country}";

    await AddressStorageService.saveSelectedAddress(selectedAddress);

    setState(() {
      selectedIndex = index;
      savedAddress = selectedAddress;
    });

    Navigator.pop(context, selectedAddress);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: const Text("Address", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Icon(Icons.chevron_left, size: 32, color: Colors.grey),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SafeArea(
        child: FutureBuilder<UserModel?>(
          future: UserSession.getCurrentUser(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final user = snapshot.data!;
            final List<AddressModel> addresses = user.address;

            /// DEFAULT FIRST ADDRESS
            if (savedAddress == null && addresses.isNotEmpty) {
              final firstAddress =
                  "${addresses[0].street}, ${addresses[0].city}, ${addresses[0].province}, ${addresses[0].country}";

              savedAddress = firstAddress;
              selectedIndex = 0;

              AddressStorageService.saveSelectedAddress(firstAddress);
            }

            return Column(
              children: [
                /// HEADER
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Color(0xFF2C2C2C),
                            size: 20,
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        "My Address",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C2C2C),
                        ),
                      ),
                    ],
                  ),
                ),

                /// ADDRESS LIST
                Expanded(
                  child: addresses.isEmpty
                      ? const Center(child: Text("No Address"))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: addresses.length,
                          itemBuilder: (context, index) {
                            final address = addresses[index];
                            final fullAddress =
                                "${address.street}, ${address.city}, ${address.province}, ${address.country}";

                            // Set default first address if none selected
                            if (savedAddress == null && index == 0) {
                              savedAddress = fullAddress;
                              selectedIndex = 0;
                              // Save to local storage
                              AddressStorageService.saveSelectedAddress(
                                fullAddress,
                              );
                            }

                            final isSelected = savedAddress == fullAddress;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: GestureDetector(
                                onTap: () => _selectAddress(address, index),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.blue.shade50
                                        : Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.blue
                                          : Colors.transparent,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      /// RADIO
                                      Radio<int>(
                                        value: index,
                                        groupValue: selectedIndex,
                                        onChanged: (value) =>
                                            _selectAddress(address, index),
                                      ),

                                      const SizedBox(width: 10),

                                      /// ADDRESS INFO
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Address ${index + 1}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(address.street),
                                            Text(
                                              "${address.city}, ${address.province}, ${address.country}",
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

                /// ADD NEW ADDRESS BUTTON
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddNewAddressScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "ADD NEW ADDRESS",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),

      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
    );
  }
}
