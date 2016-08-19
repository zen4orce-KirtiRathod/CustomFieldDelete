public class DeleteDataUtility {
   
    Hierarchicle ex = new Hierarchicle();
    Set<String> dependentObjList{get;set;}
    List<WrapperDataCleanUp> wrapObjList{get;set;}
    Boolean flag{get;set;}
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
     //This Method return dependent objects of given List
    public Set<String> dependentObjects(List<String> objList)
    {
        Set<String> dependentObject = new Set<String>();
        if(objList.size() > 0)
        {
            
            Map<string,Set<String>> mapchildobjects=new Map<string,Set<String>>();
            ex.mapRelationList();
            mapchildobjects=ex.findChildObjects(objList);
            List<String> lstOfDependent = new List<String>();
            lstOfDependent = ex.findNullValues(mapchildobjects);
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
    public  void deleteAllRecords(List<String>selectedObjects)
    {
        try
        {
           if(selectedObjects.size() > 0)
            {
                Map<string,Set<String>> chidlValues = new Map<string,Set<String>>();
                chidlValues = ex.findChildObjects(selectedObjects);
                list<String> strList = new list<String>();
                strList =  ex.findNullValues(chidlValues);
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
  
}