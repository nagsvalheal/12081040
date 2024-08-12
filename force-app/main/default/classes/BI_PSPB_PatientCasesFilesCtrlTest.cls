/**
@description	This class contains test methods to verify the functionality of 
				methods related to insertuploadfileforupdaterx with valid and invalid inputs.
* History:
* Version	Author			Date			Detail			Description
* 1.0		Joyal			23-Apr-2024		created			Initial development
* 1.1		Gokul Krishnan 	10-Jul-2024		updated			test method added for creation of prescription,
															file upload.
*/
@isTest
public class BI_PSPB_PatientCasesFilesCtrlTest {
	/**
	 * @description The test method to insert the file into the related case.
	 */
	@isTest
	static void getFilePositiveScenario() {
		// Create test data
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		// Create lead Record
		Lead testLead = new Lead(
			FirstName = 'Test',
			LastName = 'Lead',
			Company = 'Test Company',
			Status = 'Open'
		);
		insert testLead;
		// Create ContentVersion Record
		ContentVersion content = new ContentVersion();
		content.Title = 'Header_Picture1';
		content.PathOnClient = '/' + content.Title + '.jpg';
		Blob bodyBlob = Blob.valueOf('Unit Test ContentVersion Body');
		content.VersionData = bodyBlob;
		//content.LinkedEntityId=sub.id;
		content.origin = 'H';
		insert content;

		Id contantDocId = [
			SELECT contentdocumentid
			FROM contentversion
			WHERE id = :content.id
		]
		.contentdocumentid;

		// Prepare data for method invocation
		List<String> fileIds = new List<String>{ contantDocId };
		String leadCaseId = testLead.Id;

		// Call the method under test
		Test.startTest();
		BI_PSPB_PatientCasesFilesCtrl.getContentDocumentLinks(
			fileIds,
			leadCaseId
		);
		Test.stopTest();

		// Assert that ContentDocumentLink records were created
		Integer expectedLinkCount = 1; // We expect one link to be created
		List<ContentDocumentLink> createdLinks = [
			SELECT Id
			FROM ContentDocumentLink
			WHERE LinkedEntityId = :leadCaseId
		];
		Assert.areEqual(
			expectedLinkCount,
			createdLinks.size(),
			'ContentDocumentLink records not created'
		);
	}
	/**
	 * @description		The test method to negative secnario of
	 				 	insert the file into the related case.
	 */
	@isTest
	static void getContentDocumentLinksNegative() {
		try {
			BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
				Name = 'PSPB',
				BI_SFCOE_LOG_Application__c = 'Spevigo'
			);
			insert settings;

			// Create test data
			Case testCase = new Case(Subject = 'Test Case');
			insert testCase;

			// Create test files
			ContentVersion testContent = new ContentVersion(
				Title = 'Test File',
				PathOnClient = 'test.txt',
				VersionData = Blob.valueOf('Test Data')
			);
			insert testContent;

			// Call the method under test
			Test.startTest();
			BI_PSPB_PatientCasesFilesCtrl.getContentDocumentLinks(
				new List<Id>{ testContent.ContentDocumentId },
				testCase.Id
			);
			BI_PSPB_PatientCasesFilesCtrl.getContentDocumentLinks(null, null);
			Test.stopTest();
		} catch (Exception e) {
			/* While running negative scenario, the flow goes to catch.
				Thus resulting in throwing exception and so assertion is done
				for Exception only.*/
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
	}
}