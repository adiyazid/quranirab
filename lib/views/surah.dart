import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/facebook/screens/home_screen.dart';
import 'package:quranirab/theme/theme_provider.dart';

class SurahGrid extends StatefulWidget {
  const SurahGrid({Key? key}) : super(key: key);

  @override
  _SurahGridState createState() => _SurahGridState();
}

class _SurahGridState extends State<SurahGrid> {
  final ScrollController _scrollController = ScrollController();

  final List<Map> surah = [
    {"name": "Al-Fatihah", "sname": "The Opener"},
    {"name": "Al-Baqarah", "sname": "The Cow"},
    {"name": "Ali 'Imran", "sname": "Family of Imran"},
    {"name": "An-Nisa", "sname": "The Women"},
    {"name": "Al-Ma'idah", "sname": "The Table Spread"},
    {"name": "Al-An'am", "sname": "The Cattle"},
    {"name": "Al-A'raf", "sname": "The Heights"},
    {"name": "Al-Anfal", "sname": "The Spoils of War"},
    {"name": "At-Tawbah", "sname": "The Repentance"},
    {"name": "Yunus", "sname": "Jonah"},
    {"name": "Hud", "sname": "Hud"},
    {"name": "Yusuf", "sname": "Joseph"},
    {"name": "Ar-Ra'd", "sname": "The Thunder"},
    {"name": "Ibrahim", "sname": "Abraham"},
    {"name": "Al-Hijr", "sname": "The Rocky Tract"},
    {"name": "An-Nahl", "sname": "The Bee"},
    {"name": "Al-Isra'", "sname": "The Night Journey"},
    {"name": "Al-Kahf", "sname": "The Cave"},
    {"name": "Maryam", "sname": "Mary"},
    {"name": "Taha", "sname": "Ta-Ha"},
    {"name": "Al-Anbya", "sname": "The Prophets"},
    {"name": "Al-Hajj", "sname": "The Pilgrimage"},
    {"name": "Al-Mu'minun", "sname": "The Believers"},
    {"name": "An-Nur", "sname": "The Light"},
    {"name": "Al-Furqan", "sname": "The Criterion"},
    {"name": "Ash-Shu'ara", "sname": "The Poets"},
    {"name": "An-Naml", "sname": "The Ant"},
    {"name": "Al-Qasas", "sname": "The Stories"},
    {"name": "Al-'Ankabut", "sname": "The Spider"},
    {"name": "Ar-Rum", "sname": "The Romans"},
    {"name": "Luqman", "sname": "Luqman"},
    {"name": "As-Sajdah", "sname": "The Prostration"},
    {"name": "Al-Ahzab", "sname": "The Combined Forces"},
    {"name": "Saba", "sname": "Sheba"},
    {"name": "Fatir", "sname": "Originator"},
    {"name": "Ya-Sin", "sname": "Ya Sin"},
    {"name": "As-Saffat", "sname": "Those who set the Ranks"},
    {"name": "Sad", "sname": "The Letter 'Saad'"},
    {"name": "Az-Zumar", "sname": "The Troops"},
    {"name": "Ghafir", "sname": "The Forgiver"},
    {"name": "Fussilat", "sname": "Explained in Detail"},
    {"name": "Ash-Shuraa", "sname": "The Consultation"},
    {"name": "Az-Zukhruf", "sname": "The Ornaments of Gold"},
    {"name": "Ad-Dukhan", "sname": "The Smoke"},
    {"name": "Al-Jathiyah", "sname": "The Crouching"},
    {"name": "Al-Ahqaf", "sname": "The Wind-Curved Sandhills"},
    {"name": "Muhammad", "sname": "Muhammad"},
    {"name": "Al-Fath", "sname": "The Victory"},
    {"name": "Al-Hujurat", "sname": "The Rooms"},
    {"name": "Qaf", "sname": "The Letter 'Qaf'"},
    {"name": "Adh-Dhariyat", "sname": "The Winnowing Winds"},
    {"name": "At-Tur", "sname": "The Mount"},
    {"name": "An-Najm", "sname": "The Star"},
    {"name": "Al-Qamar", "sname": "The Moon"},
    {"name": "Ar-Rahman", "sname": "The Beneficent"},
    {"name": "Al-Waqi'ah", "sname": "The Inevitable"},
    {"name": "Al-Hadid", "sname": "The Iron"},
    {"name": "Al-Mujadila", "sname": "The Pleading Woman"},
    {"name": "Al-Hashr", "sname": "The Exile"},
    {"name": "Al-Mumtahanah", "sname": "She that is to be examined"},
    {"name": "As-Saf", "sname": "The Ranks"},
    {"name": "Al-Jumu'ah", "sname": "The Congregation, Friday"},
    {"name": "Al-Munafiqun", "sname": "The Hypocrites"},
    {"name": "At-Taghabun", "sname": "The Mutual Disullusion"},
    {"name": "At-Talaq", "sname": "The Divorce"},
    {"name": "At-Tahrim", "sname": "The Prohibition"},
    {"name": "Al-Mulk", "sname": "The Sovereignty"},
    {"name": "Al-Qalam", "sname": "The Pen"},
    {"name": "Al-Haqqah", "sname": "The Reality"},
    {"name": "Al-Ma'arij", "sname": "The Ascending Stairways"},
    {"name": "Nuh", "sname": "Noah"},
    {"name": "Al-Jinn", "sname": "The Jinn"},
    {"name": "Al-Muzzammil", "sname": "The Enshrouded One"},
    {"name": "Al-Muddaththir", "sname": "The Cloaked One "},
    {"name": "Al-Qiyamah", "sname": "The Resurrection"},
    {"name": "Al-Insan", "sname": "The Man"},
    {"name": "Al-Mursalat", "sname": "The Emissaries"},
    {"name": "An-Naba", "sname": "The Tidings"},
    {"name": "An-Nazi'at", "sname": "Those who drag forth"},
    {"name": "Abasa", "sname": "He Frowned"},
    {"name": "At-Takwir", "sname": "The Overthrowing"},
    {"name": "Al-Infitar", "sname": "The Cleaving"},
    {"name": "Al-Mutaffifin", "sname": "The Defrauding"},
    {"name": "Al-Inshiqaq", "sname": "The Sundering"},
    {"name": "Al-Buruj", "sname": "The Mansions of the Stars"},
    {"name": "At-Tariq", "sname": "The Nightcommer"},
    {"name": "Al-A'la", "sname": "The Most High"},
    {"name": "Al-Ghasiyah", "sname": "The Overwhelming"},
    {"name": "Al-Fajr", "sname": "The Dawn"},
    {"name": "Al-Balad", "sname": "The City"},
    {"name": "Ash-Shams", "sname": "The Sun"},
    {"name": "Al-Layl", "sname": "The Night"},
    {"name": "Ad-Duhaa", "sname": "The Morning Hours"},
    {"name": "Ash-Sharh", "sname": "The Relief"},
    {"name": "At-Tin", "sname": "The Fig"},
    {"name": "Al-'Alaq", "sname": "The Clot"},
    {"name": "Al-Qadr", "sname": "The Power"},
    {"name": "Al-Bayyinah", "sname": "The Clear Proof"},
    {"name": "Az-Zalzalah", "sname": "The Earthquake"},
    {"name": "Al-'Adiyat", "sname": "The Courser"},
    {"name": "Al-Qari'ah", "sname": "The Calamity"},
    {"name": "At-Takathur", "sname": "The Rivalry in world increase"},
    {"name": "Al-Asr'", "sname": "The Declining Day"},
    {"name": "Al-Humazah", "sname": "The Traducer"},
    {"name": "Al-Fil", "sname": "The Elephant"},
    {"name": "Quraysh", "sname": "Quraysh"},
    {"name": "Al-Ma'un", "sname": "The Small Kindnesses"},
    {"name": "Al-Kawthar", "sname": "The Abundance"},
    {"name": "Al-Kafirun", "sname": "The Disbelievers"},
    {"name": "An-Nasr", "sname": "The Divine Support"},
    {"name": "Al-Masad", "sname": "The Palm Fiber"},
    {"name": "Al-Ikhlas", "sname": "The Sincerity"},
    {"name": "Al-Falaq", "sname": "The Daybreak"},
    {"name": "An-Nas", "sname": "Mankind"},
  ].toList();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(right: 38.0),
        child: GridView.count(
            controller: _scrollController,
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 3),
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: List.generate(114, (index) {
              return InkWell(
                child: Card(
                  color: (themeProvider.isDarkMode)
                      ? const Color(0xFFD2D6DA)
                      : const Color(0xFFFFFFFF),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.orange, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: ListTile(
                      leading: Container(
                          decoration: BoxDecoration(
                              color: (themeProvider.isDarkMode)
                                  ? const Color(0xff808BA1)
                                  : const Color(0xffFFB55F),
                              borderRadius: BorderRadius.circular(5)),
                          height: 30,
                          width: 30,
                          child: Center(
                              child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                                color: Colors.black, fontSize: 20),
                          ))),
                      title: Padding(
                        padding: const EdgeInsets.only(right: 30.0),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: [
                            TextSpan(
                              text: "${surah[index]['name']}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            TextSpan(
                              text: "\n${surah[index]['sname']}",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 20,
                              ),
                            )
                          ]),
                        ),
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FacebookHomeScreen()));
                },
              );
            })),
      ),
    );
  }
}
