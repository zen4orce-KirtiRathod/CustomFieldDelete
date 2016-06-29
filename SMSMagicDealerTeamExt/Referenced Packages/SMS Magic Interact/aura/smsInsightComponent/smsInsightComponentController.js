({
	init : function(component, event, helper) {
        helper.initHelper(component, event, helper);	
	},
    
    sendSMS : function(component, event, helper) {
        helper.doSendSMS(component, event, helper);
    },
    
    selectTemplate : function(component, event, helper) {
        helper.selectTemplate(component, event, helper);
    }
})