/**
 * @description Test class contains test methods to validate the correctness of various constant values and
 * maps used in the BI_PSPB_PersonalizationConstantCtrl class.
 *
 * History:
 * Version    Author            Date            Detail                Description
 * 1.0        Angelin Irin      30-Jul-2024     Created                Initial development
 */

 @isTest
 public class BI_PSPB_PersonalizationConstantCtrlTest {
	 /**
	  * @description Tests the initialization and correctness of general labels.
	  */
	 @isTest
	 static void testGeneralLabels() {
		 Assert.areEqual(
			 'General messages',
			 BI_PSPB_PersonalizationConstantCtrl.generalMessageCategory,
			 'Error in generalMessageCategory'
		 );
		 Assert.areEqual(
			 'Monday and Friday messages',
			 BI_PSPB_PersonalizationConstantCtrl.mondayFridayCategory,
			 'Error in mondayFridayCategory'
		 );
		 Assert.areEqual(
			 'Chronic',
			 BI_PSPB_PersonalizationConstantCtrl.chronicStatus,
			 'Error in chronicStatus'
		 );
		 Assert.areEqual(
			 'Acute',
			 BI_PSPB_PersonalizationConstantCtrl.acuteStatus,
			 'Error in acuteStatus'
		 );
	 }
 
	 /**
	  * @description Tests the GPP related labels.
	  */
	 @isTest
	 static void testGppLabels() {
		 Assert.areEqual(
			 'What is GPP?',
			 BI_PSPB_PersonalizationConstantCtrl.whatGppLabel,
			 'Error in whatGppLabel'
		 );
		 Assert.areEqual(
			 'Important facts about GPP',
			 BI_PSPB_PersonalizationConstantCtrl.factsGppLabel,
			 'Error in factsGppLabel'
		 );
		 Assert.areEqual(
			 'How rare is GPP?',
			 BI_PSPB_PersonalizationConstantCtrl.rareGppLabel,
			 'Error in rareGppLabel'
		 );
		 Assert.areEqual(
			 'Why do I have GPP?',
			 BI_PSPB_PersonalizationConstantCtrl.whyDoIHaveGppLabel,
			 'Error in whyDoIHaveGppLabel'
		 );
		 Assert.areEqual(
			 'Diagnosis and acceptance of GPP',
			 BI_PSPB_PersonalizationConstantCtrl.diagnosisGppLabel,
			 'Error in diagnosisGppLabel'
		 );
		 Assert.areEqual(
			 'Is GPP contagious?',
			 BI_PSPB_PersonalizationConstantCtrl.gppContagiousLabel,
			 'Error in gppContagiousLabel'
		 );
		 Assert.areEqual(
			 'Talking to friends and family',
			 BI_PSPB_PersonalizationConstantCtrl.friendsFamilyLabel,
			 'Error in friendsFamilyLabel'
		 );
		 Assert.areEqual(
			 'Feeling misunderstood and excluded',
			 BI_PSPB_PersonalizationConstantCtrl.feelingExcludedLabel,
			 'Error in feelingExcludedLabel'
		 );
		 Assert.areEqual(
			 'GPP and intimacy',
			 BI_PSPB_PersonalizationConstantCtrl.gppIntimacyLabel,
			 'Error in gppIntimacyLabel'
		 );
		 Assert.areEqual(
			 'GPP and pregnancy',
			 BI_PSPB_PersonalizationConstantCtrl.gppPregnancyLabel,
			 'Error in gppPregnancyLabel'
		 );
	 }
 
	 /**
	  * @description Tests the management related labels.
	  */
	 @isTest
	 static void testManagementLabels() {
		 Assert.areEqual(
			 'How to manage a flare',
			 BI_PSPB_PersonalizationConstantCtrl.manageFlareLabel,
			 'Error in manageFlareLabel'
		 );
		 Assert.areEqual(
			 'GPP and comorbidities',
			 BI_PSPB_PersonalizationConstantCtrl.gppComorbiditiesLabel,
			 'Error in gppComorbiditiesLabel'
		 );
		 Assert.areEqual(
			 'How to manage your GPP symptoms',
			 BI_PSPB_PersonalizationConstantCtrl.manageGppSymptomsLabel,
			 'Error in manageGppSymptomsLabel'
		 );
		 Assert.areEqual(
			 'What to ask your doctor',
			 BI_PSPB_PersonalizationConstantCtrl.askDoctorLabel,
			 'Error in askDoctorLabel'
		 );
		 Assert.areEqual(
			 'When to seek medical care',
			 BI_PSPB_PersonalizationConstantCtrl.seekMediCareLabel,
			 'Error in seekMediCareLabel'
		 );
		 Assert.areEqual(
			 'When to seek emergency treatment',
			 BI_PSPB_PersonalizationConstantCtrl.seekEmergencyLabel,
			 'Error in seekEmergencyLabel'
		 );
		 Assert.areEqual(
			 'Managing your scars',
			 BI_PSPB_PersonalizationConstantCtrl.manageScarsLabel,
			 'Error in manageScarsLabel'
		 );
		 Assert.areEqual(
			 'How to avoid complications with GPP',
			 BI_PSPB_PersonalizationConstantCtrl.complicatGppLabel,
			 'Error in complicatGppLabel'
		 );
	 }
 
	 /**
	  * @description Tests the response labels.
	  */
	 @isTest
	 static void testResponseLabels() {
		 Assert.areEqual(
			 'Maybe',
			 BI_PSPB_PersonalizationConstantCtrl.maybeResponse,
			 'Error in maybeResponse'
		 );
		 Assert.areEqual(
			 'No',
			 BI_PSPB_PersonalizationConstantCtrl.noResponse,
			 'Error in noResponse'
		 );
		 Assert.areEqual(
			 'Yes',
			 BI_PSPB_PersonalizationConstantCtrl.yesResponse,
			 'Error in yesResponse'
		 );
	 }
 
	 /**
	  * @description Tests the category labels.
	  */
	 @isTest
	 static void testCategoryLabels() {
		 Assert.areEqual(
			 'Management',
			 BI_PSPB_PersonalizationConstantCtrl.managementCategory,
			 'Error in managementCategory'
		 );
		 Assert.areEqual(
			 'Mental health',
			 BI_PSPB_PersonalizationConstantCtrl.mentalHealthCategory,
			 'Error in mentalHealthCategory'
		 );
		 Assert.areEqual(
			 'Social life',
			 BI_PSPB_PersonalizationConstantCtrl.socialLifeCategory,
			 'Error in socialLifeCategory'
		 );
		 Assert.areEqual(
			 'Healthy lifestyle',
			 BI_PSPB_PersonalizationConstantCtrl.healthyLifeStyleCategory,
			 'Error in healthyLifeStyleCategory'
		 );
	 }
 
	 /**
	  * @description Tests the question labels.
	  */
	 @isTest
	 static void testQuestionLabels() {
		 Assert.areEqual(
			 'Do you often discuss GPP with your friends and family?​',
			 BI_PSPB_PersonalizationConstantCtrl.oftenDiscussQstn,
			 'Error in oftenDiscussQstn'
		 );
		 Assert.areEqual(
			 'What aspects of your life have been affected by GPP?',
			 BI_PSPB_PersonalizationConstantCtrl.affectGppQstn,
			 'Error in affectGppQstn'
		 );
		 Assert.areEqual(
			 'Do you have other medical conditions?',
			 BI_PSPB_PersonalizationConstantCtrl.haveMediConditionQstn,
			 'Error in haveMediConditionQstn'
		 );
		 Assert.areEqual(
			 'I have a complete understanding of my Generalized pustular psoriasis (GPP).',
			 BI_PSPB_PersonalizationConstantCtrl.completeUnderstandGppQstn,
			 'Error in completeUnderstandGppQstn'
		 );
		 Assert.areEqual(
			 'I feel confident about recognizing GPP flares.',
			 BI_PSPB_PersonalizationConstantCtrl.feelConfidentQstn,
			 'Error in feelConfidentQstn'
		 );
		 Assert.areEqual(
			 'I can manage my GPP flares.',
			 BI_PSPB_PersonalizationConstantCtrl.manageFlareQstn,
			 'Error in manageFlareQstn'
		 );
		 Assert.areEqual(
			 'I have complete understanding of Spevigo® (spesolimab) and how it is used to treat my GPP.',
			 BI_PSPB_PersonalizationConstantCtrl.understandSpevigoQstn,
			 'Error in understandSpevigoQstn'
		 );
		 Assert.areEqual(
			 'I am not good at talking to my physician about my GPP.',
			 BI_PSPB_PersonalizationConstantCtrl.notGoodTalkingQstn,
			 'Error in notGoodTalkingQstn'
		 );
		 Assert.areEqual(
			 'I rely only on my physician to manage my GPP.',
			 BI_PSPB_PersonalizationConstantCtrl.relyPhysicianQstn,
			 'Error in relyPhysicianQstn'
		 );
		 Assert.areEqual(
			 'I don’t feel like I am doing enough to stay healthy in terms of diet, exercise, etc.',
			 BI_PSPB_PersonalizationConstantCtrl.stayHealthyQstn,
			 'Error in stayHealthyQstn'
		 );
		 Assert.areEqual(
			 'GPP is affecting my mental health (e.g. leading to depression and/or anxiety).',
			 BI_PSPB_PersonalizationConstantCtrl.affectMentalHealthQstn,
			 'Error in affectMentalHealthQstn'
		 );
		 Assert.areEqual(
			 'I have required support at home from my family members and/or caregiver to manage my GPP condition.',
			 BI_PSPB_PersonalizationConstantCtrl.requireSupportQstn,
			 'Error in requireSupportQstn'
		 );
		 Assert.areEqual(
			 'I am able to afford my GPP treatment.*',
			 BI_PSPB_PersonalizationConstantCtrl.affortTreatmentQstn,
			 'Error in affortTreatmentQstn'
		 );
		 Assert.areEqual(
			 'How long you have been diagnosed with Generalized Pustular Psoriasis (GPP)?​',
			 BI_PSPB_PersonalizationConstantCtrl.howLongGppQstn,
			 'Error in howLongGppQstn'
		 );
		 Assert.areEqual(
			 'What is your gender?​',
			 BI_PSPB_PersonalizationConstantCtrl.whatGenderQstn,
			 'Error in whatGenderQstn'
		 );
		 Assert.areEqual(
			 'Relationships with friends and family',
			 BI_PSPB_PersonalizationConstantCtrl.relationshipWithFriends,
			 'Error in relationshipWithFriends'
		 );
		 Assert.areEqual(
			 'Relationship with Partner',
			 BI_PSPB_PersonalizationConstantCtrl.relationshipWithPartner,
			 'Error in relationshipWithPartner'
		 );
		 Assert.areEqual(
			 'Self Esteem',
			 BI_PSPB_PersonalizationConstantCtrl.selfEsteem,
			 'Error in selfEsteem'
		 );
	 }
 }