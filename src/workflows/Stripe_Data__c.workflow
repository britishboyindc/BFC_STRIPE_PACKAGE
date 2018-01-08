<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Mark_as_Subscription</fullName>
        <field>Subscription__c</field>
        <literalValue>1</literalValue>
        <name>Mark as Subscription</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_First_Name_from_Name_Field</fullName>
        <field>First_Name__c</field>
        <formula>LEFT(Name_on_Card__c,
FIND(&quot; &quot;, Name_on_Card__c)
)</formula>
        <name>Set First Name from Name Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_LastName_from_Name_Field</fullName>
        <description>Split Name field to find Last Name</description>
        <field>Last_Name__c</field>
        <formula>RIGHT( 
Name_on_Card__c, 
LEN(Name_on_Card__c) - FIND(&quot; &quot;, Name_on_Card__c) + 1 
)</formula>
        <name>Set LastName from Name Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Plan_Id_for_One_Time</fullName>
        <field>Plan_Id__c</field>
        <formula>&quot;OneTimeDonation&quot;</formula>
        <name>Set Plan Id for One Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set Plan Id for One Time Donation</fullName>
        <actions>
            <name>Set_Plan_Id_for_One_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Stripe_Data__c.Stripe_Event_Type__c</field>
            <operation>equals</operation>
            <value>charge.succeeded</value>
        </criteriaItems>
        <criteriaItems>
            <field>Stripe_Data__c.Charge_Invoice_Id__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>When Event = charge.succeeded, and there is no Invoice Id, assume a single donation and assign Plan Id to enable easier Campaign Lookup</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Subscription Flag</fullName>
        <actions>
            <name>Mark_as_Subscription</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Stripe_Data__c.Stripe_Event_Type__c</field>
            <operation>equals</operation>
            <value>charge.succeeded</value>
        </criteriaItems>
        <criteriaItems>
            <field>Stripe_Data__c.Charge_Invoice_Id__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>When Event = charge.succeeded, and there is no Invoice Id, assume a single donation. Otherwise, check this box so we can differentiate in processing</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Split Name for Contact</fullName>
        <actions>
            <name>Set_First_Name_from_Name_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_LastName_from_Name_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Stripe_Data__c.Name_on_Card__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Try and parse Name field into First and Last Name</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
