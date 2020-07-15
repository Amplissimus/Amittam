package de.llehn.amittam;

import android.R;
import android.annotation.TargetApi;
import android.app.assist.AssistStructure;
import android.os.Build;
import android.os.CancellationSignal;
import android.service.autofill.AutofillService;
import android.service.autofill.FillCallback;
import android.service.autofill.FillContext;
import android.service.autofill.FillRequest;
import android.service.autofill.SaveCallback;
import android.service.autofill.SaveRequest;
import android.widget.RemoteViews;

import java.util.ArrayList;
import java.util.List;

@TargetApi(Build.VERSION_CODES.O)
class AmittamAutofillService extends AutofillService {

    @Override
    public void onFillRequest(FillRequest fillRequest, CancellationSignal cancellationSignal, FillCallback fillCallback) {
        List<FillContext> contexts = fillRequest.getFillContexts();
        List<AssistStructure.ViewNode> emailFields = new ArrayList<>();
        AssistStructure assistStructure = contexts.get(contexts.size() - 1).getStructure();

        // Populate the list
        identifyEmailFields(assistStructure
                .getWindowNodeAt(0)
                .getRootViewNode(), emailFields);
        if(emailFields.size() == 0)
            return;

        RemoteViews rvEMail = new RemoteViews(getPackageName(),
                R.layout.simple_list_item_1);

        rvEMail.setTextViewText(R.id.input, "");
    }

    @Override
    public void onSaveRequest(SaveRequest saveRequest, SaveCallback saveCallback) {

    }

    void identifyEmailFields(AssistStructure.ViewNode node,
                             List<AssistStructure.ViewNode> emailFields) {
        if(node.getClassName().contains("EditText")) {
            String viewId = node.getIdEntry();
            if(viewId!=null && (viewId.contains("email")
                    || viewId.contains("username"))) {
                emailFields.add(node);
                return;
            }
        }
        for(int i=0; i<node.getChildCount();i++) {
            identifyEmailFields(node.getChildAt(i), emailFields);
        }
    }
}
