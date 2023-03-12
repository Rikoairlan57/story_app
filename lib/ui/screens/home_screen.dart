import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:story_app/data/common/enum/result_state.dart';
import 'package:story_app/data/db/auth_repository.dart';
import 'package:story_app/provider/home_provider.dart';
import 'package:story_app/data/service/api_service.dart';
import 'package:story_app/data/service/auth_service.dart';
import 'package:story_app/ui/widgets/error_view.dart';
import 'package:go_router_flow/go_router_flow.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeProvider>(
      create: (context) => HomeProvider(
        apiService: ApiService(),
        authService: AuthService(
          locale: AuthRepository(prefs: SharedPreferences.getInstance()),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Story"),
          actions: [
            Center(
                child: Text(
              "Logout",
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: Colors.white),
            )),
            Consumer<HomeProvider>(
              builder: (ctx, value, child) {
                return IconButton(
                  onPressed: () {
                    value.userLogout(context);
                  },
                  icon: const Icon(Icons.logout),
                );
              },
            )
          ],
        ),
        floatingActionButton: Consumer<HomeProvider>(
          builder: (context, value, child) {
            return FloatingActionButton(
              onPressed: () async {
                await context.push("/add");
                value.refreshData();
              },
              child: const Icon(
                Icons.add,
              ),
            );
          },
        ),
        body: Consumer<HomeProvider>(
          builder: (context, value, child) {
            if (value.state == ResultState.hasData) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Stack(
                  children: [
                    ListView.separated(
                      controller: value.scrollController,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 30),
                      itemCount: value.listStory.length,
                      itemBuilder: (context, index) {
                        final data = value.listStory[index];

                        return Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(8.0),
                          shadowColor: Colors.black12,
                          child: Ink(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: InkWell(
                              onTap: () {
                                context.push("/detail/${data.id}");
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(8.0),
                                      topRight: Radius.circular(8.0),
                                    ),
                                    child: Image.network(
                                      data.photoUrl,
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Image.asset(
                                          "assets/images/placeholder.png",
                                          fit: BoxFit.cover,
                                        );
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Center(
                                          child: Lottie.asset(
                                              'assets/lottie/95614-error-occurred.json',
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  3),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          DateFormat('yyyy-MM-dd')
                                              .add_jms()
                                              .format(data.createdAt),
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          data.description,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    if (value.isScrollLoading)
                      const Align(
                        alignment: Alignment.bottomCenter,
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
              );
            } else if (value.state == ResultState.loading) {
              return Center(
                child: Lottie.asset('assets/lottie/97930-loading.json',
                    height: MediaQuery.of(context).size.height / 3),
              );
            } else if (value.state == ResultState.noData) {
              return const Center(
                child: Text("Nothing Found"),
              );
            } else {
              return ErrorView(
                refresh: () => value.refreshData,
              );
            }
          },
        ),
      ),
    );
  }
}
