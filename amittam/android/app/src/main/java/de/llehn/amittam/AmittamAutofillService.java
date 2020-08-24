package de.llehn.amittam;

import android.annotation.TargetApi;
import android.app.assist.AssistStructure;
import android.content.SharedPreferences;
import android.os.Build;
import android.os.CancellationSignal;
import android.service.autofill.AutofillService;
import android.service.autofill.Dataset;
import android.service.autofill.FillCallback;
import android.service.autofill.FillContext;
import android.service.autofill.FillRequest;
import android.service.autofill.FillResponse;
import android.service.autofill.SaveCallback;
import android.service.autofill.SaveInfo;
import android.service.autofill.SaveRequest;
import android.view.autofill.AutofillId;
import android.view.autofill.AutofillValue;
import android.widget.RemoteViews;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.regex.Pattern;

@TargetApi(Build.VERSION_CODES.O)
public class AmittamAutofillService extends AutofillService {

    String autofillAppTitle;

    AutofillPassword passwordToSave = new AutofillPassword("", "", "");

    @Override
    public void onFillRequest(FillRequest request, CancellationSignal cancellationSignal, FillCallback callback) {
        for (AutofillPassword pw : getAutofillPasswords()) System.out.println(pw.toString());
        List<FillContext> contexts = request.getFillContexts();
        AssistStructure structure = contexts.get(contexts.size() - 1).getStructure();
        ParsedStructure parsedStructure = parseStructure(structure);
        AutofillObject autofillObject = new AutofillObject(
                null, parsedStructure, getAppNameOfStructure(structure));
        fetchRelevantAutofillPasswordsOfListIntoAutofillObject(autofillObject, getAutofillPasswords());

        FillResponse response = getFillResponse(autofillObject);

        callback.onSuccess(response);
    }

    public ParsedStructure parseStructure(AssistStructure structure) {
        ParsedStructure returnValue = new ParsedStructure();
        final int nodes = structure.getWindowNodeCount();
        for (int i = 0; i < nodes; i++) {
            AssistStructure.WindowNode windowNode = structure.getWindowNodeAt(i);
            AssistStructure.ViewNode viewNode = windowNode.getRootViewNode();
            fetchImportantAutofillIdsOfNode(viewNode, returnValue);
        }
        if (returnValue.getAutofillType() == null) returnValue.setAutofillType(AutofillType.OTHER);
        return returnValue;
    }

    public void fetchImportantAutofillIdsOfNode(AssistStructure.ViewNode viewNode, ParsedStructure parsedStructure) {
        if (viewNode.getIdEntry() != null && (viewNode.getIdEntry().toLowerCase().contains("username") || viewNode.getIdEntry().toLowerCase().contains("email"))) {
            parsedStructure.setUsernameId(viewNode.getAutofillId());
            parsedStructure.setAutofillType(AutofillType.OTHER);
        } else if (viewNode.getIdEntry() != null && viewNode.getIdEntry().toLowerCase().contains("password"))
            parsedStructure.setPasswordId(viewNode.getAutofillId());
        else if (viewNode.getIdEntry() != null && viewNode.getIdEntry().toLowerCase().contains("ssid")) {
            parsedStructure.setUsernameId(viewNode.getAutofillId());
            parsedStructure.setAutofillType(AutofillType.WIFI);
        }

        for (int i = 0; i < viewNode.getChildCount(); i++)
            fetchImportantAutofillIdsOfNode(viewNode.getChildAt(i), parsedStructure);
    }

    public String getAppNameOfStructure(AssistStructure structure) {
        String[] autofillBundleIdStrings =
                structure.getWindowNodeAt(0)
                        .getTitle()
                        .toString()
                        .split("/")[0]
                        .split("\\.");
        return autofillBundleIdStrings[autofillBundleIdStrings.length - 1];
    }

    public FillResponse getFillResponse(AutofillObject autofillObject) {
        FillResponse.Builder fillResponseBuilder;
        if (autofillObject.getParsedStructure().getUsernameId() != null && autofillObject.getParsedStructure().getPasswordId() != null) {
            fillResponseBuilder = new FillResponse.Builder()
                    .setSaveInfo(
                            new SaveInfo.Builder(SaveInfo.SAVE_DATA_TYPE_USERNAME | SaveInfo.SAVE_DATA_TYPE_PASSWORD, new AutofillId[]{
                                    autofillObject.getParsedStructure().getUsernameId(),
                                    autofillObject.getParsedStructure().getPasswordId()
                            }).build()
                    );
            for (AutofillPassword pw : autofillObject.getAutofillPasswords()) {
                RemoteViews suggestion = new RemoteViews(getPackageName(), R.layout.autofill_suggestion);
                suggestion.setTextViewText(R.id.autofill_suggestion_username, pw.getUsername());
                suggestion.setTextViewText(R.id.autofill_suggestion_password, pw.getPassword());
                
                fillResponseBuilder.addDataset(new Dataset.Builder()
                        .setValue(autofillObject.getParsedStructure().getUsernameId(),
                                AutofillValue.forText(pw.getUsername()), suggestion)
                        .setValue(autofillObject.getParsedStructure().getPasswordId(),
                                AutofillValue.forText(pw.getPassword()), suggestion)
                        .build());
            }
            return fillResponseBuilder.build();
        }
        return null;
    }


