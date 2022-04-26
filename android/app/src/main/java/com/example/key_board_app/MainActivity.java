package com.example.key_board_app;

import android.content.Intent;
import android.os.Bundle;
import android.os.PersistableBundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.util.GeneratedPluginRegister;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;


public class MainActivity extends FlutterActivity {


    private static  final String CHANNEL_NAME="flutter.native/helper";


    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(),CHANNEL_NAME).setMethodCallHandler((call, result)->{
            if(call.method.equals("helloNativeCode")){
                helloNativeCode();
                result.success("Hello");
            }
        });
    }

    private void helloNativeCode() {
        startActivity(new Intent("android.settings.INPUT_METHOD_SETTINGS"));
    }
}



