import 'package:flutter/material.dart';

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
          const SizedBox(height: 20.0),
          const FAQItem(
            question: "Will modifying my car affect the warranty?",
            answer:
                "In general, making modifications to your car can affect the warranty, especially if these modifications involve the engine or other major components. However, our team will ensure that modifications comply with the manufacturer's standards and specifications to minimize any warranty risk.",
          ),
          const FAQItem(
            question: "How long does it take to complete the modification process?",
            answer:
                "The time required to complete the modification process can vary depending on the scope of the modifications and the availability of the necessary components. Our team will provide you with a detailed estimate of the waiting time once we have evaluated your car and agreed on the work details.",
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

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  const FAQItem({
    required this.question,
    required this.answer,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ExpansionTile(
        backgroundColor: Colors.white,
        title: Text(
          question,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Color(0xFF5766F5),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              answer,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
