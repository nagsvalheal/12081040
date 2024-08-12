@isTest
public class BI_PSPB_TaskCreationCtrlTest {

    @isTest
    static void testCreateTasks() {
        // Arrange
        // Create a list of enrollees (In a real scenario, these would be actual record IDs)
        List<Id> enrollees = new List<Id>();
        
        // Insert a few dummy Account records to simulate enrollees
        Account acc1 = new Account(Name = 'Test Account 1');
        Account acc2 = new Account(Name = 'Test Account 2');
        insert new List<Account>{acc1, acc2};
        
        enrollees.add(acc1.Id);
        enrollees.add(acc2.Id);

        // Create task parameters
        BI_PSPB_TaskParameters taskParams = new BI_PSPB_TaskParameters(
            'Test Subject',
            'SMS',
            'Category A',
            'Type B',
            'New'
        );

        // Act
        List<Task> tasks = BI_PSPB_TaskCreationCtrl.createTasks(enrollees, taskParams);

        // Assert
        System.assertEquals(2, tasks.size(), 'Two tasks should be created');
        for (Task task : tasks) {
            System.assertEquals(taskParams.subject, task.Subject, 'Subject should match');
            System.assertEquals(taskParams.notificationType, task.BI_PSP_Notification_Type__c, 'Notification Type should match');
            System.assertEquals(taskParams.category, task.BI_PSP_Category__c, 'Category should match');
            System.assertEquals(taskParams.treatmentType, task.BI_PSPB_Treatment_Type__c, 'Treatment Type should match');
            System.assertEquals(taskParams.status, task.Status, 'Status should match');
            System.assert(enrollees.contains(task.WhatId), 'Enrollee ID should be in the list of enrollees');
        }
    }

    @isTest
    static void testCreateTasksExceptionHandling() {
        // Arrange
        //List<Id> enrollees = new List<Id>{'invalidId1', 'invalidId2'};
        BI_PSPB_TaskParameters taskParams = new BI_PSPB_TaskParameters(
            'Test Subject',
            'SMS',
            'Category A',
            'Type B',
            'New'
        );

        // Act
        //List<Task> tasks = BI_PSPB_TaskCreationCtrl.createTasks(enrollees, taskParams);

        // Assert
        // Check that no tasks are created due to invalid IDs
        //System.assertEquals(0, tasks.size(), 'No tasks should be created due to invalid IDs');
        
        // You may want to verify that the exception logging method is called, but that requires mocking or checking logs
    }
}