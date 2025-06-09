import 'package:eato/core/constants/colors.dart';
import 'package:eato/presentation/screen/widgets/dashboard/geo_location_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController houseController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();

  List<String> savedAddresses = [];

  void _saveAddress() {
    print("Saving address...");
    if (nameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        houseController.text.trim().isEmpty ||
        streetController.text.trim().isEmpty ||
        cityController.text.trim().isEmpty ||
        stateController.text.trim().isEmpty ||
        pincodeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    final fullAddress = '''
Name: ${nameController.text}
Phone: ${phoneController.text}
${houseController.text}, ${streetController.text}
${landmarkController.text.isNotEmpty ? "Landmark: ${landmarkController.text}\n" : ""}
${cityController.text}, ${stateController.text} - ${pincodeController.text}
''';

    setState(() {
      savedAddresses.add(fullAddress);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Address Saved")),
    );

    nameController.clear();
    phoneController.clear();
    houseController.clear();
    streetController.clear();
    landmarkController.clear();
    cityController.clear();
    stateController.clear();
    pincodeController.clear();
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1, bool required = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label + (required ? ' *' : ''),
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: label == "Phone Number" || label == "Pincode"
              ? TextInputType.number
              : TextInputType.text,
          maxLength: label == "Phone Number"
              ? 10
              : label == "Pincode"
                  ? 6
                  : null,
          inputFormatters: label == "Phone Number" || label == "Pincode"
              ? [FilteringTextInputFormatter.digitsOnly]
              : [],
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            hintText: 'Enter $label',
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Delivery Address"),

          // centerTitle: true,
          backgroundColor: AppColor.PrimaryColor,
          foregroundColor: Colors.white,
          bottom: TabBar(
            tabs: [
              Tab(
                  child: Text("Add Address",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: AppColor.White))),
              Tab(
                  child: Text("Saved Addresses",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: AppColor.White))),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildTextField("Full Name", nameController),
                  _buildTextField("Phone Number", phoneController),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LocationPickerPage(onLocationPick : (val){
                                print(val);
                              })),
                        );
                      },
                      child: Icon(Icons.location_pin)),
                  SizedBox(
                    height: 10,
                  ),
                  _buildTextField("House No. / Building", houseController),
                  _buildTextField("Street / Locality", streetController),
                  _buildTextField("Landmark (optional)", landmarkController,
                      required: false),
                  _buildTextField("City", cityController),
                  _buildTextField("State", stateController),
                  _buildTextField("Pincode", pincodeController),
                  ElevatedButton(
                    onPressed: _saveAddress,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.PrimaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text("Save Address"),
                  ),
                ],
              ),
            ),

            // Tab 2: Saved Addresses
            savedAddresses.isEmpty
                ? const Center(child: Text("No saved addresses"))
                : ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: savedAddresses.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColor.PrimaryColor.withOpacity(0.1),
                          border: Border.all(color: AppColor.PrimaryColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(savedAddresses[index]),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
