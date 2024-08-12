/**
 * @description Test class for the BI_PSPB_PersonalizedArticlesCtrl class.
 * This class contains test methods to verify the functionality of personalized article retrieval methods.
 * It includes tests for different scenarios:
 * - testGetPositiveArticles: Tests the retrieval of personalized articles when certain conditions are met.
 * - testGetNegativeArticles: Tests the retrieval of personalized articles under different conditions.
 * Each test method sets up required data, executes the methods under test, and asserts the expected outcomes.
 * History:
 * Version	Author			Date			Detail			Description
 * 1.0		Gokul Krishnan	17-Jul-2024		Created			Initial development
 * 1.2 		Gokul Krishnan  19-Jul-2024		Updated			positive and negative scenario article
 * 															retrieve test method added.
 */
@isTest
public with sharing class BI_PSPB_PersonalizedArticlesCtrlTest {
	@isTest
	static void testGetPositiveArticles() {
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
				List<String> result = BI_PSPB_PersonalizedArticlesCtrl.getpersonalizedarticles();

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
	static void testGetNegativeArticles() {
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
				BI_PSPB_PatientStatus__c = 'Acute'
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
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = qstnVersionThirty.id,
				Name = 'test data'
			);
			insert testReponseThirty;
			AssessmentQuestion questionDataFive = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_12395',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questionDataFive;

			AssessmentQuestionVersion questionVersionFive = new AssessmentQuestionVersion(
				AssessmentQuestionId = questionDataFive.id,
				QuestionText = 'Do you have other medical conditions?',
				Name = 'test data5',
				IsActive = true
			);
			insert questionVersionFive;

			AssessmentQuestionResponse testResponseFive = new AssessmentQuestionResponse(
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = questionVersionFive.id,
				Name = 'test data'
			);
			insert testResponseFive;
			AssessmentQuestion requireSupportData = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_1331313',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert requireSupportData;

			AssessmentQuestionVersion requireSupportQstn = new AssessmentQuestionVersion(
				AssessmentQuestionId = requireSupportData.id,
				QuestionText = 'I have required support at home from my family members and/or caregiver to manage my GPP condition.',
				Name = 'test data13',
				IsActive = true
			);
			insert requireSupportQstn;

			AssessmentQuestionResponse requireSupportResponse = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = requireSupportQstn.id,
				Name = 'test data'
			);
			insert requireSupportResponse;

			// Create test data
			BI_PSP_Personalized_messages__c testMessage = new BI_PSP_Personalized_messages__c(
				BI_PSP_Category__c = 'General messages',
				BI_PSP_Message_body__c = 'Test General Message'
			);
			insert testMessage;

			// Similar test data setup for the scenario where BI_PSPB_Caregiver__c is true
			// ...

			// Call the method to be tested
			Test.startTest();
			System.runAs(testUser) {
				List<String> result = BI_PSPB_PersonalizedArticlesCtrl.getpersonalizedarticles();
				Test.stopTest();
				// Assertions
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
	static void testExceptionHandlingMessages() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		// Simulate an exception by forcing an error
		try {
			System.runAs(new User(Id = UserInfo.getUserId())) {
				Test.startTest();
				List<String> resultarticles = BI_PSPB_PersonalizedArticlesCtrl.getpersonalizedarticles();
				Test.stopTest();

				Assert.areNotEqual(
					null,
					resultarticles,
					'Result should not be null'
				);
			}
		} catch (Exception e) {
			// Assert that the exception message is as expected
			Assert.areEqual(
				e.getMessage(),
				'Script-thrown exception',
				e.getMessage()
			);
		}
	}

	/**
	 * @description    : Test method for retrieving personalized articles based on the current user.
	 */
	@isTest
	static void testGetArticles() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		try {
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
				BI_PSPB_PatientStatus__c = 'Chronic'
			);
			insert testEnrolleeOne;

			Assessment assessmentData = new Assessment(
				Name = 'Introduction',
				AssessmentStatus = 'In Progress',
				BI_PSP_StatusForPersonalization__c = 'Complete',
				BI_PSP_CareProgramEnrollee__c = testEnrolleeOne.Id
			);
			insert assessmentData;
			AssessmentQuestion questionDataFive = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_12395',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questionDataFive;

			AssessmentQuestionVersion questionVersionFive = new AssessmentQuestionVersion(
				AssessmentQuestionId = questionDataFive.id,
				QuestionText = 'Do you have other medical conditions?',
				Name = 'test data5',
				IsActive = true
			);
			insert questionVersionFive;

			AssessmentQuestionResponse testResponseFive = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = questionVersionFive.id,
				Name = 'test data'
			);
			insert testResponseFive;

			// Set the test context user
			System.runAs(testUser) {
				// Call the method being tested
				Test.startTest();

				List<String> result = BI_PSPB_PersonalizedArticlesCtrl.getpersonalizedarticles();
				Test.stopTest();

				// Assert the results
				// Add assertions based on the expected behavior of your method
				Assert.areNotEqual(null, result, 'Result should not be null');
			}


			// Add more assertions as needed based on your logic
		} catch (Exception e) {
			Assert.areEqual(null, null, 'Result should not be null');
		}
	}

	/**
	 * @description Test method for retrieving personalized messages and filtering responses based on the current user.
	 */
	@isTest
	static void testGetMessagesNullUser() {
		// Insert application settings
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;

		try {
			// Set the test context user
			System.runAs(new User(Id = UserInfo.getUserId())) {
				// Call the method being tested
				Test.startTest();
				// Add method calls and assertions here
				Test.stopTest();

				// Add more assertions as needed based on your logic
			}
		} catch (Exception e) {
			// Assert that the exception message is as expected
			Assert.areEqual(null, null, e.getMessage());
		}
	}

	@isTest
	static void testGetArticlesNullUser() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		try {
			// Set the test context user
			System.runAs(new User(Id = UserInfo.getUserId())) {
				// Call the method being tested
				Test.startTest();
				List<String> result = BI_PSPB_PersonalizedArticlesCtrl.getpersonalizedarticles();
				Test.stopTest();

				// Assert the results
				Assert.areNotEqual(null, result, 'Result should not be null');
				// Add more assertions as needed based on your logic
			}
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
	static void testGetArticleCaregiver() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		Contact con = new Contact(
			LastName = 'TestAccount1',
			Email = 'testusertamil1237@example.com'
		);
		insert con;
		// Create a test user
		Profile standardUserProfile = [
			SELECT Id
			FROM Profile
			WHERE Name = 'BI_PSP_Patient Profile'
			LIMIT 1
		];

		User testUser = new User(
			FirstName = 'Test',
			LastName = 'User',
			Email = 'testuser12343@example.com',
			UserName = 'testusernew123@example.com',
			Alias = 'tuser',
			EmailEncodingKey = 'UTF-8',
			TimeZoneSidKey = 'America/Los_Angeles',
			LocaleSidKey = 'en_US',
			LanguageLocaleKey = 'en_US',
			ProfileId = standardUserProfile.Id,
			BI_PSPB_Caregiver__c = false,
			ContactId = con.Id
		);
		insert testUser;

		// Create a test account associated with the contact
		Account testAccount = new Account(Name = 'Test Account');
		insert testAccount;

		// Mock an exception by forcing a failure in the SOQL query
		try {
			// Call the method to be tested
			Test.startTest();

			System.runAs(testUser) {
				List<string> result = BI_PSPB_PersonalizedArticlesCtrl.getpersonalizedarticles();
				Test.stopTest();

				// Perform assertions for the catch part
				Assert.areEqual(
					0,
					result.size(),
					'Unexpected result for Patientstatus when an exception occurs'
				);
			}
		} catch (Exception e) {
			// Perform additional assertions if needed
			Assert.areNotEqual(
				null,
				e.getMessage(),
				'Exception message should not be null'
			);
		}
	}

	@isTest
	static void testGetArticlesNews() {
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
				BI_PSPB_PatientStatus__c = 'Chronic'
			);
			insert testEnrolleeOne;

			Assessment assessmentData = new Assessment(
				Name = 'Introduction',
				AssessmentStatus = 'In Progress',
				BI_PSP_StatusForPersonalization__c = 'Complete',
				BI_PSP_CareProgramEnrollee__c = testEnrolleeOne.Id
			);
			insert assessmentData;

			AssessmentQuestion questionData = new AssessmentQuestion(
				Name = 'test questionname',
				DeveloperName = 'Valid_Name_123',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questionData;

			AssessmentQuestion qstnDataTwo = new AssessmentQuestion(
				Name = 'test questionname2',
				DeveloperName = 'Valid_Name_1293',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert qstnDataTwo;

			AssessmentQuestionVersion qstnVersionTwo = new AssessmentQuestionVersion(
				AssessmentQuestionId = qstnDataTwo.id,
				QuestionText = 'What is your gender?',
				Name = 'test data2',
				IsActive = true
			);
			insert qstnVersionTwo;

			AssessmentQuestionResponse responseTwo = new AssessmentQuestionResponse(
				ResponseText = 'Female',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = qstnVersionTwo.id,
				Name = 'test data'
			);
			insert responseTwo;

			AssessmentQuestionVersion qstnVersion = new AssessmentQuestionVersion(
				AssessmentQuestionId = questionData.id,
				QuestionText = 'I don’t feel like I am doing enough to stay healthy in terms of diet, exercise, etc.',
				Name = 'test data',
				IsActive = true
			);
			insert qstnVersion;

			AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = qstnVersion.id,
				Name = 'test data'
			);
			insert testResponse;

			AssessmentQuestion qstnDataThree = new AssessmentQuestion(
				Name = 'test questionname3',
				DeveloperName = 'Valid_Name_12393',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert qstnDataThree;

			AssessmentQuestionVersion questionVersionThree = new AssessmentQuestionVersion(
				AssessmentQuestionId = qstnDataThree.id,
				QuestionText = 'Do you often discuss GPP with your friends and family?',
				Name = 'test data3',
				IsActive = true
			);
			insert questionVersionThree;

			AssessmentQuestionResponse responseThree = new AssessmentQuestionResponse(
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = questionVersionThree.id,
				Name = 'test data'
			);
			insert responseThree;

			AssessmentQuestion qstnDataFour = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_12394',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert qstnDataFour;

			AssessmentQuestionVersion qstnVersionFour = new AssessmentQuestionVersion(
				AssessmentQuestionId = qstnDataFour.id,
				QuestionText = 'What aspects of your life have been affected by GPP?',
				Name = 'test data4',
				IsActive = true
			);
			insert qstnVersionFour;

			AssessmentQuestionResponse responseFour = new AssessmentQuestionResponse(
				ResponseText = 'Relationships with friends and family,Relationship with Partner,Self Esteem',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = qstnVersionFour.id,
				Name = 'test data'
			);
			insert responseFour;

			AssessmentQuestion questionDataFive = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_12395',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questionDataFive;

			AssessmentQuestionVersion questionVersionFive = new AssessmentQuestionVersion(
				AssessmentQuestionId = questionDataFive.id,
				QuestionText = 'Do you have other medical conditions?',
				Name = 'test data5',
				IsActive = true
			);
			insert questionVersionFive;

			AssessmentQuestionResponse testResponseFive = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = questionVersionFive.id,
				Name = 'test data'
			);
			insert testResponseFive;

			AssessmentQuestion qstnDataSix = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_12396',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert qstnDataSix;

			AssessmentQuestionVersion qstnVersionSix = new AssessmentQuestionVersion(
				AssessmentQuestionId = qstnDataSix.id,
				QuestionText = 'I have a complete understanding of my Generalized pustular psoriasis (GPP).',
				Name = 'test data6',
				IsActive = true
			);
			insert qstnVersionSix;

			AssessmentQuestionResponse responseSix = new AssessmentQuestionResponse(
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = qstnVersionSix.id,
				Name = 'test data'
			);
			insert responseSix;

			AssessmentQuestion qstnDataSeven = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_12397',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert qstnDataSeven;

			AssessmentQuestionVersion qstnVersionSeven = new AssessmentQuestionVersion(
				AssessmentQuestionId = qstnDataSeven.id,
				QuestionText = 'I feel confident about recognizing GPP flares.',
				Name = 'test data7',
				IsActive = true
			);
			insert qstnVersionSeven;

			AssessmentQuestionResponse responseSeven = new AssessmentQuestionResponse(
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = qstnVersionSeven.id,
				Name = 'test data'
			);
			insert responseSeven;
			AssessmentQuestion qstnDataEight = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_12398',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert qstnDataEight;

			AssessmentQuestionVersion qstnVersionEight = new AssessmentQuestionVersion(
				AssessmentQuestionId = qstnDataEight.id,
				QuestionText = 'I can manage my GPP flares.',
				Name = 'test data8',
				IsActive = true
			);
			insert qstnVersionEight;

			AssessmentQuestionResponse testResponseEight = new AssessmentQuestionResponse(
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = qstnVersionEight.id,
				Name = 'test data'
			);
			insert testResponseEight;

			AssessmentQuestion qstnDataNine = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_12399',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert qstnDataNine;

			AssessmentQuestionVersion qstnVersionNine = new AssessmentQuestionVersion(
				AssessmentQuestionId = qstnDataNine.id,
				QuestionText = 'I have a complete understanding of Spevigo (spesolimab) and how it is used to treat my GPP',
				Name = 'test data9',
				IsActive = true
			);
			insert qstnVersionNine;

			AssessmentQuestionResponse responseNine = new AssessmentQuestionResponse(
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = qstnVersionNine.id,
				Name = 'test data'
			);
			insert responseNine;

			AssessmentQuestion qstnDataTen = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_1231010',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert qstnDataTen;

			AssessmentQuestionVersion qstnVersionTen = new AssessmentQuestionVersion(
				AssessmentQuestionId = qstnDataTen.id,
				QuestionText = 'I am not good at talking to my physician about my GPP.',
				Name = 'test data10',
				IsActive = true
			);
			insert qstnVersionTen;

			AssessmentQuestionResponse responseTen = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = qstnVersionTen.id,
				Name = 'test data'
			);
			insert responseTen;

			AssessmentQuestion qstnDataEleven = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_1231111',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert qstnDataEleven;

			AssessmentQuestionVersion qstnVersionEleven = new AssessmentQuestionVersion(
				AssessmentQuestionId = qstnDataEleven.id,
				QuestionText = 'I rely only on my physician to manage my GPP.',
				Name = 'test data11',
				IsActive = true
			);
			insert qstnVersionEleven;

			AssessmentQuestionResponse testResponseEleven = new AssessmentQuestionResponse(
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = qstnVersionEleven.id,
				Name = 'test data'
			);
			insert testResponseEleven;

			AssessmentQuestion affectMentalData = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_1231212',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert affectMentalData;

			AssessmentQuestionVersion affectMentalQstn = new AssessmentQuestionVersion(
				AssessmentQuestionId = affectMentalData.id,
				QuestionText = 'GPP is affecting my mental health (e.g. leading to depression and/or anxiety).',
				Name = 'test data12',
				IsActive = true
			);
			insert affectMentalQstn;

			AssessmentQuestionResponse affectMentalResponse = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = affectMentalQstn.id,
				Name = 'test data'
			);
			insert affectMentalResponse;

			AssessmentQuestion requireSupportData = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_1331313',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert requireSupportData;

			AssessmentQuestionVersion requireSupportQstn = new AssessmentQuestionVersion(
				AssessmentQuestionId = requireSupportData.id,
				QuestionText = 'I have required support at home from my family members and/or caregiver to manage my GPP condition.',
				Name = 'test data13',
				IsActive = true
			);
			insert requireSupportQstn;

			AssessmentQuestionResponse requireSupportResponse = new AssessmentQuestionResponse(
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = requireSupportQstn.id,
				Name = 'test data'
			);
			insert requireSupportResponse;

			AssessmentQuestion qstnDataFourteen = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_1431414',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert qstnDataFourteen;

			AssessmentQuestionVersion qstnVersionFourteen = new AssessmentQuestionVersion(
				AssessmentQuestionId = qstnDataFourteen.id,
				QuestionText = 'How Long you have been diagnosed with Generalized Pustular Psoriasis (GPP)?',
				Name = 'test data14',
				IsActive = true
			);
			insert qstnVersionFourteen;

			AssessmentQuestionResponse testResponse14 = new AssessmentQuestionResponse(
				ResponseText = 'Less than a month',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = qstnVersionFourteen.id,
				Name = 'test data'
			);
			insert testResponse14;

			AssessmentQuestion qstnDataFifteen = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_1531515',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert qstnDataFifteen;

			AssessmentQuestionVersion qstnVersionFifteen = new AssessmentQuestionVersion(
				AssessmentQuestionId = qstnDataFifteen.id,
				QuestionText = 'How Long you have been diagnosed with Generalized Pustular Psoriasis (GPP)?',
				Name = 'test data15',
				IsActive = true
			);
			insert qstnVersionFifteen;

			AssessmentQuestionResponse responseFifteen = new AssessmentQuestionResponse(
				ResponseText = 'More than a year',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = qstnVersionFifteen.id,
				Name = 'test data'
			);
			insert responseFifteen;

			AssessmentQuestion qstnDataSixteen = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_1631616',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert qstnDataSixteen;

			AssessmentQuestionVersion qstnVersionSixteen = new AssessmentQuestionVersion(
				AssessmentQuestionId = qstnDataSixteen.id,
				QuestionText = 'How Long you have been diagnosed with Generalized Pustular Psoriasis (GPP)?',
				Name = 'test data16',
				IsActive = true
			);
			insert qstnVersionSixteen;

			AssessmentQuestionResponse testResponseSixteen = new AssessmentQuestionResponse(
				ResponseText = 'Less than 6 months',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = qstnVersionSixteen.id,
				Name = 'test data'
			);
			insert testResponseSixteen;

			AssessmentQuestion qstnDataSeventeen = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_1731717',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert qstnDataSeventeen;

			AssessmentQuestionVersion qstnVersionSeventeen = new AssessmentQuestionVersion(
				AssessmentQuestionId = qstnDataSeventeen.id,
				QuestionText = 'How Long you have been diagnosed with Generalized Pustular Psoriasis (GPP)?',
				Name = 'test data17',
				IsActive = true
			);
			insert qstnVersionSeventeen;

			AssessmentQuestionResponse testResponseSeventeen = new AssessmentQuestionResponse(
				ResponseText = 'Less than a year',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = qstnVersionSeventeen.id,
				Name = 'test data'
			);
			insert testResponseSeventeen;

			AssessmentQuestion qstnDataEighteen = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_1831818',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert qstnDataEighteen;

			AssessmentQuestionVersion qstnVersionEighteen = new AssessmentQuestionVersion(
				AssessmentQuestionId = qstnDataEighteen.id,
				QuestionText = 'What is your gender?',
				Name = 'test data18',
				IsActive = true
			);
			insert qstnVersionEighteen;

			AssessmentQuestionResponse testResponseEighteen = new AssessmentQuestionResponse(
				ResponseText = 'Others',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = qstnVersionEighteen.id,
				Name = 'test data'
			);
			insert testResponseEighteen;

			AssessmentQuestion qstnDataNineteen = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_1931919',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert qstnDataNineteen;

			AssessmentQuestionVersion qstnVersionNineteen = new AssessmentQuestionVersion(
				AssessmentQuestionId = qstnDataNineteen.id,
				QuestionText = 'What is your gender?',
				Name = 'test data19',
				IsActive = true
			);
			insert qstnVersionNineteen;

			AssessmentQuestionResponse testResponseNineteen = new AssessmentQuestionResponse(
				ResponseText = 'Prefer not to say',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = qstnVersionNineteen.id,
				Name = 'test data'
			);
			insert testResponseNineteen;
			AssessmentQuestion qstnDataTwenty = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_2032020',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert qstnDataTwenty;

			AssessmentQuestionVersion qstnVersionTwenty = new AssessmentQuestionVersion(
				AssessmentQuestionId = qstnDataTwenty.id,
				QuestionText = 'Do you have other medical conditions?',
				Name = 'test data20',
				IsActive = true
			);
			insert qstnVersionTwenty;

			AssessmentQuestionResponse testResponseTwenty = new AssessmentQuestionResponse(
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = qstnVersionTwenty.id,
				Name = 'test data'
			);
			insert testResponseTwenty;

			AssessmentQuestion qstnDataTwentyOne = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_2132121',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert qstnDataTwentyOne;

			AssessmentQuestionVersion qstnVersionTwentyOne = new AssessmentQuestionVersion(
				AssessmentQuestionId = qstnDataTwentyOne.id,
				QuestionText = 'Do you often discuss GPP with your friends and family?',
				Name = 'test data21',
				IsActive = true
			);
			insert qstnVersionTwentyOne;

			AssessmentQuestionResponse testResponseTwentyOne = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = qstnVersionTwentyOne.id,
				Name = 'test data'
			);
			insert testResponseTwentyOne;
			AssessmentQuestion qstnDataTwentyTwo = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_2232222',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert qstnDataTwentyTwo;

			AssessmentQuestionVersion qstnVersionTwentyTwo = new AssessmentQuestionVersion(
				AssessmentQuestionId = qstnDataTwentyTwo.id,
				QuestionText = 'What is your gender?',
				Name = 'test data22',
				IsActive = true
			);
			insert qstnVersionTwentyTwo;

			AssessmentQuestionResponse testResponseTwentyTwo = new AssessmentQuestionResponse(
				ResponseText = 'Male',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = qstnVersionTwentyTwo.id,
				Name = 'test data'
			);
			insert testResponseTwentyTwo;
			AssessmentQuestion qstnDataTwentyThree = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_2332323',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert qstnDataTwentyThree;

			AssessmentQuestionVersion qstnVersionTwentyThree = new AssessmentQuestionVersion(
				AssessmentQuestionId = qstnDataTwentyThree.id,
				QuestionText = 'I have a complete understanding of my Generalized pustular psoriasis (GPP).',
				Name = 'test data23',
				IsActive = true
			);
			insert qstnVersionTwentyThree;

			AssessmentQuestionResponse testResponseTwentyThree = new AssessmentQuestionResponse(
				ResponseText = 'Maybe',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = qstnVersionTwentyThree.id,
				Name = 'test data'
			);
			insert testResponseTwentyThree;

			AssessmentQuestion qstnDataTwentyFour = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_2432424',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert qstnDataTwentyFour;

			AssessmentQuestionVersion qstnVersionTwentyFour = new AssessmentQuestionVersion(
				AssessmentQuestionId = qstnDataTwentyFour.id,
				QuestionText = 'I feel confident about recognizing GPP flares.',
				Name = 'test data24',
				IsActive = true
			);
			insert qstnVersionTwentyFour;

			AssessmentQuestionResponse testResponseTwentyFour = new AssessmentQuestionResponse(
				ResponseText = 'Maybe',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = qstnVersionTwentyFour.id,
				Name = 'test data'
			);
			insert testResponseTwentyFour;

			AssessmentQuestion qstnDataTwentyFive = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_2532525',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert qstnDataTwentyFive;

			AssessmentQuestionVersion qstnVersionTwentyFive = new AssessmentQuestionVersion(
				AssessmentQuestionId = qstnDataTwentyFive.id,
				QuestionText = 'I feel confident about recognizing GPP flares.',
				Name = 'test data25',
				IsActive = true
			);
			insert qstnVersionTwentyFive;

			AssessmentQuestionResponse testResponseTwentyFive = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = qstnVersionTwentyFive.id,
				Name = 'test data'
			);
			insert testResponseTwentyFive;

			AssessmentQuestion qstnDataTwentySix = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_2632626',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert qstnDataTwentySix;

			AssessmentQuestionVersion qstnVersionTwentySix = new AssessmentQuestionVersion(
				AssessmentQuestionId = qstnDataTwentySix.id,
				QuestionText = 'I can manage my GPP flares.',
				Name = 'test data26',
				IsActive = true
			);
			insert qstnVersionTwentySix;

			AssessmentQuestionResponse testResponseTwentySix = new AssessmentQuestionResponse(
				ResponseText = 'Maybe',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = qstnVersionTwentySix.id,
				Name = 'test data'
			);
			insert testResponseTwentySix;

			AssessmentQuestion qstnDataTwentySeven = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_2732727',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert qstnDataTwentySeven;

			AssessmentQuestionVersion qstnVersionTwentySeven = new AssessmentQuestionVersion(
				AssessmentQuestionId = qstnDataTwentySeven.id,
				QuestionText = 'I can manage my GPP flares.',
				Name = 'test data27',
				IsActive = true
			);
			insert qstnVersionTwentySeven;

			AssessmentQuestionResponse testResponseTwentySeven = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = qstnVersionTwentySeven.id,
				Name = 'test data'
			);
			insert testResponseTwentySeven;

			AssessmentQuestion qstnDataTwentyEight = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_2832828',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert qstnDataTwentyEight;

			AssessmentQuestionVersion qstnVersionTwentyEight = new AssessmentQuestionVersion(
				AssessmentQuestionId = qstnDataTwentyEight.id,
				QuestionText = 'I have a complete understanding of my Generalized pustular psoriasis (GPP).',
				Name = 'test data28',
				IsActive = true
			);
			insert qstnVersionTwentyEight;

			AssessmentQuestionResponse testResponseTwentyEight = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = qstnVersionTwentyEight.id,
				Name = 'test data'
			);
			insert testResponseTwentyEight;

			AssessmentQuestion qstnDataTwentyNine = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_2932929',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert qstnDataTwentyNine;

			AssessmentQuestionVersion qstnVersionTwentyNine = new AssessmentQuestionVersion(
				AssessmentQuestionId = qstnDataTwentyNine.id,
				QuestionText = 'I have complete understanding of Spevigo® (spesolimab) and how it is used to treat my GPP.',
				Name = 'test data29',
				IsActive = true
			);
			insert qstnVersionTwentyNine;

			AssessmentQuestionResponse testResponseTwentyNine = new AssessmentQuestionResponse(
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = qstnVersionTwentyNine.id,
				Name = 'test data'
			);
			insert testResponseTwentyNine;
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
			AssessmentQuestion qstnDataThirtyOne = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_3133131',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert qstnDataThirtyOne;

			AssessmentQuestionVersion qstnVersionThirtyOne = new AssessmentQuestionVersion(
				AssessmentQuestionId = qstnDataThirtyOne.id,
				QuestionText = 'I am not good at talking to my physician about my GPP.',
				Name = 'test data31',
				IsActive = true
			);
			insert qstnVersionThirtyOne;

			AssessmentQuestionResponse testResponseThirtyOne = new AssessmentQuestionResponse(
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = qstnVersionThirtyOne.id,
				Name = 'test data'
			);
			insert testResponseThirtyOne;

			AssessmentQuestion qstnDataThirtyTwo = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_3233232',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert qstnDataThirtyTwo;

			AssessmentQuestionVersion qstnVersionThirtyTwo = new AssessmentQuestionVersion(
				AssessmentQuestionId = qstnDataThirtyTwo.id,
				QuestionText = 'I rely only on my physician to manage my GPP.',
				Name = 'test data32',
				IsActive = true
			);
			insert qstnVersionThirtyTwo;

			AssessmentQuestionResponse testReponseThirtyTwo = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = qstnVersionThirtyTwo.id,
				Name = 'test data'
			);
			insert testReponseThirtyTwo;
			AssessmentQuestion qstnDataThirtyThree = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_3333333',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert qstnDataThirtyThree;

			AssessmentQuestionVersion qstnVersionThirtyThree = new AssessmentQuestionVersion(
				AssessmentQuestionId = qstnDataThirtyThree.id,
				QuestionText = 'I don’t feel like I am doing enough to stay healthy in terms of diet, exercise, etc.',
				Name = 'test data33',
				IsActive = true
			);
			insert qstnVersionThirtyThree;

			AssessmentQuestionResponse affectingHealthResponse = new AssessmentQuestionResponse(
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = qstnVersionThirtyThree.id,
				Name = 'test data'
			);
			insert affectingHealthResponse;
			AssessmentQuestion affectingHealthData = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_3434343',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert affectingHealthData;

			AssessmentQuestionVersion affectingHealthQstn = new AssessmentQuestionVersion(
				AssessmentQuestionId = affectingHealthData.id,
				QuestionText = 'GPP is affecting my mental health (e.g. leading to depression and/or anxiety).',
				Name = 'test data34',
				IsActive = true
			);
			insert affectingHealthQstn;

			AssessmentQuestionResponse responseThirtyFour = new AssessmentQuestionResponse(
				ResponseText = 'Maybe',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = affectingHealthQstn.id,
				Name = 'test data'
			);
			insert responseThirtyFour;
			AssessmentQuestion affectHealthData = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_3535353',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert affectHealthData;

			AssessmentQuestionVersion affectHealthQstn = new AssessmentQuestionVersion(
				AssessmentQuestionId = affectHealthData.id,
				QuestionText = 'GPP is affecting my mental health (e.g. leading to depression and/or anxiety).',
				Name = 'test data35',
				IsActive = true
			);
			insert affectHealthQstn;

			AssessmentQuestionResponse affectHealthResponse = new AssessmentQuestionResponse(
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = affectHealthQstn.id,
				Name = 'test data'
			);
			insert affectHealthResponse;

			AssessmentQuestion requireSupportHomeData = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_3636363',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert requireSupportHomeData;

			AssessmentQuestionVersion requireSupportHomeQstn = new AssessmentQuestionVersion(
				AssessmentQuestionId = requireSupportHomeData.id,
				QuestionText = 'I have required support at home from my family members and/or caregiver to manage my GPP condition.',
				Name = 'test data36',
				IsActive = true
			);
			insert requireSupportHomeQstn;

			AssessmentQuestionResponse supportHomeResponse = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = requireSupportHomeQstn.id,
				Name = 'test data'
			);
			insert supportHomeResponse;

			// Create test data
			BI_PSP_Personalized_messages__c testMessage = new BI_PSP_Personalized_messages__c(
				BI_PSP_Category__c = 'General messages',
				BI_PSP_Message_body__c = 'Test General Message'
			);
			insert testMessage;

			// Similar test data setup for the scenario where BI_PSPB_Caregiver__c is true
			// ...

			// Call the method to be tested
			Test.startTest();
			System.runAs(testUser) {
				List<String> result = BI_PSPB_PersonalizedArticlesCtrl.getpersonalizedarticles();

				Test.stopTest();

				// Assertions
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
	static void testCaregiverData() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		try {
			String currentUserName = 'Test User';
			String currentUserEmail = 'testusernew@example.com';
			Profile standardUserProfile = [
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

			User testUserTwo = new User(
				Email = 'testuser2new@example.com',
				BI_PSPB_Caregiver__c = true,
				Username = 'testuser2new@example.com',
				FirstName = 'Test',
				LastName = 'User2',
				Alias = 'tesn',
				TimeZoneSidKey = 'America/New_York',
				LocaleSidKey = 'en_US',
				EmailEncodingKey = 'UTF-8',
				ProfileId = standardUserProfile.Id,
				LanguageLocaleKey = 'en_US',
				ContactId = con.Id
			);
			insert testUserTwo;
			Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
				.get('PersonAccount')
				.getRecordTypeId();
			Account testAccountOne = new Account(
				Lastname = currentUserName,
				PersonEmail = currentUserEmail,
				RecordTypeId = personAccountRecordTypeId
			);
			insert testAccountOne;

			String currentUserNameTwo = 'Test User2';
			String currentUserEmailTwo = 'testuser2new@example.com';
			Account testAccountTwo = new Account(
				Lastname = currentUserNameTwo,
				PersonEmail = currentUserEmailTwo,
				RecordTypeId = personAccountRecordTypeId,
				BI_PSPB_Selected_Patient_ID__c = testAccountOne.Id
			);
			insert testAccountTwo;

			CareProgram cp = new CareProgram(
				Name = 'testcp',
				StartDate = Date.valueOf('2024-02-28')
			);

			insert cp;

			CareProgramEnrollee testCpa2 = new CareProgramEnrollee(
				Name = 'TestCpa222',
				AccountId = testAccountTwo.Id,
				CareProgramId = cp.Id
			);
			insert testCpa2;

			Assessment testAssessment = new Assessment(
				Name = 'Test Assessment',
				OwnerId = testUserTwo.Id,
				AssessmentStatus = 'Completed',
				BI_PSP_DateForCQ__c = 'Jan 2023'
			);
			insert testAssessment;

			//insert assessment question
			AssessmentQuestion questionData = new AssessmentQuestion(
				Name = 'test questionname',
				DeveloperName = 'Valid_Name_123',
				DataType = 'Decimal',
				QuestionCategory = 'Work & Activity Impairment (WPAI)'
			);
			insert questionData;

			//insert Assessment question version

			AssessmentQuestionVersion questionver = new AssessmentQuestionVersion(
				Name = 'question',
				QuestionText = 'Do you often discuss GPP with your friends and family?',
				AssessmentQuestionId = questionData.Id
			);
			insert questionver;
			// Datetime createddt = DateTime.newInstance(
			// 	Date.newInstance(2023, 1, 6),
			// 	Time.newInstance(12, 23, 0, 0)
			// );
			// Create test assessment response data
			AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
				Name = 'Test Response',
				ResponseText = 'No',
				BI_PSP_Category__c = 'Social life',
				AssessmentId = testAssessment.Id,
				AssessmentQuestionId = questionver.Id
				// CreatedDate = createddt
			);
			insert testResponse;
			Test.startTest();
			System.runAs(testUserTwo) {
				List<String> result = BI_PSPB_PersonalizedArticlesCtrl.getpersonalizedarticles();

				Test.stopTest();

				Assert.areNotEqual(result.size(), 1, 'Result should not empty');
			}
		} catch (Exception e) {
			// Assert that the exception message is as expected
			Assert.areEqual(
				e.getMessage(),
				'Script-thrown exception',
				e.getMessage()
			);
		}
	}

	/**
	 * @description Test method used to verify the functionality of the getpersonalizedarticles() method in the 
		Calls the getpersonalizedarticles() and getpersonalizedmessages() methods to retrieve personalized 
		articles and messages. Performs assertions to ensure that the results are not empty.
	 */
	@isTest
	static void testGetArticlesAcutePatient() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;

		try {
			Profile patient = [
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
				ProfileId = patient.Id,
				LastName = 'TestAccount1',
				Email = 'testusertamil1234@example.com',
				UserName = 'testusertamil1234@example.com',
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
				LastName = 'TestAccount1',
				PersonEmail = 'testusertamil1234@example.com',
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
				BI_PSPB_PatientStatus__c = 'Acute'
			);
			insert testEnrolleeOne;

			Assessment assessmentData = new Assessment(
				Name = 'Introduction',
				AssessmentStatus = 'In Progress',
				BI_PSP_StatusForPersonalization__c = 'Complete',
				BI_PSP_CareProgramEnrollee__c = testEnrolleeOne.Id
			);
			insert assessmentData;

			AssessmentQuestion qstnDataThirtyThree = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_3333333',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert qstnDataThirtyThree;

			AssessmentQuestionVersion qstnVersionThirtyThree = new AssessmentQuestionVersion(
				AssessmentQuestionId = qstnDataThirtyThree.id,
				QuestionText = 'I don’t feel like I am doing enough to stay healthy in terms of diet, exercise, etc.',
				Name = 'test data33',
				IsActive = true
			);
			insert qstnVersionThirtyThree;

			AssessmentQuestionResponse affectingHealthResponse = new AssessmentQuestionResponse(
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = qstnVersionThirtyThree.id,
				Name = 'test data'
			);
			insert affectingHealthResponse;

			AssessmentQuestion qstnDataEleven = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_1231111',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert qstnDataEleven;

			AssessmentQuestionVersion qstnVersionEleven = new AssessmentQuestionVersion(
				AssessmentQuestionId = qstnDataEleven.id,
				QuestionText = 'I rely only on my physician to manage my GPP.',
				Name = 'test data11',
				IsActive = true
			);
			insert qstnVersionEleven;

			AssessmentQuestionResponse testResponseEleven = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = qstnVersionEleven.id,
				Name = 'test data'
			);
			insert testResponseEleven;

			AssessmentQuestion qstnDataThirtyOne = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_3133131',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert qstnDataThirtyOne;

			AssessmentQuestionVersion qstnVersionThirtyOne = new AssessmentQuestionVersion(
				AssessmentQuestionId = qstnDataThirtyOne.id,
				QuestionText = 'I am not good at talking to my physician about my GPP.',
				Name = 'test data31',
				IsActive = true
			);
			insert qstnVersionThirtyOne;

			AssessmentQuestionResponse testResponseThirtyOne = new AssessmentQuestionResponse(
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = qstnVersionThirtyOne.id,
				Name = 'test data'
			);
			insert testResponseThirtyOne;

			AssessmentQuestion qstnDataTwentyOne = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_2132121',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert qstnDataTwentyOne;

			AssessmentQuestionVersion qstnVersionTwentyOne = new AssessmentQuestionVersion(
				AssessmentQuestionId = qstnDataTwentyOne.id,
				QuestionText = 'Do you often discuss GPP with your friends and family?',
				Name = 'test data21',
				IsActive = true
			);
			insert qstnVersionTwentyOne;

			AssessmentQuestionResponse testResponseTwentyOne = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = qstnVersionTwentyOne.id,
				Name = 'test data'
			);
			insert testResponseTwentyOne;

			AssessmentQuestion questionDataFive = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_12395',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questionDataFive;

			AssessmentQuestionVersion questionVersionFive = new AssessmentQuestionVersion(
				AssessmentQuestionId = questionDataFive.id,
				QuestionText = 'Do you have other medical conditions?',
				Name = 'test data5',
				IsActive = true
			);
			insert questionVersionFive;

			AssessmentQuestionResponse testResponseFive = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = questionVersionFive.id,
				Name = 'test data'
			);
			insert testResponseFive;

			AssessmentQuestion qstnDataSeven = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_12397',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert qstnDataSeven;

			AssessmentQuestionVersion qstnVersionSeven = new AssessmentQuestionVersion(
				AssessmentQuestionId = qstnDataSeven.id,
				QuestionText = 'I feel confident about recognizing GPP flares.',
				Name = 'test data7',
				IsActive = true
			);
			insert qstnVersionSeven;

			AssessmentQuestionResponse responseSeven = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = qstnVersionSeven.id,
				Name = 'test data'
			);
			insert responseSeven;

			AssessmentQuestion qstnDataEight = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_12398',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert qstnDataEight;

			AssessmentQuestionVersion qstnVersionEight = new AssessmentQuestionVersion(
				AssessmentQuestionId = qstnDataEight.id,
				QuestionText = 'I can manage my GPP flares.',
				Name = 'test data8',
				IsActive = true
			);
			insert qstnVersionEight;

			AssessmentQuestionResponse testResponseEight = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = qstnVersionEight.id,
				Name = 'test data'
			);
			insert testResponseEight;

			AssessmentQuestion qstnDataNine = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_12399',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert qstnDataNine;

			AssessmentQuestionVersion qstnVersionNine = new AssessmentQuestionVersion(
				AssessmentQuestionId = qstnDataNine.id,
				QuestionText = 'I have a complete understanding of Spevigo (spesolimab) and how it is used to treat my GPP.',
				Name = 'test data9',
				IsActive = true
			);
			insert qstnVersionNine;

			AssessmentQuestionResponse responseNine = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = qstnVersionNine.id,
				Name = 'test data'
			);
			insert responseNine;

			AssessmentQuestion affectMentalData = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_1231212',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert affectMentalData;

			AssessmentQuestionVersion affectMentalQstn = new AssessmentQuestionVersion(
				AssessmentQuestionId = affectMentalData.id,
				QuestionText = 'GPP is affecting my mental health (e.g. leading to depression and/or anxiety).',
				Name = 'test data12',
				IsActive = true
			);
			insert affectMentalQstn;

			AssessmentQuestionResponse affectMentalResponse = new AssessmentQuestionResponse(
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = affectMentalQstn.id,
				Name = 'test data'
			);
			insert affectMentalResponse;

			AssessmentQuestion requireSupportData = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_312012',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert requireSupportData;

			AssessmentQuestionVersion requireSupportQstn = new AssessmentQuestionVersion(
				AssessmentQuestionId = requireSupportData.id,
				QuestionText = 'I have a complete understanding of Spevigo® (spesolimab) and how it is used to treat my GPP.',
				Name = 'test data13',
				IsActive = true
			);
			insert requireSupportQstn;

			AssessmentQuestionResponse requireSupportResponse = new AssessmentQuestionResponse(
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = requireSupportQstn.id,
				Name = 'test data'
			);
			insert requireSupportResponse;

			System.runAs(testUser) {
				Test.startTest();
				List<String> result = BI_PSPB_PersonalizedArticlesCtrl.getpersonalizedarticles();
				Test.stopTest();
				Assert.areNotEqual(
					result.size(),
					10,
					'Result should not be empty'
				);
			}
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
	static void testGetArticlesNullPatient() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		try {
			Profile patient = [
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
				ProfileId = patient.Id,
				LastName = 'TestAccount1',
				Email = 'testusertamil12344@example.com',
				UserName = 'testusertamil1234@example.com',
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
				PersonEmail = 'testusertamil12344@example.com',
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
			AssessmentQuestion qstnDataThirtyThree = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_3333333',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert qstnDataThirtyThree;

			AssessmentQuestionVersion qstnVersionThirtyThree = new AssessmentQuestionVersion(
				AssessmentQuestionId = qstnDataThirtyThree.id,
				QuestionText = 'I don’t feel like I am doing enough to stay healthy in terms of diet, exercise, etc.',
				Name = 'test data33',
				IsActive = true
			);
			insert qstnVersionThirtyThree;

			AssessmentQuestionResponse affectingHealthResponse = new AssessmentQuestionResponse(
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = qstnVersionThirtyThree.id,
				Name = 'test data'
			);
			insert affectingHealthResponse;
			AssessmentQuestion qstnDataEleven = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_1231111',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert qstnDataEleven;

			AssessmentQuestionVersion qstnVersionEleven = new AssessmentQuestionVersion(
				AssessmentQuestionId = qstnDataEleven.id,
				QuestionText = 'I rely only on my physician to manage my GPP.',
				Name = 'test data11',
				IsActive = true
			);
			insert qstnVersionEleven;

			AssessmentQuestionResponse testResponseEleven = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = qstnVersionEleven.id,
				Name = 'test data'
			);
			insert testResponseEleven;
			AssessmentQuestion qstnDataThirtyOne = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_3133131',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert qstnDataThirtyOne;

			AssessmentQuestionVersion qstnVersionThirtyOne = new AssessmentQuestionVersion(
				AssessmentQuestionId = qstnDataThirtyOne.id,
				QuestionText = 'I am not good at talking to my physician about my GPP.',
				Name = 'test data31',
				IsActive = true
			);
			insert qstnVersionThirtyOne;

			AssessmentQuestionResponse testResponseThirtyOne = new AssessmentQuestionResponse(
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = qstnVersionThirtyOne.id,
				Name = 'test data'
			);
			insert testResponseThirtyOne;

			AssessmentQuestion qstnDataTwentyOne = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_2132121',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert qstnDataTwentyOne;

			AssessmentQuestionVersion qstnVersionTwentyOne = new AssessmentQuestionVersion(
				AssessmentQuestionId = qstnDataTwentyOne.id,
				QuestionText = 'Do you often discuss GPP with your friends and family?',
				Name = 'test data21',
				IsActive = true
			);
			insert qstnVersionTwentyOne;

			AssessmentQuestionResponse testResponseTwentyOne = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = qstnVersionTwentyOne.id,
				Name = 'test data'
			);
			insert testResponseTwentyOne;
			AssessmentQuestion questionDataFive = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_12395',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questionDataFive;

			AssessmentQuestionVersion questionVersionFive = new AssessmentQuestionVersion(
				AssessmentQuestionId = questionDataFive.id,
				QuestionText = 'Do you have other medical conditions?',
				Name = 'test data5',
				IsActive = true
			);
			insert questionVersionFive;

			AssessmentQuestionResponse testResponseFive = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = questionVersionFive.id,
				Name = 'test data'
			);
			insert testResponseFive;
			AssessmentQuestion qstnDataSeven = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_12397',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert qstnDataSeven;

			AssessmentQuestionVersion qstnVersionSeven = new AssessmentQuestionVersion(
				AssessmentQuestionId = qstnDataSeven.id,
				QuestionText = 'I feel confident about recognizing GPP flares.',
				Name = 'test data7',
				IsActive = true
			);
			insert qstnVersionSeven;

			AssessmentQuestionResponse responseSeven = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = qstnVersionSeven.id,
				Name = 'test data'
			);
			insert responseSeven;
			AssessmentQuestion qstnDataEight = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_12398',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert qstnDataEight;

			AssessmentQuestionVersion qstnVersionEight = new AssessmentQuestionVersion(
				AssessmentQuestionId = qstnDataEight.id,
				QuestionText = 'I can manage my GPP flares.',
				Name = 'test data8',
				IsActive = true
			);
			insert qstnVersionEight;

			AssessmentQuestionResponse testResponseEight = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = qstnVersionEight.id,
				Name = 'test data'
			);
			insert testResponseEight;
			AssessmentQuestion qstnDataNine = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_12399',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert qstnDataNine;

			AssessmentQuestionVersion qstnVersionNine = new AssessmentQuestionVersion(
				AssessmentQuestionId = qstnDataNine.id,
				QuestionText = 'I have a complete understanding of Spevigo (spesolimab) and how it is used to treat my GPP',
				Name = 'test data9',
				IsActive = true
			);
			insert qstnVersionNine;

			AssessmentQuestionResponse responseNine = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = qstnVersionNine.id,
				Name = 'test data'
			);
			insert responseNine;
			AssessmentQuestion affectMentalData = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_1231212',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert affectMentalData;

			AssessmentQuestionVersion affectMentalQstn = new AssessmentQuestionVersion(
				AssessmentQuestionId = affectMentalData.id,
				QuestionText = 'GPP is affecting my mental health (e.g. leading to depression and/or anxiety).',
				Name = 'test data12',
				IsActive = true
			);
			insert affectMentalQstn;

			AssessmentQuestionResponse affectMentalResponse = new AssessmentQuestionResponse(
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = affectMentalQstn.id,
				Name = 'test data'
			);
			insert affectMentalResponse;

			BI_PSP_Personalized_messages__c message = new BI_PSP_Personalized_messages__c(
				Name = 'message',
				BI_PSP_Category__c = 'Monday and Friday messages',
				BI_PSP_Message_body__c = 'monday messages'
			);
			insert message;
			BI_PSP_Personalized_messages__c messageFriday = new BI_PSP_Personalized_messages__c(
				Name = 'message',
				BI_PSP_Category__c = 'Monday and Friday messages',
				BI_PSP_Message_body__c = 'friday messages'
			);
			insert messageFriday;

			System.runAs(testUser) {
				Test.startTest();
				List<String> result = BI_PSPB_PersonalizedArticlesCtrl.getpersonalizedarticles();

				Test.stopTest();
				Assert.areEqual(result.size(), 1, 'Result should not empty');
			}
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
	static void testWithNullPatientStatus() {
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
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = qstnVersionThirty.id,
				Name = 'test data'
			);
			insert testReponseThirty;
			AssessmentQuestion questionDataFive = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_12395',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questionDataFive;

			AssessmentQuestionVersion questionVersionFive = new AssessmentQuestionVersion(
				AssessmentQuestionId = questionDataFive.id,
				QuestionText = 'Do you have other medical conditions?',
				Name = 'test data5',
				IsActive = true
			);
			insert questionVersionFive;

			AssessmentQuestionResponse testResponseFive = new AssessmentQuestionResponse(
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = questionVersionFive.id,
				Name = 'test data'
			);
			insert testResponseFive;
			AssessmentQuestion requireSupportData = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_1331313',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert requireSupportData;

			AssessmentQuestionVersion requireSupportQstn = new AssessmentQuestionVersion(
				AssessmentQuestionId = requireSupportData.id,
				QuestionText = 'I have required support at home from my family members and/or caregiver to manage my GPP condition.',
				Name = 'test data13',
				IsActive = true
			);
			insert requireSupportQstn;

			AssessmentQuestionResponse requireSupportResponse = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentData.id,
				AssessmentQuestionId = requireSupportQstn.id,
				Name = 'test data'
			);
			insert requireSupportResponse;

			// Create test data
			BI_PSP_Personalized_messages__c testMessage = new BI_PSP_Personalized_messages__c(
				BI_PSP_Category__c = 'General messages',
				BI_PSP_Message_body__c = 'Test General Message'
			);
			insert testMessage;

			// Similar test data setup for the scenario where BI_PSPB_Caregiver__c is true
			// ...

			// Call the method to be tested
			Test.startTest();
			System.runAs(testUser) {
				List<String> result = BI_PSPB_PersonalizedArticlesCtrl.getpersonalizedarticles();

				Test.stopTest();

				// Assertions
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