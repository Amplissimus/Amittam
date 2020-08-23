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

import io.flutter.embedding.engine.systemchannels.TextInputChannel;

@TargetApi(Build.VERSION_CODES.O)
public class AmittamAutofillService extends AutofillService {

    String autofillAppTitle;

    ParsedStructure parsedStructure;

    CurrentAction currentAction;

    AutofillPassword passwordToSave = new AutofillPassword("", "", "");

    @Override
    public void onFillRequest(FillRequest request, CancellationSignal cancellationSignal, FillCallback callback) {
        currentAction = CurrentAction.FILLING;
        parsedStructure = new ParsedStructure();
        List<FillContext> contexts = request.getFillContexts();
        AssistStructure structure = contexts.get(contexts.size() - 1).getStructure();
        processStructure(structure);

        String suggestionText = "This is an autofill suggestion!";
        RemoteViews usernameSuggestion = new RemoteViews(getPackageName(), R.layout.autofill_suggestion);
        usernameSuggestion.setTextViewText(R.id.autofill_suggestion_username, suggestionText + " (username)");
        RemoteViews passwordSuggestion = new RemoteViews(getPackageName(), R.layout.autofill_suggestion);
        passwordSuggestion.setTextViewText(R.id.autofill_suggestion_password, suggestionText + " (password)");

        FillResponse response = new FillResponse.Builder()
                .addDataset(new Dataset.Builder()
                        .setValue(parsedStructure.getUsernameId(),
                                AutofillValue.forText("Autofilled! (username)"), usernameSuggestion)
                        .setValue(parsedStructure.getPasswordId(),
                                AutofillValue.forText("Autofilled! (password)"), passwordSuggestion)
                        .build())
                .setSaveInfo(new SaveInfo.Builder(
                        SaveInfo.SAVE_DATA_TYPE_USERNAME | SaveInfo.SAVE_DATA_TYPE_PASSWORD,
                        new AutofillId[]{parsedStructure.getUsernameId(), parsedStructure.getPasswordId()})
                        .build())
                .build();

        callback.onSuccess(response);
    }

    public void getFillResponse() {
        FillResponse.Builder fillResponseBuilder = new FillResponse.Builder()
                .setSaveInfo(new SaveInfo.Builder(
                        SaveInfo.SAVE_DATA_TYPE_USERNAME | SaveInfo.SAVE_DATA_TYPE_PASSWORD,
                        new AutofillId[]{parsedStructure.getUsernameId(), parsedStructure.getPasswordId()})
                        .build());

    }



    @Override
    public void onSaveRequest(SaveRequest request, SaveCallback callback) {
        System.out.println("Saving...");
        currentAction = CurrentAction.SAVING;
        List<FillContext> contexts = request.getFillContexts();
        AssistStructure structure = contexts.get(contexts.size() - 1).getStructure();

        processStructure(structure);

        callback.onSuccess();
    }

    public void processStructure(AssistStructure structure) {
        List<String> autofillBundleIdStrings = Arrays.asList(structure.getWindowNodeAt(0).getTitle().toString().split("/")[0].split("."));
        autofillAppTitle = autofillBundleIdStrings.get(autofillBundleIdStrings.size() -1);
        if (currentAction == CurrentAction.SAVING) passwordToSave.setPlatform(autofillAppTitle);

        final int nodes = structure.getWindowNodeCount();
        for (int i = 0; i < nodes; i++) {
            AssistStructure.WindowNode windowNode = structure.getWindowNodeAt(i);
            AssistStructure.ViewNode viewNode = windowNode.getRootViewNode();
            processNode(viewNode);
        }
    }

    public void processNode(AssistStructure.ViewNode viewNode) {
        if (currentAction == CurrentAction.FILLING) {
            if (viewNode.getIdEntry() != null && (viewNode.getIdEntry().toLowerCase().contains("username") || viewNode.getIdEntry().toLowerCase().contains("email"))) {
                parsedStructure.setUsernameId(viewNode.getAutofillId());
                parsedStructure.setAutofillType(AutofillType.OTHER);
            } else if (viewNode.getIdEntry() != null && viewNode.getIdEntry().toLowerCase().contains("password"))
                parsedStructure.setPasswordId(viewNode.getAutofillId());
            else if (viewNode.getIdEntry() != null && viewNode.getIdEntry().toLowerCase().contains("ssid")) {
                parsedStructure.setUsernameId(viewNode.getAutofillId());
                parsedStructure.setAutofillType(AutofillType.WIFI);
            }
        } else if (currentAction == CurrentAction.SAVING) {
            if (viewNode.getIdEntry() != null && (viewNode.getIdEntry().contains("username") || viewNode.getIdEntry().contains("email")))
                passwordToSave.setUsername(String.valueOf(viewNode.getText()));
            else if (viewNode.getIdEntry() != null && viewNode.getIdEntry().contains("password"))
                passwordToSave.setPassword(String.valueOf(viewNode.getText()));
            System.out.println(passwordToSave.toString());
        }

        for (int i = 0; i < viewNode.getChildCount(); i++) {
            AssistStructure.ViewNode childNode = viewNode.getChildAt(i);
            processNode(childNode);
        }
    }

    public void printAutofillPasswords() {
        System.out.println("Passwords: ");
        for (AutofillPassword pw : getAutofillPasswords()) {
            System.out.println(pw.toString());
        }
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

enum CurrentAction {
    SAVING,
    FILLING,
}

enum AutofillType {
    WIFI,
    OTHER,
}