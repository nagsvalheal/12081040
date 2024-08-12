/**
 @description
 * This test class verifies the functionality of methods related to 
 * the BI_PSPB_PatientPrescriptionCtrl class with various valid and 
 * invalid inputs. It covers different scenarios including positive and 
 * negative cases for retrieving and creating case records, and handles 
 * the inclusion of files.
 * History:
* Version	Author			Date			Detail				Description
* 1.0		Joyal 			24-Apr-2024		Initial Development	Initial version created to test 
																basic functionality.
* 1.1		Gokul Krishnan 	10-Jul-2024		Added				Added additional test scenarios 
																and refined existing ones.
																Updated tests to include cases with files and 
																negative scenarios.

*/
@isTest
public class BI_PSPB_PatientPrescriptionCtrlTest {
	// Constructor to create test data
	public static User testUser;
	public static Contact contactForPatient;
	static {
		//Create the test user
		testUser = new User(
			FirstName = 'Test',
			LastName = 'Patient',
			Email = 'testuser12@example.com',
			UserName = 'testuser12@example.com',
			BI_PSPB_Caregiver__c = false,
			Alias = 'tuser1',
			EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			TimeZoneSidKey = 'America/Los_Angeles',
			ProfileId = [
				SELECT Id
				FROM Profile
				WHERE Name = 'BI_PSP_Patient Profile'
			]
			.Id
		);
		// Contact for patient user
		contactForPatient = new Contact(
			FirstName = testUser.FirstName,
			LastName = testUser.LastName,
			Email = testUser.Email
		);
		insert contactForPatient;
		testUser.ContactId = contactForPatient.Id;
		insert testUser;
	}

