public  with sharing class StandardDataCleanUpService {
    //HierarchicalUtilityService ex = new HierarchicalUtilityService();
    public List<WrapperDataCleanUpService> standardWrapObjList{get;set;}
    public boolean standardFlag{get;set;}
    public String objName{get;set;}
    public SET<String> depenStdList{get;set;}
    public List<String> selectedList {get;set;}
    public integer count{get;set;}
    public StandardDataCleanUpService()
    {
        try
        {
            System.debug('Hello');
            standardFlag = false;
            List<String> allObjList = HierarchicalUtilityService.allObjects();
            List<String> stdObjList = HierarchicalUtilityService.allStandardObj(allObjList);
            if(stdObjList != null)
            {
                standardWrapObjList = HierarchicalUtilityService.wrapObjList(StdObjList);
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
    public pageReference checkAllStd()
    { 
         try
         {
             if(standardWrapObjList.size() != null)
             {
             	standardWrapObjList = HierarchicalUtilityService.checkFlag(standardWrapObjList,standardFlag);
             }
         }
         catch(Exception e)
         {
             Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,''+e.getMessage()));
         }
         return null;
    }
    public void dependentStdtObjList()
    {
        try
        {
            List<AsyncApexJob> apexJob = DataCleanUpSelector.batchRunningDetails('BatchApexForDeleteRecords');
            if(apexJob.size() == 0 )
            {
                selectedList = HierarchicalUtilityService.selectedObjectData(standardWrapObjList);  
                if(selectedList.size() > 0 && selectedList != null)
                {
                    depenStdList = HierarchicalUtilityService.dependentObjects(selectedList);
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
    public pageReference cancelStandardDelete()
    {
        try
        {
            
            if(standardWrapObjList.size() != null )
            {
            	HierarchicalUtilityService.cancleDel(standardWrapObjList);
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
    public void deleteStdRecords()
    {
       try
       {
           System.debug('standardWrapObjList'+standardWrapObjList);
           selectedList = HierarchicalUtilityService.selectedObjectData(standardWrapObjList);
           System.debug('selectedList'+selectedList);
           if(selectedList.size() > 0 && selectedList != null)
           {
               HierarchicalUtilityService.deleteAllRecords(selectedList);
               Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,''+'We will send you an email after completion of precoss'));
           }
          else
          {
               Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,''+'Please select any object to delete'));
          }
       }
       catch(Exception e)
        {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,''+e.getMessage()));
        }
	}
   
}