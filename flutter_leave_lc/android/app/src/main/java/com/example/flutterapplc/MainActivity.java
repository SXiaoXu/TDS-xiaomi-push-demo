package com.example.flutterapplc;

import android.os.Bundle;
import android.os.PersistableBundle;
import androidx.annotation.Nullable;
import cn.leancloud.LCLogger;
import cn.leancloud.LeanCloud;
import cn.leancloud.mi.LCMixPushManager;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import androidx.annotation.NonNull;
public class MainActivity extends FlutterActivity {
    private static final String CHANNELNorthChina = "initLC-NorthChina";
    private static final String CHANNELEastChina = "initLC-EastChina";
    private static final String CHANNELUS = "initLC-US";
    private static final String CHANNELTDS = "initTDS";
    private static final String CHANNELTest = "init-Test";

    private static final String LC_APP_ID_NorthChina = "eLAwFuK8k3eIYxh29VlbHu2N-gzGzoHsz";
    private static final String LC_APP_KEY_NorthChina = "G59fl4C1uLIQVR4BIiMjxnM3";
    private static final String LC_SERVER_URL_NorthChina = "https://elawfuk8.lc-cn-n1-shared.com";

    private static final String LC_APP_ID_EastChina = "2ke9qjLSGeamYyU7dT6eqvng-9Nh9j0Va";
    private static final String LC_APP_KEY_EastChina = "FEttS9MjIXgmyvbslSp90aUI";
    private static final String LC_SERVER_URL_EastChina = "https://2ke9qjls.lc-cn-e1-shared.com";

    private static final String LC_APP_ID_US = "glvame9g0qlj3a4o29j5xdzzrypxvvb30jt4vnvm66klph4r";
    private static final String LC_APP_KEY_US = "n79rw9ja3eo8n8au838t7pqur5mw88pnnep6ahlr99iq661a";
    private static final String LC_SERVER_URL_US = "https://usfcm.goodluckin.top";

    private static final String LC_APP_ID_TDS  = "HoiGvMeacbPWnv12MK";
    private static final String LC_APP_KEY_TDS  = "FesqQUmlhjMWt6uNrKaV6QPtYgBYZMP9QFmTUk54";
    private static final String LC_SERVER_URL_TDS  = "https://hoigvmea.cloud.tds1.tapapis.cn";

    private static final String LC_APP_ID_Test = "6HKynQEeIYeWpHmF9e7ocY5R-TeStHjQi";
    private static final String LC_APP_KEY_Test = "FLx5kVKBU04k6SxmuIVndMNy";
    private static final String LC_SERVER_URL_Test = "https://api.uc-test1.leancloud.cn";
//appstore_xsui
//    private static final String XIAOMI_APP = "2882303761520227426";
//    private static final String XIAOMI_KEY = "5202022724426";
//xsui_platform
private static final String XIAOMI_APP = "2882303761517988199";
    private static final String XIAOMI_KEY = "5571798886199";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNELNorthChina)
                .setMethodCallHandler(
                        (call, result) -> {
                            // This method is invoked on the main thread.
                            if (call.method.equals("initLC-NorthChina")) {
                                LeanCloud.setLogLevel(LCLogger.Level.DEBUG);
                                LeanCloud.initialize(this, LC_APP_ID_NorthChina, LC_APP_KEY_NorthChina, LC_SERVER_URL_NorthChina);
//                                LCMixPushManager.registerXiaomiPush(this, XIAOMI_APP, XIAOMI_KEY,"appstore_xsui");
                                LCMixPushManager.registerXiaomiPush(this, XIAOMI_APP, XIAOMI_KEY,"xsui_platform");

                            } else {
                                result.notImplemented();
                            }
                        }
                );
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNELEastChina)
                .setMethodCallHandler(
                        (call, result) -> {
                            // This method is invoked on the main thread.
                            if (call.method.equals("initLC-EastChina")) {
                                LeanCloud.setLogLevel(LCLogger.Level.DEBUG);
                                LeanCloud.initialize(this, LC_APP_ID_EastChina, LC_APP_KEY_EastChina, LC_SERVER_URL_EastChina);
//                                LCMixPushManager.registerXiaomiPush(this, XIAOMI_APP, XIAOMI_KEY,"appstore_xsui");
                                LCMixPushManager.registerXiaomiPush(this, XIAOMI_APP, XIAOMI_KEY,"xsui_platform");

                            } else {
                                result.notImplemented();
                            }
                        }
                );
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNELUS)
                .setMethodCallHandler(
                        (call, result) -> {
                            // This method is invoked on the main thread.
                            if (call.method.equals("initLC-US")) {
                                LeanCloud.setLogLevel(LCLogger.Level.DEBUG);
                                LeanCloud.initialize(this, LC_APP_ID_US, LC_APP_KEY_US, LC_SERVER_URL_US);
//                                LCMixPushManager.registerXiaomiPush(this, XIAOMI_APP, XIAOMI_KEY,"appstore_xsui");
                                LCMixPushManager.registerXiaomiPush(this, XIAOMI_APP, XIAOMI_KEY,"xsui_platform");

                            } else {
                                result.notImplemented();
                            }
                        }
                );
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNELTDS)
                .setMethodCallHandler(
                        (call, result) -> {
                            // This method is invoked on the main thread.
                            if (call.method.equals("initTDS")) {
                                LeanCloud.setLogLevel(LCLogger.Level.DEBUG);
                                LeanCloud.initialize(this, LC_APP_ID_TDS, LC_APP_KEY_TDS, LC_SERVER_URL_TDS);
//                                LCMixPushManager.registerXiaomiPush(this, XIAOMI_APP, XIAOMI_KEY,"appstore_xsui");
                                LCMixPushManager.registerXiaomiPush(this, XIAOMI_APP, XIAOMI_KEY,"xsui_platform");

                            } else {
                                result.notImplemented();
                            }
                        }
                );
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNELTest)
                .setMethodCallHandler(
                        (call, result) -> {
                            // This method is invoked on the main thread.
                            if (call.method.equals("init-Test")) {
                                LeanCloud.setLogLevel(LCLogger.Level.DEBUG);
                                LeanCloud.initialize(this, LC_APP_ID_Test, LC_APP_KEY_Test, LC_SERVER_URL_Test);
//                                LCMixPushManager.registerXiaomiPush(this, XIAOMI_APP, XIAOMI_KEY,"appstore_xsui");
                                LCMixPushManager.registerXiaomiPush(this, XIAOMI_APP, XIAOMI_KEY,"xsui_platform");

                            } else {
                                result.notImplemented();
                            }
                        }
                );

    }

}
