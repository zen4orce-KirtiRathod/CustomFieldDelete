public class CustomDataCleanUpService {
    
    HierarchicalUtilityService ex = new HierarchicalUtilityService();
    public List<WrapperDataCleanUp> customWrapObjList{get;set;}
    public boolean customFlag{get;set;}
    public String objName{get;set;}
    public SET<String> depencustomList{get;set;}
    public List<String> selectedList {get;set;}
    public integer count{get;set;}
    public CustomDataCleanUpService()
    {
        try
        {
            System.debug('Hello');
            customFlag = false;
            List<String> allObjList = ex.allObjects();
            List<String> customObjList = ex.allCustomObj(allObjList);
            if(customObjList != null)
            {
                customWrapObjList = ex.wrapObjList(customObjList);
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
             	customWrapObjList = ex.checkFlag(customWrapObjList,customFlag);
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
            List<AsyncApexJob> apexJob = DataCleanUpSelector.batchRunningDetails('BatchApexForDeleteRecords');
            if(apexJob.size() == 0 )
            {
                selectedList = ex.selectedObjectData(customWrapObjList);  
                if(selectedList.size() > 0 && selectedList != null)
                {
                    depencustomList = ex.dependentObjects(selectedList);
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
    public void deleteRecords()
    {
       try
       {
           selectedList = ex.selectedObjectData(customWrapObjList);
           if(selectedList.size() > 0 && selectedList != null)
           {
               ex.deleteAllRecords(selectedList);
           }
           Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,''+'We will send you an email after completion of precoss'));
       }
       catch(Exception e)
        {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,''+e.getMessage()));
        }
	}
   
}