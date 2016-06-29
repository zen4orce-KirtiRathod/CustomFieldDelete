<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>New_Used_Ohter</fullName>
        <description>Based on RecordType New / Used / Other Selection</description>
        <field>NUO__c</field>
        <formula>CASE( $RecordType.Name ,
&quot;Used&quot;, &quot;U&quot;, 
&quot;New&quot;, &quot;N&quot;,
&quot;Demo&quot;, &quot;D&quot;,
&quot;Fleet&quot;, &quot;F&quot;,
&quot;O&quot;)</formula>
        <name>New/Used/Ohter</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Code_Changed_Update_Date</fullName>
        <description>Field update to measure status code update has changed.</description>
        <field>Status_Code_Assignment_Date__c</field>
        <formula>TODAY()</formula>
        <name>Status Code Changed Update Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Vehicle_Inventory_Name</fullName>
        <description>Update Name field of vehicle inventory to reflect StockNumber Year Make Model</description>
        <field>Name</field>
        <formula>&quot;(&quot;+Stock_Number__c +&quot;)  &quot;+  Year__c +&quot; &quot;+  Make__c  +&quot; &quot;+ Model__c</formula>
        <name>Vehicle Inventory Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
    </fieldUpdates>
    <rules>
        <fullName>NUO Field Update</fullName>
        <actions>
            <name>New_Used_Ohter</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update NUO based on recordtype</description>
        <formula>IF(1 = 1, true, false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Vehicle Inventory Set Name</fullName>
        <actions>
            <name>Vehicle_Inventory_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Rule to perform field update and set vehicle name.</description>
        <formula>IF(!CONTAINS(Name,  &quot;(&quot;+Stock_Number__c+&quot;)&quot;), true, false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
