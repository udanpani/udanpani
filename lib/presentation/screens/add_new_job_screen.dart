import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:udanpani/core/colors.dart';
import 'package:udanpani/widgets/text_input_field.dart';

class AddNewJobScreen extends StatefulWidget {
  const AddNewJobScreen({Key? key}) : super(key: key);

  @override
  State<AddNewJobScreen> createState() => _AddNewJobScreenState();
}

class _AddNewJobScreenState extends State<AddNewJobScreen> {
  final _imageHeight = 300.0;

  final _titleEditingController = TextEditingController();
  final _descriptionEditingController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _titleEditingController.dispose();
    _descriptionEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post A New Job"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.done,
              color: blueColor,
            ),
          ),
        ],
        backgroundColor: mobileBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              child: Container(
                color: mobileSearchColor,
                height: 250,
                child: const Center(
                  child: Icon(Icons.add_a_photo_outlined),
                ),
              ),
              onTap: () {},
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              width: double.infinity,
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  TextFieldInput(
                    textEditingController: _titleEditingController,
                    hintText: "Enter a title",
                    textInputType: TextInputType.text,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _descriptionEditingController,
                    decoration: InputDecoration(
                      hintText: "Enter a description",
                      border: OutlineInputBorder(
                          borderSide: Divider.createBorderSide(context)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: Divider.createBorderSide(context)),
                      filled: true,
                      contentPadding: const EdgeInsets.all(8),
                    ),
                    maxLines: 5,
                    maxLength: 300,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
