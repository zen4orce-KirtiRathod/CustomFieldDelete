public class SalesConfigControllerSelectorClass {
    
    public static list<smagicinteract__SMS_Template__c> smsTemplateList()
    {
        list<smagicinteract__SMS_Template__c> smsTemplate = new list<smagicinteract__SMS_Template__c>([SELECT id,smagicinteract__Name__c FROM smagicinteract__SMS_Template__c Where  smagicinteract__ObjectName__c =:'dealer__Sales_Appointment__c' ]);
        return smsTemplate;
    }
	public static list<smagicinteract__SMS_Template__c> inventoryList()
    {
        list<smagicinteract__SMS_Template__c> smsTemplate = new list<smagicinteract__SMS_Template__c>([SELECT id,smagicinteract__Name__c FROM smagicinteract__SMS_Template__c Where  smagicinteract__ObjectName__c =:'dealer__Vehicle_Inventory__c' ]);
        return smsTemplate; 
    }
    public static Sales_Configuration__c salesConfigObj()
    {
        Sales_Configuration__c salesObj = new Sales_Configuration__c();
        					   salesObj = [SELECT Sales_Appointment_Cancel_Keyword__c,Sales_Appointment_Followup_Keyword__c,
                                                  Sales_Appointment_Confirmation__c,Sales_Appointment_Reminder_c__c,
                                           		  Sales_Appointment_Reminder_1Hour__c,Sales_Appointment_Reminder_24Hour__c,
                                                  Sales_Test_Drive_Notification__c,Sales_Test_Drive_Notification_Status__c 
                                                  FROM Sales_Configuration__c];
        return salesObj;
        
    }
    public static list<smagicworkflow__WorkflowXMLMap__c> frstTemp()
    {
    	list<smagicworkflow__WorkflowXMLMap__c> listOfFlows = new list<smagicworkflow__WorkflowXMLMap__c>();
        smagicworkflow__WorkflowXMLMap__c workFlowConfig1 = [Select smagicworkflow__XML_String__c 
														      FROM  smagicworkflow__WorkflowXMLMap__c 
       													      WHERE smagicworkflow__XML_Name__c =:'SMS-Notification-Sales_Appointment-5051'];
       
  		smagicworkflow__WorkflowXMLMap__c workFlowConfig2 = [Select smagicworkflow__XML_String__c 
														      FROM  smagicworkflow__WorkflowXMLMap__c 
       													      WHERE smagicworkflow__XML_Name__c =:'SMS-Notification-Sales_Appointment_Reminder_1Hour-5052'];
        
       
	    smagicworkflow__WorkflowXMLMap__c workFlowConfig3 = [Select smagicworkflow__XML_String__c 
														      FROM  smagicworkflow__WorkflowXMLMap__c 
       													      WHERE smagicworkflow__XML_Name__c =:'SMS-Notification-Sales_Appointment_Reminder_24Hour-5053'];

    	smagicworkflow__WorkflowXMLMap__c workFlowConfig4 = [Select smagicworkflow__XML_String__c 
														      FROM  smagicworkflow__WorkflowXMLMap__c 
       													      WHERE smagicworkflow__XML_Name__c =:'SMS-Notification-Vehicle_Inventory-5054'];
         listOfFlows.add(workFlowConfig1);
         listOfFlows.add(workFlowConfig2);
         listOfFlows.add(workFlowConfig3);
         listOfFlows.add(workFlowConfig4);
       return listOfFlows;
    }
}