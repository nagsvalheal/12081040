/*
*********************************************************
Apex Class Name    :BI_PSP_CaregiverAndPatientCtrlTest
Created Date       : March 9  2024
@description       : To find caregiver or Patient
@author            : Harish
@last modified     :Abinsha
*********************************************************
*/

@isTest
private class BI_PSP_CaregiverAndPatientCtrlTest {
	//To get Assessment by current user name
	@isTest
	static void testGetAssessmentsByCurrentUserName() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		// Your test data setup (if required)

		String currentUserName = 'Test User';
		String currentUserEmail = 'testusernew@example.com';
		Profile standardUserProfile = [
			//Creating profile for the User
			SELECT Id
			FROM Profile
			WHERE Name = 'BI_PSP_Patient Profile'
			LIMIT 1
		];
        Contact con = new Contact(LastName = 'testusernew@example.com', Email = 'testusernew@example.com');
		insert con;

		//Creating Test User
		User testUser = new User(
			Email = 'testusernew@example.com',
			BI_PSPB_Caregiver__c = false,
			Username = 'testusernew@example.com',
			FirstName = 'Test',
			LastName = 'User',
			Alias = 'tesn',
			TimeZoneSidKey = 'America/New_York',
			LocaleSidKey = 'en_US',
			EmailEncodingKey = 'UTF-8',
			ProfileId = standardUserProfile.Id,
			LanguageLocaleKey = 'en_US',
            ContactId = con.Id
		);
		insert testUser;
		//Creating Person Account for the User
		Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
			.get('PersonAccount')
			.getRecordTypeId();

		Account testAccountOne = new Account(
			Lastname = currentUserName,
			PersonEmail = currentUserEmail,
			RecordTypeId = personAccountRecordTypeId
		);
		insert testAccountOne;

		//Creating Care program to insert careProgram Enrollee
		CareProgram carePrgm = new CareProgram(
			Name = 'testcp',
			StartDate = Date.valueOf('2024-02-28')
		);

		insert carePrgm;
		//To create Care Program Enrollee for Assessment
		CareProgramEnrollee testCpeOne = new CareProgramEnrollee(
			Name = 'TestCpa111',
			AccountId = testAccountOne.Id,
			CareProgramId = carePrgm.Id
		);
		insert testCpeOne;

		Assessment testAssessment = new Assessment(
			Name = 'Psoriasis Symptom Scale (PSS)',
			OwnerId = testUser.Id,
			AssessmentStatus = 'Completed',
			BI_PSP_DateForCQ__c = 'Jan 2023',
			BI_PSP_CareProgramEnrollee__c = testCpeOne.Id
		);
		insert testAssessment;

		//insert assessment question
		AssessmentQuestion questionData = new AssessmentQuestion(
			Name = 'test questionname',
			DeveloperName = 'Valid_Name_123',
			DataType = 'Decimal',
			QuestionCategory = 'Psoriasis Symptom Scale (PSS)'
		);
		insert questionData;

		//insert Assessment question version

		AssessmentQuestionVersion questionVer = new AssessmentQuestionVersion(
			Name = 'question',
			QuestionText = 'Do you often discuss GPP with your friends and family?',
			AssessmentQuestionId = questionData.Id
		);
		insert questionVer;
	
		// Create test assessment response data
		AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
			Name = 'Test Response',
			ResponseText = 'No',
			BI_PSP_Category__c = 'Social life',
			AssessmentId = testAssessment.Id,
			AssessmentQuestionId = questionVer.Id
			//CreatedDate = createdDt
		);
		insert testResponse;
		// To check this Test User
		System.runAs(testUser) {
			Test.startTest();

			// Switch to the test user context
			List<Assessment> result = BI_PSP_CaregiverAndPatientCtrl.getAssessmentsByCurrentUserName(
				'Psoriasis Symptom Scale (PSS)'
			);
			// Your assertions based on the expected outcome
			Test.stopTest();
			Assert.areEqual(1, result.size(), 'One assessment returned');
		}
	}
	
	@isTest
	//To get the Patient Record in negative senario
	static void testGetAssessmentsNegativeSenario() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		//User profile
		Profile standardUserProfile = [
			SELECT Id
			FROM Profile
			WHERE Name = 'BI_PSP_Patient Profile'
			LIMIT 1
		];
        Contact con = new Contact(LastName = 'User', Email = 'testusertamil1237@example.com');
		insert con;

		//TestUser for Patient
		User testUser = new User(
			Email = 'testusernew@example.com',
			BI_PSPB_Caregiver__c = false,
			Username = 'testusernew@example.com',
			FirstName = 'Test',
			LastName = 'User',
			Alias = 'tesn',
			TimeZoneSidKey = 'America/New_York',
			LocaleSidKey = 'en_US',
			EmailEncodingKey = 'UTF-8',
			ProfileId = standardUserProfile.Id,
			LanguageLocaleKey = 'en_US',
            ContactId = con.Id
		);
		insert testUser;

		System.runAs(testUser) {
			Test.startTest();
			try {
				// Switch to the test caregiver context

				BI_PSP_CaregiverAndPatientCtrl.getAssessmentsByCurrentUserName(
					''
				);
				  //This is negative senario so there no need to check assert

				Test.stopTest();
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
    @isTest
	//To get the Patient Record in negative senario
	static void testGetAssessmentsNegativeSenarioForCaregiver() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		//User profile
		Profile standardUserProfile = [
			SELECT Id
			FROM Profile
			WHERE Name = 'BI_PSP_Patient Profile'
			LIMIT 1
		];
        Contact con = new Contact(LastName = 'User', Email = 'testusertamil1237@example.com');
		insert con;

		//TestUser for Patient
		User testUser = new User(
			Email = 'testusernew@example.com',
			BI_PSPB_Caregiver__c = true,
			Username = 'testusernew@example.com',
			FirstName = 'Test',
			LastName = 'User',
			Alias = 'tesn',
			TimeZoneSidKey = 'America/New_York',
			LocaleSidKey = 'en_US',
			EmailEncodingKey = 'UTF-8',
			ProfileId = standardUserProfile.Id,
			LanguageLocaleKey = 'en_US',
            ContactId = con.Id
		);
		insert testUser;

		System.runAs(testUser) {
			Test.startTest();
			try {
				// Switch to the test caregiver context

				BI_PSP_CaregiverAndPatientCtrl.getAssessmentsByCurrentUserName(
					''
				);
				  //This is negative senario so there no need to check assert

				Test.stopTest();
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
}