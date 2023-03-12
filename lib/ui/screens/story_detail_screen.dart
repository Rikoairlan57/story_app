import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:story_app/data/common/enum/result_state.dart';
import 'package:story_app/data/db/auth_repository.dart';
import 'package:story_app/provider/detail_provider.dart';
import 'package:story_app/data/service/api_service.dart';
import 'package:story_app/data/service/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/ui/widgets/error_view.dart';

class StoryDetailScreen extends StatelessWidget {
  final String _storyId;

  const StoryDetailScreen({
    Key? key,
    required String restaurantId,
  })  : _storyId = restaurantId,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<DetailProvider>(
        create: (_) => DetailProvider(
          apiService: ApiService(),
          authService: AuthService(
            locale: AuthRepository(prefs: SharedPreferences.getInstance()),
          ),
          storyId: _storyId,
        ),
        child: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 200,
                  backgroundColor: Colors.black,
                  flexibleSpace: Consumer<DetailProvider>(
                    builder: (ctx, value, child) {
                      return FlexibleSpaceBar(
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            Hero(
                              tag: _storyId,
                              child: value.state == ResultState.hasData
                                  ? Image.network(
                                      value.listStory.photoUrl,
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress != null) {
                                          return const CircularProgressIndicator();
                                        }
                                        return child;
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                          "assets/images/placeholder.png",
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    )
                                  : Image.asset(
                                      "assets/images/placeholder.png",
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            const DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment(0.0, 0.5),
                                  end: Alignment.center,
                                  colors: <Color>[
                                    Color(0x80000000),
                                    Color(0x00000000),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        title: Text(value.state == ResultState.hasData
                                ? value.listStory.name
                                : "")
                            .animate()
                            .fade(
                              duration: 850.ms,
                            )
                            .slideY(
                              begin: -0.3,
                              duration: 1200.ms,
                              curve: Curves.fastOutSlowIn,
                            ),
                      );
                    },
                  ),
                ),
              ];
            },
            body: Consumer<DetailProvider>(
              builder: (context, value, child) {
                if (value.state == ResultState.hasData) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Description",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                              )
                                  .animate()
                                  .fade(
                                    duration: 850.ms,
                                  )
                                  .slideX(
                                    begin: -0.3,
                                    duration: 1200.ms,
                                    curve: Curves.fastOutSlowIn,
                                  ),
                              Text(
                                DateFormat('yyyy-MM-dd')
                                    .add_jms()
                                    .format(value.listStory.createdAt),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade500,
                                ),
                              )
                                  .animate()
                                  .fade(
                                    duration: 850.ms,
                                  )
                                  .slideX(
                                    begin: 0.3,
                                    duration: 1200.ms,
                                    curve: Curves.fastOutSlowIn,
                                  ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            value.listStory.description,
                            textAlign: TextAlign.justify,
                            style: Theme.of(context).textTheme.bodyMedium,
                          )
                              .animate()
                              .fade(
                                duration: 850.ms,
                              )
                              .slideY(
                                begin: 0.3,
                                duration: 1200.ms,
                                curve: Curves.fastOutSlowIn,
                              ),
                        ],
                      ),
                    ),
                  );
                } else if (value.state == ResultState.loading) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Lottie.asset('assets/lottie/97930-loading.json',
                            height: MediaQuery.of(context).size.height / 3),
                        const SizedBox(height: 10),
                        const Text("Loading Data.."),
                      ],
                    ),
                  );
                } else {
                  return ErrorView(
                    refresh: () => value.refreshData,
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
