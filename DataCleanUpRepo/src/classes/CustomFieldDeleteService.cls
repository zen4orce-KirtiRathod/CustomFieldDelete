public with sharing class CustomFieldDeleteService {
	
	public String objCount{get;set;}
    public List<WrapperDataCleanUpService> wrapFieldList{get;set;}
    Map <String, Schema.SObjectField> fieldMap{get;set;}
    public List<String> objList{get;set;}
    public Map<String,String> selectedFieldListToDelete{get;set;}
    private Static Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
    Public List<String> objFieldList {get;set;}
    
    //Constructor of class --Used to get all objects 
    public CustomFieldDeleteService() 
    {
        try
        {
            objFieldList = new List<String>();
            objList = CustomFieldDeleteService.listOfAllObj();
            selectedFieldListToDelete = new Map<String,String>();
        }
        catch(Exception e )
        {
            System.debug('Error:'+e.getMessage());
        }
    }
    
    //Method for get all objects 
    public static  List<String> listOfAllObj()
   	{
        List<String> lstOfObj = new List<String>();
        try
       	{
           List<String> lstOfallObj = HierarchicalUtilityService.allObjects();
           List<String> lstOfStdObj = HierarchicalUtilityService.allStandardObj(lstOfallObj);
           List<String> lstOfCusObj = HierarchicalUtilityService.allCustomObj(lstOfallObj);
           lstOfObj.addAll(lstOfStdObj);
           lstOfObj.addAll(lstOfCusObj);
       	}
       	catch(Exception e )
        {
            System.debug('Error:'+e.getMessage());
        }
      return lstOfObj;
   }
  
   public pageReference showAllFields()
   {
       try
       {
           List<String> lstOfFields = new List<String>();
           if(objCount != null)
           { 
               lstOfFields   = allFieldsOfObject(objCount);
               wrapFieldList = HierarchicalUtilityService.wrapObjList(lstOfFields);
           }
       }
       catch(Exception e )
       {
           System.debug('Error:'+e.getMessage());
       }
      return null;
   }
   //Get the list of all fields realted to object
   public list<String> allFieldsOfObject(String ObjName)
   {
       List<String> fieldList = new List<String>(); 
       try
        {
            Map <String,Schema.SObjectField> fieldMap = schemaMap.get(ObjName).getDescribe().fields.getMap();
           
            for(Schema.SObjectField sfield : fieldMap.Values())
            {
                schema.describefieldresult dfield = sfield.getDescribe();
                if(dfield.isCustom())
                {
                    fieldList.add(dfield.getName());
                }
            }
        }
        catch(Exception e )
        {
            System.debug('Error:'+e.getMessage());
        }
       return fieldList;    
	}
    
    //Delete all Fields
   public pageReference DeleteAll()
   {
       DeleteFields(objFieldList);
       return null;
   }
    //Call the batch class
   public void DeleteFields(List<String> lstOfFields)
   {
       CustomFieldDeleteBatchService d = new CustomFieldDeleteBatchService(lstOfFields) ; //Created an instance to call Batch Apex class 
       database.executeBatch(d,10);
   }
}