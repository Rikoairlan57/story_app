import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/enum/result_state.dart';
import 'package:story_app/data/model/story_model.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/provider/story_list_provider.dart';
import 'package:story_app/routes/page_manager.dart';
import 'package:story_app/ui/widgets/card_story.dart';
import 'package:story_app/ui/widgets/error_view.dart';
import 'package:story_app/ui/widgets/loading.dart';

class StoryListScreen extends StatelessWidget {
  final Function(String) onTapped;
  final Function() onLogout;
  final Function toFormScreen;

  const StoryListScreen({
    super.key,
    required this.onTapped,
    required this.toFormScreen,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final authWatch = context.watch<AuthProvider>();
    final ScaffoldMessengerState = ScaffoldMessenger.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Story App"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () async {
              final pageManager = context.read<PageManager>();
              toFormScreen();
              final dataString = await pageManager.waitForResult();
              ScaffoldMessengerState.showSnackBar(
                SnackBar(
                  content: Text(dataString),
                ),
              );
            },
          )
        ],
      ),
      body: Consumer<StoryListProvider>(
        builder: (ctx, provider, _) {
          if (provider.state == ResultState.loading) {
            return const Loading(message: "Prepare recommendated story");
          } else if (provider.state == ResultState.error) {
            return const ErrorView(
                message:
                    "Failed to get content, please to check your internet");
          } else {
            final List<StoryModel> stories = provider.list.listStory;
            return ListView.builder(
              itemCount: stories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    onTapped(
                      stories[index].id,
                    );
                  },
                  child: CardStory(
                    story: stories[index],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final authRead = context.read<AuthProvider>();
          final result = await authRead.logout();
          if (result) onLogout();
        },
        tooltip: "Logout",
        child: authWatch.isLoadingLogout
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : const Icon(Icons.logout),
      ),
    );
  }
}
