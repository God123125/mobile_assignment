import 'package:flutter/material.dart';
import 'package:khmer_cultur_app/models/auth/address_model.dart';
import 'package:khmer_cultur_app/screens/add_new_address_screen.dart';
import 'package:khmer_cultur_app/services/address_service.dart';
import 'package:khmer_cultur_app/services/auth_service.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  String? savedAddress;
  int? selectedIndex;
  List<AddressModel> addresses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  /// Load saved address from local storage
  Future<void> _loadSavedAddress() async {
    savedAddress = await AddressStorageService.getSelectedAddress();
  }

  /// Fetch addresses from API
  Future<void> _loadAddresses() async {
    setState(() => isLoading = true);

    await _loadSavedAddress();

    final service = AuthService();
    final userInfo = await service.getPersonalInfo();

    if (userInfo != null) {
      addresses = userInfo.address;

      // Compare selectedAddress with fetched addresses
      if (savedAddress != null) {
        final index = addresses.indexWhere((addr) {
          final full =
              "${addr.street}, ${addr.city}, ${addr.province}, ${addr.country}";
          return full == savedAddress;
        });

        selectedIndex = index >= 0 ? index : null;
      } else if (addresses.isNotEmpty) {
        // No selectedAddress → use first as default
        final first = addresses[0];
        savedAddress =
            "${first.street}, ${first.city}, ${first.province}, ${first.country}";
        selectedIndex = 0;
        await AddressStorageService.saveSelectedAddress(
          address: savedAddress!,
          lat: first.lat,
          lon: first.lng, 
        );
      }
    }

    setState(() => isLoading = false);
  }

  Future<void> _selectAddress(AddressModel address, int index) async {
    final fullAddress =
        "${address.street}, ${address.city}, ${address.province}, ${address.country}";

    await AddressStorageService.saveSelectedAddress(
      address: fullAddress,
      lat: address.lat,
      lon: address.lng,
    );

    setState(() {
      selectedIndex = index;
      savedAddress = fullAddress;
    });

    Navigator.pop(context, fullAddress);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text("My Addresses"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : addresses.isEmpty
          ? const Center(child: Text("No Address"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                final addr = addresses[index];
                final fullAddress =
                    "${addr.street}, ${addr.city}, ${addr.province}, ${addr.country}";
                final isSelected = savedAddress == fullAddress;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: GestureDetector(
                    onTap: () => _selectAddress(addr, index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue.shade50 : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? Colors.blue
                              : Colors.grey.shade200,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.blue
                                  : Colors.grey.shade200,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.location_on,
                              color: isSelected ? Colors.white : Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Address ${index + 1}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: isSelected
                                        ? Colors.blue
                                        : Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  addr.street,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "${addr.city}, ${addr.province}, ${addr.country}",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            const Icon(Icons.check_circle, color: Colors.blue),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
        child: ElevatedButton.icon(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddNewAddressScreen(),
              ),
            );
            if (result == true) _loadAddresses(); // reload after add
          },
          icon: const Icon(Icons.add),
          label: const Text(
            "Add New Address",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            elevation: 6,
            shadowColor: const Color.fromARGB(92, 33, 149, 243),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            minimumSize: const Size(double.infinity, 55),
          ),
        ),
      ),
    );
  }
}
