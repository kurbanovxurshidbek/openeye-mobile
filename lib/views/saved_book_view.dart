import 'package:flutter/material.dart';
import 'package:key_board_app/models/audio_model.dart';

// ignore: must_be_immutable
class SavedBookView extends StatelessWidget {
  AudioModel audioModel;
  Function deleteItem;
  Function onTap;

  SavedBookView(
      {Key? key,
      required this.audioModel,
      required this.deleteItem,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      width: double.infinity,
      child: ListTile(
        onTap: () {
          onTap;
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
          audioModel.name,
          style: TextStyle(
              fontSize: 14,
              fontFamily: "Serif",
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 49, 49, 49),
              fontStyle: FontStyle.normal),
        ),
        trailing: IconButton(
            onPressed: () {
              deleteItem;
            },
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            )),
      ),
    );
  }
}
