/*
* @description Test class validating CMS article, image, and news retrieval; includes methods for media,
 news, and exception handling. 
 In this test class (SeeAllData=true) is used. As per the Salesforce documentation, the 
 SeeAllData=false annotation does not work for retrieving data from the ConnectAPI. Therefore, we are using 
 SeeAllData=true in the test class test method.
 [https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/connectAPI_TestingApex.htm]
 try catch is used to handle the negative scenarios in test methods.
* History:
* Version	Author			Date			Detail				Description
* 1.0		Gokul Krishnan	05-Nov-2023		Created				Initial development
* 1.1		Gokul Krishnan 	05-Feb-2024		Updated				Updated the patient status retrieve
* 1.2		Gokul Krishnan	22-Apr-2024		Updated				Updated cms retrieve test method
* 1.3		Gokul Krishnan	28-Apr-2024		Updated				test method try catch block added for 
																negative scenarios
* 1.4		Gokul Krishnan	02-May-2024		Updated				Test method added for article like
																response retrieve and update
*/
@isTest
private class BI_PSPB_CmsCtrlTest {
	/*
	 @description    : Test method used to check reterieve of cms news content from cms */

	@isTest(SeeAllData=true)
	static void testRetrieveNewsFromCMS() {
		// Create test data
		String articleName = 'What is GPP?';
		// Call the method being tested
		Test.startTest();
		System.runAs(new User(Id = UserInfo.getUserId())) {
			String result = BI_PSPB_CmsCtrl.retrieveNewsFromCMS(articleName);

			Test.stopTest();

			// Assert the results
			Assert.areNotEqual(null, result, 'Result should not be null');
			// Add more assertions as needed based on your logic
		}
	}

	/*
	 @description    : Test method used to test reterieve of cms news content from cms */

	@isTest(SeeAllData=true)
	static void testRetrieveMediaFromCMSNew() {
		// Create test data
		String testChannelName = 'BI_PSPB_Branded';

		// Call the method being tested
		Test.startTest();
		System.runAs(new User(Id = UserInfo.getUserId())) {
			String result = BI_PSPB_CmsCtrl.retrieveMediaFromCMSNews(
				testChannelName
			);

			Test.stopTest();

			// Assert the results
			Assert.areNotEqual(null, result, 'Result should not be null');
			// Add more assertions as needed based on your logic
		}
	}

	/*
	 @description    : Test method used to check reterieve of cms content news, images and media urls 
	 from cms with null value */

	@isTest
	static void testExceptionHandling() {
		// Simulate an exception by forcing an error
		Test.startTest();
		try {
			System.runAs(new User(Id = UserInfo.getUserId())) {
				String resultnewsmedia = BI_PSPB_CmsCtrl.retrieveMediaFromCMSNews(
					null
				);

				Assert.areEqual(
					'Error',
					resultnewsmedia,
					'Expected one message'
				);
			}
		} catch (Exception e) {
			// To assert error throw in apex for negative scenario
			// Assert that the exception message is as expected
			Assert.areEqual(
				e.getMessage(),
				'Script-thrown exception',
				e.getMessage()
			);
		}
		Test.stopTest();
	}
	/*
	 @description    : Test method used to check reterieve of cms news content from cms with no channel */

	@isTest(SeeAllData=false)
	static void testRetrieveNewsWithNoChannel() {
		try {
			// Create test data
			String testChannelName = 'None';
			// Simulate an exception by forcing an error
			// Call the method being tested
			Test.startTest();
			System.runAs(new User(Id = UserInfo.getUserId())) {
				String result = BI_PSPB_CmsCtrl.retrieveNewsFromCMS(
					testChannelName
				);

				Test.stopTest();

				// Assert the results
				Assert.areNotEqual(null, result, 'Result should not be null');
				// Add more assertions as needed based on your logic
			}
		} catch (Exception e) {
			// To assert error throw in apex for negative scenario
			// Assert that the exception message is as expected
			Assert.areEqual(
				e.getMessage(),
				'Script-thrown exception',
				e.getMessage()
			);
		}
	}

	/*
	 @description    : Test method used to check reterieve of cms news content from cms where channel name is
	 blank */

	@isTest(SeeAllData=false)
	static void testRetrieveNewsEmptyChannel() {
		try {
			// Create test data
			String testChannelName = '';
			// Simulate an exception by forcing an error
			// Call the method being tested
			Test.startTest();
			System.runAs(new User(Id = UserInfo.getUserId())) {
				String result = BI_PSPB_CmsCtrl.retrieveNewsFromCMS(
					testChannelName
				);

				Test.stopTest();

				// Assert the results
				Assert.areNotEqual(null, result, 'Result should not be null');
				// Add more assertions as needed based on your logic
			}
		} catch (Exception e) {
			// To assert error throw in apex for negative scenario
			// Assert that the exception message is as expected
			Assert.areEqual(
				e.getMessage(),
				'Script-thrown exception',
				e.getMessage()
			);
		}
	}

	/*
	 @description    : Test method used to check reterieve of cms media content from cms where channel name is
	 blank */

	@isTest(SeeAllData=false)
	static void testRetrieveMediaEmptyChannel() {
		try {
			// Create test data
			String testChannelName = '';
			// Simulate an exception by forcing an error
			// Call the method being tested
			Test.startTest();
			System.runAs(new User(Id = UserInfo.getUserId())) {
				String result = BI_PSPB_CmsCtrl.retrieveMediaFromCMSNews(
					testChannelName
				);

				Test.stopTest();

				// Assert the results
				Assert.areNotEqual(null, result, 'Result should not be null');
				// Add more assertions as needed based on your logic
			}
		} catch (Exception e) {
			// To verify error throw in apex for negative scenario
			// Assert that the exception message is as expected
			Assert.areEqual(
				e.getMessage(),
				'Script-thrown exception',
				e.getMessage()
			);
		}
	}

	/*
	 @description    : Test method used to check reterieve of cms media content from cms where channel name is
	 not exist */

	@isTest(SeeAllData=false)
	static void testRetrieveMediaNoneChannel() {
		try {
			// Create test data
			String testChannelName = 'None';
			// Simulate an exception by forcing an error
			// Call the method being tested
			Test.startTest();
			System.runAs(new User(Id = UserInfo.getUserId())) {
				String result = BI_PSPB_CmsCtrl.retrieveMediaFromCMSNews(
					testChannelName
				);

				Test.stopTest();

				// Assert the results
				Assert.areNotEqual(null, result, 'Result should not be null');
				// Add more assertions as needed based on your logic
			}
		} catch (Exception e) {
			// To verify error throw in apex for negative scenario
			// Assert that the exception message is as expected
			Assert.areEqual(
				e.getMessage(),
				'Script-thrown exception',
				e.getMessage()
			);
		}
	}
}