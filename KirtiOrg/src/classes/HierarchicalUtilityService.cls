public class HierarchicalUtilityService {
    List<WrapperDataCleanUp> wrapObjList{get;set;}
    Boolean flag{get;set;}
    public list<String> allObjects()
    {
        List<String> objects = new List<String>();
        Map<String,Schema.SObjectType> lstOfObj = Schema.getGlobalDescribe();
        objects.addAll(lstOfObj.keySet());
        return objects;
    }
    public  List<String> allStandardObj(List<String> objects)
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
    public  List<String> allCustomObj(List<String> objects)
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
    public  Map<string,Set<String>> findChildObjects(list<String> objList)
    {
        Map<String,Set<String>> mapObj_Rel = new Map<String,Set<String>>();
        findChildRelationShip(objList,mapObj_Rel);
        return mapObj_Rel;
    }
    public  void findChildRelationShip(List<String> objList,Map<String,Set<String>> mapObj_Rel)
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
    public  List<String> findNullValues(Map<string,Set<String>> mapObj_Rel)
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
    public  void checkForRelationShip(String keys,Map<string,Set<String>> mapObj_Rel)
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
    public Set<String> dependentObjects(List<String> objList)
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
    public static void cancleDel(List<WrapperDataCleanUp>  wrapObjList)
    {
        try
        { 
            for(WrapperDataCleanUp obj : wrapObjList)
            {
                obj.isSelected = false;
            }
        }
        catch(Exception e)
        {
            System.debug('Error:'+e.getMessage());
        }
    }
    public  List<WrapperDataCleanUp> checkFlag(List<WrapperDataCleanUp>  wrapObjList , boolean flag)
    {
        if(wrapObjList.size() > 0)
        {
            if(flag == true )
            {
                for(WrapperDataCleanUp w :wrapObjList)
                {
                    w.isSelected = true;
                }
            }
            else
            {
                for(WrapperDataCleanUp w :wrapObjList)
                {
                    w.isSelected = false;
                }
            }
        }
        return wrapObjList;
    }
    public  List<String> selectedObjectData(List<WrapperDataCleanUp>  wrapList)
    {
        List<String> selectedObjects = new List<String>();
        try
        {
            
            if(wrapList.size() > 0 && wrapList != null)
            {
                wrapObjList = new List<WrapperDataCleanUp>();
                wrapObjList.addAll(wrapList);
                for(WrapperDataCleanUp wrapObj :wrapObjList)
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
    public  void deleteAllRecords(List<String>selectedObjects)
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
                    BatchApexForDeleteRecords d = new BatchApexForDeleteRecords(strList.get(0),strList);//Created an instance to call Batch Apex class 
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
    public List<WrapperDataCleanUp> wrapObjList(List<String> ObjList){
        try
        {
            flag = false;
            wrapObjList = new List<WrapperDataCleanUp>();
            for(String obj : ObjList)
            {
                wrapObjList.add(new WrapperDataCleanUp(obj));
            }
        }
        catch(Exception ex)
        {
            System.debug('ERROR:'+ex.getMessage());
        }
        return wrapObjList;
    }

}