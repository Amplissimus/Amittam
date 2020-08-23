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

    ParsedStructure parsedStructure = new ParsedStructure();

    CurrentAction currentAction;

    AutofillPassword passwordToSave = new AutofillPassword("", "", "");

    @Override
    public void onFillRequest(FillRequest request, CancellationSignal cancellationSignal, FillCallback callback) {
        currentAction = CurrentAction.FILLING;
        printAutofillPasswords();
        List<FillContext> contexts = request.getFillContexts();
        AssistStructure structure = contexts.get(contexts.size() - 1).getStructure();
        processStructure(structure);
        AssistStructure.WindowNode windowNode = structure.getWindowNodeAt(0);
        AssistStructure.ViewNode viewNode = windowNode.getRootViewNode();
        System.out.println(viewNode.getAutofillId());

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

    public void processStructure(AssistStructure structure) {
        int nodes = structure.getWindowNodeCount();
        for (int i = 0; i < nodes; i++) {
            AssistStructure.WindowNode windowNode = structure.getWindowNodeAt(i);
            AssistStructure.ViewNode viewNode = windowNode.getRootViewNode();
            processNode(viewNode);
        }
    }

    public void processNode(AssistStructure.ViewNode viewNode) {
        if (viewNode.getIdEntry() != null && (viewNode.getIdEntry().contains("username") || viewNode.getIdEntry().contains("email")))
            parsedStructure.setUsernameId(viewNode.getAutofillId());
        else if (viewNode.getIdEntry() != null && viewNode.getIdEntry().contains("password"))
            parsedStructure.setPasswordId(viewNode.getAutofillId());

        if (currentAction == CurrentAction.SAVING) {
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

    @Override
    public void onSaveRequest(SaveRequest request, SaveCallback callback) {
        System.out.println("Saving...");
        currentAction = CurrentAction.SAVING;
        List<FillContext> contexts = request.getFillContexts();
        AssistStructure structure = contexts.get(contexts.size() - 1).getStructure();

        processStructure(structure);

        RemoteViews notUsed = new RemoteViews(getPackageName(), android.R.layout.simple_list_item_1);

        callback.onSuccess();
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
    private AutofillId usernameId;
    private AutofillId passwordId;

    public AutofillId getUsernameId() {
        return usernameId;
    }

    public void setUsernameId(AutofillId usernameId) {
        this.usernameId = usernameId;
    }

    public AutofillId getPasswordId() {
        return passwordId;
    }

    public void setPasswordId(AutofillId passwordId) {
        this.passwordId = passwordId;
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