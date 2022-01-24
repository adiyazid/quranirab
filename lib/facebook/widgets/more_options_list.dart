import 'package:flutter/material.dart';
import 'package:quranirab/facebook/palette.dart';

class MoreOptionsList extends StatefulWidget {
  final String surah;
  final String nukKalimah;

  const MoreOptionsList({
    Key? key,
    required this.nukKalimah,
    required this.surah,
  }) : super(key: key);

  @override
  State<MoreOptionsList> createState() => _MoreOptionsListState();
}

class _MoreOptionsListState extends State<MoreOptionsList> {
  @override
  Widget build(BuildContext context) {
    final List<_Option> _popUpList = [
      _Option(
        answer: widget.nukKalimah,
        label: 'نوع الكلمة',
        hasColor: false,
        color: Colors.black,
      ),
      // const _Option(
      //   answer: '',
      //   label: 'الصرف',
      //   hasColor: true,
      //   color: Palette.orange,
      // ),
      // // نوع الكلمة     الاسمالصرفعلمة الاسم      التنوينالجنس          مذكرالعدد          مفردالتعيين        نكرةالصحة والعلة   الصحيحالجمود والاشتق  مشتق               اسم فاعلالنحوالإعراب والبناء معربموقع الإعراب    نعت               معنوتحالة االإعراب   مجرورعلامة الإعراب    كسرة ظاهرة
      // const _Option(
      //   answer: 'التنوين',
      //   label: 'علامة الاسم',
      //   hasColor: true,
      //   color: Palette.grey,
      // ),
      // const _Option(
      //   answer: 'مذكر',
      //   label: "لجنس",
      //   hasColor: true,
      //   color: Palette.grey,
      // ),
      // const _Option(
      //   answer: 'مفرد',
      //   label: "العدد",
      //   hasColor: true,
      //   color: Palette.grey,
      // ),
      // const _Option(
      //   answer: 'نكرة',
      //   label: "التعيين",
      //   hasColor: true,
      //   color: Palette.grey,
      // ),
      // const _Option(
      //   answer: 'الصحيح',
      //   label: "الصحة والعلة",
      //   hasColor: true,
      //   color: Palette.grey,
      // ),
      // const _Option(
      //   answer: 'مشتق',
      //   label: "الجمود والاشتق",
      //   hasColor: true,
      //   color: Palette.grey,
      // ),
      // const _Option(
      //   answer: 'اسم فاعل',
      //   label: "",
      //   hasColor: false,
      //   color: Palette.grey,
      // ),
      // const _Option(
      //   label: 'النحو',
      //   answer: "",
      //   hasColor: true,
      //   color: Palette.purple,
      // ),
      // const _Option(
      //   label: 'الإعراب والبناء',
      //   answer: "معرب",
      //   hasColor: true,
      //   color: Palette.grey,
      // ),
      // const _Option(
      //   label: 'موقع الإعراب',
      //   answer: "نعت",
      //   hasColor: true,
      //   color: Palette.grey,
      // ),
      // const _Option(
      //   label: '',
      //   answer: " معنوت",
      //   hasColor: true,
      //   color: Palette.grey,
      // ),
      // const _Option(
      //   label: 'حالة االإعراب',
      //   answer: "مجرور",
      //   hasColor: true,
      //   color: Palette.grey,
      // ),
      // const _Option(
      //   label: 'علامة الإعراب',
      //   answer: "كسرة ظاهرة",
      //   hasColor: true,
      //   color: Palette.grey,
      // ),
    ];
    return ListView.builder(
      itemCount: 1 + _popUpList.length,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      widget.surah,
                      style: TextStyle(
                        fontSize: 30,
                        color: Theme.of(context).textSelectionColor,
                      ),
                    )),
              ),
              const Divider(
                thickness: 1,
              )
            ],
          );
        }
        final option = _popUpList[index - 1];
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              option,
            ],
          ),
        );
      },
    );
  }
}

class _Option extends StatelessWidget {
  final String label;
  final String answer;
  final bool hasColor;
  final Color color;

  const _Option({
    Key? key,
    required this.label,
    required this.answer,
    required this.hasColor,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              child: Container(
                height: answer.length < 35 ? 56 : 120,
                padding: const EdgeInsets.only(
                  bottom: 0.2, // space between underline and text
                ),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: Theme.of(context).textSelectionColor, // Text colour here
                  width: 1, // Underline width
                ))),
                child: Text(
                  answer,
                  maxLines: 2,
                  style: TextStyle(
                    fontFamily: 'MeQuran2',
                    fontSize: 24,
                    color:
                        Theme.of(context).textSelectionColor, // Text colour here
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'MeQuran2',
                    fontSize: 24,
                    color:
                        (hasColor) ? color : Theme.of(context).textSelectionColor,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
