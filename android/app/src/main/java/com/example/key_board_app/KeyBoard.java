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

import java.util.HashMap;

public class KeyBoard extends InputMethodService implements KeyboardView.OnKeyboardActionListener{
    KeyboardView keyboardView;
    Cases coca = Cases.Letter;
    Lan lanType = Lan.Uz;


    MediaPlayer mediaPlayer;

  int[] index = {0,0,0,0,0,0};

    // ko'p_tilli_map
    HashMap<String, HashMap<Lan, String>> multilingualMap = new HashMap<String, HashMap<Lan, String>>() {{
        put("000000", new HashMap<Lan, String>(){{ put(Lan.En, " "); put(Lan.Uz, " "); put(Lan.Ru, " "); }});
        put("000001", new HashMap<Lan, String>(){{ put(Lan.En, ""); put(Lan.Uz, ""); put(Lan.Ru, ""); }});
        put("000010", new HashMap<Lan, String>(){{ put(Lan.En, ""); put(Lan.Uz, ""); put(Lan.Ru, ""); }});
        put("000011", new HashMap<Lan, String>(){{ put(Lan.En, ""); put(Lan.Uz, ""); put(Lan.Ru, ""); }});
        put("000100", new HashMap<Lan, String>(){{ put(Lan.En, ""); put(Lan.Uz, ""); put(Lan.Ru, ""); }});
        put("000101", new HashMap<Lan, String>(){{ put(Lan.En, ""); put(Lan.Uz, ""); put(Lan.Ru, ""); }});
        put("000110", new HashMap<Lan, String>(){{ put(Lan.En, ""); put(Lan.Uz, ""); put(Lan.Ru, ""); }});
        put("000111", new HashMap<Lan, String>(){{ put(Lan.En, ""); put(Lan.Uz, ""); put(Lan.Ru, ""); }});
        put("001000", new HashMap<Lan, String>(){{ put(Lan.En, "'"); put(Lan.Uz, "'"); put(Lan.Ru, ""); }});
        put("001001", new HashMap<Lan, String>(){{ put(Lan.En, "-"); put(Lan.Uz, "-"); put(Lan.Ru, "-"); }});
        put("001010", new HashMap<Lan, String>(){{ put(Lan.En, ""); put(Lan.Uz, ""); put(Lan.Ru, ""); }});
        put("001011", new HashMap<Lan, String>(){{ put(Lan.En, "”"); put(Lan.Uz, "”"); put(Lan.Ru, "”"); }});
        put("001100", new HashMap<Lan, String>(){{ put(Lan.En, "/"); put(Lan.Uz, ""); put(Lan.Ru, ""); }});
        put("001101", new HashMap<Lan, String>(){{ put(Lan.En, ""); put(Lan.Uz, ""); put(Lan.Ru, ""); }});
        put("001110", new HashMap<Lan, String>(){{ put(Lan.En, ")"); put(Lan.Uz, ")"); put(Lan.Ru, ""); }});
        put("001111", new HashMap<Lan, String>(){{ put(Lan.En, ""); put(Lan.Uz, ""); put(Lan.Ru, ""); }});
        put("010000", new HashMap<Lan, String>(){{ put(Lan.En, ","); put(Lan.Uz, ","); put(Lan.Ru, ","); }});
        put("010001", new HashMap<Lan, String>(){{ put(Lan.En, "?"); put(Lan.Uz, "?"); put(Lan.Ru, "?"); }});
        put("010010", new HashMap<Lan, String>(){{ put(Lan.En, ":"); put(Lan.Uz, ":"); put(Lan.Ru, ":"); }});
        put("010011", new HashMap<Lan, String>(){{ put(Lan.En, "."); put(Lan.Uz, "."); put(Lan.Ru, "."); }});
        put("010100", new HashMap<Lan, String>(){{ put(Lan.En, "i"); put(Lan.Uz, "i"); put(Lan.Ru, "и"); }});
        put("010101", new HashMap<Lan, String>(){{ put(Lan.En, ""); put(Lan.Uz, ""); put(Lan.Ru, "э"); }});
        put("010110", new HashMap<Lan, String>(){{ put(Lan.En, "j"); put(Lan.Uz, "j"); put(Lan.Ru, "ж"); }});
        put("010111", new HashMap<Lan, String>(){{ put(Lan.En, "w"); put(Lan.Uz, "v"); put(Lan.Ru, "в"); }});
        put("011000", new HashMap<Lan, String>(){{ put(Lan.En, ";"); put(Lan.Uz, ";"); put(Lan.Ru, ";"); }});
        put("011001", new HashMap<Lan, String>(){{ put(Lan.En, "“"); put(Lan.Uz, "“"); put(Lan.Ru, "“"); }});
        put("011010", new HashMap<Lan, String>(){{ put(Lan.En, "!"); put(Lan.Uz, "!"); put(Lan.Ru, "!"); }});
        put("011011", new HashMap<Lan, String>(){{ put(Lan.En, ""); put(Lan.Uz, ""); put(Lan.Ru, "("); }});
        put("011100", new HashMap<Lan, String>(){{ put(Lan.En, "s"); put(Lan.Uz, "s"); put(Lan.Ru, "с"); }});
        put("011101", new HashMap<Lan, String>(){{ put(Lan.En, ""); put(Lan.Uz, ""); put(Lan.Ru, "ы"); }});
        put("011110", new HashMap<Lan, String>(){{ put(Lan.En, "t"); put(Lan.Uz, "t"); put(Lan.Ru, "т"); }});
        put("011111", new HashMap<Lan, String>(){{ put(Lan.En, ""); put(Lan.Uz, ""); put(Lan.Ru, "ь"); }});
        put("100000", new HashMap<Lan, String>(){{ put(Lan.En, "a"); put(Lan.Uz, "a"); put(Lan.Ru, "а"); }});
        put("100001", new HashMap<Lan, String>(){{ put(Lan.En, ""); put(Lan.Uz, ""); put(Lan.Ru, "ё"); }});
        put("100010", new HashMap<Lan, String>(){{ put(Lan.En, "e"); put(Lan.Uz, "e"); put(Lan.Ru, "е"); }});
        put("100011", new HashMap<Lan, String>(){{ put(Lan.En, ""); put(Lan.Uz, "sh"); put(Lan.Ru, "ш"); }});
        put("100100", new HashMap<Lan, String>(){{ put(Lan.En, "c"); put(Lan.Uz, ""); put(Lan.Ru, "ц"); }});
        put("100101", new HashMap<Lan, String>(){{ put(Lan.En, ""); put(Lan.Uz, ""); put(Lan.Ru, ""); }});
        put("100110", new HashMap<Lan, String>(){{ put(Lan.En, "d"); put(Lan.Uz, "d"); put(Lan.Ru, "д"); }});
        put("100111", new HashMap<Lan, String>(){{ put(Lan.En, ""); put(Lan.Uz, "x"); put(Lan.Ru, ""); }});
        put("101000", new HashMap<Lan, String>(){{ put(Lan.En, "k"); put(Lan.Uz, "k"); put(Lan.Ru, "к"); }});
        put("101001", new HashMap<Lan, String>(){{ put(Lan.En, "u"); put(Lan.Uz, "u"); put(Lan.Ru, "у"); }});
        put("101010", new HashMap<Lan, String>(){{ put(Lan.En, "o"); put(Lan.Uz, "o"); put(Lan.Ru, "о"); }});
        put("101011", new HashMap<Lan, String>(){{ put(Lan.En, "z"); put(Lan.Uz, "z"); put(Lan.Ru, "з"); }});
        put("101100", new HashMap<Lan, String>(){{ put(Lan.En, "m"); put(Lan.Uz, "m"); put(Lan.Ru, "м"); }});
        put("101101", new HashMap<Lan, String>(){{ put(Lan.En, "x"); put(Lan.Uz, ""); put(Lan.Ru, "щ"); }});
        put("101110", new HashMap<Lan, String>(){{ put(Lan.En, "n"); put(Lan.Uz, "n"); put(Lan.Ru, "н"); }});
        put("101111", new HashMap<Lan, String>(){{ put(Lan.En, "y"); put(Lan.Uz, "q"); put(Lan.Ru, ""); }});
        put("110000", new HashMap<Lan, String>(){{ put(Lan.En, "b"); put(Lan.Uz, "b"); put(Lan.Ru, "б"); }});
        put("110001", new HashMap<Lan, String>(){{ put(Lan.En, "("); put(Lan.Uz, "("); put(Lan.Ru, ""); }});
        put("110010", new HashMap<Lan, String>(){{ put(Lan.En, "h"); put(Lan.Uz, "h"); put(Lan.Ru, "х"); }});
        put("110011", new HashMap<Lan, String>(){{ put(Lan.En, ""); put(Lan.Uz, ""); put(Lan.Ru, "ю"); }});
        put("110100", new HashMap<Lan, String>(){{ put(Lan.En, "f"); put(Lan.Uz, "f"); put(Lan.Ru, "ф"); }});
        put("110101", new HashMap<Lan, String>(){{ put(Lan.En, ""); put(Lan.Uz, ""); put(Lan.Ru, "я"); }});
        put("110110", new HashMap<Lan, String>(){{ put(Lan.En, "g"); put(Lan.Uz, "g"); put(Lan.Ru, "г"); }});
        put("110111", new HashMap<Lan, String>(){{ put(Lan.En, ""); put(Lan.Uz, "g'"); put(Lan.Ru, ""); }});
        put("111000", new HashMap<Lan, String>(){{ put(Lan.En, "l"); put(Lan.Uz, "l"); put(Lan.Ru, "л"); }});
        put("111001", new HashMap<Lan, String>(){{ put(Lan.En, "v"); put(Lan.Uz, "o'"); put(Lan.Ru, ""); }});
        put("111010", new HashMap<Lan, String>(){{ put(Lan.En, "r"); put(Lan.Uz, "r"); put(Lan.Ru, "р"); }});
        put("111011", new HashMap<Lan, String>(){{ put(Lan.En, ""); put(Lan.Uz, ""); put(Lan.Ru, "ъ"); }});
        put("111100", new HashMap<Lan, String>(){{ put(Lan.En, "p"); put(Lan.Uz, "p"); put(Lan.Ru, "п"); }});
        put("111101", new HashMap<Lan, String>(){{ put(Lan.En, ""); put(Lan.Uz, "y"); put(Lan.Ru, "й"); }});
        put("111110", new HashMap<Lan, String>(){{ put(Lan.En, "q"); put(Lan.Uz, "ch"); put(Lan.Ru, "ч"); }});
        put("111111", new HashMap<Lan, String>(){{ put(Lan.En, ""); put(Lan.Uz, ""); put(Lan.Ru, ""); }});
    }};

