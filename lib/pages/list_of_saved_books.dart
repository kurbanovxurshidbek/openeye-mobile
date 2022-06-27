import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_board_app/cubits/saved_book/saved_books_cubit.dart';
import '../cubits/saved_book/saved_books_state.dart';
import '../navigators/goto.dart';
import 'list_of_part_books.dart';

class SavedBooksPage extends StatefulWidget {
  const SavedBooksPage({Key? key}) : super(key: key);

  @override
  State<SavedBooksPage> createState() => _SavedBooksPageState();
}

class _SavedBooksPageState extends State<SavedBooksPage>  {
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
        title: Text(
          "saved_books",
          style: TextStyle(
            fontSize: 20,fontFamily:"Roboto"
          ),
        ).tr(),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.blueGrey,
        // shadowColor: Colors.blueGrey ,
      ),
      body: BlocBuilder<SavedBooksCubit, SavedBooksState>(
        builder: (context, state) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(color: Colors.white),
            child: ListView(
                children: List.generate(
                    state.listOAudioBook.length,
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
                                    GOTO.pushRP(
                                        context,
                                        PartBooksPage(
                                          index: index,
                                          name: state.listOAudioBook[index],
                                        ));
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
                                    state.listOAudioBook[index],
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontFamily: "Roboto-Medium",
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueGrey.shade500,
                                        fontStyle: FontStyle.normal),
                                  ),
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
    );
  }
}
