<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Part_Line_Price_Level_Desc</fullName>
        <description>Save parts pricing strategy level name.</description>
        <field>Price_Level__c</field>
        <formula>Price_Level_Strategy__r.Name</formula>
        <name>Part Line Price Level Desc</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Parts_Invoice_Line_Total</fullName>
        <description>Update total price field of Parts Invoice line after each modifcation</description>
        <field>Total_Price__c</field>
        <formula>IF(Quantity_Sold__c &gt; 0, (Quantity_Sold__c *  Price__c), 0.00)</formula>
        <name>Parts Invoice Line Total</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
    </fieldUpdates>
    <rules>
        <fullName>Parts Line Clean</fullName>
        <actions>
            <name>Part_Line_Price_Level_Desc</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update necessary parts lines sales data</description>
        <formula>LastModifiedDate !=  NOW()</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
