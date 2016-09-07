public class CustomFieldDeleteApiService {
	//Delete Fields using metadata api
    public static void deleteField(List<String> lstOfMaps,String sessionID)
    {
        MetadataService.MetadataPort service = createServiceBatch(sessionID);
        List<MetadataService.DeleteResult> results =
            service.deleteMetadata(
                'CustomField',lstOfMaps );
        handleDeleteResults(results[0]);
       
   }
   //Create service 
   public static MetadataService.MetadataPort createService()
    {
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        return service;
    }
    //Create Service for batch
    public static MetadataService.MetadataPort createServiceBatch(string sessionId)
    {
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = sessionId;
        return service;
    }

    public class DeleteCustomFieldsException extends Exception { }
    //Handle Save results
	public  static void handleSaveResults(MetadataService.SaveResult saveResult)
    {
        // Nothing to see?
        
        if(saveResult==null || saveResult.success)
            return ;
        // Construct error message and throw an exception
        if(saveResult.errors!=null)
        {
            List<String> messages = new List<String>();
            messages.add(
                (saveResult.errors.size()==1 ? 'Error ' : 'Errors ') +
                    'occured processing component ' + saveResult.fullName + '.');
            for(MetadataService.Error error : saveResult.errors)
                messages.add(
                    error.message + ' (' + error.statusCode + ').' +
                    ( error.fields!=null && error.fields.size()>0 ?
                        ' Fields ' + String.join(error.fields, ',') + '.' : '' ) );
            if(messages.size()>0)
                throw new DeleteCustomFieldsException(String.join(messages, ' '));
        }
        if(!saveResult.success)
            throw new DeleteCustomFieldsException('Request failed with no specified error.');
       
    }
	//Handle Delete Results
    public static List<String> handleDeleteResults(MetadataService.DeleteResult deleteResult)
    {
        // Nothing to see?
        List<String> messages = new List<String>();
        if(deleteResult==null || deleteResult.success)
            return messages;
        // Construct error message and throw an exception
        if(deleteResult.errors!=null)
        {
            messages.add(
                (deleteResult.errors.size()==1 ? 'Error ' : 'Errors ') +
                    'occured processing component ' + deleteResult.fullName + '.');
            for(MetadataService.Error error : deleteResult.errors)
                messages.add(
                    error.message + ' (' + error.statusCode + ').' +
                    ( error.fields!=null && error.fields.size()>0 ?
                        ' Fields ' + String.join(error.fields, ',') + '.' : '' ) );
            if(messages.size()>0)
                throw new DeleteCustomFieldsException(String.join(messages, ' '));
        }
        if(!deleteResult.success)
            throw new DeleteCustomFieldsException('Request failed with no specified error.');
         return messages;
    }

	
}