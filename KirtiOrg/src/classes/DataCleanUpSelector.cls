public with sharing class DataCleanUpSelector {
	//Query for find NamespacePrefix of your Organization
    public static string nameSpaceprefixOfOrg()
    {
        String nameSpace;
        Organization org = [SELECT NamespacePrefix FROM Organization];
        nameSpace = String.valueOf(org.NamespacePrefix);
        return nameSpace;
    }
    
    //Query for find numberOfReocrds of Object
    public static Integer numberOfReocrds(String obj)
    {
        integer  count;	
        if(obj != null)
        {
	        count = database.countQuery('SELECT count() FROM '+obj);
        }
        System.debug('count'+count);
        return count;
    }
    
    //Query for returning records to batch class
    public static Database.QueryLocator queryLocatorById(String query)
    {
        return Database.getQueryLocator(query);
    }
    
    //Query to AsyncApexJob object to find Status of job
    public static AsyncApexJob asyncApexJobDetails(Id idOfJob)
    {
        AsyncApexJob a;
        if(idOfJob != null)
        {
        	 a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
            		      TotalJobItems, CreatedBy.Email
             			  FROM AsyncApexJob WHERE Id =:idOfJob];
        }
 		return a;
    }
    public static List<AsyncApexJob> batchRunningDetails(String batchClassName)
    {
        List<AsyncApexJob> a = new List<AsyncApexJob>();
        if(batchClassName != null)
        {
        	 a = [SELECT Id,ApexClass.name ,Status 
                  	FROM AsyncApexJob
                  	WHERE ApexClass.name =: batchClassName AND
   				  (Status =:'Processing' OR Status = : 'Queued' OR Status  =: 'Preparing') LIMIT 1];
        }
        return a;
    }
    
}