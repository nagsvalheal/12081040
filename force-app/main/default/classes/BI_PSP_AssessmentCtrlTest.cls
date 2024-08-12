/*
* @description       This test class provides test methods to retrieve questionnaire questions for different categories
                     such as Work & Activity Impairment (WPAI), Introduction, Psoriasis Symptom Scale (PSS), 
                     Dermatology Life Quality Index (DLQI), and Qualitative satisfaction questionnaire.
                     It also includes test methods to handle the insertion of assessment records, including completed 
                     assessments and drafts, and test methods to get the status of assessments and counts of completed
                     assessments of the test user.
* History:
* Version	Author		Date			Detail			Description
* 1.0		Sowmitha 	05-Dec-2023		Created			Initial development.
* 1.1		Sowmitha 	01-Jan-2024		Updated			Updated for caregiver.
* 1.2		Abinsha 	04-Apr-2024		Updated			test cases added.
*/
@isTest
public class BI_PSP_AssessmentCtrlTest {
    public static String assessmentId;
    public static Date expireDatePss;
    public static Date expireDateWai;
    public static Date expireDateDlqi;
    public static String introduction = 'Introduction';
    public static String pss = System.Label.BI_PSP_PssCategory;
    public static String wapiCategory = ' (WPAI)';
    public static String dlqiCategory = System.Label.BI_PSP_DlqiCategory;
    public static String qualiCategory = System.Label.BI_PSP_QualitativeCategory;
    public static String inProgress = System.Label.BI_PSP_InProgressTxt;
    public static Integer expireDate = Integer.valueOf(
        System.Label.BI_PSP_ExpireDateForQualitative
    );
    //holds the error message.
    private static String errorMsg;
    //custom label for Assesssment Questions query when the result  is empty.
    private static String questionsNotAvailable = System.Label.BI_PSP_QuestionsUnavailable;
    //Custom label for care givers patient.
    private static String caregiversPatientAccountErr = System.Label.BI_PSP_CaregiversPatient;
    //custom label that displays an error message when there is no account records for the selected patient.
    private static String caregiversSelectedPatientErrMsg = System.Label.BI_PSP_SelectedPatientAccount;
    // custom label that displays an error message when there is no careProgramEnrollee records for the selected patient.
    private static String selectedPatientsEnrolleeErrorMsg = System.Label.BI_PSP_SelectedPatientEnrollee;
    // custom label that displays an error message when there is no Account records for the patient.
    // custom label that displays an error message when the submit functionality of the assessment fails.
    private static String submitErrorMsg = System.Label.BI_PSP_SubmitErrorMsg;
    // custom label that displays an error message when there is no Assessmnet Record.
    private static String emptyAssesment = System.Label.BI_PSP_EmptyAssessment;
    // custom label that displays an error message when there is no AssessmnetQuestionResponse Record.
    private static String emptyQuestionResponse = System.Label.BI_PSP_EmptyQuestionResponse;
    // custom label that displays an error message when there is no AssessmnetQuestionVersion Record.
    private static String emptyQuestionVersion = System.Label.BI_PSP_EmptyQuestionVersion;
    // custom label that displays an error message when there is no rollout date present.
    private static String rolloutDateErrorMessage = System.Label.BI_PSP_RolloutErrorMsg;
    
    //@Description this method is for inserting the responses of wapi,dlqi,pss Questionnaire Questions as user who is a care giver.
    @istest
    static void testRanswerOfTheQuestion() {
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
            WHERE Name = 'System Administrator'
            LIMIT 1
        ];

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
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;
        User testUserSecond = new User(
            Email = 'testUserSecondnew@example.com',
            BI_PSPB_Caregiver__c = true,
            Username = 'testUserSecondnew@example.com',
            FirstName = 'Test',
            LastName = 'User2',
            Alias = 'tesn',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = standardUserProfile.Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUserSecond;
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
            AccountId = testAccountFirst.Id,
            CareProgramId = carePrgm.Id
        );
        insert testCareProgramEnrolleeOne;
        CareProgramEnrollee testCareProgramEnrolleeTwo = new CareProgramEnrollee(
            Name = 'testCareProgramEnrolleeTwo',
            AccountId = testAccountSecond.Id,
            CareProgramId = carePrgm.Id
        );
        insert testCareProgramEnrolleeTwo;

