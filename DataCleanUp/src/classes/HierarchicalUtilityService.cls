public  with sharing class HierarchicalUtilityService {
   // List<WrapperDataCleanUpService> wrapObjList{get;set;}
   // Boolean flag{get;set;}
    public static List<String> allObjects()
    {
        List<String> objects = new List<String>();
        Map<String,Schema.SObjectType> lstOfObj = Schema.getGlobalDescribe();
        objects.addAll(lstOfObj.keySet());
        return objects;
    }
    public static List<String> allStandardObj(List<String> objects)
    {
        List<String> objectList = new List<String>();
        System.debug('objects'+objects.size());
        for(integer i =0;i< objects.size();i++)
        {
            if(objects[i].endsWith('kav') || objects[i].containsIgnoreCase('CollaborationGroupRecord'))
            {
                objects.remove(i);
            }
        }
        Schema.DescribeSObjectResult[] results = Schema.DescribeSObjects(objects);
        String nameSpace = DataCleanUpSelector.nameSpaceprefixOfOrg();
        for(Schema.DescribeSObjectResult res : results)
        {
            String resString = String.valueOf((res.getName()));
            if(!res.isCustomSetting() &&!res.isCustom() && res.getRecordTypeInfos().size() > 0 && res.isqueryable()  && res.isDeletable() && res.isCreateable())//get the list of objetcs which are queryable,deletable and creatable
            {
                if(nameSpace != null && resString.startsWith(nameSpace + '__'))
                {
                    objectList.add(res.getname());
                }
                else if(namespace == null && resString.countMatches('__') < 2)
                {
                    objectList.add(res.getname());
                } 
            }
        }
         return objectList;
     }
    //Get a list of All Custom Objects
    public static List<String> allCustomObj(List<String> objects)
    {
        List<String> objectList = new List<String>();
        Schema.DescribeSObjectResult[] results = Schema.DescribeSObjects(objects);
        String nameSpace = DataCleanUpSelector.nameSpaceprefixOfOrg();
        for(Schema.DescribeSObjectResult res : results)
        {
            String resString = String.valueOf(res.getName());
            if(!res.isCustomSetting()  && res.iscustom() && res.getRecordTypeInfos().size() > 0 && res.isqueryable()  && res.isDeletable() && res.isCreateable())//get the list of objetcs which are queryable,deletable and creatable
            {
                if(nameSpace != null && resString.startsWith(nameSpace + '__'))
                {
                    objectList.add(res.getname());
                }
                else if(namespace == null && resString.countMatches('__') < 2)
                {
                    objectList.add(res.getname());
                } 
            }
        }
        return objectList; 
    }
    public static Map<string,Set<String>> findChildObjects(list<String> objList)
    {
        Map<String,Set<String>> mapObj_Rel = new Map<String,Set<String>>();
        findChildRelationShip(objList,mapObj_Rel);
        return mapObj_Rel;
    }
    public static void findChildRelationShip(List<String> objList,Map<String,Set<String>> mapObj_Rel)
    {
        Schema.DescribeSObjectResult[] results = Schema.DescribeSObjects(objList);
        for(Schema.DescribeSObjectResult R : results)
        {
            if(R.isqueryable() && R.isDeletable())
            {
                Set<String> putInMap = new Set<String>();
                list<Schema.ChildRelationship> childRel = R.getChildRelationships();
                if(childRel != null)
                {
                    for(Schema.ChildRelationship cr : childRel)
                    {
                        if(R.getName() =='Account')
                        {
                            list<String> recussionList = new list<String>();
                            recussionList.add('Opportunity');
                            findChildRelationShip(recussionList,mapObj_Rel);
                            putInMap.add('Opportunity');
                            recussionList.add('Contact');
                            findChildRelationShip(recussionList,mapObj_Rel);
                            putInMap.add('Contact');
                            
                        }
                        if(cr.isRestrictedDelete() &&  String.valueOf(cr.getChildSObject()) != R.getName() )
                        {	
                            list<String> recussionList = new list<String>();
                            recussionList.add(String.valueOf(cr.getChildSObject()));
                            findChildRelationShip(recussionList,mapObj_Rel);
                            putInMap.add(String.valueOf(cr.getChildSObject()));
                        }
                    }
                }
                mapObj_Rel.put(R.getName(),putInMap) ;
            }
        }
        //Put it in Map;
    }
   
    /* Call Recurssion function to find child's child*/
    public static List<String> findNullValues(Map<string,Set<String>> mapObj_Rel)
    {
       List<String> finalRelationList = new List<String>();
        for(String k : mapObj_Rel.keySet())
        {
            checkForRelationShip(k,mapObj_Rel);
            finalRelationList.add(k);
        }
        return finalRelationList;
    }
    /* This method is used to find child who is not parent of another object*/
    public static void checkForRelationShip(String keys,Map<string,Set<String>> mapObj_Rel)
    {
        Set<String> mapValues = new Set<String>();
        mapValues = mapObj_Rel.get(keys);
        if(mapValues != null)
        {
            for(String values : mapValues)
            {
                checkForRelationShip(values,mapObj_Rel);
            }
        }
    } 
    public static Set<String> dependentObjects(List<String> objList)
    {
        Set<String> dependentObject = new Set<String>();
        if(objList.size() > 0)
        {
            Map<string,Set<String>> mapchildobjects=new Map<string,Set<String>>();
            mapchildobjects= findChildObjects(objList);
            List<String> lstOfDependent = new List<String>();
            lstOfDependent = findNullValues(mapchildobjects);
            dependentObject.addAll(lstOfDependent);
            System.debug('mapchildobjects'+mapchildobjects);
            for(String s : objList)
            {
                if(dependentObject.contains(s))
                {
                    dependentObject.remove(s);
                }
            }
        }
         return dependentObject;
    }
    public static void cancleDel(List<WrapperDataCleanUpService>  wrapObjList)
    {
        try
        { 
            for(WrapperDataCleanUpService obj : wrapObjList)
            {
                obj.isSelected = false;
            }
        }
        catch(Exception e)
        {
            System.debug('Error:'+e.getMessage());
        }
    }
    public static List<WrapperDataCleanUpService> checkFlag(List<WrapperDataCleanUpService>  wrapObjList , boolean flag)
    {
        if(wrapObjList.size() > 0)
        {
            if(flag == true )
            {
                for(WrapperDataCleanUpService w :wrapObjList)
                {
                    w.isSelected = true;
                }
            }
            else
            {
                for(WrapperDataCleanUpService w :wrapObjList)
                {
                    w.isSelected = false;
                }
            }
        }
        return wrapObjList;
    }
    public static List<String> selectedObjectData(List<WrapperDataCleanUpService>  wrapList)
    {
        List<String> selectedObjects = new List<String>();
        List<WrapperDataCleanUpService> wrapObjList = new List<WrapperDataCleanUpService>();
        try
        {
            if(wrapList.size() > 0 && wrapList != null)
            {
                wrapObjList.addAll(wrapList);
                for(WrapperDataCleanUpService wrapObj :wrapObjList)
                {
                    if(wrapObj.isSelected == true)
                    {
                        selectedObjects.add(wrapObj.objName);
                    }
                }
        	}
        }
        catch(Exception ex)
        {
          	System.debug('ERROR:'+ex.getMessage());
        }
        return selectedObjects; 
        
    }
    
    public static void deleteAllRecords(List<String>selectedObjects)
    {
        try
        {
           if(selectedObjects.size() > 0)
            {
                Map<string,Set<String>> chidlValues = new Map<string,Set<String>>();
                chidlValues = findChildObjects(selectedObjects);
                list<String> strList = new list<String>();
                strList =  findNullValues(chidlValues);
                if(strList.size() > 0)
                {
                    BatchApexDeleteRecordsService d = new BatchApexDeleteRecordsService(strList.get(0),strList);//Created an instance to call Batch Apex class 
                    database.executeBatch(d,2000);
                }
                else
                {
                    System.debug('Your List is strList empty in DeleteDataUtility');
                }
            }
            else
            {
                System.debug('Your List is selectedObjects empty in DeleteDataUtility');
            }
        } 
        catch(Exception ex)
        {
           System.debug('ERROR:'+ex.getMessage());
        }
    }
    public  static List<WrapperDataCleanUpService> wrapObjList(List<String> ObjList)
    {
        List<WrapperDataCleanUpService> wrapObjList  = new List<WrapperDataCleanUpService>();
        try
        {
            Boolean flag = false;
            for(String obj : ObjList)
            {
                wrapObjList.add(new WrapperDataCleanUpService(obj));
            }
        }
        catch(Exception ex)
        {
            System.debug('ERROR:'+ex.getMessage());
        }
        return wrapObjList;
    }

}