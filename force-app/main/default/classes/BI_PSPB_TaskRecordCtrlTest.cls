/**
@description    Test class for the BI_PSPB_TaskRecordTriggerHandler class.
@author                    Niyas
@Last Modified On       04/23/2024
@Last Modified By         Niyas
*/
@isTest
private class BI_PSPB_TaskRecordCtrlTest {
 /**
     * @description Test method to validate the handleBeforeInsert method of the trigger handler.
     */
    @isTest
    static void testHandleBeforeInsert() {
        // Create test data
        Account testAccount = new Account(Name = 'Test Account', BI_PSP_CommunityUsername__c = 'Test Community Username');
        insert testAccount;
        CareProgram testCP = new CareProgram(Name = 'Test Enrollee');
        insert testCP;
        CareProgramEnrollee testEnrollee = new CareProgramEnrollee(AccountId = testAccount.Id, Name = 'Test Enrollee', CareProgramId = testCP.Id);
        insert testEnrollee;
         BI_PSP_FeedItem__c feedItem = new BI_PSP_FeedItem__c(
            BI_PSP_CareProgramEnrollee__c = testEnrollee.Id,
            BI_PSP_AccountR__c = testAccount.Id
            // Add other required fields
        );
        insert feedItem;
        
        BI_PSP_FeedComment__c feedComment = new BI_PSP_FeedComment__c(
            BI_PSP_CareProgramEnrolleeCmt__c = testEnrollee.Id,
            BI_PSP_AccountCmt__c = testAccount.Id
            // Add other required fields
        );
        insert feedComment;
        Task testTask = new Task(
            Subject = 'Test Task',
            WhatId = testEnrollee.Id,
            BI_PSP_Category__c = 'Community',
            BI_PSP_Notification_Type__c = 'General',
            BI_PSP_ChatterType__c = 'CreatePost'
        );
        insert testTask;
      
        Task testTaskCommunityFollow = new Task(
            Subject = 'Test Task',
            WhatId = testEnrollee.Id,
            BI_PSP_Category__c = 'Community',
            BI_PSP_Notification_Type__c = 'General',
            BI_PSP_ChatterType__c = 'Follow'
        );
        insert testTaskCommunityFollow;
        Task testTaskCommunityComment = new Task(
            Subject = 'Test Task',
            WhatId = testEnrollee.Id,
            BI_PSP_Category__c = 'Community',
            BI_PSP_Notification_Type__c = 'General',
            BI_PSP_ChatterType__c = 'Comment'
        );
        insert testTaskCommunityComment;
        Task testTaskGeneral = new Task(
            Subject = 'Test Task',
            WhatId = testEnrollee.Id,
            BI_PSP_Category__c = 'Community',
            BI_PSP_Notification_Type__c = 'General',
            BI_PSP_ChatterType__c = 'Reaction'
        );
        insert testTaskGeneral;
         Task testTaskChallenges = new Task(
            Subject = 'Test Task',
            WhatId = testEnrollee.Id,
            BI_PSP_Category__c = 'Challenges',
            BI_PSP_Notification_Type__c = 'General'
        );
        insert testTaskChallenges;
         Task testTaskSymptom = new Task(
            Subject = 'Test Task',
            WhatId = testEnrollee.Id,
            BI_PSP_Category__c = 'Symptom Tracker',
            BI_PSP_Notification_Type__c = 'General'
        );
        insert testTaskSymptom;

        Test.startTest();
        // Call the trigger handler method
        BI_PSPB_TaskRecordCtrl.handleAfterInsert(new List<Task>{ testTask });
        BI_PSPB_TaskRecordCtrl.handleAfterInsert(new List<Task>{ testTaskCommunityFollow });
        BI_PSPB_TaskRecordCtrl.handleAfterInsert(new List<Task>{ testTaskCommunityComment});
        BI_PSPB_TaskRecordCtrl.handleAfterInsert(new List<Task>{ testTaskGeneral });
        BI_PSPB_TaskRecordCtrl.handleAfterInsert(new List<Task>{ testTaskChallenges });
        BI_PSPB_TaskRecordCtrl.handleAfterInsert(new List<Task>{ testTaskSymptom });
        BI_PSPB_TaskRecordCtrl.handleAfterInsert(new List<Task>());
        Test.stopTest();
        // Retrieve the inserted Task
        Task insertedTask = [SELECT Id, BI_PSP_Notification_Type__c, BI_PSP_ChatterType__c FROM Task WHERE Id = :testTask.Id];
        Task insertedTaskFollow = [SELECT Id, BI_PSP_Notification_Type__c, BI_PSP_ChatterType__c FROM Task WHERE Id = :testTaskCommunityFollow.Id];
        Task insertedTaskComment= [SELECT Id, BI_PSP_Notification_Type__c, BI_PSP_ChatterType__c FROM Task WHERE Id = :testTaskCommunityComment.Id];
        Task insertedTaskGeneral = [SELECT Id, BI_PSP_Notification_Type__c, BI_PSP_ChatterType__c FROM Task WHERE Id = :testTaskGeneral.Id];
        
        // Assert that the trigger handler correctly processed the Task
        Assert.areEqual('CreatePost', insertedTask.BI_PSP_ChatterType__c, 'Notification Type not set correctly.');
        Assert.areEqual('Follow', insertedTaskFollow.BI_PSP_ChatterType__c, 'Chatter Type not set correctly.');
        Assert.areEqual('Comment', insertedTaskComment.BI_PSP_ChatterType__c, 'Notification Type not set correctly.');
        Assert.areEqual('Reaction', insertedTaskGeneral.BI_PSP_ChatterType__c, 'Chatter Type not set correctly.');
    }
}