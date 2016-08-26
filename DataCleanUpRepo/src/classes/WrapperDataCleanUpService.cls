public class WrapperDataCleanUpService {
    public String objName{get;set;}
    public boolean isSelected{get;set;}
    public WrapperDataCleanUpService(String objName)
    {
        this.objName = objName;
        isSelected = false;
    }
  
    public WrapperDataCleanUpService()
    {
        
    }
   

}