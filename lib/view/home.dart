import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:multiquranirab/Routes/route.dart';
import 'package:multiquranirab/providers/db.list.providers.dart';
import 'package:multiquranirab/providers/user.provider.dart';
import 'package:multiquranirab/view/category.translation.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var box = GetStorage();

  var filter;

  @override
  initState() {
    Provider.of<DbListProvider>(context, listen: false).getDbList();
    super.initState();
  }

  GroupController chipsController = GroupController(isMultipleSelection: false);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: const CircleAvatar(
            radius: 10,
            backgroundImage: AssetImage('assets/quranirab.png'),
          ),
          title: Text(widget.title),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(40),
            child: TabBar(
              tabs: [
                Tab(
                  text: 'All',
                ),
                Tab(
                  text: 'Chinese',
                ),
                Tab(
                  text: 'French',
                ),
                Tab(
                  text: 'Spanish',
                ),
                Tab(
                  text: 'Bengali',
                )
              ],
            ),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  try {
                    Navigator.pushReplacementNamed(
                      context,
                      RoutesName.loginPage,
                    );
                    await Provider.of<AppUser>(context, listen: false)
                        .signOut();
                  } catch (e) {
                    print(e.toString());
                  }
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body: Consumer<DbListProvider>(builder: (context, list, child) {
          return TabBarView(children: [
            buildScrollbar(list),
            ListView.builder(
              itemCount: list.chinese.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      RoutesName.viewDataPage,
                      arguments: GetWordTranslation(list.chinese[index]),
                    );
                  },
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(list.nameC[index]),
                  subtitle: Text(list.chinese[index]),
                  trailing: ButtonBar(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.edit)),
                      IconButton(
                          onPressed: () {
                            try {
                              var id = list.idC[index];
                              FirebaseFirestore.instance
                                  .collection('category_translations')
                                  .doc(id)
                                  .delete();
                              var catID = list.chinese[index];
                              Provider.of<DbListProvider>(context,
                                      listen: false)
                                  .remove(1, catID);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Deleting data...')));
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())));
                            }
                          },
                          icon: const Icon(Icons.delete))
                    ],
                  ),
                );
              },
            ),
            ListView.builder(
              itemCount: list.french.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  onTap: () {},
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(list.nameF[index]),
                  subtitle: Text(list.french[index]),
                  trailing: ButtonBar(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.edit)),
                      IconButton(
                          onPressed: () {
                            try {
                              var id = list.idF[index];
                              FirebaseFirestore.instance
                                  .collection('category_translations')
                                  .doc(id)
                                  .delete();
                              var catID = list.french[index];
                              Provider.of<DbListProvider>(context,
                                      listen: false)
                                  .remove(2, catID);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Deleting data...')));
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())));
                            }
                          },
                          icon: const Icon(Icons.delete))
                    ],
                  ),
                );
              },
            ),
            ListView.builder(
              itemCount: list.spanish.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  onTap: () {},
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(list.nameS[index]),
                  subtitle: Text(list.spanish[index]),
                  trailing: ButtonBar(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.edit)),
                      IconButton(
                          onPressed: () {
                            try {
                              var id = list.idS[index];
                              FirebaseFirestore.instance
                                  .collection('category_translations')
                                  .doc(id)
                                  .delete();
                              var catID = list.spanish[index];
                              Provider.of<DbListProvider>(context,
                                      listen: false)
                                  .remove(3, catID);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Deleting data...')));
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())));
                            }
                          },
                          icon: const Icon(Icons.delete))
                    ],
                  ),
                );
              },
            ),
            ListView.builder(
              itemCount: list.bengali.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  onTap: () {},
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(list.nameB[index]),
                  subtitle: Text(list.bengali[index]),
                  trailing: ButtonBar(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.edit)),
                      IconButton(
                          onPressed: () {
                            try {
                              var id = list.idB[index];
                              FirebaseFirestore.instance
                                  .collection('category_translations')
                                  .doc(id)
                                  .delete();
                              var catID = list.bengali[index];
                              Provider.of<DbListProvider>(context,
                                      listen: false)
                                  .remove(4, catID);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Deleting data...')));
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())));
                            }
                          },
                          icon: const Icon(Icons.delete))
                    ],
                  ),
                );
              },
            )
          ]);
        }),
      ),
    );
  }

  Scrollbar buildScrollbar(DbListProvider list) {
    return Scrollbar(
      child: PaginateFirestore(
        padding: const EdgeInsets.all(32),
        // Use SliverAppBar in header to make it sticky
        header: SliverToBoxAdapter(
            child: Center(
                child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SimpleGroupedChips<int>(
            controller: chipsController,
            values: List.generate(5, (index) => index),
            itemTitle: const [
              'No Chinese translation',
              'No French translation',
              'No Spanish translation',
              'No Bengali translation',
              'Show All'
            ],
            backgroundColorItem: Colors.black26,
            isScrolling: false,
            chipGroupStyle: ChipGroupStyle.minimize(
              backgroundColorItem: Colors.red[400],
              itemTitleStyle: const TextStyle(
                fontSize: 14,
              ),
            ),
            onItemSelected: (values) {
              setState(() {});
              filter = values;
            },
          ),
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
          if (filter == 0) {
            return list.chinese.contains(documentSnapshots[index].id)
                ? Container()
                : ListTile(
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
                    subtitle: checkLanguage(data!['id'], list));
          } else if (filter == 1) {
            return list.french.contains(documentSnapshots[index].id)
                ? Container()
                : ListTile(
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
                    subtitle: checkLanguage(data!['id'], list));
          } else if (filter == 2) {
            return list.spanish.contains(documentSnapshots[index].id)
                ? Container()
                : ListTile(
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
                    subtitle: checkLanguage(data!['id'], list));
          } else if (filter == 3) {
            return list.bengali.contains(documentSnapshots[index].id)
                ? Container()
                : ListTile(
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
                    subtitle: checkLanguage(data!['id'], list));
          } else if (filter == 4) {
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
                subtitle: checkLanguage(data!['id'], list));
          } else {
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
                subtitle: checkLanguage(data!['id'], list));
          }
        },
        // orderBy is compulsory to enable pagination
        query: FirebaseFirestore.instance
            .collection('word_categories')
            .orderBy('created_at'),
        itemsPerPage: 5,
        // to fetch real-time data
        isLive: true,
      ),
    );
  }

  checkLanguage(id, DbListProvider list) {
    if (list.chinese.contains(id) &&
        list.french.contains(id) &&
        list.spanish.contains(id) &&
        list.bengali.contains(id)) {
      return const Text('Chinese, Spanish, Bengali and French Language added');
    } else if (list.chinese.contains(id) &&
        list.french.contains(id) &&
        list.bengali.contains(id)) {
      return const Text('Chinese, Bengali and French Language added');
    } else if (list.french.contains(id) &&
        list.spanish.contains(id) &&
        list.bengali.contains(id)) {
      return const Text('Spanish, Bengali and French Language added');
    } else if (list.chinese.contains(id) &&
        list.spanish.contains(id) &&
        list.bengali.contains(id)) {
      return const Text('Chinese, Spanish,and Bengali Language added');
    } else if (list.chinese.contains(id) &&
        list.french.contains(id) &&
        list.spanish.contains(id)) {
      return const Text('Chinese, Spanish, and French Language added');
    } else if (list.chinese.contains(id) && list.french.contains(id)) {
      return const Text('Chinese and French Language added');
    } else if (list.chinese.contains(id) && list.spanish.contains(id)) {
      return const Text('Chinese and Spanish Language added');
    } else if (list.chinese.contains(id) && list.bengali.contains(id)) {
      return const Text('Chinese and Banggali Language added');
    } else if (list.french.contains(id) && list.spanish.contains(id)) {
      return const Text('Spanish and French Language added');
    } else if (list.bengali.contains(id) && list.spanish.contains(id)) {
      return const Text('Bengali and Spanish Language added');
    } else if (list.bengali.contains(id) && list.french.contains(id)) {
      return const Text('Bengali and French Language added');
    } else if (list.chinese.contains(id)) {
      return const Text('Chinese Language added');
    } else if (list.french.contains(id)) {
      return const Text('French Language added');
    } else if (list.spanish.contains(id)) {
      return const Text('Spanish Language added');
    } else if (list.bengali.contains(id)) {
      return const Text('Bengali Language added');
    }
  }
}
