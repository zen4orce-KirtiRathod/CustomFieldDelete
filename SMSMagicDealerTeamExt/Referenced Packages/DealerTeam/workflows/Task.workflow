<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>PopulateQuickNote</fullName>
        <field>Quick_Note__c</field>
        <formula>left (Description, 255)</formula>
        <name>PopulateQuickNote</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
    </fieldUpdates>
    <rules>
        <fullName>QuickNoteAutoPopulate</fullName>
        <actions>
            <name>PopulateQuickNote</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>1&lt;&gt;0</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
