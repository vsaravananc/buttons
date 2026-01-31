import 'package:button/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

void main() {
  runApp(const MyApp());
}

Rx<bool> isLoading = false.obs;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Form(
          key: formKey,
          child: Column(
            spacing: 12,
            mainAxisSize: .max,
            mainAxisAlignment: .center,
            children: [
              Padding(
                padding: const .symmetric(horizontal: 18),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: SizedBox(
          height: 80,
          child: Padding(
            padding: const .symmetric(horizontal: 12),
            child: Row(
              spacing: 8,
              children: [
                Column(
                  crossAxisAlignment: .center,
                  mainAxisAlignment: .center,
                  children: [const Text('Total Amount'), Text('\$ 250.00')],
                ),
                Obx(
                  () => Expanded(
                    child: VibrateButton(
                      formState: formKey,
                      shakeCount: 4,
                      radius: 14,
                      margin: .all(0),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      loading: isLoading.value,
                      text: 'Confirm order',
                      child: Row(
                        mainAxisAlignment: .center,
                        crossAxisAlignment: .center,
                        spacing: 8,
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            color: Colors.white,
                          ),
                          Text(
                            'Confirm order',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        isLoading.value = !isLoading.value;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
