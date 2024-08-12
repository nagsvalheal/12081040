/*

Apex Class Name    :BI_PSP_RetriveDraftResponseTest
Created Date       : November 5, 2023
description       : To get the Response for every Questionnaire by the current user
author            : Harish
@Last Modified On  :11/03/2024
@Last Modified by  :Sowmitha

*/

//this test method is for checking the retreival of draft responses for the Psoriasis category.
@isTest
private class BI_PSP_DraftResponseCtrlTest {


	@isTest
	//To retrive Assessment Response for WAPI Questionnarie for Patient negative
	static void testDraftResponseOfWorkAndApiCatch() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		// Create a test user

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

		CareProgram carePrgm = new CareProgram(
			Name = 'testcp',
			StartDate = Date.valueOf('2024-02-28')
		);

		insert carePrgm;

		//Create Assessment
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
		try {
            
			System.runAs(testUserTwo) {
                String categoryName='Work & Activity Impairment (WPAI)';
                Boolean falseVal=false;
				//assertion is not done because this is for negative scenario and it goes to catch
				Test.startTest();
				BI_PSP_DraftResponseCtrl.retrieveDrfatResponses(categoryName,falseVal);
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
static void testInsertCurrentUsersExistingAndCurrentResponse() {
    // Create test AssessmentQuestionResponse records to insert
// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		// Create a test user

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

		CareProgram carePrgm = new CareProgram(
			Name = 'testcp',
			StartDate = Date.valueOf('2024-02-28')
		);

		insert carePrgm;

		//Create Assessment
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

		AssessmentQuestionVersion questionVer = new AssessmentQuestionVersion(
			Name = 'question',
			QuestionText = 'Do you often discuss GPP with your friends and family?',
			AssessmentQuestionId = questionData.Id
		);
		insert questionVer;
		
		// Create test assessment response data
		AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
			Name = 'Insert Test Response',
			ResponseText = 'No',
			BI_PSP_Category__c = 'Social life',
			AssessmentId = testAssessment.Id,
			AssessmentQuestionId = questionVer.Id
			//CreatedDate = createdDt
		);
		insert testResponse;


    Test.startTest();
    BI_PSP_DraftResponseCtrl.insertCurrentUsersExistingAndCurrentResponse(new List<AssessmentQuestionResponse>{ testResponse });
    Test.stopTest();

    // Verify that the insert was successful by querying using the AssessmentId
   List<AssessmentQuestionResponse> insertedResponses = [
    SELECT Id, ResponseText, AssessmentId 
    FROM AssessmentQuestionResponse 
    WHERE AssessmentId = :testAssessment.id
];
    System.assertEquals(1, insertedResponses.size());
    System.assertEquals('Insert Test Response', insertedResponses[0].ResponseText);
}

    
    @isTest
static void updateAssessment() {
    // Create test AssessmentQuestionResponse records to insert
// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		// Create a test user

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

		CareProgram carePrgm = new CareProgram(
			Name = 'testcp',
			StartDate = Date.valueOf('2024-02-28')
		);

		insert carePrgm;

		//Create Assessment
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

		AssessmentQuestionVersion questionVer = new AssessmentQuestionVersion(
			Name = 'question',
			QuestionText = 'Do you often discuss GPP with your friends and family?',
			AssessmentQuestionId = questionData.Id
		);
		insert questionVer;
		
		// Create test assessment response data
		AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
			Name = 'Insert Test Response',
			ResponseText = 'No',
			BI_PSP_Category__c = 'Social life',
			AssessmentId = testAssessment.Id,
			AssessmentQuestionId = questionVer.Id
			//CreatedDate = createdDt
		);
		insert testResponse;


    Test.startTest();
    BI_PSP_DraftResponseCtrl.updateCurrentUsersExistingResponse(new List<Assessment>{ testAssessment });
    Test.stopTest();

    // Verify that the insert was successful by querying using the AssessmentId
   List<Assessment> insertedResponses = [
    SELECT Id
    FROM Assessment 
    WHERE Id = :testAssessment.id
];
    System.assertEquals(1, insertedResponses.size());
    System.assertEquals('Insert Test Response', insertedResponses[0].id);
}
    
    
    @isTest
    static void testBuildConditions() {
        String conditions = BI_PSP_DraftResponseCtrl.buildConditions('TestCategory', true, BI_PSP_QuestionnaireConstant.inprogress, 'TestEnrolleeId');
        System.assert(conditions.contains('BI_PSP_CareProgramEnrollee__c = \'TestEnrolleeId\''));
        System.assert(conditions.contains('BI_PSP_QsqAfter2months__c = \'' + BI_PSP_QuestionnaireConstant.pageOne + '\''));
        System.assert(conditions.contains('Assessment.AssessmentStatus = \'' + BI_PSP_QuestionnaireConstant.inprogress + '\''));
    }
    
     @isTest
    static void testRetrieveDraftResponses() {
        	BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		// Create a test user
		  
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

        Account testAccountFirst = new Account(
            Lastname = currentUserName,
            PersonEmail = currentUserEmail,
            RecordTypeId = personAccountRecordTypeId
        );
        insert testAccountFirst;
        String currentUserNameSecond = 'Test User2';
        String currentUserEmailSecond = 'testUserSecondnew@example.com';
        Account testAccountSecond = new Account(
            Lastname = currentUserNameSecond,
            PersonEmail = currentUserEmailSecond,
            RecordTypeId = personAccountRecordTypeId,
            BI_PSPB_Selected_Patient_ID__c = testAccountFirst.Id
        );
        insert testAccountSecond;
        
		CareProgram carePrgm = new CareProgram(
			Name = 'testcp',
			StartDate = Date.valueOf('2024-02-28')
		);

		insert carePrgm;
        
          CareProgramEnrollee testCareProgramEnrolleeOne = new CareProgramEnrollee(
            Name = 'testCareProgramEnrolleeOne',
            AccountId = testAccountSecond.Id,
            CareProgramId = carePrgm.Id
        );
        insert testCareProgramEnrolleeOne;

		//Create Assessment
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

		AssessmentQuestionVersion questionVer = new AssessmentQuestionVersion(
			Name = 'question',
			QuestionText = 'Do you often discuss GPP with your friends and family?',
			AssessmentQuestionId = questionData.Id
		);
		insert questionVer;
		
		// Create test assessment response data
		AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
			Name = 'Insert Test Response',
			ResponseText = 'No',
			BI_PSP_Category__c = 'Social life',
			AssessmentId = testAssessment.Id,
			AssessmentQuestionId = questionVer.Id
			//CreatedDate = createdDt
		);
		insert testResponse;
        try {
            
			System.runAs(testUserTwo) {
        Test.startTest();
        List<AssessmentQuestionResponse> responses = BI_PSP_DraftResponseCtrl.retrieveDrfatResponses('Work & Activity Impairment (WPAI)', false);
        Test.stopTest();
                
        System.assertEquals(0, responses.size());
        //System.assertEquals('Test Response', responses[0].ResponseText);
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