/**
* @description  Used to
	create task when a video is uploaded and calling the method to
	send sms and email.
* History
* Version	Author			Date		Detail		Description
* 1.0		Niyas		24-07-2024		Created		Refactored Version
*/
public with sharing class BI_PSPB_PssQuestionariesSched implements Schedulable {
	/**
	 * @description  Used to create task when a video is uploaded and calling the
	 * method to send sms and email.
	 */
	public void execute(SchedulableContext ctx) {
		try {
			BI_PSPB_PssQuestionnaireServiceCtrl.processWpaiQuestionnaires();
		} catch (Exception ex) {
			BI_PSP_LogMessagesUtility.exceptionLogMessage(
                ex.getMessage(),
                BI_PSPB_PssQuestionariesSched.class.getName(),
                ex
            );
		}
	}
}