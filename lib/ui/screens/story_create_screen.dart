import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router_flow/go_router_flow.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/data/db/auth_repository.dart';
import 'package:story_app/data/service/api_service.dart';
import 'package:story_app/data/service/auth_service.dart';
import 'package:story_app/provider/story_create_provider.dart';

class CreateStoryScreen extends StatelessWidget {
  const CreateStoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.pop();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Created Story"),
        ),
        body: ChangeNotifierProvider<StoryCreateProvider>(
          create: (_) => StoryCreateProvider(
            apiService: ApiService(),
            authService: AuthService(
              locale: AuthRepository(prefs: SharedPreferences.getInstance()),
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Consumer<StoryCreateProvider>(
                    builder: (context, value, child) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: value.imageFile != null
                            ? Image.file(
                                File(value.imageFile!.path.toString()),
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                "assets/images/placeholder.png",
                              ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Consumer<StoryCreateProvider>(
                    builder: (context, value, child) {
                      return Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                value.getImage(ImageSource.camera);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent),
                              child: const Text(
                                "Camera",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                value.getImage(ImageSource.gallery);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              child: const Text(
                                "Galery",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Description",
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Consumer<StoryCreateProvider>(
                    builder: (context, value, child) {
                      return TextField(
                        controller: value.descController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Isi deskripsi gambar",
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 40.0, horizontal: 20),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(child: Consumer<StoryCreateProvider>(
                        builder: (ctx, value, child) {
                          return ElevatedButton(
                            onPressed: value.isLoading
                                ? null
                                : () {
                                    value.uploadImage(context);
                                  },
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: value.isLoading
                                  ? const SizedBox(
                                      height: 20.0,
                                      width: 20.0,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      "Upload",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                            ),
                          );
                        },
                      )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
