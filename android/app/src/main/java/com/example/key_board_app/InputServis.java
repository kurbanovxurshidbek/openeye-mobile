package com.example.key_board_app;

import android.content.Intent;
import android.inputmethodservice.InputMethodService;
import android.view.inputmethod.InputConnection;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

public class InputServis extends AppCompatActivity {


    @Override
    public void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
    }
}
