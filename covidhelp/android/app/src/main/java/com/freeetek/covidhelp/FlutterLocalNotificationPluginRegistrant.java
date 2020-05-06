package com.freetek.covidhelp.covidhelp;

import io.flutter.plugin.common.PluginRegistry;
import com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin;

public final class FlutterLocalNotificationPluginRegistrant{
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    FlutterLocalNotificationsPlugin.registerWith(registry.registrarFor("com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = FlutterLocalNotificationPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
        return true;
    }
    registry.registrarFor(key);
    return false;
}


}