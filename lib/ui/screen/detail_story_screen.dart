import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/enum/result_state.dart';
import 'package:story_app/provider/detail_story_provider.dart';
import 'package:story_app/ui/widgets/error_view.dart';
import 'package:story_app/ui/widgets/loading.dart';

class DetailStoryScreen extends StatelessWidget {
  final String storyId;
  const DetailStoryScreen({
    super.key,
    required this.storyId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DetailStoryProvider>(
      create: (_) => DetailStoryProvider(apiService: ApiService(), id: storyId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Detail Story"),
        ),
        body: Consumer<DetailStoryProvider>(
          builder: (ctx, provider, _) {
            if (provider.state == ResultState.loading) {
              return const Loading(message: "Please awaiting!!");
            } else if (provider.state == ResultState.error) {
              return const ErrorView(
                  message:
                      "Failed to get content, please to check your internet");
            } else {
              final story = provider.story.story;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 200.0,
                        margin: const EdgeInsets.only(bottom: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                              image: NetworkImage(story.photoUrl),
                              fit: BoxFit.cover),
                        ),
                      ),
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'author : ${story.name}',
                              style:
                                  Theme.of(context).textTheme.titleLarge!.apply(
                                        color: Colors.redAccent,
                                        fontStyle: FontStyle.italic,
                                      ),
                            ),
                            Text(
                              'Created At : ${story.createdAt.hour} : ${story.createdAt.minute}',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .apply(
                                    color: Colors.grey,
                                    fontStyle: FontStyle.italic,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        story.description,
                        style: Theme.of(context).textTheme.bodySmall!.apply(
                            color: Colors.black, fontStyle: FontStyle.normal),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
