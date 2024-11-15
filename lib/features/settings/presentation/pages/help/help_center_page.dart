import 'package:flutter/material.dart';
import 'package:cartunn/features/settings/presentation/widgets/faq_item.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 8.0),
                const Text(
                  'Help & Center',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const FAQItem(
            question: "Will tuning affect my car's warranty?",
            answer:
                "In general, making modifications to your car can affect the warranty, especially if these modifications are related to the engine or other major components. However, our team will ensure that any modifications made comply with the manufacturer's standards and specifications to minimize any warranty risk.",
          ),
          const FAQItem(
            question: "How long does it take to complete the tuning process?",
            answer:
                "The time required to complete the tuning process may vary depending on the scope of the modifications and the availability of the necessary components. Our team will provide you with a detailed estimate of the waiting time once we have evaluated your car and agreed on the details of the work to be done.",
          ),
          const FAQItem(
            question: "How safe are the modifications made in the service?",
            answer:
                "Safety is our top priority. All modifications performed on your car are carried out by professionals who follow rigorous safety guidelines and standards.",
          ),
        ],
      ),
    );
  }
}
