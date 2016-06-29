{
 "smagicinteract__SMS_Template_Type__c": [
    {
	"smagicinteract__Template_Object_Type__c": "dealer__Sales_Appointment__c",    
    "smagicinteract__Related_Object_Types__c": ""
	},
	{
    "smagicinteract__Template_Object_Type__c": "dealer__Service_Appointment__c",
    "smagicinteract__Related_Object_Types__c": ""
  },
  {
    "smagicinteract__Template_Object_Type__c": "dealer__Vehicle_Inventory__c",
    "smagicinteract__Related_Object_Types__c": ""
	},
	{
    "smagicinteract__Template_Object_Type__c": "dealer__Service_Repair_Order__c",
    "smagicinteract__Related_Object_Types__c": ""
	},
	{
	"smagicinteract__Template_Object_Type__c": "dealer__Sales_Up__c",
    "smagicinteract__Related_Object_Types__c": "dealer__Desired_Vehicle__c"
	},
	{
	"smagicinteract__Template_Object_Type__c": "Event",
    "smagicinteract__Related_Object_Types__c": ""
	}
],
  "smagicinteract__SMS_Template__c": [
	{
    "smagicinteract__Name__c": "Sample1",
    "smagicinteract__ObjectName__c": "dealer__Sales_Appointment__c",
    "smagicinteract__Text__c": ""
	},{
    "smagicinteract__Name__c": "Sample2",
    "smagicinteract__ObjectName__c": "dealer__Service_Appointment__c",
    "smagicinteract__Text__c": ""
	},{
    "smagicinteract__Name__c": "Sample3",
    "smagicinteract__ObjectName__c": "dealer__Desired_Vehicle__c",
    "smagicinteract__Text__c": ""
	},{
	"smagicinteract__Name__c": "Sample4",
    "smagicinteract__ObjectName__c": "dealer__Service_Repair_Order__c",
    "smagicinteract__Text__c": ""
	}],
  "smagicreminder__EventReminderConfig__c": [
	{
    "smagicreminder__Config_String__c": "Config Name 1",
    "smagicreminder__Configuration_Name__c": "Sales_Appointment_Reminder_1Hour-5052",
	"smagicreminder__Description__c": "textAreaForDesc",
	"smagicreminder__onDelete__c":"true",
	"smagicreminder__Short_Name__c":"ShortNameForEVent",
	"smagicreminder__SMSOptOut__c":"true",
	"smagicreminder__SMSSenderId__c":"XYZ",
	"smagicreminder__Template__c":"",
	"smagicreminder__SMSText__c":"Some Text"
	},{
    "smagicreminder__Config_String__c": "Config Name 2",
    "smagicreminder__Configuration_Name__c": "Sales_Appointment_Reminder_24Hour-5053",
	"smagicreminder__Description__c": "textAreaForDesc",
	"smagicreminder__onDelete__c":"true",
	"smagicreminder__Short_Name__c":"ShortNameForEVent",
	"smagicreminder__SMSOptOut__c":"true",
	"smagicreminder__SMSSenderId__c":"XYZ",
	"smagicreminder__Template__c":"",
	"smagicreminder__SMSText__c":"Some Text"
	},{
    "smagicreminder__Config_String__c": "Config Name 3",
    "smagicreminder__Configuration_Name__c": "Service_Appointment_Reminder_1Hour-5056",
	"smagicreminder__Description__c": "textAreaForDesc",
	"smagicreminder__onDelete__c":"true",
	"smagicreminder__Short_Name__c":"ShortNameForEVent",
	"smagicreminder__SMSOptOut__c":"true",
	"smagicreminder__SMSSenderId__c":"XYZ",
	"smagicreminder__Template__c":"",
	"smagicreminder__SMSText__c":"Some Text"
	},{
    "smagicreminder__Config_String__c": "Config Name 4",
    "smagicreminder__Configuration_Name__c": "Service_Appointment_Reminder_24Hour-5057",
	"smagicreminder__Description__c": "textAreaForDesc",
	"smagicreminder__onDelete__c":"true",
	"smagicreminder__Short_Name__c":"ShortNameForEVent",
	"smagicreminder__SMSOptOut__c":"true",
	"smagicreminder__SMSSenderId__c":"XYZ",
	"smagicreminder__Template__c":"",
	"smagicreminder__SMSText__c":"Some Text"
    }],
 "smagicinteract__incoming_lookup_config__c":[
  {
  "smagicinteract__incoming_sms_owner__c":"Record Owner",
  "smagicinteract__objectName__c":"dealer__Sales_Appointment__c",
  "smagicinteract__Notify_Record_Owner__c":"true",
  "smagicinteract__ReferenceField__c":"Contact Field",
  "smagicinteract__MobilePhoneField__c":"Company Number Field"
  },{
  "smagicinteract__incoming_sms_owner__c":"Record Owner",
  "smagicinteract__objectName__c":"dealer__Service_Appointment__c",
  "smagicinteract__Notify_Record_Owner__c":"true",
  "smagicinteract__ReferenceField__c":"Contact Field",
  "smagicinteract__MobilePhoneField__c":"Company Number Field" 
  },{
  "smagicinteract__incoming_sms_owner__c":"Record Owner",
  "smagicinteract__objectName__c":"dealer__Sales_Up__c",
  "smagicinteract__Notify_Record_Owner__c":"true",
  "smagicinteract__ReferenceField__c":"Contact Field",
  "smagicinteract__MobilePhoneField__c":"Company Number Field"
  }]
}
