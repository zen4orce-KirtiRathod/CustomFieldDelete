public class SelectorClassForPostInstallRecords {
    public StaticResource resource = new StaticResource();
    //Query StaticResource object for finding JSOn File
    public StaticResource dataForConfig()
    {
        try
        {
            resource = [SELECT id,Body FROM StaticResource WHERE Name = 'ConfigData'];
           
        }
        catch(Exception ex)
        {
            System.debug('ERROR:' +ex.getMessage());
           
        }
        return resource; 
    }

}