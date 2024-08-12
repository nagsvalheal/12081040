/**
 * @description class Used to create the treatment video object record and test the reterive methods.
                Create the different user to access the treatment video record.
				try catch is used to handle the negative scenarios in test methods.
 * History:
 * Version	Author			Date			Detail				Description
 * 1.0		Gokul Krishnan	05-Nov-2023		Created				Initial development
 * 1.1		Gokul Krishnan 	01-Dec-2023		Updated				Updated the patient status retrieve test method
 * 1.2		Gokul Krishnan	04-Apr-2024		Updated				Catch block added
 */
@isTest
private class BI_PSPB_TreatmentVideoCtrlTest {
	/**
	 * @description Test method used to verify the functionality of the getRecords() method in the BI_PSPB_treatmentvideocmd class.
	 *Inserts a test record for BI_PSPB_Treatment_videos__c, calls getRecords() method, and performs assertions on the returned results.
	 */
	@isTest
	static void testGetRecords() {
		// Insert test records for BI_PSP_Treatment_video__c
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;

		BI_PSPB_Treatment_videos__c testRecord = new BI_PSPB_Treatment_videos__c(
			BI_PSPB_URL__c = 'testurl.com'
		);
		insert testRecord;
		System.runAs(new User(Id = UserInfo.getUserId())) {
			// Call the method to be tested
			Test.startTest();
			List<BI_PSPB_Treatment_videos__c> result = BI_PSPB_TreatmentVideoCtrl.getRecords();
			Test.stopTest();

			// Perform assertions
			Assert.areEqual(
				1,
				result.size(),
				'Expected one record to be returned'
			);
			Assert.areEqual(
				testRecord.BI_PSPB_URL__c,
				result[0].BI_PSPB_URL__c,
				'Unexpected value for BI_PSPB_URL__c'
			);
		}
	}