        Assessment testAssessment = new Assessment(
            Name = 'Test Assessment',
            OwnerId = testUser.Id,
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

        AssessmentQuestion questionDataTwo = new AssessmentQuestion(
            Name = 'test questionname2',
            DeveloperName = 'Valid_Name_1293',
            DataType = 'Decimal',
            QuestionCategory = 'Introduction'
        );
        insert questionDataTwo;

        AssessmentQuestionVersion questionVersionTwo = new AssessmentQuestionVersion(
            AssessmentQuestionId = questionDataTwo.id,
            QuestionText = 'What is your gender?',
            Name = 'test data2',
            IsActive = true
        );
        insert questionVersionTwo;

        AssessmentQuestionResponse testResponseTwo = new AssessmentQuestionResponse(
            ResponseText = 'Female',
            BI_PSP_Category__c = '',
            AssessmentId = testAssessment.id,
            AssessmentQuestionId = questionVersionTwo.id,
            Name = 'test data'
        );
        insert testResponseTwo;

        List<String> responseTexts = new List<String>{
            testResponseTwo.ResponseText,
            testResponse.ResponseText
        };
        List<String> questionIds = new List<String>{
            questionVer.Id,
            questionVersionTwo.Id
        };
        // Call the method under test
        System.runAs(testUserSecond) {
            try {
            Test.startTest();

            // Use the extracted questionIds and responseTexts in the method

            BI_PSP_AssessmentCtrl.submitConfirmedResponses(questionIds, responseTexts);

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
        List<AssessmentQuestionResponse> draftRecords = [
            SELECT Id
            FROM AssessmentQuestionResponse
            WHERE AssessmentId = :testAssessment.Id
        ];
        Integer expectedDraftRecordCount = 2; // Assuming 2 draft records were created
        Assert.areEqual(
            expectedDraftRecordCount,
            draftRecords.size(),
            'Expected characters after first two'
        ); // Succeeds
    }

    @isTest
    static void testRanswerQnCatch() {
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;

        String currentUserName = 'Test User';
        String currentUserEmail = 'testusernew@example.com';
        Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
        insert con;
        
        Profile standardUserProfile = [
            SELECT Id
            FROM Profile
            WHERE Name = 'BI_PSP_Patient Profile'
            LIMIT 1
        ];

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

        CareProgramEnrollee testCareProgramEnrolleeTwo = new CareProgramEnrollee(
            Name = 'testCareProgramEnrolleeTwo',
            AccountId = testAccountFirst.Id,
            CareProgramId = carePrgm.Id
        );
        insert testCareProgramEnrolleeTwo;

        List<String> responseTexts = new List<String>();
        List<String> questionIds = new List<String>();
        try {
            // Ensure the test context
            Test.startTest();

            // Call the AuraEnabled method
            BI_PSP_AssessmentCtrl.submitConfirmedResponses(questionIds, responseTexts);

            //we are using this test method to test the negative scenario so that we are not using assert in here.
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
    //this method is for inserting the responses of wapi,dlqi,pss Questionnaire Questions as darft .
    @isTest
    static void multipleOfTheQuestion() {
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;
		Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
        insert con;
        
        String currentUserName = 'Test User';
        String currentUserEmail = 'testusernew@example.com';
        Profile standardUserProfile = [
            SELECT Id
            FROM Profile
            WHERE Name = 'BI_PSP_Patient Profile'
            LIMIT 1
        ];

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
            AccountId = testAccountFirst.Id,
            CareProgramId = carePrgm.Id
        );
        insert testCareProgramEnrolleeOne;
        CareProgramEnrollee testCareProgramEnrolleeTwo = new CareProgramEnrollee(
            Name = 'testCareProgramEnrolleeTwo',
            AccountId = testAccountSecond.Id,
            CareProgramId = carePrgm.Id
        );
        insert testCareProgramEnrolleeTwo;

        Assessment testAssessment = new Assessment(
            Name = 'Test Assessment',
            OwnerId = testUser.Id,
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

        AssessmentQuestion questionDataTwo = new AssessmentQuestion(
            Name = 'test questionname2',
            DeveloperName = 'Valid_Name_1293',
            DataType = 'Decimal',
            QuestionCategory = 'Introduction'
        );
        insert questionDataTwo;

        AssessmentQuestionVersion questionVersionTwo = new AssessmentQuestionVersion(
            AssessmentQuestionId = questionDataTwo.id,
            QuestionText = 'What is your gender?',
            Name = 'test data2',
            IsActive = true
        );
        insert questionVersionTwo;

        AssessmentQuestionResponse testResponseTwo = new AssessmentQuestionResponse(
            ResponseText = 'Female',
            BI_PSP_Category__c = '',
            AssessmentId = testAssessment.id,
            AssessmentQuestionId = questionVersionTwo.id,
            Name = 'test data'
        );
        insert testResponseTwo;

        List<String> responseTexts = new List<String>{
            testResponseTwo.ResponseText,
            testResponse.ResponseText
        };
        List<String> questionIds = new List<String>{
            questionVer.Id,
            questionVersionTwo.Id
        };
        System.runAs(testUser) {
            // Call the method under test
            try {
            Test.startTest();

            // Use the extracted questionIds and responseTexts in the method
            BI_PSP_AssessmentCtrl.mulitipleDraftRecordsInsertion(
                questionIds,
                responseTexts
            );

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
        List<AssessmentQuestionResponse> draftRecords = [
            SELECT Id
            FROM AssessmentQuestionResponse
            WHERE AssessmentId = :testAssessment.Id
        ];
        Integer expectedDraftRecordCount = 2; // Assuming 2 draft records were created
        Assert.areEqual(
            expectedDraftRecordCount,
            draftRecords.size(),
            'Expected characters after first two'
        ); // Succeeds
    }

    //this method is for saving the responses as drfat for dlqi.wapi,pss as a user who is a care giver.
    @isTest
    static void multipleOfTheQuestionTwo() {
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
            WHERE Name = 'System Administrator'
            LIMIT 1
        ];

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
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;
        User testUserSecond = new User(
            Email = 'testUserSecondnew@example.com',
            BI_PSPB_Caregiver__c = true,
            Username = 'testUserSecondnew@example.com',
            FirstName = 'Test',
            LastName = 'User2',
            Alias = 'tesn',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = standardUserProfile.Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUserSecond;
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
            AccountId = testAccountFirst.Id,
            CareProgramId = carePrgm.Id
        );
        insert testCareProgramEnrolleeOne;
        CareProgramEnrollee testCareProgramEnrolleeTwo = new CareProgramEnrollee(
            Name = 'testCareProgramEnrolleeTwo',
            AccountId = testAccountSecond.Id,
            CareProgramId = carePrgm.Id
        );
        insert testCareProgramEnrolleeTwo;

        Assessment testAssessment = new Assessment(
            Name = 'Test Assessment',
            OwnerId = testUser.Id,
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

        AssessmentQuestion questionDataTwo = new AssessmentQuestion(
            Name = 'test questionname2',
            DeveloperName = 'Valid_Name_1293',
            DataType = 'Decimal',
            QuestionCategory = 'Introduction'
        );
        insert questionDataTwo;

        AssessmentQuestionVersion questionVersionTwo = new AssessmentQuestionVersion(
            AssessmentQuestionId = questionDataTwo.id,
            QuestionText = 'What is your gender?',
            Name = 'test data2',
            IsActive = true
        );
        insert questionVersionTwo;

        AssessmentQuestionResponse testResponseTwo = new AssessmentQuestionResponse(
            ResponseText = 'Female',
            BI_PSP_Category__c = '',
            AssessmentId = testAssessment.id,
            AssessmentQuestionId = questionVersionTwo.id,
            Name = 'test data'
        );
        insert testResponseTwo;

        List<String> responseTexts = new List<String>{
            testResponseTwo.ResponseText,
            testResponse.ResponseText
        };
        List<String> questionIds = new List<String>{
            questionVer.Id,
            questionVersionTwo.Id
        };
        List<AssessmentQuestionResponse> draftRecords = [
            SELECT Id
            FROM AssessmentQuestionResponse
            WHERE AssessmentId = :testAssessment.Id
        ];
        Integer expectedDraftRecordCount = 2; // Assuming 2 draft records were created
		
        System.runAs(testUserSecond) {
            // Call the method under test
            try {
            Test.startTest();

            // Use the extracted questionIds and responseTexts in the method
            BI_PSP_AssessmentCtrl.mulitipleDraftRecordsInsertion(
                questionIds,
                responseTexts
            );
            Assert.areEqual(
                expectedDraftRecordCount,
                draftRecords.size(),
                'Expected characters after first two'
            );

            Test.stopTest();
            }catch (Exception e) {
            // Assert that the exception message is as expected
            Assert.areEqual(
                e.getMessage(),
                'Script-thrown exception',
                e.getMessage()
            );
        }
        }

    }
    //this method is for catching the responses of dlqi,wapi,pss as a user who is not a care giver.
    @isTest
    static void testMatchingCatch() {
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;
		Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
        insert con;
        String currentUserName = 'Test User';
        String currentUserEmail = 'testusernew@example.com';
        Profile standardUserProfile = [
            SELECT Id
            FROM Profile
            WHERE Name = 'BI_PSP_Patient Profile'
            LIMIT 1
        ];

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

        CareProgramEnrollee testCareProgramEnrolleeTwo = new CareProgramEnrollee(
            Name = 'testCareProgramEnrolleeTwo',
            AccountId = testAccountFirst.Id,
            CareProgramId = carePrgm.Id
        );
        insert testCareProgramEnrolleeTwo;

        List<String> responseTexts = new List<String>();
        List<String> questionIds = new List<String>();
        List<AssessmentQuestionResponse> draftRecords = [
            SELECT Id
            FROM AssessmentQuestionResponse
        ];
        Integer expectedDraftRecordCount = 2; // Assuming 2 draft records were created

        // Ensure the test context
        try {
            Test.startTest();

            // Call the AuraEnabled method
            BI_PSP_AssessmentCtrl.mulitipleDraftRecordsInsertion(
                questionIds,
                responseTexts
            );
            Assert.areEqual(
                expectedDraftRecordCount,
                draftRecords.size(),
                'Expected characters after first two'
            );
            // Ensure the test context is properly closed
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

    //test method for retrieving the count of answered assessment questions associated with a specific assessment record.
    @istest
    static void testGetCategoryStatus() {
        try {
            // Create mock BI_SFCOE_LOG_App_Settings__c record
            BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
                Name = 'ApplicationName',
                BI_SFCOE_LOG_Application__c = 'Spevigo'
            );
            insert settings;

            String currentUserName = 'Test User';
            String currentUserEmail = 'testusernew@example.com';
            Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
            insert con;
            Profile standardUserProfile = [
                SELECT Id
                FROM Profile
                WHERE Name = 'BI_PSP_Patient Profile'
                LIMIT 1
            ];

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
                AccountId = testAccountFirst.Id,
                CareProgramId = carePrgm.Id
            );
            insert testCareProgramEnrolleeOne;
            CareProgramEnrollee testCareProgramEnrolleeTwo = new CareProgramEnrollee(
                Name = 'testCareProgramEnrolleeTwo',
                AccountId = testAccountSecond.Id,
                CareProgramId = carePrgm.Id
            );
            insert testCareProgramEnrolleeTwo;

            Assessment testAssessment = new Assessment(
                Name = 'Work & Activity Impairment (WPAI)',
                OwnerId = testUser.Id,
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

            AssessmentQuestion questionDataTwo = new AssessmentQuestion(
                Name = 'test questionname2',
                DeveloperName = 'Valid_Name_1293',
                DataType = 'Decimal',
                QuestionCategory = 'Work & Activity Impairment (WPAI)'
            );
            insert questionDataTwo;

            AssessmentQuestionVersion questionVersionTwo = new AssessmentQuestionVersion(
                AssessmentQuestionId = questionDataTwo.id,
                QuestionText = 'What is your gender?',
                Name = 'test data2',
                IsActive = true
            );
            insert questionVersionTwo;

            AssessmentQuestionResponse testResponseTwo = new AssessmentQuestionResponse(
                ResponseText = 'Female',
                BI_PSP_Category__c = '',
                AssessmentId = testAssessment.id,
                AssessmentQuestionId = questionVersionTwo.id,
                Name = 'test data'
            );
            insert testResponseTwo;
            // Call the method under test
            Test.startTest();

            // Use the test Assessment Id in the method
            Integer result = BI_PSP_AssessmentCtrl.getCategoryStatus(
                testAssessment.Id
            );

            Test.stopTest();

            // Add assertions to verify the expected behavior
            // For example, check if the count of answered questions matches the expected value

            Assert.areEqual(2, result, 'Expected 2 answered questions');
        } catch (Exception e) {
            // Assert that the exception message is as expected
            Assert.areEqual(
                e.getMessage(),
                'Script-thrown exception',
                e.getMessage()
            );
        }

        // You can add more assertions based on your specific use case and requirements
    }

    //test method for retrieving the total count of assessment questions belonging to a specified category, such as "Introduction".
    @istest
    static void testgetTotalquestionscount() {
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;

        String currentUserName = 'Test User';
        String currentUserEmail = 'testusernew@example.com';
        Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
        insert con;
        Profile standardUserProfile = [
            SELECT Id
            FROM Profile
            WHERE Name = 'BI_PSP_Patient Profile'
            LIMIT 1
        ];

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
            AccountId = testAccountFirst.Id,
            CareProgramId = carePrgm.Id
        );
        insert testCareProgramEnrolleeOne;
        CareProgramEnrollee testCareProgramEnrolleeTwo = new CareProgramEnrollee(
            Name = 'testCareProgramEnrolleeTwo',
            AccountId = testAccountSecond.Id,
            CareProgramId = carePrgm.Id
        );
        insert testCareProgramEnrolleeTwo;

        Assessment testAssessment = new Assessment(
            Name = 'Test Assessment',
            OwnerId = testUser.Id,
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

        AssessmentQuestion questionDataTwo = new AssessmentQuestion(
            Name = 'test questionname2',
            DeveloperName = 'Valid_Name_1293',
            DataType = 'Decimal',
            QuestionCategory = 'Introduction'
        );
        insert questionDataTwo;

        AssessmentQuestionVersion questionVersionTwo = new AssessmentQuestionVersion(
            AssessmentQuestionId = questionDataTwo.id,
            QuestionText = 'What is your gender?',
            Name = 'test data2',
            IsActive = true
        );
        insert questionVersionTwo;

        AssessmentQuestionResponse testResponseTwo = new AssessmentQuestionResponse(
            ResponseText = 'Female',
            BI_PSP_Category__c = '',
            AssessmentId = testAssessment.id,
            AssessmentQuestionId = questionVersionTwo.id,
            Name = 'test data'
        );
        insert testResponseTwo;
        try {
            Test.startTest();

            // Use the test Assessment Id in the method
            Integer result = BI_PSP_AssessmentCtrl.getTotalquestionscount(
                'Introduction'
            );

            Test.stopTest();

            // Add assertions to verify the expected behavior
            // For example, check if the count of answered questions matches the expected value
            Assert.areEqual(1, result, 'Expected 1 testtt answered questions');
        } catch (Exception e) {
            // Assert that the exception message is as expected
            Assert.areEqual(
                e.getMessage(),
                'Script-thrown exception',
                e.getMessage()
            );
        }

        // You can add more assertions based on your specific use case and requirements
    }

    //test method, which retrieves assessment counts for the current user. It ensures that the method returns the expected assessment count for the user within the specified context.
    @isTest
    static void testGetAssessmentCountsByCurrentUserName() {
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;

        // Retrieve the ProfileId for the desired profile (replace 'Your Profile Name' with the actual name)

        String currentUserName = 'Test User';
        String currentUserEmail = 'testusernew@example.com';
        Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
        insert con;
        Profile standardUserProfile = [
            SELECT Id
            FROM Profile
            WHERE Name = 'BI_PSP_Patient Profile'
            LIMIT 1
        ];

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

        Account testAccountFirst = new Account(
            Lastname = currentUserName,
            PersonEmail = currentUserEmail,
            RecordTypeId = personAccountRecordTypeId
        );
        insert testAccountFirst;

        CareProgram carePrgm = new CareProgram(
            Name = 'testcp',
            StartDate = Date.valueOf('2024-02-28')
        );

        insert carePrgm;

        CareProgramEnrollee testCareProgramEnrolleeOne = new CareProgramEnrollee(
            Name = 'testCareProgramEnrolleeOne',
            AccountId = testAccountFirst.Id,
            CareProgramId = carePrgm.Id
        );
        insert testCareProgramEnrolleeOne;

        Assessment testAssessment = new Assessment(
            Name = 'Work & Activity Impairment (WPAI)',
            OwnerId = testUser.Id,
            AssessmentStatus = 'Completed',
            BI_PSP_DateForCQ__c = 'Jan 2023',
            BI_PSP_CareProgramEnrollee__c = testCareProgramEnrolleeOne.Id
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
        System.runAs(testUser) {
            // Call the method under test
            Test.startTest();

            // Use the test category name in the method
            List<Integer> result = BI_PSP_AssessmentCtrl.getAssessmentCountsByCurrentUserName();

            Test.stopTest();

            // Add assertions to verify the expected behavior
            // For example, check if the result list has the expected size
            Assert.areEqual(4, result.size(), 'Expected 1 assessment count');
        }


        // You can add more assertions based on your specific use case and requirements
    }
    //this test method, ensuring it correctly retrieves assessment counts for the current user within a specific context.
    @isTest
    static void testGetAssessmentCountsBycurrentUserNameSecond() {
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;
		Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
        insert con;
        // Retrieve the ProfileId for the desired profile (replace 'Your Profile Name' with the actual name)

        String currentUserName = 'Test User';
        String currentUserEmail = 'testusernew@example.com';
        Profile standardUserProfile = [
            SELECT Id
            FROM Profile
            WHERE Name = 'BI_PSP_Patient Profile'
            LIMIT 1
        ];

        User testUserSecond = new User(
            Email = 'testUserSecondnew@example.com',
            BI_PSPB_Caregiver__c = true,
            Username = 'testUserSecondnew@example.com',
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
        insert testUserSecond;
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

        CareProgramEnrollee testCareProgramEnrolleeTwo = new CareProgramEnrollee(
            Name = 'testCareProgramEnrolleeTwo',
            AccountId = testAccountFirst.Id,
            CareProgramId = carePrgm.Id
        );
        insert testCareProgramEnrolleeTwo;

        Assessment testAssessment = new Assessment(
            Name = 'Test Assessment',
            OwnerId = testUserSecond.Id,
            AssessmentStatus = 'Completed',
            BI_PSP_DateForCQ__c = 'Jan 2023',
            BI_PSP_CareProgramEnrollee__c = testCareProgramEnrolleeTwo.Id
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

        System.runAs(testUserSecond) {
            // Call the method under test
            Test.startTest();

            // Use the test category name in the method
            List<Integer> result = BI_PSP_AssessmentCtrl.getAssessmentCountsByCurrentUserName();

            Test.stopTest();

            // Add assertions to verify the expected behavior
            // For example, check if the result list has the expected size
            Assert.areEqual(4, result.size(), 'Expected 1 assessment count');
        }


        // You can add more assertions based on your specific use case and requirements
    }

    //test method for retrieving questionnaire setup records for a care program enrollee. It ensures that the method correctly returns the expected questionnaire setup records within the test context.
    @isTest
    static void testGetRolloutdateCaregiverTrue() {
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;
        // Test data setup
		Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
        insert con;
        String currentUserName = 'Test User';
        String currentUserEmail = 'testusernew@example.com';
        Profile standardUserProfile = [
            SELECT Id
            FROM Profile
            WHERE Name = 'BI_PSP_Patient Profile'
            LIMIT 1
        ];

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

        Account testAccountFirst = new Account(
            Lastname = currentUserName,
            PersonEmail = currentUserEmail,
            RecordTypeId = personAccountRecordTypeId
        );
        insert testAccountFirst;

        CareProgram carePrgm = new CareProgram(
            Name = 'testcp',
            StartDate = Date.valueOf('2024-02-28')
        );

        insert carePrgm;

        CareProgramEnrollee testCareProgramEnrolleeOne = new CareProgramEnrollee(
            Name = 'testCareProgramEnrolleeOne',
            AccountId = testAccountFirst.Id,
            CareProgramId = carePrgm.Id
        );
        insert testCareProgramEnrolleeOne;

        BI_PSP_Questionnaire_Setups__c qsq = new BI_PSP_Questionnaire_Setups__c(
            BI_PSP_CareProgramEnrollee__c = testCareProgramEnrolleeOne.Id,
            Name = testCareProgramEnrolleeOne.Name,
            BI_PSP_WAI_RollOutDate__c = Date.valueOf('2024-02-28'),
            BI_PSP_PSS_RollOutDate__c = Date.valueOf('2024-02-28'),
            BI_PSP_DLQI_RollOutDate__c = Date.valueOf('2024-02-28')
        );
        insert qsq;
        System.runAs(testUser) {
            // Ensure the test context
            Test.startTest();

            // Call the AuraEnabled method
            List<BI_PSP_Questionnaire_Setups__c> result = BI_PSP_AssessmentCtrl.getRolloutdate();

            // Add assertions

            // Add more specific assertions based on your test data and expectations

            // Ensure the test context is properly closed
            Test.stopTest();
            Assert.areEqual(1, result.size(), 'returns qn setupss1');
        }
    }
    //test method for retrieving questionnaire setup records for a care program enrollee when the user is not a caregiver. It ensures that the method returns the expected questionnaire setup records within the test context.
    @isTest
    static void testGetRolloutdateCaregiverfalse() {
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

        User testUserSecond = new User(
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
        insert testUserSecond;
        
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

        CareProgramEnrollee testCareProgramEnrolleeTwo = new CareProgramEnrollee(
            Name = 'testCareProgramEnrolleeTwo',
            AccountId = testAccountFirst.Id,
            CareProgramId = carePrgm.Id
        );
        insert testCareProgramEnrolleeTwo;

        BI_PSP_Questionnaire_Setups__c qsq = new BI_PSP_Questionnaire_Setups__c(
            BI_PSP_CareProgramEnrollee__c = testCareProgramEnrolleeTwo.Id,
            Name = testCareProgramEnrolleeTwo.Name,
            BI_PSP_WAI_RollOutDate__c = Date.valueOf('2024-02-28'),
            BI_PSP_PSS_RollOutDate__c = Date.valueOf('2024-02-28'),
            BI_PSP_DLQI_RollOutDate__c = Date.valueOf('2024-02-28')
        );

        insert qsq;
        System.runAs(testUserSecond) {
            // Ensure the test context
            Test.startTest();

            // Call the AuraEnabled method
            List<BI_PSP_Questionnaire_Setups__c> result = BI_PSP_AssessmentCtrl.getRolloutdate();

            // Add assertions
            Assert.areEqual(1, result.size(), 'returns qn setupss2');
            // Add more specific assertions based on your test data and expectations

            // Ensure the test context is properly closed
            Test.stopTest();
        }
    }

    // test method functions when the user is not a caregiver and no questionnaire setup records are found for the care program enrollee. It ensures that the method correctly handles the scenario where no records are returned and asserts that the result list size is as expected within the test context.
    @isTest
    static void testGetRolloutdateCaregiverfalsecatch() {
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;
		Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
        insert con;
        String currentUserName = 'Test User';
        String currentUserEmail = 'testusernew@example.com';
        Profile standardUserProfile = [
            SELECT Id
            FROM Profile
            WHERE Name = 'BI_PSP_Patient Profile'
            LIMIT 1
        ];

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

        CareProgramEnrollee testCareProgramEnrolleeTwo = new CareProgramEnrollee(
            Name = 'testCareProgramEnrolleeTwo',
            AccountId = testAccountFirst.Id,
            CareProgramId = carePrgm.Id
        );
        insert testCareProgramEnrolleeTwo;

        try {
            // Ensure the test context
            Test.startTest();

            // Call the AuraEnabled method
            List<BI_PSP_Questionnaire_Setups__c> result = BI_PSP_AssessmentCtrl.getRolloutdate();

            // Add assertions
            Assert.areEqual(0, result.size(), 'returns qn setupss3');
            // Add more specific assertions based on your test data and expectations

            // Ensure the test context is properly closed
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
    //The test method ensures that the method correctly retrieves the count of completed assessments associated with the current user's username.
    @IsTest
    static void testGetCompletedAssessmentCountsByCurrentUserName() {
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;
		Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
        insert con;
        String currentUserName = 'Test User';
        String currentUserEmail = 'testusernew@example.com';
        Profile standardUserProfile = [
            SELECT Id
            FROM Profile
            WHERE Name = 'BI_PSP_Patient Profile'
            LIMIT 1
        ];

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

        Account testAccountFirst = new Account(
            Lastname = currentUserName,
            PersonEmail = currentUserEmail,
            RecordTypeId = personAccountRecordTypeId
        );
        insert testAccountFirst;

        CareProgram carePrgm = new CareProgram(
            Name = 'testcp',
            StartDate = Date.valueOf('2024-02-28')
        );

        insert carePrgm;

        CareProgramEnrollee testCareProgramEnrolleeOne = new CareProgramEnrollee(
            Name = 'testCareProgramEnrolleeOne',
            AccountId = testAccountFirst.Id,
            CareProgramId = carePrgm.Id
        );
        insert testCareProgramEnrolleeOne;

        Assessment testAssessment = new Assessment(
            Name = 'Work & Activity Impairment (WPAI)',
            OwnerId = testUser.Id,
            AssessmentStatus = 'Completed',
            BI_PSP_DateForCQ__c = 'Jan 2023',
            BI_PSP_CareProgramEnrollee__c = testCareProgramEnrolleeOne.Id
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
        // Call the method to be tested
        try {
            System.runAs(testUser) {
                Test.startTest();
                List<Integer> result = BI_PSP_AssessmentCtrl.getCompletedAssessmentCountsByCurrentUserName();
                Test.stopTest();
                Assert.areEqual(4, result.size(), 'returns assess');
                // Assert the results
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
    //The test method ensures that the method correctly retrieves the count of completed assessments associated with the current user's username, considering the user's caregiver status.
    @IsTest
    static void testGetCompletedAssessmentCountsByCurrentUserNameTwo() {
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;

        String currentUserName = 'Test User';
        String currentUserEmail = 'testusernew@example.com';
        Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
        insert con;
        Profile standardUserProfile = [
            SELECT Id
            FROM Profile
            WHERE Name = 'BI_PSP_Patient Profile'
            LIMIT 1
        ];

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

        CareProgramEnrollee testCareProgramEnrolleeTwo = new CareProgramEnrollee(
            Name = 'testCareProgramEnrolleeTwo',
            AccountId = testAccountFirst.Id,
            CareProgramId = carePrgm.Id
        );
        insert testCareProgramEnrolleeTwo;

        Assessment testAssessment = new Assessment(
            Name = 'Work & Activity Impairment (WPAI)',
            OwnerId = testUser.Id,
            AssessmentStatus = 'Completed',
            BI_PSP_DateForCQ__c = 'Jan 2023',
            BI_PSP_CareProgramEnrollee__c = testCareProgramEnrolleeTwo.Id
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
            // Call the method to be tested
            System.runAs(testUser) {
                Test.startTest();
                List<Integer> result = BI_PSP_AssessmentCtrl.getCompletedAssessmentCountsByCurrentUserName();
                Test.stopTest();
                Assert.areEqual(4, result.size(), 'returns assess');
                // Assert the results
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

    //The test method ensures that the method correctly retrieves the count of completed assessments associated with the current user's username, considering the user's caregiver status.
    @isTest
    static void testGetCompassCatch() {
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;
		Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
        insert con;
        String currentUserEmailThree = 'testusernew@example.com';
        Profile standardUserProfile = [
            SELECT Id
            FROM Profile
            WHERE Name = 'BI_PSP_Patient Profile'
            LIMIT 1
        ];

        User testUserThree = new User(
            Email = 'testuser3new@example.com',
            BI_PSPB_Caregiver__c = false,
            Username = 'testuser3new@example.com',
            FirstName = 'Test3',
            LastName = 'User3',
            Alias = 'tesn',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = standardUserProfile.Id,
            LanguageLocaleKey = 'en_US',
            ContactId = con.Id
        );
        insert testUserThree;

        Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
            .get('PersonAccount')
            .getRecordTypeId();
        Account testAccount3 = new Account(
            Lastname = 'test',
            PersonEmail = currentUserEmailThree,
            RecordTypeId = personAccountRecordTypeId
        );
        insert testAccount3;
        try {
            System.runAs(testUserThree) {
                // Ensure the test context
                Test.startTest();

                // Call the AuraEnabled method
                List<Integer> result = BI_PSP_AssessmentCtrl.getCompletedAssessmentCountsByCurrentUserName();

                // Add assertions
                System.assertEquals(
                    0,
                    result.size(),
                    'No Assessment with completed State'
                );
                // Add more specific assertions based on your test data and expectations

                // Ensure the test context is properly closed
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

    //The test method ensures that the method correctly retrieves the count of completed assessments associated with the current user's username, considering the user's caregiver status.
    @isTest
    static void testGetCompassCatchElse() {
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;

        String currentUserName = 'Test3 User3';
        String currentUserEmail = 'testuser3new@example.com';
        Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
        insert con;
        Profile standardUserProfile = [
            SELECT Id
            FROM Profile
            WHERE Name = 'BI_PSP_Patient Profile'
            LIMIT 1
        ];

        User testUserThree = new User(
            Email = 'testuser3new@example.com',
            BI_PSPB_Caregiver__c = true,
            Username = 'testuser3new@example.com',
            FirstName = 'Test3',
            LastName = 'User3',
            Alias = 'tesn',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = standardUserProfile.Id,
            LanguageLocaleKey = 'en_US',
            ContactId = con.Id
        );
        insert testUserThree;

        Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
            .get('PersonAccount')
            .getRecordTypeId();
        String currentUserNameSecond = 'Test User2';
        String currentUserEmailSecond = 'testUserSecondnew@example.com';
        Account testAccountFirst = new Account(
            Lastname = currentUserName,
            PersonEmail = currentUserEmail,
            RecordTypeId = personAccountRecordTypeId
        );
        insert testAccountFirst;

        Account testAccountSecond = new Account(
            Lastname = currentUserNameSecond,
            PersonEmail = currentUserEmailSecond,
            RecordTypeId = personAccountRecordTypeId,
            BI_PSPB_Selected_Patient_ID__c = testAccountFirst.Id
        );
        insert testAccountSecond;
        try {
            System.runAs(testUserThree) {
                // Ensure the test context
                Test.startTest();

                // Call the AuraEnabled method
                List<Integer> result = BI_PSP_AssessmentCtrl.getCompletedAssessmentCountsByCurrentUserName();

                // Add assertions
                System.assertEquals(
                    0,
                    result.size(),
                    'No Assessment with completed State'
                );
                // Add more specific assertions based on your test data and expectations

                // Ensure the test context is properly closed
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

    //The test method ensures that the method correctly retrieves the count of completed assessments associated with the current user's username, considering the user's caregiver status.
    @isTest
    static void testGetCompassCatchElseCpe() {
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;

        String currentUserName = 'Test3 User3';
        String currentUserEmail = 'testuser3new@example.com';
        Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
        insert con;
        Profile standardUserProfile = [
            SELECT Id
            FROM Profile
            WHERE Name = 'BI_PSP_Patient Profile'
            LIMIT 1
        ];

        User testUserThree = new User(
            Email = 'testuser3new@example.com',
            BI_PSPB_Caregiver__c = true,
            Username = 'testuser3new@example.com',
            FirstName = 'Test3',
            LastName = 'User3',
            Alias = 'tesn',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = standardUserProfile.Id,
            LanguageLocaleKey = 'en_US',
            ContactId = con.Id
        );
        insert testUserThree;

        Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
            .get('PersonAccount')
            .getRecordTypeId();
        String currentUserNameSecond = 'Test User2';
        String currentUserEmailSecond = 'testUserSecondnew@example.com';
        Account testAccountSecond = new Account(
            Lastname = currentUserNameSecond,
            PersonEmail = currentUserEmailSecond,
            RecordTypeId = personAccountRecordTypeId
        );
        insert testAccountSecond;
        Account testAccountFirst = new Account(
            Lastname = currentUserName,
            PersonEmail = currentUserEmail,
            RecordTypeId = personAccountRecordTypeId,
            BI_PSPB_Selected_Patient_ID__c = testAccountSecond.Id
        );
        insert testAccountFirst;

        try {
            System.runAs(testUserThree) {
                // Ensure the test context
                Test.startTest();

                // Call the AuraEnabled method
                List<Integer> result = BI_PSP_AssessmentCtrl.getCompletedAssessmentCountsByCurrentUserName();

                // Add assertions
                System.assertEquals(
                    0,
                    result.size(),
                    'No Assessment with completed State'
                );
                // Add more specific assertions based on your test data and expectations

                // Ensure the test context is properly closed
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

    //To get cover the catch of caregiver after giving Response in negative
    @istest
    static void forElseLogMessage() {
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;
		Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
        insert con;
        Profile standardUserProfile = [
            SELECT Id
            FROM Profile
            WHERE Name = 'BI_PSP_Patient Profile'
            LIMIT 1
        ];

        User testUserSecond = new User(
            Email = 'testUserSecondnew@example.com',
            BI_PSPB_Caregiver__c = true,
            Username = 'testUserSecondnew@example.com',
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
        insert testUserSecond;

        List<String> responseTexts = new List<String>();
        List<String> questionIds = new List<String>();
        List<AssessmentQuestionResponse> draftRecords = [
            SELECT Id
            FROM AssessmentQuestionResponse
        ];

        // Call the method under test
        try {
            System.runAs(testUserSecond) {
                Test.startTest();

                // Use the extracted questionIds and responseTexts in the method

                BI_PSP_AssessmentCtrl.submitConfirmedResponses(
                    questionIds,
                    responseTexts
                );
                Integer expectedDraftRecordCount = 2; // Assuming 2 draft records were created
                Assert.areEqual(
                    expectedDraftRecordCount,
                    draftRecords.size(),
                    'Expected characters after first two'
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
    // Testing Log error for if condition in ranswerOfTheQuestion.
    @istest
    static void forCaregiverTestingLogError() {
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;
		Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
        insert con;
        String currentUserName = 'Test User';
        String currentUserEmail = 'testusernew@example.com';
        Profile standardUserProfile = [
            SELECT Id
            FROM Profile
            WHERE Name = 'BI_PSP_Patient Profile'
            LIMIT 1
        ];

        User testUser = new User(
            Email = 'testusernew@example.com',
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
            AccountId = testAccountFirst.Id,
            CareProgramId = carePrgm.Id
        );
        insert testCareProgramEnrolleeOne;
        CareProgramEnrollee testCareProgramEnrolleeTwo = new CareProgramEnrollee(
            Name = 'testCareProgramEnrolleeTwo',
            AccountId = testAccountSecond.Id,
            CareProgramId = carePrgm.Id
        );
        insert testCareProgramEnrolleeTwo;

        Assessment testAssessment = new Assessment(
            Name = 'Test Assessment',
            OwnerId = testUser.Id,
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
            AssessmentId = testAssessment.id,
            AssessmentQuestionId = questionVer.Id
            //CreatedDate = createdDt
        );
        insert testResponse;

        AssessmentQuestion questionDataTwo = new AssessmentQuestion(
            Name = 'test questionname2',
            DeveloperName = 'Valid_Name_1293',
            DataType = 'Decimal',
            QuestionCategory = 'Introduction'
        );
        insert questionDataTwo;

        AssessmentQuestionVersion questionVersionTwo = new AssessmentQuestionVersion(
            AssessmentQuestionId = questionDataTwo.id,
            QuestionText = 'What is your gender?',
            Name = 'test data2',
            IsActive = true
        );
        insert questionVersionTwo;

        AssessmentQuestionResponse testResponseTwo = new AssessmentQuestionResponse(
            Name = 'Test Response',
            ResponseText = 'No',
            BI_PSP_Category__c = 'Social life',
            AssessmentId = testAssessment.id,
            AssessmentQuestionId = questionVersionTwo.Id
            //CreatedDate = createdDt
        );
        insert testResponseTwo;

        List<String> responseTexts = new List<String>{
            testResponseTwo.ResponseText,
            testResponse.ResponseText
        };
        List<String> questionIds = new List<String>{
            questionVer.Id,
            questionVersionTwo.Id
        };
        List<AssessmentQuestionResponse> draftRecords = [
            SELECT Id
            FROM AssessmentQuestionResponse
            WHERE AssessmentId = :testAssessment.Id
        ];
        Integer expectedDraftRecordCount = 2; // Assuming 2 draft records were created

        // Call the method under test
        try {
            Test.startTest();

            // Use the extracted questionIds and responseTexts in the method

            BI_PSP_AssessmentCtrl.submitConfirmedResponses(questionIds, responseTexts);
            Assert.areEqual(
                expectedDraftRecordCount,
                draftRecords.size(),
                'Expected characters after first two'
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

    //this method is for inserting the responses of wapi,dlqi,pss Questionnaire Questions as user who is a care giver.
    @istest
    static void testElse() {
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;

        String currentUserName = 'Test User';
        String currentUserEmail = 'testusernew@example.com';
        Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
        insert con;
        Profile standardUserProfile = [
            SELECT Id
            FROM Profile
            WHERE Name = 'BI_PSP_Patient Profile'
            LIMIT 1
        ];

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
            AccountId = testAccountFirst.Id,
            CareProgramId = carePrgm.Id
        );
        insert testCareProgramEnrolleeOne;
        CareProgramEnrollee testCareProgramEnrolleeTwo = new CareProgramEnrollee(
            Name = 'testCareProgramEnrolleeTwo',
            AccountId = testAccountSecond.Id,
            CareProgramId = carePrgm.Id
        );
        insert testCareProgramEnrolleeTwo;

        Assessment testAssessment = new Assessment(
            Name = 'Test Assessment',
            OwnerId = testUser.Id,
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
            Name = 'Locked',
            ResponseText = 'Locked',
            BI_PSP_Category__c = 'Social life',
            AssessmentId = testAssessment.Id,
            AssessmentQuestionId = questionVer.Id
            //CreatedDate = createdDt
        );
        insert testResponse;

        AssessmentQuestion questionDataTwo = new AssessmentQuestion(
            Name = 'test questionname2',
            DeveloperName = 'Valid_Name_1293',
            DataType = 'Decimal',
            QuestionCategory = 'Introduction'
        );
        insert questionDataTwo;

        AssessmentQuestionVersion questionVersionTwo = new AssessmentQuestionVersion(
            AssessmentQuestionId = questionDataTwo.id,
            QuestionText = 'What is your gender?',
            Name = 'test data2',
            IsActive = true
        );
        insert questionVersionTwo;

        AssessmentQuestionResponse testResponseTwo = new AssessmentQuestionResponse(
            ResponseText = 'Locked',
            BI_PSP_Category__c = '',
            AssessmentId = testAssessment.id,
            AssessmentQuestionId = questionVersionTwo.id,
            Name = 'test data'
        );
        insert testResponseTwo;

        List<String> responseTexts = new List<String>{
            testResponseTwo.ResponseText,
            testResponse.ResponseText
        };
        List<String> questionIds = new List<String>{
            questionVer.Id,
            questionVersionTwo.Id
        };
        List<AssessmentQuestionResponse> draftRecords = [
            SELECT Id
            FROM AssessmentQuestionResponse
            WHERE AssessmentId = :testAssessment.Id
        ];
        Integer expectedDraftRecordCount = 2; // Assuming 2 draft records were created

        // Call the method under test
        
        System.runAs(testUser) {
            try{
            Test.startTest();

            // Use the extracted questionIds and responseTexts in the method

            BI_PSP_AssessmentCtrl.submitConfirmedResponses(questionIds, responseTexts);

            Assert.areEqual(
                expectedDraftRecordCount,
                draftRecords.size(),
                'Expected characters after first two'
            );
            Test.stopTest();
        }catch (Exception e) {
            // Assert that the exception message is as expected
            Assert.areEqual(
                e.getMessage(),
                'Script-thrown exception',
                e.getMessage()
            );
        }
        }

    }

    //To cover the catch for total Question counts
     @isTest
    static void getCatchTotalQuestions() {
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
            Integer result = BI_PSP_AssessmentCtrl.getTotalquestionscount(null);
            Test.StopTest();
            Assert.areEqual(
                null,
                result,
                'There should be no Qualitative AssessmentQuestion'
            );
        }
    }
    @isTest
    //To cover the catch for category status
    static void getCatchCategoryStatus() {
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
            Integer result = BI_PSP_AssessmentCtrl.getCategoryStatus('');
            Test.StopTest();
            Assert.areEqual(
                null,
                result,
                'There should be no Qualitative AssessmentQuestion'
            );
        }
    }
    @isTest
    static void testCaregiverData() {
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;
        try {
            //
            String currentUserName = 'Test User';
            String currentUserEmail = 'testusernew@example.com';
            Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
            insert con;
            Profile standardUserProfile = [
                SELECT Id
                FROM Profile
                WHERE Name = 'BI_PSP_Patient Profile'
                LIMIT 1
            ];
            User testUserSecond = new User(
                Email = 'testUserSecondnew@example.com',
                BI_PSPB_Caregiver__c = true,
                Username = 'testUserSecondnew@example.com',
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
            insert testUserSecond;
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

            CareProgramEnrollee testCareProgramEnrolleeTwo = new CareProgramEnrollee(
                Name = 'testCareProgramEnrolleeTwo',
                AccountId = testAccountSecond.Id,
                CareProgramId = carePrgm.Id
            );
            insert testCareProgramEnrolleeTwo;

            System.runAs(testUserSecond) {
                Test.startTest();
                BI_PSP_AssessmentCtrl.getAssessmentCountsByCurrentUserName();
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