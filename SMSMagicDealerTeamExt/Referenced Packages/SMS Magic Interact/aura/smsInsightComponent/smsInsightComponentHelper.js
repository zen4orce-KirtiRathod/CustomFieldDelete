({
    initHelper : function(component, event, helper) {
        
        function getURLParams(){
            var urlParams;
            (window.onpopstate = function () {
                var match,
                    pl     = /\+/g,  // Regex for replacing addition symbol with a space
                    search = /([^&=]+)=?([^&]*)/g,
                    decode = function (s) { return decodeURIComponent(s.replace(pl, " ")); },
                    query  = window.location.search.substring(1);
                
                urlParams = {};
                while (match = search.exec(query))
                    urlParams[decode(match[1])] = decode(match[2]);
            })();
            return urlParams;
        }        
        function getObjectId() {
            var objId = component.get("v.objectId");
            return objId == null || objId == undefined ? getURLParams()['id'] : objId;
        }
        component.set("v.auraMessage",null);
        var action = component.get("c.loadData");
        var objectId = getObjectId();
        
        if (objectId) {
            component.set("v.objectId",objectId);
            action.setParams({ objectId : objectId});
            
            action.setCallback(this, function(data) {
                
                var returnVal = data.getReturnValue();
                
                if(typeof returnVal == 'object')
                {
                    var inboundCountVar = component.find("inboundCount");
                    var outboundCountVar = component.find("outboundCount");
                    
                    inboundCountVar.set("v.value", returnVal['inboundCount'] > 99 ? '99+' : returnVal['inboundCount']);
                    outboundCountVar.set("v.value", returnVal['outboundCount'] > 99 ? '99+' : returnVal['outboundCount']);                
                    var allowSendSMS=returnVal['allowSendSMS'];
                    var allowTemplateChange=returnVal['allowTemplateSelection'];
                    if(allowSendSMS==false){
                        component.set("v.permissionErrorMessage", "{!$Label.smagicinteract.CANNOT_SND_SMS}");
                    }
                    if(allowTemplateChange==false){
                        component.set("v.allowToChangeTemplateSelection", "true");
                    }
                    component.set("v.messages", returnVal['convList']);
                    var phoneMetaList = returnVal['phoneList'];
                    component.set("v.phoneList", phoneMetaList);
                    var senderMetaList = returnVal['senderList'];
                    component.set("v.senderList", senderMetaList);
                    component.set("v.templateNameList", returnVal['templateNameList']);
                    if (senderMetaList && senderMetaList.length > 0) {
                        var selectedValue = senderMetaList[0].name;
                        for(var i=0; i < senderMetaList.length; i++){
                            if(senderMetaList[i].preselectedOption==true)
                                selectedValue = senderMetaList[i].name;
                        }
                        component.find("senderId").set("v.value", selectedValue);   
                    }
                    if (phoneMetaList && phoneMetaList.length > 0) {
                        var selectedPhone=phoneMetaList[0].name;
                        for(var i=0; i < phoneMetaList.length; i++){
                            if(phoneMetaList[i].preselectedOption==true)
                                selectedPhone = phoneMetaList[i].name;
                        }
                        component.find("phoneFieldId").set("v.value", selectedPhone);
                    }
                    
                    
                    var templateTextMap = new Object();
                    var templateTextList = returnVal['templateTextList'];
                    for(var i=0; i < templateTextList.length; i++){
                        templateTextMap[templateTextList[i].name] = templateTextList[i].label;
                    }
                    component.set("v.templateTextList", templateTextMap);
                    component.set("v.inboundCount", returnVal['inboundCount']);
                    component.set("v.outboundCount", returnVal['outboundCount']);        
                } 
                else if(returnVal == 'NO_PHONE_FIELDS_ON_OBJECT'){
                    component.set("v.auraMessage", "{!$Label.smagicinteract.NO_PHONE_FIELDS_ON_OBJECT}");
                }
                    else {
                        component.set("v.auraMessage", "{!$Label.smagicinteract.LOAD_CONV_VIEW_PERMISSION_FAILURE}");
                    } 
            });
            $A.enqueueAction(action);
        }
        else {
            component.set("v.auraMessage", "SMS Insight works only for salesforce objects.");
        }
        
        
    },
    
    doSendSMS : function(component, event, helper) {  
        
        component.set("v.auraMessage",null);
        var sendSMS = component.get("c.sendSMS1");
        var selectedSenderId = component.find("senderId").get("v.value");    
        var phoneField = component.find("phoneFieldId").get("v.value"); 
        var templateId = component.find("templateId").get("v.value");
        var templateText = component.find("smsTextId").get("v.value");
        var objectId = component.get("v.objectId");  
        sendSMS.setParams({ objectId : objectId,
                           senderId : selectedSenderId,
                           phoneField : phoneField, 
                           templateId : templateId, 
                           templateText : templateText});
        sendSMS.setCallback(this, function(data) {
            var returnVal = data.getReturnValue();
            if(returnVal == "Failure") {
                component.set("v.auraMessage", "{!$Label.c.SEND_SMS_FAILURE}");
            }
            else if(returnVal == "insufficient_access") {
                component.set("v.auraMessage", "{!$Label.c.INSUFFICIENT_ACCESS}");
            }
                else if(returnVal == "Invalid_Object") {
                    component.set("v.auraMessage", "{!$Label.c.PACKAGE_RESTRICTION_SEND_SMS}");
                }
                    else if(returnVal.startsWith('Id of following unrelated object(s) are missing')) {
                        component.set("v.auraMessage", returnVal);
                    }
                        else {
                            
                            window.location.reload();
                            //helper.initHelper(component, event, helper);                    
                        }
        });
        $A.enqueueAction(sendSMS);
    },
    
    selectTemplate : function(component, event, helper){
        var resolveTemplate = component.get("c.resolveTemplateText");
        var selectedTemplateId = component.find("templateId").get("v.value");
        var templateText = component.get("v.templateTextList");
        var smstextVar = component.find("smsTextId");
        var recordIds=component.get("v.objectId");;
        var returnVal='';
        var originalTemplate=templateText[selectedTemplateId];
        if(selectedTemplateId != null){
            resolveTemplate.setParams({ originalTemplate : originalTemplate,
                                       recordIds : recordIds});
            resolveTemplate.setCallback(this, function(data) {
                returnVal = data.getReturnValue();
                if(returnVal[0].ErrorMessage != null){
                    component.set("v.templateTextPermission",returnVal[0].ErrorMessage);
                    smstextVar.set("v.value", '');	
                }
                else{
                    component.set("v.templateTextPermission",null);
                    smstextVar.set("v.value",returnVal[0].label);	
                }
            });
            $A.enqueueAction(resolveTemplate);
        }
        else{
            component.set("v.templateTextPermission",null);
            smstextVar.set("v.value",'');
        }
    }
})