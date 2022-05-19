package com.example.key_board_app;

import java.util.HashMap;

public class ButtonLabels {

    public HashMap<Lan, String> language = new HashMap<Lan, String>() {{
        put(Lan.En, "ENG");
        put(Lan.Uz, "UZB");
        put(Lan.Ru, "RUS");
    }};

    public HashMap<Cases, String> wordType = new HashMap<Cases, String>() {{
        put(Cases.Upper, "A-Z");
        put(Cases.Letter, "a-z");
        put(Cases.Number, "0-9");
    }};
}
