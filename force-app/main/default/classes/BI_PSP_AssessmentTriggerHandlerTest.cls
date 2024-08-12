/*
* @description    This class operates in such a way that it populates a field called BI_PSP_DateForCQ__c in assessment 
                  With a formatted date that reprsents the date in which the assessment got completed.
* History:
* Version	Author		Date			Detail			Description
* 1.0		Harish		05-Dec-2023		Created			Initial development.
* 1.1		Harish   	01-Jan-2024		Updated			Updated for consitional statements.
l* 1.2		Harish		04-Apr-2024		Updated			Added check for log statements.
*/

@isTest
public class BI_PSP_AssessmentTriggerHandlerTest {
	/*This test class method operates in such a way that it populates a field called BI_PSP_DateForCQ__c in assessment
	 With a formatted date that reprsents the date in which the assessment got completed.*/
	@isTest
	static void testAssessmentTrigger() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		// Create a test record
		Assessment testAssessment = new Assessment(
			// Set other required fields as needed
			Name = 'Psoriasis Symptom Scale (PSS)',
			AssessmentStatus = 'Completed',
			EffectiveDateTime = DateTime.now()
		);
		insert testAssessment;

		// Retrieve the inserted record
		Assessment insertedRecord = [
			SELECT Id, BI_PSP_DateForCQ__c, EffectiveDateTime
			FROM Assessment
			WHERE Id = :testAssessment.Id
		];

		// Verify that the BI_PSP_DateForCQ__c field is populated correctly
		Assert.areEqual(
			insertedRecord.EffectiveDateTime.format('MMMM') +
				' ' +
				insertedRecord.EffectiveDateTime.year(),
			insertedRecord.BI_PSP_DateForCQ__c,
			'BI_PSP_DateForCQ__c should be formatted correctly'
		);

		// Update the record and verify the trigger logic for updates
		DateTime newDateTime = DateTime.now().addMonths(1);
		testAssessment.EffectiveDateTime = null;
		update testAssessment;

		// Retrieve the updated record
		Assessment updatedRecord = [
			SELECT Id, BI_PSP_DateForCQ__c
			FROM Assessment
			WHERE Id = :testAssessment.Id
		];

		// Verify that the BI_PSP_DateForCQ__c field is updated correctly after the record update
		Assert.areNotEqual(
			newDateTime.format('MMMM') + ' ' + newDateTime.year(),
			updatedRecord.BI_PSP_DateForCQ__c,
			'BI_PSP_DateForCQ__c should be updated correctly after the record update'
		);
	}
}