    HashMap<String, String> numberToNumber = new HashMap<String, String>() {{
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
        put("010011", ".");
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

    // for result sign sound / chiqan belgini ovozini berish
    HashMap<Lan, HashMap<String, Integer>> wordSound = new HashMap<Lan, HashMap<String,Integer>>() {{
        put(Lan.En, new HashMap<String, Integer>(){{
            put("a", R.raw.en_a );
            put("b", R.raw.en_b);
            put("c", R.raw.en_c);
            put("d", R.raw.en_d);
            put("e", R.raw.en_e);
            put("f", R.raw.en_f);
            put("g", R.raw.en_g);
            put("h", R.raw.en_h);
            put("i", R.raw.en_i);
            put("j", R.raw.en_j);
            put("k", R.raw.en_k);
            put("l", R.raw.en_l);
            put("m", R.raw.en_m);
            put("n", R.raw.en_n);
            put("o", R.raw.en_o);
            put("p", R.raw.en_p);
            put("q", R.raw.en_q);
            put("r", R.raw.en_r);
            put("s", R.raw.en_s);
            put("t", R.raw.en_t);
            put("u", R.raw.en_u);
            put("v", R.raw.en_v);
            put("w", R.raw.en_w);
            put("x", R.raw.en_x);
            put("y", R.raw.en_y);
            put("z", R.raw.en_z);
            put("1", R.raw.en_n1);
            put("2", R.raw.en_n2);
            put("3", R.raw.en_n3);
            put("4", R.raw.en_n4);
            put("5", R.raw.en_n5);
            put("6", R.raw.en_n6);
            put("7", R.raw.en_n7);
            put("8", R.raw.en_n8);
            put("9", R.raw.en_n9);
            put("0", R.raw.en_n0);
            put(" ", R.raw.en_space);
            put(".", R.raw.en_dot);
            put(",", R.raw.en_comma);
            put("(", R.raw.en_bracket_opened);
            put(")", R.raw.en_bracket_closed);
            put("'", R.raw.en_apostrophe);
            put("-", R.raw.en_minus);
            put("”", R.raw.en_quote_closed);
            put("“", R.raw.en_quote_opened);
            put("!", R.raw.en_exclamation_mark);
            put("?", R.raw.en_question_mark);
            put(":", R.raw.en_colon);
            put(";", R.raw.en_semicolon);
            put("*", R.raw.en_asterisk);
        }});
        put(Lan.Uz, new HashMap<String, Integer>(){{
            put("a", R.raw.uz_a );
            put("b", R.raw.uz_b);
            put("d", R.raw.uz_d);
            put("e", R.raw.uz_e);
            put("f", R.raw.uz_f);
            put("g", R.raw.uz_g);
            put("h", R.raw.uz_h);
            put("i", R.raw.uz_i);
            put("j", R.raw.uz_j);
            put("k", R.raw.uz_k);
            put("l", R.raw.uz_l);
            put("m", R.raw.uz_m);
            put("n", R.raw.uz_n);
            put("o", R.raw.uz_o);
            put("p", R.raw.uz_p);
            put("q", R.raw.uz_q);
            put("r", R.raw.uz_r);
            put("s", R.raw.uz_s);
            put("t", R.raw.uz_t);
            put("u", R.raw.uz_u);
            put("v", R.raw.uz_v);
            put("x", R.raw.uz_x);
            put("y", R.raw.uz_y);
            put("z", R.raw.uz_z);
            put("1", R.raw.uz_n1);
            put("2", R.raw.uz_n2);
            put("3", R.raw.uz_n3);
            put("4", R.raw.uz_n4);
            put("5", R.raw.uz_n5);
            put("6", R.raw.uz_n6);
            put("7", R.raw.uz_n7);
            put("8", R.raw.uz_n8);
            put("9", R.raw.uz_n9);
            put("0", R.raw.uz_n0);
            put(" ", R.raw.uz_space);
            put(".", R.raw.uz_dot);
            put(",", R.raw.uz_comma);
            put("(", R.raw.uz_bracket_opened);
            put(")", R.raw.uz_bracket_closed);
            put("'", R.raw.uz_apostrophe);
            put("-", R.raw.uz_minus);
            put("”", R.raw.uz_quote_closed);
            put("“", R.raw.uz_quote_opened);
            put("!", R.raw.uz_exclamation_mark);
            put("?", R.raw.uz_question_mark);
            put(":", R.raw.uz_colon);
            put(";", R.raw.uz_semicolon);
            put("*", R.raw.uz_asterisk);
        }});
        put(Lan.Ru, new HashMap<String, Integer>(){{
            put("а", R.raw.ru_a );
            put("б", R.raw.ru_b );
            put("в", R.raw.ru_v );
            put("г", R.raw.ru_g );
            put("д", R.raw.ru_d );
            put("е", R.raw.ru_ye );
            put("ё", R.raw.ru_yo );
            put("ж", R.raw.ru_j );
            put("з", R.raw.ru_z );
            put("и", R.raw.ru_i );
            put("й", R.raw.ru_y );
            put("к", R.raw.ru_k );
            put("л", R.raw.ru_l );
            put("м", R.raw.ru_m );
            put("н", R.raw.ru_n );
            put("о", R.raw.ru_o );
            put("п", R.raw.ru_p );
            put("р", R.raw.ru_r );
            put("с", R.raw.ru_s );
            put("т", R.raw.ru_t );
            put("у", R.raw.ru_u );
            put("ф", R.raw.ru_f );
            put("х", R.raw.ru_x );
            put("ц", R.raw.ru_ts );
            put("ч", R.raw.ru_ch );
            put("ш", R.raw.ru_sh );
            put("щ", R.raw.ru_shsh );
            put("ъ", R.raw.ru_ib );
            put("ы", R.raw.ru_bi );
            put("ь", R.raw.ru_bb );
            put("э", R.raw.ru_e );
            put("ю", R.raw.ru_yu );
            put("я", R.raw.ru_ya );
            put("1", R.raw.ru_n1 );
            put("2", R.raw.ru_n2 );
            put("3", R.raw.ru_n3 );
            put("4", R.raw.ru_n4 );
            put("5", R.raw.ru_n5 );
            put("6", R.raw.ru_n6 );
            put("7", R.raw.ru_n7 );
            put("8", R.raw.ru_n8 );
            put("9", R.raw.ru_n9 );
            put("0", R.raw.ru_n0 );
            put(" ", R.raw.ru_space);
            put(".", R.raw.ru_dot);
            put(",", R.raw.ru_comma);
            put("(", R.raw.ru_bracket_opened);
            put(")", R.raw.ru_bracket_closed);
            put("'", R.raw.ru_apostrophe);
            put("-", R.raw.ru_minus);
            put("”", R.raw.ru_quote_closed);
            put("“", R.raw.ru_quote_opened);
            put("!", R.raw.ru_exclamation_mark);
            put("?", R.raw.ru_question_mark);
            put(":", R.raw.ru_colon);
            put(";", R.raw.ru_semicolon);
            put("*", R.raw.ru_asterisk);
        }});
    }};

    // for click buttons sound / tugmalarni bosganda ovoz berish uchun
    HashMap<Set, HashMap<Lan,Integer>> settings = new HashMap<Set, HashMap<Lan,Integer>>() {{
        // go to letter case / harfga otish
        put(Set.Letter, new HashMap<Lan, Integer>(){{ put(Lan.En, R.raw.en_letter); put(Lan.Uz, R.raw.uz_letter); put(Lan.Ru,R.raw.ru_letter); }});
        // letter case. there is no such sign / harf holatida bunday belgi yo'q
        put(Set.Letter_no_sign, new HashMap<Lan, Integer>(){{ put(Lan.En, R.raw.en_letter_no_sign); put(Lan.Uz, R.raw.uz_letter_no_sign); put(Lan.Ru,R.raw.ru_letter_no_sign); }});
        // inability to use a letter in the case of a number / raqam holatida harfdan foydalana olmaslik
        put(Set.Cannot_use_letter, new HashMap<Lan, Integer>(){{ put(Lan.En, R.raw.en_cannot_use_letters); put(Lan.Uz, R.raw.uz_cannot_use_letters); put(Lan.Ru,R.raw.ru_cannot_use_letters); }});
        // go to upper case / katta harf holatiga otish
        put(Set.Upper, new HashMap<Lan, Integer>(){{ put(Lan.En, R.raw.en_upper); put(Lan.Uz, R.raw.uz_upper); put(Lan.Ru,R.raw.ru_upper); }});
        // go to number case / raqam holatiga o'tish
        put(Set.Number, new HashMap<Lan, Integer>(){{ put(Lan.En, R.raw.en_number); put(Lan.Uz, R.raw.uz_number); put(Lan.Ru,R.raw.ru_number); }});
        // number case. there is no such sign / raqam holatidasiz. bunday belgi yo'q
        put(Set.Number_no_Sign, new HashMap<Lan, Integer>(){{ put(Lan.En, R.raw.en_number_no_sign); put(Lan.Uz, R.raw.uz_number_no_sign); put(Lan.Ru,R.raw.ru_number_no_sign); }});
        // delete / o'chirish
        put(Set.Delete, new HashMap<Lan, Integer>(){{ put(Lan.En, R.raw.en_delete); put(Lan.Uz, R.raw.uz_delete); put(Lan.Ru,R.raw.ru_delete); }});
        // change language / tilni o'zgartirish
        put(Set.Language, new HashMap<Lan, Integer>(){{ put(Lan.En, R.raw.en_lang); put(Lan.Uz, R.raw.uz_lang); put(Lan.Ru,R.raw.ru_lang); }});
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
                setListener(MediaPlayer.create(this, wordSound.get(lanType).get("1")));
                break;
            case 50:
                index[1]=2;

                setListener(MediaPlayer.create(this, wordSound.get(lanType).get("2")));

                break;
            case 51:
                index[2]=3;
                setListener(MediaPlayer.create(this, wordSound.get(lanType).get("3")));

                break;
            case 52:
                index[3]=4;

                setListener(MediaPlayer.create(this, wordSound.get(lanType).get("4")));

                break;
            case 53:
                index[4]=5;
                setListener(MediaPlayer.create(this, wordSound.get(lanType).get("5")));
                break;
            case 54:
                index[5]=6;
                setListener(MediaPlayer.create(this, wordSound.get(lanType).get("6")));
                break;
            case 100:
                 if(lanType == Lan.Uz){
                     lanType = Lan.Ru;
                     setListener(MediaPlayer.create(this, R.raw.ru_lang));
                 } else if(lanType == Lan.Ru){
                     lanType = Lan.En;
                     setListener(MediaPlayer.create(this, R.raw.en_lang));
                 } else   if(lanType == Lan.En){
                     lanType = Lan.Uz;
                     setListener(MediaPlayer.create(this, R.raw.uz_lang));
                 }
                 Keyboard keyboard = new Keyboard(this, R.xml.brail);
                 keyboard.getKeys().get(7).label = new ButtonLabels().wordType.get(coca);
                 keyboard.getKeys().get(8).label = new ButtonLabels().language.get(lanType);
                 keyboardView.setKeyboard(keyboard);
                 break;

             case 98:
                 keyboard = keyboardView.getKeyboard();
                 if( coca == Cases.Letter) {
                     coca = Cases.Upper;
                     setListener(MediaPlayer.create(this, settings.get(Set.Upper).get(lanType)));
                 } else if( coca == Cases.Upper) {
                     coca = Cases.Number;
                     setListener(MediaPlayer.create(this, settings.get(Set.Number).get(lanType)));
                 } else if (coca == Cases.Number) {
                     coca = Cases.Letter;
                     setListener(MediaPlayer.create(this, settings.get(Set.Letter).get(lanType)));
                 }
                 keyboard.getKeys().get(7).label = new ButtonLabels().wordType.get(coca);
                 keyboard.getKeys().get(8).label = new ButtonLabels().language.get(lanType);
                 keyboardView.setKeyboard(keyboard);
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
                setListener(MediaPlayer.create(this, settings.get(Set.Delete).get(lanType)));
                makeZero();
                break;
            case 10:
                String numbers = "";
                for(int num = 0 ; num < 6; num++) {
                    if(index[num] == num+1) {
                        numbers += "1";
                    } else {
                        numbers += "0";
                    }
                }

                System.out.println("++++++++++++++++++++ numbers olindi ++++++++++++++++++++");
                if(coca == Cases.Letter || coca == Cases.Upper) {
                    System.out.println("++++++++++++++++++++ harfga kirdi ++++++++++++++++++++");
                    if(multilingualMap.get(numbers).get(lanType) != "") {
                        System.out.println("++++++++++++++++++++ harf bor ++++++++++++++++++++");
                        String word = multilingualMap.get(numbers).get(lanType);
                        if(coca == Cases.Upper) {
                            ic.commitText(word.toUpperCase(), word.length());
                        } else {
                            ic.commitText(word, word.length());
                        }
                        if(wordSound.get(lanType).containsKey(word)) {
                            System.out.println("++++++++++++++++++++ harf ovozi bor ++++++++++++++++++++");
                            setListener(MediaPlayer.create(this, wordSound.get(lanType).get(word)));
                        }
                    } else {
                        System.out.println("++++++++++++++++++++ bunday harf yo'q ++++++++++++++++++++");
                        setListener(MediaPlayer.create(this, settings.get(Set.Letter_no_sign).get(lanType)));
                    }
                } else if(coca == Cases.Number) {
                    String num = numberToNumber.get(numbers);
                    System.out.println("++++++++++++++++++++ numberga kirdi ++++++++++++++++++++");
                    if(num != "") {
                        ic.commitText(num, 1);
                        System.out.println("++++++++++++++++++++ son qowiw ++++++++++++++++++++");
                        setListener(MediaPlayer.create(this, wordSound.get(lanType).get(num)));
                        System.out.println("++++++++++++++++++++ son qowildi ++++++++++++++++++++");
                    } else if(multilingualMap.get(numbers).get(lanType) != "") {
                        System.out.println("++++++++++++++++++++ harfdan foydalana olmaysiz ++++++++++++++++++++");
                        setListener(MediaPlayer.create(this, settings.get(Set.Cannot_use_letter).get(lanType)));
                    } else {
                        System.out.println("++++++++++++++++++++ bunday belgi yo'q ++++++++++++++++++++");
                        setListener(MediaPlayer.create(this, settings.get(Set.Number_no_Sign).get(lanType)));
                    }
                }
                System.out.println("++++++++++++++++++++ tugadi ++++++++++++++++++++");

                makeZero();
                break;
            default:
                setListener(MediaPlayer.create(this, settings.get(Set.Letter).get(lanType)));
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
