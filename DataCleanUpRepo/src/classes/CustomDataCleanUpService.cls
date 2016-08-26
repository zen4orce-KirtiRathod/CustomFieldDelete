public  with sharing class CustomDataCleanUpService {
    
    //HierarchicalUtilityService hel = new HierarchicalUtilityService();
    public List<WrapperDataCleanUpService> customWrapObjList{get;set;}
    public boolean customFlag{get;set;}
    public String objName{get;set;}
    public SET<String> depencustomList{get;set;}
    public List<String> selectedCustomList {get;set;}
    public integer count{get;set;}
    public CustomDataCleanUpService()
    {
        try
        {
            System.debug('Hello in cons');
            customFlag = false;
            List<String> allObjList = HierarchicalUtilityService.allObjects();
            List<String> customObjList = HierarchicalUtilityService.allCustomObj(allObjList);
            if(customObjList != null)
            {
                customWrapObjList = HierarchicalUtilityService.wrapObjList(customObjList);
            }
        }
        catch(Exception e)
        {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,''+e.getMessage()));
        }
    }
    public pageReference QueryCount()
    {
        try
        {
            if(objName != null)
            {
            	count = DataCleanUpSelector.numberOfReocrds(objName);
            }
        }
        catch(Exception e)
        {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,''+e.getMessage()));
        }
        return null;
    }
    public pageReference checkAllCustomObj()
    { 
         try
         {
             if(customWrapObjList.size() != null)
             {
             	customWrapObjList = HierarchicalUtilityService.checkFlag(customWrapObjList,customFlag);
             }
         }
         catch(Exception e)
         {
             Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,''+e.getMessage()));
         }
         return null;
    }
    public void dependentCustomObjList()
    {
        try
        {
            System.debug('hello in depen');
            List<AsyncApexJob> apexJob = DataCleanUpSelector.batchRunningDetails('BatchApexForDeleteRecords');
            if(apexJob.size() == 0 )
            {
                System.debug('hello in depen');
                selectedCustomList = HierarchicalUtilityService.selectedObjectData(customWrapObjList);  
                if(selectedCustomList.size() > 0 && selectedCustomList != null)
                {
                    depencustomList = HierarchicalUtilityService.dependentObjects(selectedCustomList);
                } 
                else
                {
                     Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,''+'Please Select any object to delete..'));
                }
            }
            else
            {
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,''+'Please wait..Records are deleting..'));
            }   
        }
        catch(Exception e)
        {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,''+e.getMessage()));
        }  
    } 
    public pageReference cancelCustomDelete()
    {
        try
        {
            if(customWrapObjList.size() != null )
            {
            	HierarchicalUtilityService.cancleDel(customWrapObjList);
            }
            else
            {
               Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,''+'Their is no data to cancel')); 
            }
        }
        catch(Exception e)
        {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,''+e.getMessage()));
        }
        return null;
    }
    public void deleteCusRecords()
    {
       try
       {
           System.debug('Hello in cons deleteRecords');
           selectedCustomList = HierarchicalUtilityService.selectedObjectData(customWrapObjList);
           if(selectedCustomList.size() > 0 && selectedCustomList != null)
           {
               HierarchicalUtilityService.deleteAllRecords(selectedCustomList);
           }
           Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,''+'We will send you an email after completion of precoss'));
       }
       catch(Exception e)
        {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,''+e.getMessage()));
        }
	}
   
}