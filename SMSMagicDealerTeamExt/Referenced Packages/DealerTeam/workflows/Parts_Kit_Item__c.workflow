<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Kit_Cost_Update</fullName>
        <description>Update the line item cost of a part based on price and quantity</description>
        <field>Extended_Cost__c</field>
        <formula>NULLVALUE(Cost__c, 0) * NULLVALUE(Quantity__c, 0)</formula>
        <name>Kit Cost Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Kit_List_Update</fullName>
        <description>Update List price of a line item on a kit.</description>
        <field>Extended_List__c</field>
        <formula>NULLVALUE( List__c , 0) * NULLVALUE(Quantity__c, 0)</formula>
        <name>Kit List Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
    </fieldUpdates>
    <rules>
        <fullName>Parts Kit Cost Update</fullName>
        <actions>
            <name>Kit_Cost_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Kit_List_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update cost * quantity</description>
        <formula>OR(ISCHANGED( Quantity__c ), ISBLANK(Quantity__c), Quantity__c = 1)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
