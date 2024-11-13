import 'package:flutter/material.dart';
import 'package:accordion/accordion.dart';

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
      elevation: 2, 
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Accordion(
        maxOpenSections: 1,
        headerBackgroundColorOpened: const Color(0xFFE0E3F3), 
        children: [
          AccordionSection(
            isOpen: false,
            headerBackgroundColor: Colors.transparent,
            header: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                question,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF5766F5), 
                ),
              ),
            ),
            rightIcon: const Icon(
              Icons.expand_more,
              color: Color(0xFF5766F5), 
            ),
            content: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12.0),
                  bottomRight: Radius.circular(12.0),
                ),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Text(
                answer,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ),
            contentBorderWidth: 0, // Sin borde adicional
          ),
        ],
      ),
    );
  }
}
