class AmittamAutofillService extends AutofillService {
    SharedPreferences prefs = getSharedPreferences("FlutterSharedPreferences", MODE_PRIVATE);
    String value = prefs.getString("flutter."+key, null);
}