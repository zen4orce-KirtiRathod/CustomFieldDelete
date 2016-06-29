<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Chart_of_Accounts_Name</fullName>
        <description>Update Account Number Unique field based on Chart of Accounts Name field</description>
        <field>Account_Number__c</field>
        <formula>Name</formula>
        <name>Chart of Accounts Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
    </fieldUpdates>
    <rules>
        <fullName>Account Number Unique</fullName>
        <actions>
            <name>Chart_of_Accounts_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Ensure no duplicate names exist in the chart of accounts</description>
        <formula>IF(Name&lt;&gt;&apos;&apos;, true, false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
