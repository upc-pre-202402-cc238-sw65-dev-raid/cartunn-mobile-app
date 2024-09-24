import 'package:flutter/material.dart';
import 'package:cartunn/widgets/custom_text_button.dart';
import 'package:cartunn/widgets/custom_text_form_field.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> myFormKey = GlobalKey<FormState>();
    final Map<String, String> formValues = {
      'itemId': '',
    };

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Input Screen'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 150, horizontal: 50),
              child: Form(
                key: myFormKey,
                child: Column(
                  children: [
                    // Título en negrita
                    const Text(
                      'Remove item by Id',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo),
                    ),
                    const SizedBox(height: 20), // Espacio entre el título y el texto
                    const Text(
                      'Are you sure you want to delete this item (this action is irreversible)?',
                      style: TextStyle(fontSize: 20, color: Colors.indigo),
                    ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      labelText: 'Id',
                      icon: Icons.label,
                      suffixIcon: Icons.check_circle,
                      keyboardType: TextInputType.text,
                      formProperty: 'itemId',
                      formValues: formValues,
                    ),
                    const SizedBox(height: 20),
                    // Cambiar a Row para colocar los botones uno al lado del otro
                    Container(
                      width: 280, // Cambiar a 280 para que coincida con el tamaño del TextFormField
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                // Acción para cancelar
                                print('Cancelled');
                              },
                              child: const Text('Cancel'),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.indigo), // Color del borde
                              ),
                            ),
                          ),
                          const SizedBox(width: 10), // Espacio entre los botones
                          Expanded(
                            child: CustomTextButton(
                              text: 'Save',
                              color: Colors.white,
                              backgroundColor: Colors.indigo,
                              onPressed: () {
                                FocusScope.of(context).requestFocus(FocusNode());
                                if (!myFormKey.currentState!.validate()) {
                                  print('Form not valid');
                                  return;
                                }
                                print(formValues);
                                // Lógica para guardar el ID del ítem
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
