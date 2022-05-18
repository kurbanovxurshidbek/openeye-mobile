package com.example.key_board_app;

import java.util.HashMap;

public enum Cases {
    Number,Letter,Upper
}

enum Lan {
    En,Uz,Ru
}

enum Set {
    Number,Letter,Upper,Delete,Number_no_Sign,Cannot_use_letter,Letter_no_sign,Language
}

class ButtonText {
        HashMap<Lan, String> language = new HashMap<Lan, String>() {{
            put(Lan.En, "ENG");
            put(Lan.Uz, "UZB");
            put(Lan.Ru, "RUS");
        }};
}


