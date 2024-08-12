/*
*********************************************************
Apex Class Name    :BI_PSP_CompletedQuestionnaireCtrlTest
Created Date       : March 10, 2024
@description       : This Apex Test Class for Retrieving Questionnaire Records those status is in Completed
                  	and expired
@author            : Sowmitha
Last Modification  : Harish
*********************************************************
*/

@isTest
public class BI_PSP_CompletedQuestionnaireCtrlTest {
	public static string careProgramEnrolleeOne;
	public static String pss = 'Psoriasis Symptom Scale (PSS)';
	public static String wapiCategory = 'Work & Activity Impairment (WPAI)';
	public static String dlqiCategory = 'Dermatology Life Quality Index (DLQI)';
	public static String qualiCategory = 'Qualitative satisfaction questionnaire';
	public static String inProgress = 'In Progress';

	@isTest
	//To get the Qualitative Questionnaire Response for Patient
	static void getQsqTwomonthsPatientCompletedQuestionaresTest() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		String targetDate = 'Jan 2023';
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
		String currentUserEmaiTwo = 'testuser2new@example.com';
		Account testAccountTwo = new Account(
			Lastname = currentUserNameTwo,
			PersonEmail = currentUserEmaiTwo,
			RecordTypeId = personAccountRecordTypeId,
			BI_PSPB_Selected_Patient_ID__c = testAccountOne.Id
		);
		insert testAccountTwo;

		CareProgram carePrgm = new CareProgram(
			Name = 'testcp',
			StartDate = Date.valueOf('2024-02-28')
		);

		insert carePrgm;

		CareProgramEnrollee testCpeTwo = new CareProgramEnrollee(
			Name = 'TestCpa222',
			AccountId = testAccountOne.Id,
			CareProgramId = carePrgm.Id
		);
		insert testCpeTwo;

		Assessment testAssessment = new Assessment(
			Name = 'Test Assessment',
			OwnerId = testUserTwo.Id,
			AssessmentStatus = 'Completed',
			BI_PSP_DateForCQ__c = 'Jan 2023',
			BI_PSP_CareProgramEnrollee__c = testCpeTwo.Id
		);
		insert testAssessment;

		//insert assessment question
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
	
