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
import java.util.HashMap;

public class KeyBoard extends InputMethodService implements KeyboardView.OnKeyboardActionListener{
    KeyboardView keyboardView;
    Cases coca = Cases.Latter;


    MediaPlayer mediaPlayer;

  int[] index = {0,0,0,0,0,0};
    HashMap<String, String> numberToWord = new HashMap<String, String>() {{
        put("000000", " ");
        put("000001", ""); /// command to Upper Letters
        put("000010", "");
        put("000011", ""); /// command to Lower Letters
        put("000100", ""); /// qandaydr belgi qoyb urg'u berish uchun
        put("000101", "");
        put("000110", "");
        put("000111", "");
        put("001000", "");
        put("001001", "");
        put("001010", "");
        put("001011", "");
        put("001100", "");
        put("001101", "");
        put("001110", "");
        put("001111", ""); /// write by numbers
        put("010000", "");
        put("010001", "");
        put("010010", "");
        put("010011", "");
        put("010100", "i");
        put("010101", "");
        put("010110", "j");
        put("010111", "w");
        put("011000", "");
        put("011001", "");
        put("011010", "");
        put("011011", "");
        put("011100", "s");
        put("011101", "");
        put("011110", "t");
        put("011111", "");
        put("100000", "a");
        put("100001", "");
        put("100010", "e");
        put("100011", "");
        put("100100", "c");
        put("100101", "");
        put("100110", "d");
        put("100111", "");
        put("101000", "k");
        put("101001", "u");
        put("101010", "o");
        put("101011", "z");
        put("101100", "m");
        put("101101", "x");
        put("101110", "n");
        put("101111", "y");
        put("110000", "b");
        put("110001", "");
        put("110010", "h");
        put("110011", "");
        put("110100", "f");
        put("110101", "");
        put("110110", "g");
        put("110111", "");
        put("111000", "l");
        put("111001", "v");
        put("111010", "r");
        put("111011", "");
        put("111100", "p");
        put("111101", "");
        put("111110", "q");
        put("111111", "");
    }};
    HashMap<String, String> numberToNumber= new HashMap<String, String>() {{
        put("000000", " ");
        put("000001", ""); /// command to Upper Letters
        put("000010", "");
        put("000011", ""); /// command to Lower Letters
        put("000100", ""); /// qandaydr belgi qoyb urg'u berish uchun
        put("000101", "");
        put("000110", "");
        put("000111", "");
        put("001000", "");
        put("001001", "");
        put("001010", "");
        put("001011", "");
        put("001100", "");
        put("001101", "");
        put("001110", "");
        put("001111", ""); /// write by numbers
        put("010000", "");
        put("010001", "");
        put("010010", "");
        put("010011", "");
        put("010100", "9");
        put("010101", "");
        put("010110", "0");
        put("010111", "");
        put("011000", "");
        put("011001", "");
        put("011010", "");
        put("011011", "");
        put("011100", "");
        put("011101", "");
        put("011110", "");
        put("011111", "");
        put("100000", "1");
        put("100001", "");
        put("100010", "5");
        put("100011", "");
        put("100100", "3");
        put("100101", "");
        put("100110", "4");
        put("100111", "");
        put("101000", "");
        put("101001", "");
        put("101010", "");
        put("101011", "");
        put("101100", "");
        put("101101", "");
        put("101110", "");
        put("101111", "");
        put("110000", "2");
        put("110001", "");
        put("110010", "8");
        put("110011", "");
        put("110100", "6");
        put("110101", "");
        put("110110", "7");
        put("110111", "");
        put("111000", "");
        put("111001", "");
        put("111010", "");
        put("111011", "");
        put("111100", "");
        put("111101", "");
        put("111110", "");
        put("111111", "");
    }};
    HashMap<String, Integer> wordSound = new HashMap<String, Integer>() {{
        put("a", R.raw.a);
        put("b", R.raw.b);
        put("c", R.raw.c);
        put("d", R.raw.d);
        put("e", R.raw.e);
        put("f", R.raw.f);
        put("g", R.raw.g);
        put("h", R.raw.h);
        put("i", R.raw.i);
        put("j", R.raw.j);
        put("k", R.raw.k);
        put("l", R.raw.l);
        put("m", R.raw.m);
        put("n", R.raw.n);
        put("o", R.raw.o);
        put("p", R.raw.p);
        put("q", R.raw.q);
        put("r", R.raw.r);
        put("s", R.raw.s);
        put("t", R.raw.t);
        put("u", R.raw.u);
        put("v", R.raw.v);
        put("w", R.raw.w);
        put("x", R.raw.x);
        put("y", R.raw.y);
        put("z", R.raw.z);
        put("1", R.raw.n1);
        put("2", R.raw.n2);
        put("3", R.raw.n3);
        put("4", R.raw.n4);
        put("5", R.raw.n5);
        put("6", R.raw.n6);
        put("7", R.raw.n7);
        put("8", R.raw.n8);
        put("9", R.raw.n9);
        put("0", R.raw.n0);
        put(" ", R.raw.space);
    }};


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
                setListener(MediaPlayer.create(this, R.raw.n1));
                break;
            case 50:
                index[1]=2;

                setListener(MediaPlayer.create(this, R.raw.n2));

                break;
            case 51:
                index[2]=3;
                setListener(MediaPlayer.create(this, R.raw.n3));

                break;
            case 52:
                index[3]=4;

                setListener(MediaPlayer.create(this, R.raw.n4));

                break;
            case 53:
                index[4]=5;
                setListener(MediaPlayer.create(this, R.raw.n5));
                break;
            case 54:
                index[5]=6;
                setListener(MediaPlayer.create(this, R.raw.n6));
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
                String numbers = "";
                System.out.println();
                for(int num = 0 ; num < 6; num++) {
                    if(index[num] == num+1) {
                        numbers += "1";
                    } else {
                        numbers += "0";
                    }

                }
                System.out.println(numbers);
                if(coca == Cases.Upper) {
                    ic.commitText(numberToWord.get(numbers).toUpperCase(), 1);
                    if(numberToWord.get(numbers) != "") {
                        setListener(MediaPlayer.create(this, wordSound.get(numberToWord.get(numbers))));
                    } else {
                        setListener(MediaPlayer.create(this, R.raw.letter_no_sign));
                    }
                } else if(coca == Cases.Latter) {
                    ic.commitText(numberToWord.get(numbers), 1);
                    if(numberToWord.get(numbers) != "") {
                        setListener(MediaPlayer.create(this, wordSound.get(numberToWord.get(numbers))));
                    } else {
                        setListener(MediaPlayer.create(this, R.raw.letter_no_sign));
                    }
                } else if(coca == Cases.Number && numberToNumber.get(numbers) != null) {
                    ic.commitText(numberToNumber.get(numbers), 1);
                    System.out.println(numberToNumber.get(numbers) != null);
                    if(numberToNumber.get(numbers) != "") {
                        setListener(MediaPlayer.create(this, wordSound.get(numberToNumber.get(numbers))));
                    }
                    else if(numberToWord.get(numbers) != "") {
                        setListener(MediaPlayer.create(this, R.raw.cannot_use_letters));
                    }
                    else {
                        setListener(MediaPlayer.create(this, R.raw.number_no_sign));
                    }
                }
                makeZero();
                break;
            default:
                setListener(MediaPlayer.create(this, R.raw.latter));
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
