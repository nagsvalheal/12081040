@isTest
private class BI_PSP_CurrentUserTest {
 @testSetup
    static void setup() {
        // Create Profile
     /*   Profile standardUserProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];

        // Create User
        User testUser = new User(
            Email = 'testuser@example.com',
            BI_PSPB_Caregiver__c = false,
            Username = 'testuser@example.com',
            FirstName = 'Test',
            LastName = 'User',
            Alias = 'testu',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = standardUserProfile.Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;

        // Create Caregiver User
        User caregiverUser = new User(
            Email = 'caregiver@example.com',
            BI_PSPB_Caregiver__c = true,
            Username = 'caregiver@example.com',
            FirstName = 'Caregiver',
            LastName = 'User',
            Alias = 'careg',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = standardUserProfile.Id,
            LanguageLocaleKey = 'en_US'
        );
        insert caregiverUser;

        // Create Account
        Account patientAccount = new Account(
            LastName = 'Patient User',
            PersonEmail = 'testuser@example.com',
            IsPersonAccount = true,
            BI_PSPB_User_Type__c = 'Patient'
        );
        insert patientAccount;

        // Create Caregiver Account
        Account caregiverAccount = new Account(
            LastName = 'Caregiver User',
            PersonEmail = 'caregiver@example.com',
            IsPersonAccount = true,
            BI_PSPB_User_Type__c = 'Caregiver',
            BI_PSPB_Selected_Patient_ID__c = patientAccount.Id
        );
        insert caregiverAccount;

        // Create CareProgramEnrollee
        CareProgramEnrollee enrollee = new CareProgramEnrollee(
            AccountId = patientAccount.Id,
            Name = 'Enrollee Record'
        );
        insert enrollee;*/
        
        
    }
        
        

    @isTest
    static void testReturnTheAccountsAsPatient() {
        User testUser = [SELECT Id FROM User WHERE Email = 'testuser@example.com' LIMIT 1];
        System.runAs(testUser) {
            Test.startTest();
            List<Account> accounts = BI_PSP_CurrentUser.returnTheAccounts();
            Test.stopTest();

            System.assertEquals(1, accounts.size());
            System.assertEquals('Patient User', accounts[0].LastName);
        }
    }

    @isTest
    static void testReturnTheAccountsAsCaregiver() {
        User caregiverUser = [SELECT Id FROM User WHERE Email = 'caregiver@example.com' LIMIT 1];
        System.runAs(caregiverUser) {
            Test.startTest();
            List<Account> accounts = BI_PSP_CurrentUser.returnTheAccounts();
            Test.stopTest();

            System.assertEquals(1, accounts.size());
            System.assertEquals('Patient User', accounts[0].LastName);
        }
    }

    @isTest
    static void testGetCurrentUser() {
        User testUser = [SELECT Id FROM User WHERE Email = 'testuser@example.com' LIMIT 1];
        System.runAs(testUser) {
            Test.startTest();
            User currentUser = BI_PSP_CurrentUser.getCurrentUser();
            Test.stopTest();

            System.assertNotEquals(null, currentUser);
            System.assertEquals('testuser@example.com', currentUser.Email);
        }
    }

    @isTest
    static void testGetEnrolleeRecordsAsPatient() {
        User testUser = [SELECT Id FROM User WHERE Email = 'testuser@example.com' LIMIT 1];
        System.runAs(testUser) {
            Test.startTest();
            List<CareProgramEnrollee> enrollees = BI_PSP_CurrentUser.getEnrolleeRecords();
            Test.stopTest();

            System.assertEquals(1, enrollees.size());
            System.assertEquals('Enrollee Record', enrollees[0].Name);
        }
    }

    @isTest
    static void testGetEnrolleeRecordsAsCaregiver() {
        User caregiverUser = [SELECT Id FROM User WHERE Email = 'caregiver@example.com' LIMIT 1];
        System.runAs(caregiverUser) {
            Test.startTest();
            List<CareProgramEnrollee> enrollees = BI_PSP_CurrentUser.getEnrolleeRecords();
            Test.stopTest();

            System.assertEquals(1, enrollees.size());
            System.assertEquals('Enrollee Record', enrollees[0].Name);
        }
    }
}