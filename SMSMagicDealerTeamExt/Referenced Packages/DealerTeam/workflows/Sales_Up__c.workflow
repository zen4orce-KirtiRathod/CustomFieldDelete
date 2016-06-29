<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Sales_Up_Name</fullName>
        <description>Update the Name field for all sales ups to be have searchable context</description>
        <field>Name</field>
        <formula>Buyer_Contact__r.FirstName &amp; &quot; &quot; &amp;  Buyer_Contact__r.LastName &amp; &quot; &quot; &amp;  TEXT(Year_High__c) &amp; &quot; &quot; &amp;  Make__c &amp; &quot; &quot; &amp;  Model__c</formula>
        <name>Sales Up Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Sales Up Searchable Name Context</fullName>
        <actions>
            <name>Sales_Up_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Create a searchable context out of the sales up name field.</description>
        <formula>NOT(CONTAINS(Name,  Buyer_Contact__r.LastName ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