    @Override
    public void onSaveRequest(SaveRequest request, SaveCallback callback) {
        System.out.println("Saving...");
        List<FillContext> contexts = request.getFillContexts();
        AssistStructure structure = contexts.get(contexts.size() - 1).getStructure();

        processStructure(structure);

        callback.onSuccess();
    }


    public void processStructure(AssistStructure structure) {
        passwordToSave.setPlatform(autofillAppTitle);

        final int nodes = structure.getWindowNodeCount();
        for (int i = 0; i < nodes; i++) {
            AssistStructure.WindowNode windowNode = structure.getWindowNodeAt(i);
            AssistStructure.ViewNode viewNode = windowNode.getRootViewNode();
            processNode(viewNode);
        }
    }

    public void processNode(AssistStructure.ViewNode viewNode) {
        if (viewNode.getIdEntry() != null && (viewNode.getIdEntry().contains("username") || viewNode.getIdEntry().contains("email")))
            passwordToSave.setUsername(String.valueOf(viewNode.getText()));
        else if (viewNode.getIdEntry() != null && viewNode.getIdEntry().contains("password"))
            passwordToSave.setPassword(String.valueOf(viewNode.getText()));
        System.out.println(passwordToSave.toString());

        for (int i = 0; i < viewNode.getChildCount(); i++) {
            AssistStructure.ViewNode childNode = viewNode.getChildAt(i);
            processNode(childNode);
        }
    }

    public void fetchRelevantAutofillPasswordsOfListIntoAutofillObject(AutofillObject autofillObject, List<AutofillPassword> autofillPasswords) {
        final List<AutofillPassword> resultList = new ArrayList<>();
        for (AutofillPassword pw : autofillPasswords) {
            System.out.println("check password platform: ");
            if (autofillObject.getAppName().toLowerCase().trim().contains(pw.getPlatform().trim().toLowerCase()))
                resultList.add(pw);
        }
        autofillObject.setAutofillPasswords(resultList);
        System.out.println("Result Passwords length: " + resultList.size());
        for (AutofillPassword pw : resultList) System.out.println("Result Password: "+ pw.toString());
    }

    public List<AutofillPassword> getAutofillPasswords() {
        SharedPreferences prefs = getSharedPreferences("FlutterSharedPreferences", MODE_PRIVATE);
        String passwordsString = prefs.getString("flutter.autofill_passwords", null);
        List<String> passwordsStringList = new ArrayList<>();
        if (passwordsString != null)
            passwordsStringList = Arrays.asList(passwordsString.split(Pattern.quote("}")));
        List<AutofillPassword> returnList = new ArrayList<>();
        for (String str : passwordsStringList) {
            String[] attrs = str.split(Pattern.quote("~"));
            returnList.add(new AutofillPassword(attrs[0], attrs[1], attrs[2]));
        }
        return returnList;
    }
}

class ParsedStructure {
    private AutofillType autofillType;
    private AutofillId usernameId;
    private AutofillId passwordId;

    AutofillId getUsernameId() {
        return usernameId;
    }

    void setUsernameId(AutofillId usernameId) {
        this.usernameId = usernameId;
    }

    AutofillId getPasswordId() {
        return passwordId;
    }

    void setPasswordId(AutofillId passwordId) {
        this.passwordId = passwordId;
    }

    AutofillType getAutofillType() {
        return autofillType;
    }

    void setAutofillType(AutofillType autofillType) {
        this.autofillType = autofillType;
    }
}

class AutofillPassword {
    AutofillPassword(String platform, String username, String password) {
        this.platform = platform;
        this.username = username;
        this.password = password;
    }

    private String platform;
    private String username;
    private String password;

    public String getPlatform() {
        return platform;
    }

    public void setPlatform(String platform) {
        this.platform = platform;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    @Override
    public String toString() {
        return String.format("AutofillPassword: {platform: %s, username: %s, password: %s}", getPlatform(), getUsername(), getPassword());
    }
}

class AutofillObject {
    AutofillObject(List<AutofillPassword> autofillPasswords, ParsedStructure parsedStructure, String appName) {
        this.autofillPasswords = autofillPasswords;
        this.parsedStructure = parsedStructure;
        this.appName = appName;
    }

    private List<AutofillPassword> autofillPasswords;
    private ParsedStructure parsedStructure;
    private String appName;

    public ParsedStructure getParsedStructure() {
        return parsedStructure;
    }

    public void setParsedStructure(ParsedStructure parsedStructure) {
        this.parsedStructure = parsedStructure;
    }

    public List<AutofillPassword> getAutofillPasswords() {
        return autofillPasswords;
    }

    public void setAutofillPasswords(List<AutofillPassword> autofillPasswords) {
        this.autofillPasswords = autofillPasswords;
    }

    public String getAppName() {
        return appName;
    }

    public void setAppName(String appName) {
        this.appName = appName;
    }
}

enum AutofillType {
    WIFI,
    OTHER,
}