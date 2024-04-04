import 'package:flutter/material.dart';

class RowExpandContent extends StatelessWidget {
  const RowExpandContent({super.key, required this.text1, required this.text2, required this.text3});
  final String text1;
  final String text2;
  final String text3;
  @override
  Widget build(BuildContext context) {
    return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(flex: 2, child: Text(text1, textAlign: TextAlign.start)),
                Expanded(flex: 2, child: Text(text2, textAlign: TextAlign.center)),
                Expanded(flex: 2, child: Text(text3, textAlign: TextAlign.center)),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 5, horizontal: 5)),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: (){}, 
                    child: const Text('Брак'),),
                ), // IconButton(onPressed: (){}, icon: const Icon(Icons.fmd_bad_outlined))
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 5, horizontal: 5)),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: (){}, 
                    child: const Text('Доработка')),
                ),//IconButton(onPressed: (){}, icon: const Icon(Icons.mode_edit_outline_rounded))
              ],
            );
  }
}