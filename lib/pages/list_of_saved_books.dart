import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_board_app/cubits/saved_book/saved_books_cubit.dart';

import '../cubits/saved_book/saved_books_state.dart';
import '../navigators/goto.dart';
import '../views/dialogs.dart';
import 'reading_audio_page.dart';

class SavedBooksPage extends StatefulWidget {
  const SavedBooksPage({Key? key}) : super(key: key);

  @override
  State<SavedBooksPage> createState() => _SavedBooksPageState();
}

class _SavedBooksPageState extends State<SavedBooksPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    BlocProvider.of<SavedBooksCubit>(context).loadList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.blueGrey,
        shadowColor: Colors.blueGrey,
      ),
      body: BlocBuilder<SavedBooksCubit, SavedBooksState>(
        builder: (context, state) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(color: Colors.white),
            child: ListView(
                children: List.generate(
                    state.listOfAudioModels.length,
                    (index) => Column(
                          children: [
                            Container(
                              height: 100,
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blueGrey,
                                    offset: const Offset(
                                      0.0,
                                      3.0,
                                    ),
                                    blurRadius: 3.0,
                                    spreadRadius: 0.1,
                                  ), //BoxShadow
                                  //BoxShadow
                                ],
                              ),
                              child: Center(
                                child: ListTile(
                                  onTap: () {
                                    GOTO.push(
                                        context,
                                        ReadingPage(
                                            onListBooksPage: true,
                                            listAudio: state.listOfAudioModels,
                                            startOnIndex: index));
                                  },
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      "assets/images/audio_book.png",
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: Text(
                                    state.listOfAudioModels[index].name,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Serif",
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueGrey.shade600,
                                        fontStyle: FontStyle.normal),
                                  ),
                                  trailing: IconButton(
                                      onPressed: () {
                                        deleteItemDialog(context,
                                            state.listOfAudioModels[index]);
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.blueGrey,
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ))),
          );
        },
      ),
    );
  }
}
