public class CustomFieldDeleteApiService {
    public static List<String> deleteField(List<String> lstOfMaps,String sessionID)
    {
        MetadataService.MetadataPort service = createServiceBatch(sessionID);
        List<MetadataService.DeleteResult> results =
            service.deleteMetadata(
                'CustomField',lstOfMaps );
        List<String> messages =  handleDeleteResults(results);
        return messages;
   	}
   	public static MetadataService.MetadataPort createService()
    {
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        return service;
    }
    public static MetadataService.MetadataPort createServiceBatch(string sessionId)
    {
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = sessionId;
        return service;
    }
	public static List<String> handleDeleteResults(List<MetadataService.DeleteResult> deleteResult)
    {	
        List<String> messages = new List<String>();
        for(MetadataService.DeleteResult res : deleteResult)
        {
       		 if(res.errors!=null)
             {
                 messages.add('\n'+res.fullName + ':');
                 for(MetadataService.Error error : res.errors)
                     messages.add(
                         error.message + ' (' + error.statusCode + ').' +
                         ( error.fields!=null && error.fields.size()>0 ?
                          ' Fields ' + String.join(error.fields, '.') + '.' : '' ) );
             }
        }
      
        return messages;
    }
}