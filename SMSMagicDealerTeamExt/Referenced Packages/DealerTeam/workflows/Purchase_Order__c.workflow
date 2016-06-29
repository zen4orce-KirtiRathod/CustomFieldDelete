<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>PurchaseOrderVendorCity</fullName>
        <description>Update vendor city based on vendor selected</description>
        <field>Vendor_City__c</field>
        <formula>Vendor__r.BillingCity</formula>
        <name>Purchase Order Vendor City</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PurchaseOrderVendorEmail</fullName>
        <description>Copy field of vendor email address</description>
        <field>Vendor_Email__c</field>
        <formula>Vendor__r.Billing_Email__c</formula>
        <name>Purchase Order Vendor Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PurchaseOrderVendorName</fullName>
        <description>Update vendor name to a copy field for record keeping</description>
        <field>Vendor_Name__c</field>
        <formula>Vendor__r.Name</formula>
        <name>Purchase Order Vendor Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PurchaseOrderVendorPhone</fullName>
        <description>Copy field of vendor phone</description>
        <field>Vendor_Phone__c</field>
        <formula>Vendor__r.Phone</formula>
        <name>Purchase Order Vendor Phone</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PurchaseOrderVendorState</fullName>
        <description>Copy field of vendor state</description>
        <field>Vendor_State__c</field>
        <formula>Vendor__r.BillingState</formula>
        <name>Purchase Order Vendor State</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PurchaseOrderVendorStreet</fullName>
        <description>Update vendor street address to copy field for records keeping</description>
        <field>Vendor_Street__c</field>
        <formula>Vendor__r.BillingStreet</formula>
        <name>Purchase Order Vendor Street</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Purchase_OrderVendorPostalCode</fullName>
        <description>Copy field of vendor postal code</description>
        <field>Vendor_Postal_Code__c</field>
        <formula>Vendor__r.BillingPostalCode</formula>
        <name>Purchase Order Vendor PostalCode</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
    </fieldUpdates>
    <rules>
        <fullName>PurchaseOrderCopyField</fullName>
        <actions>
            <name>PurchaseOrderVendorCity</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PurchaseOrderVendorEmail</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PurchaseOrderVendorName</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PurchaseOrderVendorPhone</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PurchaseOrderVendorState</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PurchaseOrderVendorStreet</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Purchase_OrderVendorPostalCode</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Copy vendor account information to static fields to ensure that future changes do not impact the current purchase order record.</description>
        <formula>Id &lt;&gt; TEXT(0)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
