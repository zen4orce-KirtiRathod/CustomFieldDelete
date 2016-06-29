({
    init : function(component, event, helper) {
        var action = component.get("c.loadData");
        action.setCallback(this, function(data) {
            var returnVal = data.getReturnValue();
            
            if(returnVal) {
                component.set("v.objectList", returnVal);
            } else {
                component.set("v.auraMessage", "{!$Label.smagicinteract.LOAD_CONV_VIEW_PERMISSION_FAILURE}");
            }
        });
        $A.enqueueAction(action);
    },
    
    
    createChat : function(component, event, helper) {
        
        var postHTTPCallout = component.get("c.postHTTPCallout");
        var pageLabelName=component.find("pageLabelName").get("v.value");
        var pageAPIName=component.find("pageAPIName").get("v.value");
        var ObjectId=component.find("objectId").get("v.value");
        
        function isEmpty(val){
            return (val === undefined || val == null || val.trim().length <= 0) ? true : false;
        }
        
        if(isEmpty(ObjectId) || isEmpty(pageAPIName) || isEmpty(pageLabelName)) {
            component.set("v.auraMessage", "{!$Label.smagicinteract.CONV_VIEW_ERR_MSG}");
            return;
        }
        
        postHTTPCallout.setParams({ pageAPIName : pageAPIName,
                                   pageLabelName : pageLabelName,	
                                   objectName : ObjectId
                                  });	    
        
        postHTTPCallout.setCallback(this, function(data) {
            
            var returnVal = data.getReturnValue();
            if(returnVal.name == "201") {
                component.set("v.successMessage", "{!$Label.smagicinteract.Conversation_View_Success_Message}");	
            }	
            else {
                component.set("v.auraMessage", returnVal.ErrorMessage);
            }
        });
        $A.enqueueAction(postHTTPCallout);
        
    }
})