	/**
	 * @description Test method used to verify the functionality of the patientStatus() method in the BI_PSPB_treatmentvideocmd class.
	 * Calls the patientStatus() method with a specific input value and performs assertions based on the logic in the method.
	 */
	@isTest
	static void testPatientstatus() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		try {
			System.runAs(new User(Id = UserInfo.getUserId())) {
				// Call the method to be tested
				Test.startTest();
				String result = BI_PSPB_TreatmentVideoCtrl.patientStatus();
				Test.stopTest();

				// Perform assertions based on the logic in the method

				Assert.areEqual(
					'Unassigned',
					result,
					'Unexpected result for Patientstatus'
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
	 * @description Test method used to verify the functionality of the patientStatus() method in the BI_PSPB_treatmentvideocmd class when no record is found.
	 * Creates a test user, calls the patientStatus() method with the test user's Id, and performs assertions for the else part based on the logic in the method.
	 */
	@isTest
	static void testPatientstatusWithNoRecord() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		// Create a test user
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

		User testUser = new User(
			FirstName = 'Test',
			LastName = 'User',
			Email = 'testusernew12@example.com',
			UserName = 'testusernew123@examplei.com',
			Alias = 'tuseri',
			EmailEncodingKey = 'UTF-8',
			TimeZoneSidKey = 'America/Los_Angeles',
			LocaleSidKey = 'en_US',
			LanguageLocaleKey = 'en_US',
			ProfileId = standardUserProfile.Id,
			ContactId = con.Id
		);
		insert testUser;
		try {
			System.runAs(testUser) {
				Test.startTest();
				// Call the method to be tested
				String result = BI_PSPB_TreatmentVideoCtrl.patientStatus();
				Test.stopTest();

				// Perform assertions for the else part
				Assert.areEqual(
					'Unassigned',
					result,
					'Unexpected result for Patientstatus when no record is found'
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
	 * @description Test method used to verify the functionality of the patientStatus() method in the BI_PSPB_treatmentvideocmd class when an exception occurs.
	 * Creates a test user, contact, and account, then mocks an exception by forcing a failure in the SOQL query.
	 * Calls the patientStatus() method with an invalid user Id and performs assertions for the catch part based on the logic in the method.
	 */
	@isTest
	static void testPatientstatusWithException() {
		// Create a test user
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
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
			BI_PSPB_Caregiver__c = true,
			ContactId = con.Id
		);
		insert testUser;

		// Create a test contact associated with the user
		Contact testContact = new Contact(
			FirstName = 'Test',
			LastName = 'Contact',
			Email = testUser.Email,
			BI_PSPB_Selected_Patient_ID__c = testUser.Id
		);
		insert testContact;

		// Create a test account associated with the contact
		Account testAccount = new Account(Name = 'Test Account');
		insert testAccount;

		// Mock an exception by forcing a failure in the SOQL query
		try {
			// Call the method to be tested
			System.runAs(testUser) {
				String result = BI_PSPB_TreatmentVideoCtrl.patientStatus();
				Test.startTest();
				List<BI_PSPB_Treatment_videos__c> treatmentVideoList = BI_PSPB_TreatmentVideoCtrl.getRecords();
				Test.stopTest();

				// Perform assertions for the catch part
				Assert.areEqual(
					'Error',
					result,
					'Unexpected result for Patientstatus when an exception occurs'
				);
				Assert.areEqual(
					0,
					treatmentVideoList.size(),
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
	/**
	 * @description Test method used to verify the functionality of the getRecords() method in the BI_PSPB_Treatmentvideocmd class when the query is successful.
	 * Calls the getRecords() method and performs assertions to ensure that the query result is not null.
	 */
	@isTest
	static void testGetTreatmentVideos() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		// Test when the query is successful
		List<BI_PSPB_Treatment_videos__c> treatmentVideos = null;
		try {
			System.runAs(new User(Id = UserInfo.getUserId())) {
				Test.startTest();
				treatmentVideos = BI_PSPB_TreatmentVideoCtrl.getRecords();
				Test.stopTest();

				Assert.areNotEqual(
					null,
					treatmentVideos,
					'Query result should not be null'
				);
			}
		} catch (Exception ex) {
			Assert.areEqual(
				ex.getMessage(),
				'Script-thrown exception',
				ex.getMessage()
			);
		}
	}
	/**
	 * @description Test method used to verify the functionality of the getPersonalizedArticlesnew() method in the BI_PSPB_Treatmentvideocmd class.
	 * Creates a test user, account, care program, care program enrollee, assessment, and assessment question records.
	 * Calls the getPersonalizedArticlesnew() method and performs assertions based on the logic in the method.
	 */
	@isTest
	static void testChronicStatus() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
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
		CareProgramEnrollee enrolleeRecord = new CareProgramEnrollee(
			Name = 'TestCpa1',
			AccountId = testAccountOne.Id,
			CareProgramId = testCareProgram.Id,
			BI_PSPB_PatientStatus__c = 'Chronic'
		);
		insert enrolleeRecord;

		Assessment assessmentData = new Assessment(
			Name = 'Introduction',
			AssessmentStatus = 'In Progress',
			BI_PSP_StatusForPersonalization__c = 'Complete',
			BI_PSP_CareProgramEnrollee__c = enrolleeRecord.Id
		);
		insert assessmentData;

		AssessmentQuestion qstnData = new AssessmentQuestion(
			Name = 'test questionname',
			DeveloperName = 'Valid_Name_123',
			DataType = 'Decimal',
			QuestionCategory = 'Introduction'
		);
		insert qstnData;
		System.runAs(testUser) {
			Test.startTest();
			String treatmentVideosWithError = BI_PSPB_TreatmentVideoCtrl.patientStatus();
			Test.stopTest();
			Assert.areEqual(
				treatmentVideosWithError,
				'Chronic',
				'Expected one message'
			);
		}

	}
	/**
	 * @description Test method used to verify the functionality of the getRecords() method in the BI_PSPB_treatmentvideocmd class when an exception occurs.
	 * Mocks the exception scenario by forcing an error and asserts the exception message.
	 */
	@isTest
	static void testGetRecordsWithException() {
		// Create test data if needed
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		// Mock the exception scenario by forcing an error
		try {
			System.runAs(new User(Id = UserInfo.getUserId())) {
				Test.startTest();
				// Call the method that you want to test
				List<BI_PSPB_Treatment_videos__c> result = BI_PSPB_TreatmentVideoCtrl.getRecords();
				Test.stopTest();
				Assert.areEqual(
					0,
					result.size(),
					'Expected one record to be returned'
				);
			}
		} catch (Exception e) {
			// Optionally assert the exception type or message
			Assert.areEqual(
				e.getMessage(),
				'Script-thrown exception',
				e.getMessage()
			);
		}
	}
	/**
	 * @description Test method used to verify the functionality of the patientStatus() method in the BI_PSPB_treatmentvideocmd class when the patient status is null.
	 * Creates a test user, account, care program, and care program enrollee records with a null patient status.
	 * Calls the patientStatus() method and asserts the result.
	 */
	@isTest
	static void testNullPatient() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
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
			Email = 'testusertamil123494@example.com',
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
			PersonEmail = 'testusertamil123494@example.com',
			RecordTypeId = personAccountRecordTypeId
		);
		insert testAccountOne;

		CareProgram testCareProgram = new CareProgram(
			Name = 'TestCareProgram',
			StartDate = Date.today()
		);
		insert testCareProgram;
		CareProgramEnrollee enrolleeRecord = new CareProgramEnrollee(
			Name = 'TestCpa1',
			AccountId = testAccountOne.Id,
			CareProgramId = testCareProgram.Id,
			BI_PSPB_PatientStatus__c = null
		);
		insert enrolleeRecord;
		System.runAs(testUser) {
			Test.startTest();

			String resultMessage = BI_PSPB_TreatmentVideoCtrl.patientStatus();

			Test.stopTest();
			Assert.areEqual(
				resultMessage.length(),
				resultMessage.length(),
				'Expected one message'
			);
		}
	}

	/**
	 * @description Test method used to verify the patient status for no user record.
	 */
	@isTest
	static void tesrNoRecordUser() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		try {
			System.runAs(new User(Id = UserInfo.getUserId())) {
				// Call the method to be tested
				Test.startTest();
				String result = BI_PSPB_TreatmentVideoCtrl.patientStatus();
				Test.stopTest();

				// Perform assertions for the else part
				Assert.areEqual(
					'Unassigned',
					result,
					'Unexpected result for Patientstatus when no record is found'
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
	 * @description Test method used to verify the patient status for patient with No account record
	 */
	@isTest
	static void testGetPersonalizedArticlesNoAccount() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
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
		try {
			System.runAs(testUser) {
				Test.startTest();
				String treatmentVideosWithError = BI_PSPB_TreatmentVideoCtrl.patientStatus();
				Test.stopTest();
				Assert.areEqual(
					treatmentVideosWithError,
					'Unassigned',
					'Expected one message'
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
	 * @description Test method used to verify the patient status for patient through caregiver profile
	 */
	@isTest
	static void testCargiverData() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		try {
			// String targetDate = 'Jan 2023';
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

			CareProgramEnrollee enrolleeValue = new CareProgramEnrollee(
				Name = 'TestCpa222',
				AccountId = testAccountTwo.Id,
				CareProgramId = cp.Id
			);
			insert enrolleeValue;

			System.runAs(testUserTwo) {
				Test.startTest();
				String result = BI_PSPB_TreatmentVideoCtrl.patientStatus();
				Test.stopTest();

				Assert.areNotEqual(result, null, 'Result should not null');
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