public with sharing class CustomFieldDeleteService {
	
	public String objCount{get;set;}
    public List<WrapperDataCleanUpService> wrapFieldList{get;set;}
    Map <String, Schema.SObjectField> fieldMap{get;set;}
    public  List<String> objList{get;set;}
    public String selectedField{get;set;}
    public WrapperDataCleanUpService selectedWrapField{get;set;}
    public Map<String,String> selectedFieldListToDelete{get;set;}
    private Static Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
    Public List<String> objFieldList {get;set;}
    public boolean flag {get;set;}
    public CustomFieldDeleteService() 
    {
        try
        {
            flag = false;
            objFieldList = new List<String>();
            objList = CustomFieldDeleteService.listOfAllObj();
            selectedFieldListToDelete = new Map<String,String>();
        }
        catch(Exception e )
        {
            System.debug('Error:'+e.getMessage());
        }
    }
    public static List<String> listOfAllObj()
   	{
       List<String> allStdCusList = new List<String>();
       try
       {
           List<String> lstOfallObj = HierarchicalUtilityService.allObjects();
           List<String> lstOfStdObj = HierarchicalUtilityService.allStandardObj(lstOfallObj);
           List<String> lstOfCusObj = HierarchicalUtilityService.allCustomObj(lstOfallObj);
           allStdCusList.addAll(lstOfStdObj);
           allStdCusList.addAll(lstOfCusObj);
       }
       catch(Exception e )
        {
            System.debug('Error:'+e.getMessage());
        }
      return allStdCusList;
   }
    
   public static Map<String,List<String>> listOfAllFields()
   {
       Map<String,List<String>> customFieldsMap = new Map<String,List<String>>();
       List<String> lstOfObj = new List<String>();
       lstOfObj = listOfAllObj();
       if(lstOfObj != null)
       for(String obj : lstOfObj)
       { 
           List<String> lstOfFields = new List<String>();
           lstOfFields   = allFieldsOfObject(obj);
           customFieldsMap.put(obj,lstOfFields);
       }
       return customFieldsMap;
   }
   public  void valuesDeSelected()
    {
        WrapperDataCleanUpService wrap = new WrapperDataCleanUpService();
        wrap.deSelectValues();
        System.debug('In Values');
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
               for(WrapperDataCleanUpService field : wrapFieldList)
               {
                   String objManipulate = objCount+'__c.'+field.objName;
                   System.debug('objManipulate'+objManipulate);
                   if(selectedFieldListToDelete.get(objManipulate) != null)
                   {
                       field.isSelected = true;
                   }
               }
           }
       }
       catch(Exception e )
       {
           System.debug('Error:'+e.getMessage());
       }
      return null;
   }
   public static list<String> allFieldsOfObject(String ObjName)
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
    public pageReference selectedFieldEvent()
    {
        try
        {
           
          System.debug(objCount +' '+selectedField+' '+flag);
            String manipulateString = objCount+'__c.'+selectedField ;
        System.debug('manipulateString'+manipulateString+flag);
        
        if(selectedFieldListToDelete.get(manipulateString) != null)
        {
            selectedFieldListToDelete.remove(manipulateString);
        }
        else
        {
            objFieldList.add(manipulateString);
            selectedFieldListToDelete.put(manipulateString,manipulateString);
        }
        System.debug('objFieldList'+objFieldList);
        }
        catch(Exception e )
        {
            System.debug('Error:'+e.getMessage());
        }
       // objFieldMap.put(objCount,wrapFieldList.objName);
        return null;
    }
    
   public pageReference DeleteAll()
   {
      // DeleteFields(objFieldList);
       return null;
   }
  
    //Call the batch class
   public void DeleteFields(List<String> lstOfFields)
   {
       CustomFieldDeleteBatchService d = new CustomFieldDeleteBatchService(lstOfFields) ; //Created an instance to call Batch Apex class 
       database.executeBatch(d,10);
   }
}