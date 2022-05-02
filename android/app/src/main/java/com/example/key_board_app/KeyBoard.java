package com.example.key_board_app;


import android.annotation.SuppressLint;
import android.inputmethodservice.InputMethodService;

import android.inputmethodservice.Keyboard;
import android.inputmethodservice.KeyboardView;
import android.media.MediaPlayer;
import android.os.Build;
import android.os.Vibrator;
import android.text.TextUtils;
import android.view.View;
import android.view.inputmethod.InputConnection;

import androidx.annotation.RequiresApi;

import java.util.Arrays;


public class KeyBoard extends InputMethodService implements KeyboardView.OnKeyboardActionListener{
    KeyboardView keyboardView;
    Cases coca = Cases.Latter;


    MediaPlayer mediaPlayer;

  int[] index = {0,0,0,0,0,0};

    @RequiresApi(api = Build.VERSION_CODES.P)
    @Override
    public View onCreateInputView() {
        keyboardView = (KeyboardView) getLayoutInflater().inflate(R.layout.keyboard_app, null);
        Keyboard keyboard = new Keyboard(this, R.xml.brail);
        keyboardView.setKeyboard(keyboard);
        keyboardView.setOnKeyboardActionListener(this);
        return keyboardView;
    }





    @Override
    public void onPress(int i) {

    }

    @Override
    public void onRelease(int i) {

    }


    @SuppressLint("MissingPermission")
    @Override
    public void onKey(int i, int[] ints) {
        Vibrator vibrator = (Vibrator)getSystemService(VIBRATOR_SERVICE);
        InputConnection ic = getCurrentInputConnection();
        if (ic == null) return;
        vibrator.vibrate(200);

        switch (i){
            case 49:
                index[0]=1;
                setListener(MediaPlayer.create(this, R.raw.one));
                break;
            case 50:
                index[1]=2;

                setListener(MediaPlayer.create(this, R.raw.two));

                break;
            case 51:
                index[2]=3;
                setListener(MediaPlayer.create(this, R.raw.tree));

                break;
            case 52:
                index[3]=4;

                setListener(MediaPlayer.create(this, R.raw.fo));

                break;
            case 53:
                index[4]=5;
                setListener(MediaPlayer.create(this, R.raw.five));
                break;
            case 54:
                index[5]=6;
                setListener(MediaPlayer.create(this, R.raw.six));
                break;
            case 100:
                coca= Cases.Number;
                setListener(MediaPlayer.create(this, R.raw.number));
                break;

             case 98:
                 if( coca == Cases.Latter){
                     coca = Cases.Upper;
                     setListener(MediaPlayer.create(this, R.raw.upper));
                 }else{
                     coca = Cases.Latter;
                     setListener(MediaPlayer.create(this, R.raw.latter))   ;
                 }


                break;
            case -5:
                CharSequence selectedText = ic.getSelectedText(0);
                if (TextUtils.isEmpty(selectedText)) {
                    // no selection, so delete previous character
                    ic.deleteSurroundingText(1, 0);
                } else {
                    // delete the selection
                    ic.commitText("", 1);
                }
                setListener(MediaPlayer.create(this, R.raw.delete));
                makeZero();
                break;
            case 10:
                if(Arrays.toString(index).equals("[1, 0, 3, 0, 0, 6]")){
                    if (coca== Cases.Upper){
                        ic.commitText("U", 1);
                    }
                    else{
                        ic.commitText("u", 1);
                    }
                    setListener(MediaPlayer.create(this, R.raw.u));

                } else   if(Arrays.toString(index).equals("[1, 2, 0, 0, 0, 0]")){
                    if (coca== Cases.Upper){
                        ic.commitText("B", 1);
                        setListener(MediaPlayer.create(this, R.raw.r));

                    } else if(coca== Cases.Number){
                        ic.commitText("2", 1);
                        setListener(MediaPlayer.create(this, R.raw.two));
                    }
                    else{
                        ic.commitText("b", 1);

                    }
                } else   if(Arrays.toString(index).equals("[1, 2, 3, 0, 5, 0]")){
                    setListener(MediaPlayer.create(this, R.raw.r));
                    if (coca== Cases.Upper){
                        ic.commitText("R", 1);
                    }else{
                        ic.commitText("r", 1);
                    }
                } else if(Arrays.toString(index).equals("[1, 0, 0, 0, 5, 0]")){
                    setListener(MediaPlayer.create(this, R.raw.e));
                    if (coca== Cases.Upper){
                        ic.commitText("E", 1);
                    }else{
                        ic.commitText("e", 1);
                    }
                } else  if(Arrays.toString(index).equals("[0, 2, 3, 4, 5, 0]")){
                    setListener(MediaPlayer.create(this, R.raw.t));
                    if (coca== Cases.Upper){
                        ic.commitText("T", 1);
                    }else{
                        ic.commitText("t", 1);
                    }
                } else  if(Arrays.toString(index).equals("[1, 2, 3, 0, 0, 0]")){
                    setListener(MediaPlayer.create(this, R.raw.l));
                    if (coca== Cases.Upper){
                        ic.commitText("L", 1);
                    }else{
                        ic.commitText("l", 1);
                    }
                } else  if(Arrays.toString(index).equals("[0, 0, 0, 0, 0, 0]")){
                    setListener(MediaPlayer.create(this, R.raw.space));
                    ic.commitText(" ", 1);
                } else if(Arrays.toString(index).equals("[1, 0, 0, 0, 0, 0]")){
                    if (coca== Cases.Upper){
                        ic.commitText("A", 1);
                    }else if(coca== Cases.Number){
                        setListener(MediaPlayer.create(this, R.raw.one));
                        ic.commitText("1", 1);
                    } else{
                        ic.commitText("a", 1);
                    }
                } else if(Arrays.toString(index).equals("[1, 2, 0, 4, 0, 0]")){
                    setListener(MediaPlayer.create(this, R.raw.f));
                    if (coca== Cases.Upper){
                        ic.commitText("F", 1);
                    }else{
                        ic.commitText("f", 1);
                    }

                }
                else{
                    ic.commitText(Arrays.toString(index), 1);
                }
                makeZero();
                break;
            default:
                setListener(MediaPlayer.create(this, R.raw.latter));;
        }


        if(mediaPlayer!=null){
            mediaPlayer.start();
        }
    }


    void stopSound(){
        mediaPlayer.stop();
        mediaPlayer.release();
        mediaPlayer=null;
    }

    void makeZero(){
        index[0]=0;
        index[1]=0;
        index[2]=0;
        index[3]=0;
        index[4]=0;
        index[5]=0;
    }


    void setListener(MediaPlayer _mediaPlayer){
        if(mediaPlayer!=null){
            stopSound();
        }
        
            mediaPlayer =   _mediaPlayer;
            mediaPlayer.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
                @Override
                public void onCompletion(MediaPlayer mediaPlayer) {
                    stopSound();
                }
            });
        

    }







    @Override
    public void onText(CharSequence charSequence) {

    }

    @Override
    public void swipeLeft() {
     
    }

    @Override
    public void swipeRight() {
     

    }

    @Override
    public void swipeDown() {
        InputConnection ic = getCurrentInputConnection();
        if (ic == null) return;
        char  code = (char) 10;
        ic.commitText(String.valueOf(code), 1);
    }

    @Override
    public void swipeUp() {

    }




}
