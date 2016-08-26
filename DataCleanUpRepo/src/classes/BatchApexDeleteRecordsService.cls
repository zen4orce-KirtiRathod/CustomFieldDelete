global  with sharing class BatchApexDeleteRecordsService implements Database.Batchable<sObject>,Database.Stateful {
    global list<String> lstOfObj ;
    global String query ;
    Id batchInstanceId ;
    global Integer numberOfRecords = 0 ;
    //DataCleanUpDomain domain = new DataCleanUpDomain();
    global BatchApexDeleteRecordsService(String str,list<String> strList)
    {
        try
        {
            query = 'SELECT Id FROM '+ str;
            lstOfObj = strList ; 
        }
        catch(Exception ex)
        {
            System.debug('ERROR:'+ex.getMessage());
        }
    } 
    
    //Start method of batch class
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        try
        {
            return DataCleanUpSelector.queryLocatorById(query); //pass dynamic query to get the list of records
        }
        catch(Exception ex)
        {
            System.debug('ERROR:'+ex.getMessage());
            return null;
        }
    }
    
    //Execute method of batch class
    global void execute(Database.BatchableContext BC,list<SObject> objRecordList)
    {
        try
        {
          if(objRecordList.size() > 0)
            {
                numberOfRecords = numberOfRecords+objRecordList.size();
                DataCleanUpDomain.executeMethod(objRecordList);
            }
        }
        catch(Exception ex)
        {
            System.debug('ERROR:'+ex.getMessage());
        }
    }
    
    //finish method of the batch class
    global void finish(Database.BatchableContext bc) 
    {
        try
        {
            lstOfObj.remove(0);
            if(lstOfObj.size() > 0)//Call batch class again for delete another object's record
            {
                batchInstanceId = Database.executeBatch(new BatchApexDeleteRecordsService(lstOfObj.get(0),lstOfObj),2000);
                System.debug(batchInstanceId);
            }
            else
            {
                AsyncApexJob a = DataCleanUpSelector.asyncApexJobDetails(bc.getJobId());
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {a.CreatedBy.Email};
                mail.setToAddresses(toAddresses);
                mail.setSubject('Record Clean Up Status: ' + a.Status);
                mail.setPlainTextBody
                    ('The batch Apex job processed ' + a.TotalJobItems +
                     ' batches with '+ a.NumberOfErrors + ' failures.'+'\nNumber of Records deleted'+' '+numberOfRecords);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
  		}
        catch(Exception ex)
        {
            System.debug('ERROR:'+ex.getMessage());
        }
    }
}