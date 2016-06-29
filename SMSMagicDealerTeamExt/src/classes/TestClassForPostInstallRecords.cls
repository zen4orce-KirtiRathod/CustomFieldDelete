@isTest
public class TestClassForPostInstallRecords {
    
    @isTest
    static void testInstallScript(){
        PostInstallRecordsClass postinstall = new PostInstallRecordsClass();
        Test.testInstall(postinstall, null);
        List<smagicinteract__SMS_Template_Type__c> sms = [SELECT id FROM smagicinteract__SMS_Template_Type__c];
        System.assertEquals(sms.size(), 6);
        list<smagicinteract__SMS_Template__c> smstemp = [SELECT id FROM smagicinteract__SMS_Template__c];
        System.assertEquals(smstemp.size(),4);
        list<smagicreminder__EventReminderConfig__c> smsEvent = [SELECT id FROM smagicreminder__EventReminderConfig__c];
        System.assertEquals(smsEvent.size(), 4);
        list<smagicinteract__incoming_lookup_config__c> smsLookUp = [SELECT id FROM smagicinteract__incoming_lookup_config__c];
        System.assertEquals(smsLookUp.size(), 3);
    }

}