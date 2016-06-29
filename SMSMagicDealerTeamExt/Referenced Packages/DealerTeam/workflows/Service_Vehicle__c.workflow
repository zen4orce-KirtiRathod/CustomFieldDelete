<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Service_Vehicle_Name_Update</fullName>
        <description>Update name of Service Vehicle Record</description>
        <field>Name</field>
        <formula>if(VIN__c != null,RIGHT(VIN__c ,6) + &apos; - &apos;+

if( 
(Year__c == null &amp;&amp; Make__c  == null &amp;&amp; Carline__c == null) || 
(Year__c != null &amp;&amp; Make__c  == null &amp;&amp; Carline__c == null) 
, &apos;Decode Required&apos;,
if(Year__c == null &amp;&amp; Make__c  != null &amp;&amp; Carline__c == null,
Make__c,
if(Year__c == null &amp;&amp; Make__c  == null &amp;&amp; Carline__c != null,
Carline__c,
Year__c +&quot; &quot;+ Make__c +&quot; &quot;+ Carline__c))),&apos;&apos;)</formula>
        <name>Service Vehicle Name Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Service Vehicle Name Update</fullName>
        <actions>
            <name>Service_Vehicle_Name_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Update Name of Service Vehicle Record

OLD criteria changed on 21-12-2015 
IF(Name !=  dealer__Year__c +&quot; &quot;+ dealer__Make__c +&quot; &quot;+ dealer__Carline__c, true, false)</description>
        <formula>IF(Name != RIGHT(VIN__c,6) + &quot; - &quot; + Year__c +&quot; &quot;+ Make__c +&quot; &quot;+ Carline__c, true, false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
