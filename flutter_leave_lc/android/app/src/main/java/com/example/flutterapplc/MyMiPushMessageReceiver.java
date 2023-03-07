package com.example.flutterapplc;

import android.content.Context;
import android.util.Log;

import com.xiaomi.mipush.sdk.MiPushCommandMessage;
import com.xiaomi.mipush.sdk.PushMessageReceiver;

import java.util.List;
import cn.leancloud.LCInstallation;
import cn.leancloud.LCObject;
import cn.leancloud.mi.LCMixPushManager;
import io.reactivex.Observer;
import io.reactivex.disposables.Disposable;

public class MyMiPushMessageReceiver extends PushMessageReceiver {

    @Override
    public void onReceiveRegisterResult(Context context, MiPushCommandMessage miPushCommandMessage) {
        super.onReceiveRegisterResult(context, miPushCommandMessage);
        String command = miPushCommandMessage.getCommand();
        List<String> arguments = miPushCommandMessage.getCommandArguments();
        String cmdArg1 = ((arguments != null && arguments.size() > 0) ? arguments.get(0) : null);
        if (com.xiaomi.mipush.sdk.MiPushClient.COMMAND_REGISTER.equals(command)) {
            if (miPushCommandMessage.getResultCode() == com.xiaomi.mipush.sdk.ErrorCode.SUCCESS) {
                updateAVInstallation(cmdArg1);
            } else {
                Log.d("MI","register error, " + miPushCommandMessage.toString());
            }
        } else {
        }
    }
    private void updateAVInstallation(String miRegId) {
        if (miRegId != null) {
            LCInstallation installation = LCInstallation.getCurrentInstallation();

            if (!"mi".equals(installation.getString(LCInstallation.VENDOR))) {
                installation.put(LCInstallation.VENDOR, "mi");
            }
            if (!miRegId.equals(installation.getString(LCInstallation.REGISTRATION_ID))) {
                installation.put(LCInstallation.REGISTRATION_ID, miRegId);
            }
            String localProfile = installation.getString(LCMixPushManager.MIXPUSH_PROFILE);
            localProfile = (null != localProfile ? localProfile : "");
            if (!localProfile.equals(LCMixPushManager.miDeviceProfile)) {
                installation.put(LCMixPushManager.MIXPUSH_PROFILE, LCMixPushManager.miDeviceProfile);
            }

            installation.saveInBackground().subscribe(new Observer<LCObject>() {
                @Override
                public void onSubscribe(Disposable d) {
                }
                @Override
                public void onNext(LCObject avObject) {
                    System.out.println("保存成功：" + avObject.getObjectId() );
                }
                @Override
                public void onError(Throwable e) {
                    System.out.println("保存失败，错误信息：" + e.getMessage());
                }
                @Override
                public void onComplete() {
                }
            });
        }
    }
}
