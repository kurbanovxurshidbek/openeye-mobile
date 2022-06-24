import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_board_app/cubits/part_saved_books/part_audio_books_dart_state.dart';
import 'package:key_board_app/pages/saved_audio_reading_page.dart';
import '../cubits/part_saved_books/part_audio_books_dart_cubit.dart';
import '../navigators/goto.dart';
import '../views/dialogs.dart';
import 'list_of_saved_books.dart';

class PartBooksPage extends StatefulWidget {
  int index;
  String name;
  PartBooksPage({Key? key, required this.index, required this.name})
      : super(key: key);

  @override
  State<PartBooksPage> createState() => _PartBooksPageState();
}

class _PartBooksPageState extends State<PartBooksPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    BlocProvider.of<PartAudioBooksDartCubit>(context).loadList(widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
  GOTO.pushRP(context, SavedBooksPage());

        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              GOTO.pushRP(context, SavedBooksPage());
            },

            icon: Icon(Icons.arrow_back),
          ),

          title: Text(
            widget.name,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.blueGrey,
          // shadowColor: Colors.blueGrey ,
        ),
        body: BlocBuilder<PartAudioBooksDartCubit, PartAudioBooksDartState>(
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
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: ListTile(
                                    onTap: () {
                                      GOTO.push(
                                          context,
                                          ReadingPage(
                                              listAudio: state.listOfAudioModels,
                                              startOnIndex: index));
                                    },
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        "assets/images/audbook.png",
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    title: Text(
                                      state.listOfAudioModels[index].name,
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontFamily: "Serif",
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueGrey.shade600,
                                          fontStyle: FontStyle.normal),
                                    ),
                                    trailing: IconButton(
                                        onPressed: () {
                                          deleteItemDialog(
                                              context,
                                              state.listOfAudioModels[index],
                                              widget.index);
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        )),
                                  ),
                                ),
                              ),
                              Container(
                                height: 1,
                                color: Colors.grey.shade300,
                              )
                            ],
                          ))),
            );
          },
        ),
      ),
    );
  }
}
