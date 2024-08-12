@isTest
public class BI_PSPB_TaskParametersTest {

    @isTest
    static void testBI_PSPB_TaskParametersConstructor() {
        // Arrange
        String subject = 'Test Subject';
        String notificationType = 'Email';
        String category = 'Reminder';
        String treatmentType = 'Type A';
        String status = 'Active';

        // Act
        BI_PSPB_TaskParameters taskParameters = new BI_PSPB_TaskParameters(
            subject,
            notificationType,
            category,
            treatmentType,
            status
        );

        // Assert
        System.assertEquals(subject, taskParameters.subject, 'Subject should match');
        System.assertEquals(notificationType, taskParameters.notificationType, 'Notification Type should match');
        System.assertEquals(category, taskParameters.category, 'Category should match');
        System.assertEquals(treatmentType, taskParameters.treatmentType, 'Treatment Type should match');
        System.assertEquals(status, taskParameters.status, 'Status should match');
    }
}