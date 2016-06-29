<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>PopulateAdvisorCompletionTime</fullName>
        <field>Time_to_Advisor_Completion__c</field>
        <formula>NOW()</formula>
        <name>PopulateAdvisorCompletionTime</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PopulateTechCompletionTime</fullName>
        <field>Time_to_Tech_Completion__c</field>
        <formula>NOW()</formula>
        <name>PopulateTechCompletionTime</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>SLC-Inspection Report Follow Up</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Inspection_Report__c.Status__c</field>
            <operation>equals</operation>
            <value>Advisor Review</value>
        </criteriaItems>
        <criteriaItems>
            <field>Inspection_Report__c.Action_Item_Count__c</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <description>MPI Results SLC Message for red/yellow items</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SLC-InspectionReportResults-AllGreen</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Inspection_Report__c.Status__c</field>
            <operation>equals</operation>
            <value>Customer Review</value>
        </criteriaItems>
        <criteriaItems>
            <field>Inspection_Report__c.Action_Item_Count__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <description>MPI Results SLC Message for all Green MPI results</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SetAdvisorCompleteTime</fullName>
        <actions>
            <name>PopulateAdvisorCompletionTime</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Inspection report set the completion time based on Status value = Advisor Complete</description>
        <formula>AND( ISBLANK( Time_to_Advisor_Completion__c ),  ISPICKVAL( Status__c , &quot;Customer Review&quot;)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SetTechCompleteTime</fullName>
        <actions>
            <name>PopulateTechCompletionTime</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Inspection report set the completion time based on Status value = Advisor Reivew</description>
        <formula>AND( ISBLANK( Time_to_Tech_Completion__c ),  ISPICKVAL( Status__c , &quot;Advisor Review&quot;)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
