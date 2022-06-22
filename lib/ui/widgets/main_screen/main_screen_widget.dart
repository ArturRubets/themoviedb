import 'package:flutter/material.dart';

import '../../../library/widgets/inherited/provider.dart';
import '../app/my_app_model.dart';
import '../movie_list/movie_list_model.dart';
import '../movie_list/movie_list_widget.dart';

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({Key? key}) : super(key: key);

  @override
  State<MainScreenWidget> createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  int _selectedTab = 0;
  final _movieListModel = MovieListModel();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _movieListModel.setupLocale(context);
  }

  void onSelectTab(int index) {
    if (_selectedTab == index) return;
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TMDB'),
        actions: [
          IconButton(
            onPressed: () =>
                Provider.of<MyAppModel>(context)?.resetSession(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          const Text('News'),
          NotifierProvider(
            create: () => _movieListModel,
            isManagingModel: false,
            child: const MovieListWidget(),
          ),
          const Text('Series'),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onSelectTab,
        currentIndex: _selectedTab,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie_filter),
            label: 'Movies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tv),
            label: 'Series',
          ),
        ],
      ),
    );
  }
}
