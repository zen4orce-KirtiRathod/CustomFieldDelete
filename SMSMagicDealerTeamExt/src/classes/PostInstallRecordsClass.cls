global  class PostInstallRecordsClass implements InstallHandler{
    public list<smagicinteract__SMS_Template_Type__c> listTemplatesTypes = new list<smagicinteract__SMS_Template_Type__c>();
    public list<smagicinteract__SMS_Template__c> listTemplate = new list<smagicinteract__SMS_Template__c>();
    public list<smagicreminder__EventReminderConfig__c> listOfWorkFlow = new list<smagicreminder__EventReminderConfig__c>();
    public list<smagicinteract__incoming_lookup_config__c>listOfLookUps = new list<smagicinteract__incoming_lookup_config__c>();
    public list<smagicworkflow__WorkflowXMLMap__c>listOfFlows = new list<smagicworkflow__WorkflowXMLMap__c>();
    SelectorClassForPostInstallRecords selector = new SelectorClassForPostInstallRecords();
    DomainClassForPostInstallRecords domain = new DomainClassForPostInstallRecords();
    //Post installation script Method for inserting records in objects
    global void onInstall(InstallContext context)
    {
       try
       {
        if(context.previousVersion() == null )
       {
            StaticResource resource = new StaticResource();
        	String arrayName;
            resource = selector.dataForConfig();//it calls Json file from Static Resource
            JSONParser parser = jSON.createParser(resource.Body.toString()); // create a parsor of Json file
            while(parser.nextToken() != null)
            {
                if(parser.getCurrentToken()  ==  JSONToken.START_ARRAY) // Start the Array ---Records
                {
                    arrayName = parser.getCurrentName(); /// Store the value of an Object in arrayname
                }
                if(parser.getCurrentToken() == JSONToken.START_OBJECT) // Start the Object
                {
                    if(arrayName == 'smagicinteract__SMS_Template_Type__c')
                    {
                        smagicinteract__SMS_Template_Type__c smsTemplate =(smagicinteract__SMS_Template_Type__c)parser.readValueAs(smagicinteract__SMS_Template_Type__c.class);
                        listTemplatesTypes.add(smsTemplate);
                    }
                    else if(arrayName == 'smagicinteract__SMS_Template__c')
                    {
                        smagicinteract__SMS_Template__c smsTemplate1 =(smagicinteract__SMS_Template__c)parser.readValueAs(smagicinteract__SMS_Template__c.class);
                        listTemplate.add(smsTemplate1);
                    }
                    else if(arrayName == 'smagicreminder__EventReminderConfig__c')
                    {
                        smagicreminder__EventReminderConfig__c smsTemplate2 =(smagicreminder__EventReminderConfig__c)parser.readValueAs(smagicreminder__EventReminderConfig__c.class);
                        listOfWorkFlow.add(smsTemplate2);
                    }
                    else if(arrayName == 'smagicinteract__incoming_lookup_config__c')
                    {
                        smagicinteract__incoming_lookup_config__c smsTemplate3 =(smagicinteract__incoming_lookup_config__c)parser.readValueAs(smagicinteract__incoming_lookup_config__c.class);
                        listOfLookUps.add(smsTemplate3);
                    }
                    else if(arrayName == 'smagicworkflow__WorkflowXMLMap__c')
                    {
                        smagicworkflow__WorkflowXMLMap__c smsTemplate4=(smagicworkflow__WorkflowXMLMap__c)parser.readValueAs(smagicworkflow__WorkflowXMLMap__c.class);
                        listOfFlows.add(smsTemplate4);
                    }
                }
            }
            domain.insertRecords(listTemplatesTypes); // insert a record
            domain.insertRecords(listTemplate);
            domain.insertRecords(listOfWorkFlow);
            domain.insertRecords(listOfLookUps);
            domain.insertRecords(listOfFlows);
		}
     }
     catch(Exception ex)
     {
         System.debug('ERROR:' +ex.getMessage());
     }
   }
}