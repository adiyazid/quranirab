import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:multiquranirab/Routes/route.dart';
import 'package:multiquranirab/user.provider.dart';
import 'package:multiquranirab/view/category.translation.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var box = GetStorage();

  @override
  initState() {
    getLocal();
    super.initState();
  }

  List<String> _local = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const CircleAvatar(
          radius: 10,
          backgroundImage: AssetImage('quranirab.png'),
        ),
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () async {
                try {
                  Navigator.pushNamed(
                    context,
                    RoutesName.loginPage,
                  );
                  await Provider.of<AppUser>(context, listen: false).signOut();
                } catch (e) {
                  print(e.toString());
                }
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Scrollbar(
        thumbVisibility: true,
        child: PaginateFirestore(
          padding: const EdgeInsets.all(32),
          // Use SliverAppBar in header to make it sticky
          header: const SliverToBoxAdapter(
              child: Center(
                  child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('List of all Category'),
          ))),
          footer: const SliverToBoxAdapter(
              child: Center(
                  child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('End of the list'),
          ))),
          // item builder type is compulsory.
          itemBuilderType: PaginateBuilderType.listView,
          //Change types accordingly
          itemBuilder: (context, documentSnapshots, index) {
            final data = documentSnapshots[index].data() as Map?;
            return ListTile(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  RoutesName.viewDataPage,
                  arguments: GetWordTranslation(data!['id']),
                );
              },
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: data == null
                  ? const Text('Error in data')
                  : Text(data['tname']),
              subtitle: Text(_local.contains(documentSnapshots[index].id)
                  ? 'Added'
                  : 'Not added yet'),
            );
          },
          // orderBy is compulsory to enable pagination
          query: FirebaseFirestore.instance
              .collection('word_categories')
              .orderBy('created_at'),
          itemsPerPage: 5,
          // to fetch real-time data
          isLive: true,
        ),
      ),
    );
  }

  Future<void> getLocal() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    _local = prefs.getStringList('lang') ?? [];
    // prefs.remove('lang');
  }
}
