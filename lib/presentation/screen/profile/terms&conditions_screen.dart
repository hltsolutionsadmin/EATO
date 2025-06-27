import 'package:eato/components/custom_topbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: "Terms & Conditions",
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFAFAFA), Color(0xFFF5F7FA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.97),
                borderRadius: BorderRadius.circular(24),
                
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "EATO - Terms & Conditions",
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSection(
                      title: "1. Use of Service",
                      content:
                          "EATO provides a food delivery platform connecting customers with restaurants and delivery partners. You agree to use the app only for lawful purposes and not to misuse or exploit the service.",
                    ),
                    _buildSection(
                      title: "2. Account Registration",
                      content:
                          "You must register with a valid mobile number to place orders. You are responsible for maintaining the confidentiality of your account.",
                    ),
                    _buildSection(
                      title: "3. Orders & Payments",
                      content:
                          "By placing an order, you agree to pay the listed price including taxes and delivery charges. Payments are securely processed via Razorpay, Paytm, or UPI.",
                    ),
                    _buildSection(
                      title: "4. Delivery & Cancellations",
                      content:
                          "Delivery times are estimates. You may cancel within the allowed window. Refunds will be handled as per policy.",
                    ),
                    _buildSection(
                      title: "5. User Conduct",
                      content:
                          "You must not use the app for fraudulent, harmful, or illegal purposes or interfere with its normal operation.",
                    ),
                    _buildSection(
                      title: "6. Content Ownership",
                      content:
                          "All content is owned by HAVE LIFE TECH SOLUTIONS. Do not copy, redistribute, or reuse without permission.",
                    ),
                    _buildSection(
                      title: "7. Location Access",
                      content:
                          "We use your location to show nearby restaurants and ensure timely delivery. Location is only used for improving service.",
                    ),
                    _buildSection(
                      title: "8. Promotions & Offers",
                      content:
                          "Promo codes and credits are subject to terms, cannot be redeemed for cash, and may expire.",
                    ),
                    _buildSection(
                      title: "9. Limitation of Liability",
                      content:
                          "We are not liable for losses due to third-party failures, outages, or service interruptions.",
                    ),
                    _buildSection(
                      title: "10. Termination",
                      content:
                          "We may suspend or terminate accounts found violating our policies or terms of service.",
                    ),
                    _buildSection(
                      title: "11. Account Deletion",
                      content:
                          "Request account deletion at havelifetech03@gmail.com. Processing may take up to 7 working days.",
                    ),
                    _buildSection(
                      title: "12. Changes to Terms",
                      content:
                          "We may update these terms. Continued use after updates implies your acceptance.",
                    ),
                    const SizedBox(height: 20),
                    Divider(color: Colors.grey.shade300),
                    const SizedBox(height: 10),
                    Text(
                      "Contact Us",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "📧 havelifetech03@gmail.com\n🏢 HAVE LIFE TECH SOLUTIONS",
                      style: GoogleFonts.roboto(fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: GoogleFonts.roboto(
              fontSize: 14,
              height: 1.6,
              color: Colors.grey.shade800,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