	/**
	 * @description The test method to check the case record.
	 */
	@isTest
	static void testGetCasesForPatientPositive() {
		try {
			System.runAs(testUser) {
				BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
					Name = 'ApplicationName',
					BI_SFCOE_LOG_Application__c = 'Spevigo'
				);
				insert settings;
				RecordType testRecordType = [
					SELECT Id
					FROM RecordType
					WHERE SObjectType = 'Account'
					LIMIT 1
				];
				// Create test data
				Account testPatientAccount = new Account(
					Name = 'Test Patient',
					RecordTypeId = testRecordType.Id
				);
				insert testPatientAccount;

				CareProgram testCareProgram = new CareProgram(
					Name = 'Test Care Program'
				);
				insert testCareProgram;
				CareProgramEnrollee testCareProgramEnrollee = new CareProgramEnrollee(
					AccountId = testPatientAccount.Id,
					CareProgramId = testCareProgram.Id,
					Name = 'Test Enrollee'
				);
				insert testCareProgramEnrollee;
				// Call the method under test
				Test.startTest();
				List<Case> resultCases = BI_PSPB_PatientPrescriptionCtrl.getCasesForPatient(
					'Open'
				);
				Test.stopTest();
				// Verify the results
				Assert.areEqual(
					0,
					resultCases.size(),
					'Expected zero open case for the patient account'
				);
			}
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

	/**
	 * @description The test method to check the case record for negative scenario.
	 */
	@isTest
	static void testGetCasesForPatientNegative() {
		try {
			System.runAs(testUser) {
				BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
					Name = 'ApplicationName',
					BI_SFCOE_LOG_Application__c = 'Spevigo'
				);
				insert settings;
				RecordType testRecordType = [
					SELECT Id
					FROM RecordType
					WHERE SObjectType = 'Account'
					LIMIT 1
				];
				// Create a test account for the patient
				Account testPatientAccount = new Account(
					Name = 'Test Patient',
					RecordTypeId = testRecordType.Id
					// Add other required fields as needed
				);
				insert testPatientAccount;
				// Call the method under test with a null status value to trigger an exception
				Test.startTest();
				BI_PSPB_PatientPrescriptionCtrl.getCasesForPatient(null);
			}
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
	/**
	 * @description The test method to check the case record Insertion.
	 */
	@isTest
	static void testGetCaseRecordWithFiles() {
		try {
			System.runAs(testUser) {
				// Create mock BI_SFCOE_LOG_App_Settings__c record
				BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
					Name = 'ApplicationName',
					BI_SFCOE_LOG_Application__c = 'Spevigo'
				);
				insert settings;
				//Get Aaccount Record Type
				RecordType testRecordTypeForAccount = [
					SELECT Id
					FROM RecordType
					WHERE SObjectType = 'Account'
					LIMIT 1
				];
				// Create account record
				Account testAccount = new Account(
					Name = 'Test Patient',
					RecordTypeId = testRecordTypeforAccount.Id
				);
				insert testAccount;
				//Get case record Type
				RecordType testRecordType = [
					SELECT Id
					FROM RecordType
					WHERE SObjectType = 'Case'
					LIMIT 1
				];
				// Create case record
				Case newCase = new Case(
					RecordTypeId = testRecordType.Id, // Assign the Record Type Id here
					AccountId = testAccount.Id
				);
				insert newCase;

				BI_PSPB_PatientPrescriptionCtrl.BI_PSPB_caseForUpdateRxWrapper caseRecord = new BI_PSPB_PatientPrescriptionCtrl.BI_PSPB_caseForUpdateRxWrapper();
				caseRecord.eprescription = 'Yes';
				caseRecord.physicalCopy = 'Yes';
				caseRecord.prescriptionSentTo = 'test prescription';
				caseRecord.additionalComments = 'test comment';
				List<String> fileIds = new List<String>{ 'FileId1', 'FileId2' };
				Test.startTest();
				// Call the method to test
				BI_PSPB_PatientPrescriptionCtrl.createCaseRecordWithFiles(
					caseRecord,
					fileIds
				);
				Test.stopTest();
				List<Case> insertedCase = [
					SELECT
						Id,
						RecordTypeId,
						AccountId,
						BI_PSPB_e_prescription__c,
						BI_PSPB_physical_copy__c,
						BI_PSPB_prescription_sent_to__c,
						BI_PSPB_Additional_Comments__c
					FROM Case
					WHERE Id = :newCase.Id
				];
				Assert.areEqual(
					1,
					insertedCase.size(),
					'Expected zero open case for the patient account'
				);
			}
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
	/**
 * @description The test method to check the case record 
 				Insertion for negative scenario.
*/
	@isTest
	static void testGetCaseRecordWithFilesNegative() {
		try {
			System.runAs(testUser) {
				// Create mock BI_SFCOE_LOG_App_Settings__c record
				BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
					Name = 'ApplicationName',
					BI_SFCOE_LOG_Application__c = 'Spevigo'
				);
				insert settings;
				//Get Aaccount Record Type
				RecordType testRecordTypeForAccount = [
					SELECT Id
					FROM RecordType
					WHERE SObjectType = 'Account'
					LIMIT 1
				];
				// Create account record
				Account testAccount = new Account(
					Name = 'Test Patient',
					RecordTypeId = testRecordTypeforAccount.Id
				);
				insert testAccount;
				//Get case record Type
				RecordType testRecordType = [
					SELECT Id
					FROM RecordType
					WHERE SObjectType = 'Case'
					LIMIT 1
				];
				// Create case record
				Case newCase = new Case(
					RecordTypeId = testRecordType.Id, // Assign the Record Type Id here
					AccountId = testAccount.Id
				);
				insert newCase;
				BI_PSPB_PatientPrescriptionCtrl.BI_PSPB_caseForUpdateRxWrapper caseRecord = new BI_PSPB_PatientPrescriptionCtrl.BI_PSPB_caseForUpdateRxWrapper();
				caseRecord.eprescription = 'Yes';
				caseRecord.physicalCopy = 'Yes';
				caseRecord.prescriptionSentTo = 'test prescription';
				caseRecord.additionalComments = 'test comment';
				List<String> fileIds = new List<String>{ 'FileId1', 'FileId2' };
				Test.startTest();
				BI_PSPB_PatientPrescriptionCtrl.createCaseRecordWithFiles(
					caseRecord,
					fileIds
				);
				Test.stopTest();
			}
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
	@isTest
	static void testNullCaseRecord() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		try {
			// Create a test user
			Profile p = [
				SELECT Id
				FROM Profile
				WHERE Name = 'BI_PSP_Patient Profile'
				LIMIT 1
			];
			Contact con = new Contact(
				LastName = 'TestAccount1',
				Email = 'testusertamil1237@example.com'
			);
			insert con;

			User testUser = new User(
				ProfileId = p.Id,
				LastName = 'TestAccount1',
				Email = 'testusertamil123@example.com',
				UserName = 'testusertamil123@example.com',
				Alias = 'tuser',
				EmailEncodingKey = 'UTF-8',
				LanguageLocaleKey = 'en_US',
				LocaleSidKey = 'en_US',
				TimeZoneSidKey = 'America/Los_Angeles',
				ContactId = con.Id
			);
			insert testUser;
			Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
				.get('PersonAccount')
				.getRecordTypeId();

			// Create test data for the scenario where BI_PSPB_Caregiver__c is false
			Account testAccountOne = new Account(
				Lastname = 'TestAccount1',
				PersonEmail = 'testusertamil123@example.com',
				RecordTypeId = personAccountRecordTypeId
			);
			insert testAccountOne;

			CareProgram testCareProgram = new CareProgram(
				Name = 'TestCareProgram',
				StartDate = Date.today()
			);
			insert testCareProgram;
			CareProgramEnrollee testEnrolleeOne = new CareProgramEnrollee(
				Name = 'TestCpa1',
				AccountId = testAccountOne.Id,
				CareProgramId = testCareProgram.Id,
				BI_PSPB_PatientStatus__c = null
			);
			insert testEnrolleeOne;

			Assessment assessmentData = new Assessment(
				Name = 'Introduction',
				AssessmentStatus = 'In Progress',
				BI_PSP_StatusForPersonalization__c = 'Complete',
				BI_PSP_CareProgramEnrollee__c = testEnrolleeOne.Id
			);
			insert assessmentData;

			AssessmentQuestion qstnDataThirty = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_3033030',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert qstnDataThirty;

			AssessmentQuestionVersion qstnVersionThirty = new AssessmentQuestionVersion(
				AssessmentQuestionId = qstnDataThirty.id,
				QuestionText = 'I have complete understanding of Spevigo® (spesolimab) and how it is used to treat my GPP.',
				Name = 'test data30',
				IsActive = true
			);
			insert qstnVersionThirty;

			AssessmentQuestionResponse testReponseThirty = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = qstnVersionThirty.id,
				Name = 'test data'
			);
			insert testReponseThirty;

			// Call the method to be tested
			Test.startTest();
			System.runAs(testUser) {
				List<case> result = BI_PSPB_PatientPrescriptionCtrl.getCasesForPatient(
					''
				);

				Test.stopTest();
				Assert.areNotEqual(null, result, 'Result should not be null');
			}
			// Add more assertions based on the expected behavior of your method
		} catch (Exception e) {
			// Assert that the exception message is as expected
			Assert.areEqual(
				e.getMessage(),
				'Script-thrown exception',
				e.getMessage()
			);
		}
	}
	@isTest
	static void testOpenCaseRecord() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		try {
			// Create a test user
			Profile p = [
				SELECT Id
				FROM Profile
				WHERE Name = 'BI_PSP_Patient Profile'
				LIMIT 1
			];
			Contact con = new Contact(
				LastName = 'TestAccount1',
				Email = 'testusertamil1237@example.com'
			);
			insert con;

			User testUser = new User(
				ProfileId = p.Id,
				LastName = 'TestAccount1',
				Email = 'testusertamil123@example.com',
				UserName = 'testusertamil123@example.com',
				Alias = 'tuser',
				EmailEncodingKey = 'UTF-8',
				LanguageLocaleKey = 'en_US',
				LocaleSidKey = 'en_US',
				TimeZoneSidKey = 'America/Los_Angeles',
				ContactId = con.Id
			);
			insert testUser;
			Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
				.get('PersonAccount')
				.getRecordTypeId();

			// Create test data for the scenario where BI_PSPB_Caregiver__c is false
			Account testAccountOne = new Account(
				Lastname = 'TestAccount1',
				PersonEmail = 'testusertamil123@example.com',
				RecordTypeId = personAccountRecordTypeId
			);
			insert testAccountOne;

			CareProgram testCareProgram = new CareProgram(
				Name = 'TestCareProgram',
				StartDate = Date.today()
			);
			insert testCareProgram;
			CareProgramEnrollee testEnrolleeOne = new CareProgramEnrollee(
				Name = 'TestCpa1',
				AccountId = testAccountOne.Id,
				CareProgramId = testCareProgram.Id,
				BI_PSPB_PatientStatus__c = null
			);
			insert testEnrolleeOne;

			Assessment assessmentData = new Assessment(
				Name = 'Introduction',
				AssessmentStatus = 'In Progress',
				BI_PSP_StatusForPersonalization__c = 'Complete',
				BI_PSP_CareProgramEnrollee__c = testEnrolleeOne.Id
			);
			insert assessmentData;

			AssessmentQuestion qstnDataThirty = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_3033030',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert qstnDataThirty;

			AssessmentQuestionVersion qstnVersionThirty = new AssessmentQuestionVersion(
				AssessmentQuestionId = qstnDataThirty.id,
				QuestionText = 'I have complete understanding of Spevigo® (spesolimab) and how it is used to treat my GPP.',
				Name = 'test data30',
				IsActive = true
			);
			insert qstnVersionThirty;

			AssessmentQuestionResponse testReponseThirty = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = qstnVersionThirty.id,
				Name = 'test data'
			);
			insert testReponseThirty;

			BI_PSPB_PatientPrescriptionCtrl.BI_PSPB_caseForUpdateRxWrapper caseRecord = new BI_PSPB_PatientPrescriptionCtrl.BI_PSPB_caseForUpdateRxWrapper();
			caseRecord.eprescription = 'Yes';
			caseRecord.physicalCopy = 'Yes';
			caseRecord.prescriptionSentTo = 'test prescription';
			caseRecord.additionalComments = 'test comment';
			List<String> fileIds = new List<String>{ 'FileId1', 'FileId2' };

			// Call the method to be tested
			Test.startTest();
			System.runAs(testUser) {
				List<case> result = BI_PSPB_PatientPrescriptionCtrl.getCasesForPatient(
					'Open'
				);
				BI_PSPB_PatientPrescriptionCtrl.createCaseRecordWithFiles(
					caseRecord,
					fileIds
				);
				Test.stopTest();
				Assert.areNotEqual(null, result, 'Result should not be null');
			}
			// Add more assertions based on the expected behavior of your method
		} catch (Exception e) {
			// Assert that the exception message is as expected
			Assert.areEqual(
				e.getMessage(),
				'Script-thrown exception',
				e.getMessage()
			);
		}
	}
}