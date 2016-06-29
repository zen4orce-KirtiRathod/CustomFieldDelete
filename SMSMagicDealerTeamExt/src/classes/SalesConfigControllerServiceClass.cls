public class SalesConfigControllerServiceClass {
    public static String template0{get;set;}
    public static String template1{get;set;}
    public static String template2{get;set;}
    public static String template3{get;set;}
    @AuraEnabled
    public static list<smagicinteract__SMS_Template__c> allTempRelSmsApp()
    {
        list<smagicinteract__SMS_Template__c> smsTemplateList = SalesConfigControllerSelectorClass.smsTemplateList();
        return smsTemplateList;
         
    }
    @AuraEnabled
    public static list<smagicinteract__SMS_Template__c> allTempRelVehInv()
    {
        list<smagicinteract__SMS_Template__c> smsTemplateList = SalesConfigControllerSelectorClass.inventoryList();
        return smsTemplateList;
         
    }
    @AuraEnabled
    public static void updateCustomSettings(String cancel,boolean confirm ,string followup,boolean reminder,boolean oneHrReminder,boolean twentyFourHrReminder, boolean notification,String status)
    {
        Sales_Configuration__c salesObj = SalesConfigControllerSelectorClass.salesConfigObj();
        salesObj.Sales_Appointment_Cancel_Keyword__c     = cancel;
        salesObj.Sales_Appointment_Confirmation__c       = (confirm==true)?true:false;
        salesObj.Sales_Appointment_Followup_Keyword__c   = followup;
        salesObj.Sales_Appointment_Reminder_c__c         = (reminder==true)?true:false; 
        salesObj.Sales_Appointment_Reminder_1Hour__c     = (oneHrReminder==true)?true:false; 
        salesObj.Sales_Appointment_Reminder_24Hour__c    = (twentyFourHrReminder==true)?true:false; 
        salesObj.Sales_Test_Drive_Notification__c        = (notification==true)?true:false; 
        salesObj.Sales_Test_Drive_Notification_Status__c = status;
        SalesConfigControllerDomainClass.updateObjs(salesObj);
    }
    @AuraEnabled
    public static void updateWorkFlowConfig()
    {
      
      list<smagicworkflow__WorkflowXMLMap__c> workFlowConfig = SalesConfigControllerSelectorClass.frstTemp();
        
      String frstTemp = xxXmlString(workFlowConfig[0],template0) ;
      workFlowConfig[0].smagicworkflow__XML_String__c = frstTemp;
      SalesConfigControllerDomainClass.updateFlows(workFlowConfig[0])  ;
        
     
      String secTemp = xxXmlString(workFlowConfig[1],template1) ;
      workFlowConfig[1].smagicworkflow__XML_String__c = secTemp;
      SalesConfigControllerDomainClass.updateFlows(workFlowConfig[1])  ;
        
   
      String trdTemp = xxXmlString(workFlowConfig[2],template2) ;
      workFlowConfig[2].smagicworkflow__XML_String__c = frstTemp;
      SalesConfigControllerDomainClass.updateFlows(workFlowConfig[2])  ;
        
     
      String frtTemp = xxXmlString(workFlowConfig[3],template3) ;
      workFlowConfig[3].smagicworkflow__XML_String__c = frstTemp;
      SalesConfigControllerDomainClass.updateFlows(workFlowConfig[3])  ;
          
        
    }
    public static String xxXmlString(smagicworkflow__WorkflowXMLMap__c workFlowConfig,String tempId)
    {
      String xmlString    =  workFlowConfig.smagicworkflow__XML_String__c;
      XMLPjClass localObj = DataFromXMLString.processXMLObj(xmlString);       
	  String ObjName      = localObj.objectName;
      String name         = localObj.nameField;
      String sendId       = localObj.senderId;
      String tempText     = localObj.templateText;
      String phField      = localObj.phonefield;
      String relUser      = localObj.relatedUserField;
      String usergp       = localObj.userGroup;
      String queEnable    = localObj.queueEnabled;
      boolean b           = (queEnable == 'true')?true:false;  
      XMLStringPjClass xmlStringPjClassInstance = new XMLStringPjClass(tempId,ObjName, tempText,phField, relUser,sendId,name, usergp, b);
	  String generatedXML = GenerateXMLString.getXMLString(xmlStringPjClassInstance);
	  System.debug('genearted XML'+ generatedXML);
      return generatedXML;
  
    }
}