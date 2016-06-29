<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>PartName</fullName>
        <description>Fix part name to be the MFG:PartNo</description>
        <field>Name</field>
        <formula>Name</formula>
        <name>Part Name Format</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
    </fieldUpdates>
    <rules>
        <fullName>Part Record Clean</fullName>
        <actions>
            <name>PartName</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Clean certain fields to be valid</description>
        <formula>NOT(CONTAINS(Name,  Part_No__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