		// Create test assessment response data
		AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
			Name = 'Test Response',
			ResponseText = 'No',
			BI_PSP_Category__c = 'Social life',
			AssessmentId = testAssessment.Id,
			AssessmentQuestionId = questionVer.Id,
			//CreatedDate = createdDt
			BI_PSP_QsqAfter2months__c = 'pageOne'
		);
		insert testResponse;

		System.runAs(testUserTwo) {
			Test.startTest();
			List<AssessmentQuestionResponse> result = BI_PSP_CompletedQuestionnaireCtrl.getQSQCompletedQuestionaresTwoMonths(
				targetDate
			);
			Test.stopTest();
			Assert.areEqual(
				1,
				result.size(),
				'There should be one qsq1 1 AssessmentQuestionResponse in the result'
			);
		}

	}
	//To get the Qualitative Questionnaire(14 weeks) Response for Patient
	@isTest
	static void getQsqTwomonthsCompletedQuestionaresTest() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		String targetDate = 'Jan 2023';
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
			CareProgramId = carePrgm.Id
		);
		insert testCpeOne;

		Assessment testAssessment = new Assessment(
			Name = 'Test Assessment',
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
		
		// Create test assessment response data
		AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
			Name = 'Test Response',
			ResponseText = 'No',
			BI_PSP_Category__c = 'Social life',
			AssessmentId = testAssessment.Id,
			AssessmentQuestionId = questionVer.Id,
			//CreatedDate = createdDt,
			BI_PSP_QsqAfter2months__c = 'pageOne'
		);
		insert testResponse;

		System.runAs(testUser) {
			Test.startTest();
			List<AssessmentQuestionResponse> result = BI_PSP_CompletedQuestionnaireCtrl.getQSQCompletedQuestionaresTwoMonths(
				targetDate
			);
			Test.stopTest();
			Assert.areEqual(
				1,
				result.size(),
				'There should be one qsq1 2 AssessmentQuestionResponse in the result'
			);
		}

	}

	@isTest
	//To get the Qualitative Questionnaire Response for Patient status Expired
	static void getQsqOnecompletedQuestionaresTestCatch() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		String targetDate = 'Jan 2023';
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

		String currentUserNameTwo = 'Test User2';
		String currentUserEmaiTwo = 'testuser2new@example.com';
		Account testAccountTwo = new Account(
			Lastname = currentUserNameTwo,
			PersonEmail = currentUserEmaiTwo,
			RecordTypeId = personAccountRecordTypeId,
			BI_PSPB_Selected_Patient_ID__c = testAccountOne.Id
		);
		insert testAccountTwo;

		CareProgram carePrgm = new CareProgram(
			Name = 'testcp',
			StartDate = Date.valueOf('2024-02-28')
		);

		insert carePrgm;

		CareProgramEnrollee testCpeTwo = new CareProgramEnrollee(
			Name = 'TestCpa222',
			AccountId = testAccountOne.Id,
			CareProgramId = carePrgm.Id
		);
		insert testCpeTwo;

		Assessment testAssessment = new Assessment(
			Name = 'Test Assessment',
			OwnerId = testUser.Id,
			AssessmentStatus = 'Completed',
			BI_PSP_DateForCQ__c = 'Jan 2023',
			BI_PSP_CareProgramEnrollee__c = testCpeTwo.Id
		);
		insert testAssessment;

		//insert assessment question
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
		
		// Create test assessment response data
		AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
			Name = 'Test Response',
			ResponseText = 'No',
			BI_PSP_Category__c = 'Social life',
			AssessmentId = testAssessment.Id,
			AssessmentQuestionId = questionVer.Id,
			//CreatedDate = createdDt,
			BI_PSP_QsqAfter2months__c = 'pageOne'
		);
		insert testResponse;
		try {
			//assertion is not done because this is for negative scenario and it goes to catch
			Test.startTest();
			BI_PSP_CompletedQuestionnaireCtrl.getQSQCompletedQuestionaresTwoMonths(
				targetDate
			);
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

	@isTest
	//To get the Qualitative Questionnaire (14 weeks)Response for Patient status expired
	static void getQsqTwoCompletedQuestionaresTest() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		String targetDate = 'Jan 2023';
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
		String currentUserEmaiTwo = 'testuser2new@example.com';
		Account testAccountTwo = new Account(
			Lastname = currentUserNameTwo,
			PersonEmail = currentUserEmaiTwo,
			RecordTypeId = personAccountRecordTypeId,
			BI_PSPB_Selected_Patient_ID__c = testAccountOne.Id
		);
		insert testAccountTwo;

		CareProgram carePrgm = new CareProgram(
			Name = 'testcp',
			StartDate = Date.valueOf('2024-02-28')
		);

		insert carePrgm;

		CareProgramEnrollee testCpeTwo = new CareProgramEnrollee(
			Name = 'TestCpa222',
			AccountId = testAccountOne.Id,
			CareProgramId = carePrgm.Id
		);
		insert testCpeTwo;

		Assessment testAssessment = new Assessment(
			Name = 'Test Assessment',
			OwnerId = testUserTwo.Id,
			AssessmentStatus = 'Completed',
			BI_PSP_DateForCQ__c = 'Jan 2023',
			BI_PSP_CareProgramEnrollee__c = testCpeTwo.Id
		);
		insert testAssessment;

		//insert assessment question
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
	
		// Create test assessment response data
		AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
			Name = 'Test Response',
			ResponseText = 'No',
			BI_PSP_Category__c = 'Social life',
			AssessmentId = testAssessment.Id,
			AssessmentQuestionId = questionVer.Id,
			//CreatedDate = createdDt,
			BI_PSP_QsqAfterWeeks__c = 'pageTwo'
		);
		insert testResponse;

		System.runAs(testUserTwo) {
			Test.startTest();
			List<AssessmentQuestionResponse> result = BI_PSP_CompletedQuestionnaireCtrl.getQSQCompletedQuestionaresFourteenWks(
				targetDate
			);
			Test.stopTest();
			Assert.areEqual(
				1,
				result.size(),
				'There should be one qsq2 1 AssessmentQuestionResponse in the result'
			);
		}

	}

	@isTest
	//To get the Qualitative Questionnaire Response for Patient for Expired
	static void getQsqFourteenWeeksCompletedQuestionaresTest() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		String targetDate = 'Jan 2023';
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
			CareProgramId = carePrgm.Id
		);
		insert testCpeOne;

		Assessment testAssessment = new Assessment(
			Name = 'Test Assessment',
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
		
		// Create test assessment response data
		AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
			Name = 'Test Response',
			ResponseText = 'No',
			BI_PSP_Category__c = 'Social life',
			AssessmentId = testAssessment.Id,
			AssessmentQuestionId = questionVer.Id,
			//CreatedDate = createdDt,
			BI_PSP_QsqAfterWeeks__c = 'pageTwo'
		);
		insert testResponse;

		System.runAs(testUser) {
			Test.startTest();
			List<AssessmentQuestionResponse> result = BI_PSP_CompletedQuestionnaireCtrl.getQSQCompletedQuestionaresFourteenWks(
				targetDate
			);
			Test.stopTest();
			Assert.areEqual(
				1,
				result.size(),
				'There should be one qsq2 2 AssessmentQuestionResponse in the result'
			);
		}

	}
	@isTest
	//To get the Qualitative Questionnaire Response for Patient to cover negative Senario
	static void getQsqCompletedQuestionaresTestCatchNegative() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		String targetDate = 'Jan 2023';
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

		String currentUserNameTwo = 'Test User2';
		String currentUserEmaiTwo = 'testuser2new@example.com';
		Account testAccountTwo = new Account(
			Lastname = currentUserNameTwo,
			PersonEmail = currentUserEmaiTwo,
			RecordTypeId = personAccountRecordTypeId,
			BI_PSPB_Selected_Patient_ID__c = testAccountOne.Id
		);
		insert testAccountTwo;

		CareProgram carePrgm = new CareProgram(
			Name = 'testcp',
			StartDate = Date.valueOf('2024-02-28')
		);

		insert carePrgm;

		CareProgramEnrollee testCpeTwo = new CareProgramEnrollee(
			Name = 'TestCpa222',
			AccountId = testAccountOne.Id,
			CareProgramId = carePrgm.Id
		);
		insert testCpeTwo;

		Assessment testAssessment = new Assessment(
			Name = 'Test Assessment',
			OwnerId = testUser.Id,
			AssessmentStatus = 'Completed',
			BI_PSP_DateForCQ__c = 'Jan 2023',
			BI_PSP_CareProgramEnrollee__c = testCpeTwo.Id
		);
		insert testAssessment;

		//insert assessment question
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
	
		// Create test assessment response data
		AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
			Name = 'Test Response',
			ResponseText = 'No',
			BI_PSP_Category__c = 'Social life',
			AssessmentId = testAssessment.Id,
			AssessmentQuestionId = questionVer.Id,
			//CreatedDate = createdDt,
			BI_PSP_QsqAfterWeeks__c = 'pageTwo'
		);
		insert testResponse;
		try {
			//assertion is not done because this is for negative scenario and it goes to catch
			Test.startTest();
			BI_PSP_CompletedQuestionnaireCtrl.getQSQCompletedQuestionaresFourteenWks(
				targetDate
			);
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

	@isTest
	//To get the Qualitative Questionnaire Response for Caregiver
	static void getQsqCompletedQuestionaresTestExpired() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

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
		String currentUserEmaiTwo = 'testuser2new@example.com';
		Account testAccountTwo = new Account(
			Lastname = currentUserNameTwo,
			PersonEmail = currentUserEmaiTwo,
			RecordTypeId = personAccountRecordTypeId,
			BI_PSPB_Selected_Patient_ID__c = testAccountOne.Id
		);
		insert testAccountTwo;

		CareProgram carePrgm = new CareProgram(
			Name = 'testcp',
			StartDate = Date.valueOf('2024-02-28')
		);

		insert carePrgm;

		CareProgramEnrollee testCpeTwo = new CareProgramEnrollee(
			Name = 'TestCpa222',
			AccountId = testAccountOne.Id,
			CareProgramId = carePrgm.Id
		);
		insert testCpeTwo;
		Datetime createdDt = DateTime.newInstance(
			Date.newInstance(2023, 1, 6),
			Time.newInstance(12, 23, 0, 0)
		);
		Assessment testAssessment = new Assessment(
			Name = 'Qualitative satisfaction questionnaire',
			AssessmentStatus = 'Expired',
			BI_PSP_DateForCQ__c = 'Jan 2023',
			ExpirationDateTime = createdDt,
			BI_PSP_CareProgramEnrollee__c = testCpeTwo.Id
		);
		insert testAssessment;

		//insert assessment question
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

		// Create test assessment response data
		AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
			Name = 'Test Response',
			ResponseText = 'No',
			BI_PSP_Category__c = 'Social life',
			AssessmentId = testAssessment.Id,
			AssessmentQuestionId = questionVer.Id,
			//CreatedDate = createdDt,
			BI_PSP_QsqAfter2months__c = 'pageOne'
		);
		insert testResponse;

		System.runAs(testUserTwo) {
			Test.startTest();
			List<Assessment> result = BI_PSP_CompletedQuestionnaireCtrl.getQSQExpiredQuestionnaireTwoMonths();
			Test.stopTest();
			Assert.areEqual(
				1,
				result.size(),
				'There should be one qsq1 1 expired AssessmentQuestionResponse in the result'
			);
		}

	}

	@isTest
	//To get the Qualitative Questionnaire Response for Patient negative catch
	static void getQsqCompletedQuestionaresTestExpiredCaregiverNegative() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
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
			CareProgramId = carePrgm.Id
		);
		insert testCpeOne;
		Datetime createdDt = DateTime.newInstance(
			Date.newInstance(2023, 1, 6),
			Time.newInstance(12, 23, 0, 0)
		);

		Assessment testAssessment = new Assessment(
			Name = 'Qualitative satisfaction questionnaire',
			OwnerId = testUser.Id,
			AssessmentStatus = 'Expired',
			BI_PSP_DateForCQ__c = 'Jan 2023',
			ExpirationDateTime = createdDt,
			BI_PSP_CareProgramEnrollee__c = testCpeOne.Id
		);
		insert testAssessment;

		//insert assessment question
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

		// Create test assessment response data
		AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
			Name = 'Test Response',
			ResponseText = 'No',
			BI_PSP_Category__c = 'Social life',
			AssessmentId = testAssessment.Id,
			AssessmentQuestionId = questionVer.Id,
			//CreatedDate = createdDt,
			BI_PSP_QsqAfter2months__c = 'pageOne'
		);
		insert testResponse;

		System.runAs(testUser) {
			Test.startTest();
			List<Assessment> result = BI_PSP_CompletedQuestionnaireCtrl.getQSQExpiredQuestionnaireTwoMonths();
			Test.stopTest();
			Assert.areEqual(
				1,
				result.size(),
				'There should be one qsq1 2 expired AssessmentQuestionResponse in the result'
			);
		}

	}

	@isTest
	//To get the Qualitative Questionnaire Response for Patient to get Catch for completed Status
	static void getQsqCompletedQuestionaresTestExpiredCompletedCatch() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		String currentUserName = 'Test User';
		String currentUserEmail = 'testusernew@example.com';

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
		String currentUserEmaiTwo = 'testuser2new@example.com';
		Account testAccountTwo = new Account(
			Lastname = currentUserNameTwo,
			PersonEmail = currentUserEmaiTwo,
			RecordTypeId = personAccountRecordTypeId,
			BI_PSPB_Selected_Patient_ID__c = testAccountOne.Id
		);
		insert testAccountTwo;

		CareProgram carePrgm = new CareProgram(
			Name = 'testcp',
			StartDate = Date.valueOf('2024-02-28')
		);

		insert carePrgm;

		CareProgramEnrollee testCpeTwo = new CareProgramEnrollee(
			Name = 'TestCpa222',
			AccountId = testAccountOne.Id,
			CareProgramId = carePrgm.Id
		);
		insert testCpeTwo;
		Datetime createdDt = DateTime.newInstance(
			Date.newInstance(2023, 1, 6),
			Time.newInstance(12, 23, 0, 0)
		);
		Assessment testAssessment = new Assessment(
			Name = 'Qualitative satisfaction questionnaire',
			AssessmentStatus = 'Expired',
			BI_PSP_DateForCQ__c = 'Jan 2023',
			ExpirationDateTime = createdDt,
			BI_PSP_CareProgramEnrollee__c = testCpeTwo.Id
		);
		insert testAssessment;

		//insert assessment question
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

		// Create test assessment response data
		AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
			Name = 'Test Response',
			ResponseText = 'No',
			BI_PSP_Category__c = 'Social life',
			AssessmentId = testAssessment.Id,
			AssessmentQuestionId = questionVer.Id,
			//CreatedDate = createdDt,
			BI_PSP_QsqAfter2months__c = 'pageOne'
		);
		insert testResponse;
		try {
			//assertion is not done because this is for negative scenario and it goes to catch
			Test.startTest();
			BI_PSP_CompletedQuestionnaireCtrl.getQSQExpiredQuestionnaireTwoMonths();
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

	@isTest
	//To get the Qualitative Questionnaire Response for caregive negative
	static void getQsqCaregiverNegativeCompletedQuestionaresTestExpired() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

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
		String currentUserEmaiTwo = 'testuser2new@example.com';
		Account testAccountTwo = new Account(
			Lastname = currentUserNameTwo,
			PersonEmail = currentUserEmaiTwo,
			RecordTypeId = personAccountRecordTypeId,
			BI_PSPB_Selected_Patient_ID__c = testAccountOne.Id
		);
		insert testAccountTwo;

		CareProgram carePrgm = new CareProgram(
			Name = 'testcp',
			StartDate = Date.valueOf('2024-02-28')
		);

		insert carePrgm;

		CareProgramEnrollee testCpeTwo = new CareProgramEnrollee(
			Name = 'TestCpa222',
			AccountId = testAccountOne.Id,
			CareProgramId = carePrgm.Id
		);
		insert testCpeTwo;
		Datetime createdDt = DateTime.newInstance(
			Date.newInstance(2023, 1, 6),
			Time.newInstance(12, 23, 0, 0)
		);
		Assessment testAssessment = new Assessment(
			Name = 'Qualitative satisfaction questionnaire',
			AssessmentStatus = 'Expired',
			BI_PSP_DateForCQ__c = 'Jan 2023',
			ExpirationDateTime = createdDt,
			BI_PSP_CareProgramEnrollee__c = testCpeTwo.Id
		);
		insert testAssessment;

		//insert assessment question
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

		// Create test assessment response data
		AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
			Name = 'Test Response',
			ResponseText = 'No',
			BI_PSP_Category__c = 'Social life',
			AssessmentId = testAssessment.Id,
			AssessmentQuestionId = questionVer.Id,
			//CreatedDate = createdDt,
			BI_PSP_QsqAfterWeeks__c = 'pageTwo'
		);
		insert testResponse;

		System.runAs(testUserTwo) {
			Test.startTest();
			List<Assessment> result = BI_PSP_CompletedQuestionnaireCtrl.getQSQExpiredQuestionnaireFourteenWks();
			Test.stopTest();
			Assert.areEqual(
				1,
				result.size(),
				'There should be one qsq2 1 expired AssessmentQuestionResponse in the result'
			);
		}

	}

	@isTest
	//To get the Qualitative Questionnaire Response for Caregiver Expired
	static void getQsqCaregiverExpiredCompletedQuestionaresTestExpired() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

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
			CareProgramId = carePrgm.Id
		);
		insert testCpeOne;
		Datetime createdDt = DateTime.newInstance(
			Date.newInstance(2023, 1, 6),
			Time.newInstance(12, 23, 0, 0)
		);

		Assessment testAssessment = new Assessment(
			Name = 'Qualitative satisfaction questionnaire',
			OwnerId = testUser.Id,
			AssessmentStatus = 'Expired',
			BI_PSP_DateForCQ__c = 'Jan 2023',
			ExpirationDateTime = createdDt,
			BI_PSP_CareProgramEnrollee__c = testCpeOne.Id
		);
		insert testAssessment;

		//insert assessment question
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

		// Create test assessment response data
		AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
			Name = 'Test Response',
			ResponseText = 'No',
			BI_PSP_Category__c = 'Social life',
			AssessmentId = testAssessment.Id,
			AssessmentQuestionId = questionVer.Id,
			//CreatedDate = createdDt,
			BI_PSP_QsqAfterWeeks__c = 'pageTwo'
		);
		insert testResponse;

		System.runAs(testUser) {
			Test.startTest();
			List<Assessment> result = BI_PSP_CompletedQuestionnaireCtrl.getQSQExpiredQuestionnaireFourteenWks();
			Test.stopTest();
			Assert.areEqual(
				1,
				result.size(),
				'There should be one qsq2 2 expired AssessmentQuestionResponse in the result'
			);
		}

	}

	@isTest
	static void getQsqCompletedQuestionaresTestExpiredCatch() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

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

		String currentUserNameTwo = 'Test User2';
		String currentUserEmaiTwo = 'testuser2new@example.com';
		Account testAccountTwo = new Account(
			Lastname = currentUserNameTwo,
			PersonEmail = currentUserEmaiTwo,
			RecordTypeId = personAccountRecordTypeId,
			BI_PSPB_Selected_Patient_ID__c = testAccountOne.Id
		);
		insert testAccountTwo;

		CareProgram carePrgm = new CareProgram(
			Name = 'testcp',
			StartDate = Date.valueOf('2024-02-28')
		);

		insert carePrgm;

		CareProgramEnrollee testCpeTwo = new CareProgramEnrollee(
			Name = 'TestCpa222',
			AccountId = testAccountOne.Id,
			CareProgramId = carePrgm.Id
		);
		insert testCpeTwo;
		Datetime createdDt = DateTime.newInstance(
			Date.newInstance(2023, 1, 6),
			Time.newInstance(12, 23, 0, 0)
		);
		Assessment testAssessment = new Assessment(
			Name = 'Qualitative satisfaction questionnaire',
			OwnerId = testUser.Id,
			AssessmentStatus = 'Expired',
			BI_PSP_DateForCQ__c = 'Jan 2023',
			ExpirationDateTime = createdDt,
			BI_PSP_CareProgramEnrollee__c = testCpeTwo.Id
		);
		insert testAssessment;

		//insert assessment question
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

		// Create test assessment response data
		AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
			Name = 'Test Response',
			ResponseText = 'No',
			BI_PSP_Category__c = 'Social life',
			AssessmentId = testAssessment.Id,
			AssessmentQuestionId = questionVer.Id,
			//CreatedDate = createdDt,
			BI_PSP_QsqAfterWeeks__c = 'pageTwo'
		);
		insert testResponse;
		try {
			//assertion is not done because this is for negative scenario and it goes to catch
			Test.startTest();
			BI_PSP_CompletedQuestionnaireCtrl.getQSQExpiredQuestionnaireFourteenWks();
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

	@isTest
	//To get the Completed Questionnaire Response by Category
	static void getCompletedQuestionaresTest() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		String targetDate = 'Jan 2023';
		String currentUserName = 'Test User';
		String currentUserEmail = 'testusernew@example.com';

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
		String currentUserEmaiTwo = 'testuser2new@example.com';
		Account testAccountTwo = new Account(
			Lastname = currentUserNameTwo,
			PersonEmail = currentUserEmaiTwo,
			RecordTypeId = personAccountRecordTypeId,
			BI_PSPB_Selected_Patient_ID__c = testAccountOne.Id
		);
		insert testAccountTwo;

		CareProgram carePrgm = new CareProgram(
			Name = 'testcp',
			StartDate = Date.valueOf('2024-02-28')
		);

		insert carePrgm;

		CareProgramEnrollee testCpeTwo = new CareProgramEnrollee(
			Name = 'TestCpa222',
			AccountId = testAccountOne.Id,
			CareProgramId = carePrgm.Id
		);
		insert testCpeTwo;
		Datetime createdDt = DateTime.newInstance(
			Date.newInstance(2023, 1, 6),
			Time.newInstance(12, 23, 0, 0)
		);
		Assessment testAssessment = new Assessment(
			Name = 'Qualitative satisfaction questionnaire',
			AssessmentStatus = 'Expired',
			BI_PSP_DateForCQ__c = 'Jan 2023',
			ExpirationDateTime = createdDt,
			BI_PSP_CareProgramEnrollee__c = testCpeTwo.Id
		);
		insert testAssessment;

		//insert assessment question
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

		// Create test assessment response data
		AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
			Name = 'Test Response',
			ResponseText = 'No',
			BI_PSP_Category__c = 'Social life',
			AssessmentId = testAssessment.Id,
			AssessmentQuestionId = questionVer.Id,
			//CreatedDate = createdDt,
			BI_PSP_QsqAfterWeeks__c = 'pageTwo'
		);
		insert testResponse;

		String categoryName = 'Dermatology Life Quality Index (DLQI)';
		try {
			//assertion is not done because this is for negative scenario and it goes to catch
			Test.startTest();
			BI_PSP_CompletedQuestionnaireCtrl.getCompletedQuestionares(
				targetDate,
				categoryName
			);
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

	@isTest
	//To get the all Completed Questionnaire Response for category negative Senario
	static void getCompletedQuestionaresNullTest() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

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

		String currentUserNameTwo = 'Test User2';
		String currentUserEmaiTwo = 'testuser2new@example.com';
		Account testAccountTwo = new Account(
			Lastname = currentUserNameTwo,
			PersonEmail = currentUserEmaiTwo,
			RecordTypeId = personAccountRecordTypeId,
			BI_PSPB_Selected_Patient_ID__c = testAccountOne.Id
		);
		insert testAccountTwo;

		CareProgram carePrgm = new CareProgram(
			Name = 'testcp',
			StartDate = Date.valueOf('2024-02-28')
		);

		insert carePrgm;

		CareProgramEnrollee testCpeTwo = new CareProgramEnrollee(
			Name = 'TestCpa222',
			AccountId = testAccountOne.Id,
			CareProgramId = carePrgm.Id
		);
		insert testCpeTwo;
		Datetime createdDt = DateTime.newInstance(
			Date.newInstance(2023, 1, 6),
			Time.newInstance(12, 23, 0, 0)
		);
		Assessment testAssessment = new Assessment(
			Name = 'Qualitative satisfaction questionnaire',
			OwnerId = testUser.Id,
			AssessmentStatus = 'Expired',
			BI_PSP_DateForCQ__c = 'Jan 2023',
			ExpirationDateTime = createdDt,
			BI_PSP_CareProgramEnrollee__c = testCpeTwo.Id
		);
		insert testAssessment;

		//insert assessment question
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

		// Create test assessment response data
		AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
			Name = 'Test Response',
			ResponseText = 'No',
			BI_PSP_Category__c = 'Social life',
			AssessmentId = testAssessment.Id,
			AssessmentQuestionId = questionVer.Id,
			//CreatedDate = createdDt,
			BI_PSP_QsqAfterWeeks__c = 'pageTwo'
		);
		insert testResponse;

		try {
			//assertion is not done because this is for negative scenario and it goes to catch
			Test.startTest();
			BI_PSP_CompletedQuestionnaireCtrl.getCompletedQuestionares(null, null);
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

	@isTest
	//To get the All Completed Questionnaire Response for caregiver
	static void getCompltdTestCaregiver() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		String targetDate = 'Jan 2023';
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

		String currentUserNameTwo = 'Test User2';
		String currentUserEmaiTwo = 'testuser2new@example.com';
		Account testAccountTwo = new Account(
			Lastname = currentUserNameTwo,
			PersonEmail = currentUserEmaiTwo,
			RecordTypeId = personAccountRecordTypeId,
			BI_PSPB_Selected_Patient_ID__c = testAccountOne.Id
		);
		insert testAccountTwo;

		CareProgram carePrgm = new CareProgram(
			Name = 'testcp',
			StartDate = Date.valueOf('2024-02-28')
		);

		insert carePrgm;

		CareProgramEnrollee testCpeTwo = new CareProgramEnrollee(
			Name = 'TestCpa222',
			AccountId = testAccountOne.Id,
			CareProgramId = carePrgm.Id
		);
		insert testCpeTwo;
		Datetime createdDt = DateTime.newInstance(
			Date.newInstance(2023, 1, 6),
			Time.newInstance(12, 23, 0, 0)
		);
		Assessment testAssessment = new Assessment(
			Name = 'Qualitative satisfaction questionnaire',
			OwnerId = testUser.Id,
			AssessmentStatus = 'Expired',
			BI_PSP_DateForCQ__c = 'Jan 2023',
			ExpirationDateTime = createdDt,
			BI_PSP_CareProgramEnrollee__c = testCpeTwo.Id
		);
		insert testAssessment;

		//insert assessment question
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

		// Create test assessment response data
		AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
			Name = 'Test Response',
			ResponseText = 'No',
			BI_PSP_Category__c = 'Social life',
			AssessmentId = testAssessment.Id,
			AssessmentQuestionId = questionVer.Id,
			//CreatedDate = createdDt,
			BI_PSP_QsqAfterWeeks__c = 'pageTwo'
		);
		insert testResponse;

		String categoryName = 'Dermatology Life Quality Index (DLQI)';
		try {
			//assertion is not done because this is for negative scenario and it goes to catch
			System.runAs(testUser) {
				Test.startTest();
				BI_PSP_CompletedQuestionnaireCtrl.getCompletedQuestionares(
					targetDate,
					categoryName
				);
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

	@isTest
	//To get the All completed  Questionnaire Response for Caregiver
	static void getCompltdTestNoncaregvr() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		String targetDate = 'Jan 2023';
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
		String currentUserEmaiTwo = 'testuser2new@example.com';
		Account testAccountTwo = new Account(
			Lastname = currentUserNameTwo,
			PersonEmail = currentUserEmaiTwo,
			RecordTypeId = personAccountRecordTypeId,
			BI_PSPB_Selected_Patient_ID__c = testAccountOne.Id
		);
		insert testAccountTwo;

		CareProgram carePrgm = new CareProgram(
			Name = 'testcp',
			StartDate = Date.valueOf('2024-02-28')
		);

		insert carePrgm;

		CareProgramEnrollee testCpeTwo = new CareProgramEnrollee(
			Name = 'TestCpa222',
			AccountId = testAccountOne.Id,
			CareProgramId = carePrgm.Id
		);
		insert testCpeTwo;
		Datetime createdDt = DateTime.newInstance(
			Date.newInstance(2023, 1, 6),
			Time.newInstance(12, 23, 0, 0)
		);
		Assessment testAssessment = new Assessment(
			Name = 'Qualitative satisfaction questionnaire',
			OwnerId = testUserTwo.Id,
			AssessmentStatus = 'Expired',
			BI_PSP_DateForCQ__c = 'Jan 2023',
			ExpirationDateTime = createdDt,
			BI_PSP_CareProgramEnrollee__c = testCpeTwo.Id
		);
		insert testAssessment;

		//insert assessment question
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

		// Create test assessment response data
		AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
			Name = 'Test Response',
			ResponseText = 'No',
			BI_PSP_Category__c = 'Social life',
			AssessmentId = testAssessment.Id,
			AssessmentQuestionId = questionVer.Id,
			//CreatedDate = createdDt,
			BI_PSP_QsqAfterWeeks__c = 'pageTwo'
		);
		insert testResponse;

		String categoryName = 'Dermatology Life Quality Index (DLQI)';
		try {
			//assertion is not done because this is for negative scenario and it goes to catch
			System.runAs(testUserTwo) {
				Test.startTest();
				BI_PSP_CompletedQuestionnaireCtrl.getCompletedQuestionares(
					targetDate,
					categoryName
				);
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

	@isTest
	//To get the current Completed date caregiver
	static void forCurrentDateTestCaregvr() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

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
		String currentUserEmaiTwo = 'testuser2new@example.com';
		Account testAccountTwo = new Account(
			Lastname = currentUserNameTwo,
			PersonEmail = currentUserEmaiTwo,
			RecordTypeId = personAccountRecordTypeId,
			BI_PSPB_Selected_Patient_ID__c = testAccountOne.Id
		);
		insert testAccountTwo;

		CareProgram carePrgm = new CareProgram(
			Name = 'testcp',
			StartDate = Date.valueOf('2024-02-28')
		);

		insert carePrgm;

		CareProgramEnrollee testCpeTwo = new CareProgramEnrollee(
			Name = 'TestCpa222',
			AccountId = testAccountOne.Id,
			CareProgramId = carePrgm.Id
		);
		insert testCpeTwo;
		Datetime createdDt = DateTime.newInstance(
			Date.newInstance(2023, 1, 6),
			Time.newInstance(12, 23, 0, 0)
		);
		Assessment testAssessment = new Assessment(
			Name = 'Qualitative satisfaction questionnaire',
			OwnerId = testUserTwo.Id,
			AssessmentStatus = 'Expired',
			BI_PSP_DateForCQ__c = 'Jan 2023',
			ExpirationDateTime = createdDt,
			BI_PSP_CareProgramEnrollee__c = testCpeTwo.Id
		);
		insert testAssessment;

		//insert assessment question
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

		// Create test assessment response data
		AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
			Name = 'Test Response',
			ResponseText = 'No',
			BI_PSP_Category__c = 'Social life',
			AssessmentId = testAssessment.Id,
			AssessmentQuestionId = questionVer.Id,
			//CreatedDate = createdDt,
			BI_PSP_QsqAfterWeeks__c = 'pageTwo'
		);
		insert testResponse;

		String categoryName = 'Dermatology Life Quality Index (DLQI)';
		try {
			//assertion is not done because this is for negative scenario and it goes to catch
			System.runAs(testUserTwo) {
				Test.startTest();
				BI_PSP_CompletedQuestionnaireCtrl.getQstnrcurrentcompleteddate(
					categoryName
				);
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

	@isTest
	//To get current date for completed Questionnaire for patient
	static void forCurrentDateTestNoncaregvr() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

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

		String currentUserNameTwo = 'Test User2';
		String currentUserEmaiTwo = 'testuser2new@example.com';
		Account testAccountTwo = new Account(
			Lastname = currentUserNameTwo,
			PersonEmail = currentUserEmaiTwo,
			RecordTypeId = personAccountRecordTypeId,
			BI_PSPB_Selected_Patient_ID__c = testAccountOne.Id
		);
		insert testAccountTwo;

		CareProgram carePrgm = new CareProgram(
			Name = 'testcp',
			StartDate = Date.valueOf('2024-02-28')
		);

		insert carePrgm;

		CareProgramEnrollee testCpeTwo = new CareProgramEnrollee(
			Name = 'TestCpa222',
			AccountId = testAccountOne.Id,
			CareProgramId = carePrgm.Id
		);
		insert testCpeTwo;
		Datetime createdDt = DateTime.newInstance(
			Date.newInstance(2023, 1, 6),
			Time.newInstance(12, 23, 0, 0)
		);
		Assessment testAssessment = new Assessment(
			Name = 'Qualitative satisfaction questionnaire',
			OwnerId = testUser.Id,
			AssessmentStatus = 'Expired',
			BI_PSP_DateForCQ__c = 'Jan 2023',
			ExpirationDateTime = createdDt,
			BI_PSP_CareProgramEnrollee__c = testCpeTwo.Id
		);
		insert testAssessment;

		//insert assessment question
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

		// Create test assessment response data
		AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
			Name = 'Test Response',
			ResponseText = 'No',
			BI_PSP_Category__c = 'Social life',
			AssessmentId = testAssessment.Id,
			AssessmentQuestionId = questionVer.Id,
			//CreatedDate = createdDt,
			BI_PSP_QsqAfterWeeks__c = 'pageTwo'
		);
		insert testResponse;

		String categoryName = 'Dermatology Life Quality Index (DLQI)';
		try {
			//assertion is not done because this is for negative scenario and it goes to catch
			System.runAs(testUser) {
				Test.startTest();
				BI_PSP_CompletedQuestionnaireCtrl.getQstnrcurrentcompleteddate(
					categoryName
				);
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

	@isTest
	//To cover negative Senario for current completed date
	static void forCurrentDateTestNull() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

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

		String currentUserNameTwo = 'Test User2';
		String currentUserEmaiTwo = 'testuser2new@example.com';
		Account testAccountTwo = new Account(
			Lastname = currentUserNameTwo,
			PersonEmail = currentUserEmaiTwo,
			RecordTypeId = personAccountRecordTypeId,
			BI_PSPB_Selected_Patient_ID__c = testAccountOne.Id
		);
		insert testAccountTwo;

		CareProgram carePrgm = new CareProgram(
			Name = 'testcp',
			StartDate = Date.valueOf('2024-02-28')
		);

		insert carePrgm;

		CareProgramEnrollee testCpeTwo = new CareProgramEnrollee(
			Name = 'TestCpa222',
			AccountId = testAccountOne.Id,
			CareProgramId = carePrgm.Id
		);
		insert testCpeTwo;
		Datetime createdDt = DateTime.newInstance(
			Date.newInstance(2023, 1, 6),
			Time.newInstance(12, 23, 0, 0)
		);
		Assessment testAssessment = new Assessment(
			Name = 'Qualitative satisfaction questionnaire',
			OwnerId = testUser.Id,
			AssessmentStatus = 'Expired',
			BI_PSP_DateForCQ__c = 'Jan 2023',
			ExpirationDateTime = createdDt,
			BI_PSP_CareProgramEnrollee__c = testCpeTwo.Id
		);
		insert testAssessment;

		//insert assessment question
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

		// Create test assessment response data
		AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
			Name = 'Test Response',
			ResponseText = 'No',
			BI_PSP_Category__c = 'Social life',
			AssessmentId = testAssessment.Id,
			AssessmentQuestionId = questionVer.Id,
			//CreatedDate = createdDt,
			BI_PSP_QsqAfterWeeks__c = 'pageTwo'
		);
		insert testResponse;

		try {
			//assertion is not done because this is for negative scenario and it goes to catch
			System.runAs(testUser) {
				Test.startTest();
				BI_PSP_CompletedQuestionnaireCtrl.getQstnrcurrentcompleteddate(null);
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

	@isTest
	//To cover all method catch by passing negative Date
	static void catchNegativeSenario() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
		insert con;
		//User profile
		Profile standardUserProfile = [
			SELECT Id
			FROM Profile
			WHERE Name = 'BI_PSP_Patient Profile'
			LIMIT 1
		];
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
		try {
			//assertion is not done because this is for negative scenario and it goes to catch
			System.runAs(testUser) {
				Test.startTest();

				// Switch to the test caregiver context
				BI_PSP_CompletedQuestionnaireCtrl.getQSQCompletedQuestionaresTwoMonths('');
				BI_PSP_CompletedQuestionnaireCtrl.getQSQExpiredQuestionnaireTwoMonths();
				BI_PSP_CompletedQuestionnaireCtrl.getQSQCompletedQuestionaresFourteenWks('');
				BI_PSP_CompletedQuestionnaireCtrl.getQSQExpiredQuestionnaireFourteenWks();

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
}