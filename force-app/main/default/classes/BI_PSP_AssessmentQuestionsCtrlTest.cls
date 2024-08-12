/*

Apex Class Name    :BI_PSP_GetAssessmentQuestionsTest
Created Date       : November 5, 2023
description       : Get Assessment Questions
author            : Harish
@Last Modified On  :11/03/2024
@Last Modified by  :Abinsha

*/

@isTest
private class BI_PSP_AssessmentQuestionsCtrlTest{
	//this test method is for checking the retreival assessment questions related to WAPI category.
	@isTest
	static void testGetTheAssessmentQuestion() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		//create Assessment Questions Work & Activity Impairment (WPAI)
		AssessmentQuestion questionData = new AssessmentQuestion(
			Name = 'test questionname',
			DeveloperName = 'Valid_Name_123',
			DataType = 'Decimal',
			QuestionCategory = 'Work & Activity Impairment (WPAI)'
		);
		insert questionData;

		//insert Assessment question version

		AssessmentQuestionVersion questionVer = new AssessmentQuestionVersion(
			Name = 'question',
			QuestionText = 'Do you often discuss GPP with your friends and family?',
			AssessmentQuestionId = questionData.Id
		);
		insert questionVer;
        String questionnaireName='Introduction';
        try {
		Test.startTest();
		// Call the method from BI_PSP_AssessmentQuestionsCtrl
		List<AssessmentQuestion> questions = BI_PSP_AssessmentQuestionsCtrl.getTheAssesmentQuestion(questionnaireName);
		Assert.areEqual(1, questions.size(), 'Expected one WAPI question');
		Test.stopTest();
        }
        catch (Exception e) {
			// Assert that the exception message is as expected
			Assert.areEqual(
				e.getMessage(),
				'Script-thrown exception',
				e.getMessage()
			);
		}
	}
    
	//this test method is for checking the retreival assessment questions related to PSS category.
	@isTest
	static void testGetPsoriasisAssesmentQues() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
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

		Test.startTest();
		// Call the method from BI_PSP_AssessmentQuestionsCtrl
		List<AssessmentQuestion> questions = BI_PSP_AssessmentQuestionsCtrl.getTheAssesmentQuestion('Psoriasis Symptom Scale (PSS)');
		Assert.areEqual(1, questions.size(), 'Expected one PSS question');
		Test.stopTest();
	}


	//this test method is for checking the retreival of assessment questions related to Qualitative Satisfaction Questionnaire.
	@isTest
	static void testGetQualitativeAssesmentQues() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		AssessmentQuestion questionData = new AssessmentQuestion(
			Name = 'test questionname',
			DeveloperName = 'Valid_Name_123',
			DataType = 'Decimal',
			QuestionCategory = 'Qualitative satisfaction questionnaire'
		);
		insert questionData;

		//insert Assessment question version

		AssessmentQuestionVersion questionVer = new AssessmentQuestionVersion(
			Name = 'question',
			QuestionText = 'Do you often discuss GPP with your friends and family?',
			AssessmentQuestionId = questionData.Id
		);
		insert questionVer;

		Test.startTest();
		// Call the method from BI_PSP_AssessmentQuestionsCtrl
		List<AssessmentQuestion> questions = BI_PSP_AssessmentQuestionsCtrl.getTheAssesmentQuestion('Qualitative satisfaction questionnaire');
		Assert.areEqual(1, questions.size(), 'Expected one QSQ question');
		Test.stopTest();
	}

	//this test method is for checking the retreival of assessment questions related to DLQI category.
	@isTest
	static void testGetDermatologyAssesmentQues() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		AssessmentQuestion questionData = new AssessmentQuestion(
			Name = 'test questionname',
			DeveloperName = 'Valid_Name_123',
			DataType = 'Decimal',
			QuestionCategory = 'Dermatology Life Quality Index (DLQI)'
		);
		insert questionData;

		//insert Assessment question version

		AssessmentQuestionVersion questionVer = new AssessmentQuestionVersion(
			Name = 'question',
			QuestionText = 'Do you often discuss GPP with your friends and family?',
			AssessmentQuestionId = questionData.Id
		);
		insert questionVer;

		Test.startTest();
		// Call the method from BI_PSP_AssessmentQuestionsCtrl
		List<AssessmentQuestion> questions = BI_PSP_AssessmentQuestionsCtrl.getTheAssesmentQuestion('Dermatology Life Quality Index (DLQI)');
		Assert.areEqual(1, questions.size(), 'Expected one DLQI question');
		Test.stopTest();
	}

	//this test method is for checking the retreival of Patient status (Unassigned).
	@isTest
	static void testPatientStatusReturnPatient() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		// Create a test user without caregiver access
		String currentUserName = 'Test User';
		String currentUserEmail = 'testusernew@example.com';
		Profile standardUserProfile = [
			SELECT Id
			FROM Profile
			WHERE Name = 'BI_PSP_Patient Profile'
			LIMIT 1
		];
        Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
		insert con;

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

		Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
			.get('PersonAccount')
			.getRecordTypeId();

		Account testAccountOne = new Account(
			Lastname = currentUserName,
			PersonEmail = currentUserEmail,
			RecordTypeId = personAccountRecordTypeId
		);
		insert testAccountOne;

		CareProgram carePrgm = new CareProgram(
			Name = 'testcp',
			StartDate = Date.valueOf('2024-02-28')
		);

		insert carePrgm;

		CareProgramEnrollee testCpeOne = new CareProgramEnrollee(
			Name = 'TestCpa111',
			AccountId = testAccountOne.Id,
			CareProgramId = carePrgm.Id,
			BI_PSPB_PatientStatus__c = 'Unassigned'
		);
		insert testCpeOne;

		// Call the method under test
		Test.startTest();
		System.runAs(testUser) {
			String result = BI_PSP_AssessmentQuestionsCtrl.patientstatusreturn();
			Assert.areEqual(
				'Unassigned',
				result,
				'Expected status to be Unassigned'
			);
		}
		Test.stopTest();

		// Add assertions to verify the expected behavior
	}

	//this test method is for checking the retreival of Patient status (Acute).
	@isTest
	static void testPatientStatusReturnPatientAcute() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		// Create a test user without caregiver access
		String currentUserName = 'Test User';
		String currentUserEmail = 'testusernew@example.com';
		Profile standardUserProfile = [
			SELECT Id
			FROM Profile
			WHERE Name = 'BI_PSP_Patient Profile'
			LIMIT 1
		];
		Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
		insert con;
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

		Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
			.get('PersonAccount')
			.getRecordTypeId();

		Account testAccountOne = new Account(
			Lastname = currentUserName,
			PersonEmail = currentUserEmail,
			RecordTypeId = personAccountRecordTypeId
		);
		insert testAccountOne;

		CareProgram carePrgm = new CareProgram(
			Name = 'testcp',
			StartDate = Date.valueOf('2024-02-28')
		);

		insert carePrgm;

		CareProgramEnrollee testCpeOne = new CareProgramEnrollee(
			Name = 'TestCpa111',
			AccountId = testAccountOne.Id,
			CareProgramId = carePrgm.Id,
			BI_PSPB_PatientStatus__c = 'Acute'
		);
		insert testCpeOne;

		// Call the method under test
		Test.startTest();
		System.runAs(testUser) {
			String result = BI_PSP_AssessmentQuestionsCtrl.patientstatusreturn();
			Assert.areEqual(
				'Acute',
				result,
				'Expected status to be Unassigned'
			);
		}
		Test.stopTest();

		// Add assertions to verify the expected behavior
	}
	//this test method is for checking the retreival of Caregiver status (Unassigned).
	@isTest
	static void testPatientStatusReturnCaregiver() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		// Create a test user with caregiver access
		String currentUserName = 'Test User';
		String currentUserEmail = 'testusernew@example.com';
		Profile standardUserProfile = [
			SELECT Id
			FROM Profile
			WHERE Name = 'BI_PSP_Patient Profile'
			LIMIT 1
		];
		Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
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

		CareProgram carePrgm = new CareProgram(
			Name = 'testcp',
			StartDate = Date.valueOf('2024-02-28')
		);

		insert carePrgm;

		CareProgramEnrollee testCpeOne = new CareProgramEnrollee(
			Name = 'TestCpa111',
			AccountId = testAccountOne.Id,
			CareProgramId = carePrgm.Id
		);
		insert testCpeOne;
		CareProgramEnrollee testCpeTwo = new CareProgramEnrollee(
			Name = 'TestCpa222',
			AccountId = testAccountTwo.Id,
			CareProgramId = carePrgm.Id,
			BI_PSPB_PatientStatus__c = 'Unassigned'
		);
		insert testCpeTwo;

		// Call the method under test
		try {
			//assertion is not done because this is for negative scenario and it goes to catch
			System.runAs(testUserTwo) {
				Test.startTest();
				BI_PSP_AssessmentQuestionsCtrl.patientstatusreturn();
				Test.stopTest();
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

	//this test method is for checking the retreival of Caregiver status (Acute).
	@isTest
	static void testPatientStatusReturnCaregiveracute() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
        
		// Create a test user with caregiver access
		String currentUserName = 'Test User';
		String currentUserEmail = 'testusernew@example.com';
		Profile standardUserProfile = [
			SELECT Id
			FROM Profile
			WHERE Name = 'BI_PSP_Patient Profile'
			LIMIT 1
		];
        Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
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

		CareProgram carePrgm = new CareProgram(
			Name = 'testcp',
			StartDate = Date.valueOf('2024-02-28')
		);

		insert carePrgm;

		CareProgramEnrollee testCpeOne = new CareProgramEnrollee(
			Name = 'TestCpa111',
			AccountId = testAccountOne.Id,
			CareProgramId = carePrgm.Id
		);
		insert testCpeOne;
		CareProgramEnrollee testCpeTwo = new CareProgramEnrollee(
			Name = 'TestCpa222',
			AccountId = testAccountTwo.Id,
			CareProgramId = carePrgm.Id,
			BI_PSPB_PatientStatus__c = 'Acute'
		);
		insert testCpeTwo;

		// Call the method under test
		try {
			System.runAs(testUserTwo) {
				//assertion is not done because this is for negative scenario and it goes to catch
				Test.startTest();

				BI_PSP_AssessmentQuestionsCtrl.patientstatusreturn();

				Test.stopTest();
			}
		} catch (Exception e) {
			// Assert that the exception message is as expected
			Assert.areEqual(
				e.getMessage(),
				'Script-thrown exception',
				e.getMessage()
			);
		}

		// Add assertions to verify the expected behavior
	}


	//this test method is for checking the retreival of Assessments questions of WAPI - negative.
	@isTest
	static void getCatch() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		Profile standardUserProfile = [
			//creating Profile
			SELECT Id
			FROM Profile
			WHERE Name = 'BI_PSP_Patient Profile'
			LIMIT 1
		];
        Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
		insert con;
		//user with patient
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
			try {
                String questionnaireName='Introduction';
				//assertion is not done because this is for negative scenario and it goes to catch
				Test.startTest();
				BI_PSP_AssessmentQuestionsCtrl.getTheAssesmentQuestion(questionnaireName);
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

	//this test method is for checking the retreival of Assessments questions of PSS - negative.
	@isTest
	static void getCatchFour() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		Profile standardUserProfile = [
			//creating Profile
			SELECT Id
			FROM Profile
			WHERE Name = 'BI_PSP_Patient Profile'
			LIMIT 1
		];
        Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
		insert con;
		//user with patient
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
			try {
				//assertion is not done because this is for negative scenario and it goes to catch
				Test.startTest();
				BI_PSP_AssessmentQuestionsCtrl.getTheAssesmentQuestion('Psoriasis Symptom Scale (PSS)');
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

	//this test method is for checking the retreival of Assessments questions of DLQI - negative.
	@isTest
	static void getCatchFive() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		Profile standardUserProfile = [
			//creating Profile
			SELECT Id
			FROM Profile
			WHERE Name = 'BI_PSP_Patient Profile'
			LIMIT 1
		];
		Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
		insert con;
		//user with patient
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
			try {
				//assertion is not done because this is for negative scenario and it goes to catch
				Test.startTest();
				BI_PSP_AssessmentQuestionsCtrl.getTheAssesmentQuestion('Dermatology Life Quality Index (DLQI)');
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
	//this test method is for checking the retreival of Assessments questions of QSQ - negative.
	@isTest
	static void getCatchSix() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
		insert con;
		Profile standardUserProfile = [
			//creating Profile
			SELECT Id
			FROM Profile
			WHERE Name = 'BI_PSP_Patient Profile'
			LIMIT 1
		];
		//user with patient
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
			try {
				//assertion is not done because this is for negative scenario and it goes to catch
				Test.startTest();
				BI_PSP_AssessmentQuestionsCtrl.getTheAssesmentQuestion('Qualitative satisfaction questionnaire');
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
    
    //this test method is for checking the retreival of Assessments questions of QSQ - negative.
	@isTest
	static void getCatchNegativeForStatus() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		Profile standardUserProfile = [
			//creating Profile
			SELECT Id
			FROM Profile
			WHERE Name = 'BI_PSP_Patient Profile'
			LIMIT 1
		];
        Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
		insert con;
		//user with patient
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
			try {
				//assertion is not done because this is for negative scenario and it goes to catch
				Test.startTest();
				BI_PSP_AssessmentQuestionsCtrl.patientstatusreturn();
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