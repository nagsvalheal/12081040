// This component is consolidate component used to update hcp patient information enrollment form main page.
// To import Libraries
import { LightningElement, wire} from 'lwc';

//  To import Apex Classes
import LEAD_GET from '@salesforce/apex/BI_PSPB_ThankyouPageUtilites.getExistingLeads';
import CAREGIVER_GET from '@salesforce/apex/BI_PSPB_ThankyouPageUtilites.getLeadCaregiver';
import PHYSICIAN_GET from '@salesforce/apex/BI_PSPB_EnrollmentUtilities.getHcpDetails';
import COTHANKS_GET from '@salesforce/apex/BI_PSPB_ThankyouPageUtilites.checkCaregiverData';

import { resource } from "c/biPspbEnrollmentFormResource";


export default class BiPspbPrepopulateSummaryPage extends LightningElement {
	//Proper naming conventions with camel case for all the variables will be followed in the future releases
	// Declaration of variables with  
	showSpinner = true;
	verifyTheInfo = resource.VERIFY_THE_INFO;
	verifyYourInfo = resource.VERIFY_YOUR_INFO;
	addressColan = resource.ADRRESS_COLAN;
	enrollHead = resource.ENROLL_SUMMARY;
	nameColan = resource.NAME_COLAN;
	dobColan = resource.DOB_COLAN;
	emailColan = resource.EMAIL_COLAN;
	phoneColan = resource.PHONE_COLAN;
	prescriptionInfo = resource.PRESCRIPTION_INFO;
	patientinfo = resource.PATIENT_INFO ;
	physicianInfo = resource.PHYSICIAN_INFO ;
	relationColan = resource.RELATION_COLAN;
	caregiverInfo = resource.CAREGIVER_INFO;
	age = true;
	head = true;
	recordDetails;
	caregiver;
	cargivers;
	result;
	recordId;
	count;
	email;
	messageContent;
	messageContentTwo;
	contData;
	valueAvatar = false;
	careEmail;
	// Declaration of Global variables
	beyandGpp = resource.BGPP;
	mailImg = resource.IMG;

	//to get Lead's Physician record
	renderedCallback() {
		try {
			// Retrieve the recordId from localStorage
			this.recordId = localStorage.getItem('recordId');
			PHYSICIAN_GET({ leadId: this.recordId })
				.then((result) => {

					// Assuming result is an array of physician records
					// Assigning the result to a trackable property for further usage
					this.physicianData = result;

				})
				.catch((error) => {
					let globalThis = window;
			globalThis.sessionStorage.setItem('errorMessage', error.body.message);
            globalThis.location?.assign(this.baseUrl +  resource.BRANDED_URL + this.errorPage );
				});
		} catch (error) {
			let globalThis = window;
			globalThis.sessionStorage.setItem('errorMessage', error.body.message);
            globalThis.location?.assign(this.baseUrl +  resource.BRANDED_URL + this.errorPage );
		}
	}

	// Handle errors and redirect to an error page
handleError(error) {
    let globalThis = window;
    globalThis.sessionStorage.setItem("errorMessage", error.body.message);
    globalThis.location?.assign(`${this.baseUrl}${resource.BRANDED_URL}${this.errorPage}`);
}

// General handler for data fetching
handleDataFetch({ data, errors }, targetField, additionalLogic = null) {
    try {
        if (data) {
			this.showSpinner = false;
            this[targetField] = data;
            if (additionalLogic) {
                additionalLogic.call(this, data);
            }
        } else if (errors) {
            this.handleError(errors);
        }
    } catch (err) {
        this.handleError(err);
    }
}

// Generate thank you message based on data
generateThankYouMessage() {
    if (this.contData === true) {
        this.messageContent = resource.THANKYOU_MSG_ONE + this.email;
        this.messageContentTwo = resource.THANKYOU_MSG_TWO;
    } else {
        this.messageContent = resource.THANKYOU_MSG_THREE;
        this.messageContentTwo = resource.THANKYOU_MSG_FOUR + this.email;
    }
}

// Wire methods utilizing the general data handler
@wire(LEAD_GET, { createLeadId: "$recordId" })
wiredRecordDetailsLead(result) {
    this.handleDataFetch(result, 'recordDetails', function (data) {
        this.email = data[0]?.Email;
    });
}

@wire(CAREGIVER_GET, { caregiverCreateId: "$recordId" })
wiredRecordDetailsCaregiver(result) {
    this.handleDataFetch(result, 'caregiver', function () {
        this.age = true;
        this.head = true;
        this.careEmail = this.caregiver[0]?.BI_PSPB_E_mail_ID__c;
        this.valueAvatar = true;
        if (this.careEmail) {
            this.callcothanks();
        }
        this.dispatchEvent(
            new CustomEvent(resource.SEND_AVATAR_MSG, { detail: this.valueAvatar })
        );
    });
}

@wire(PHYSICIAN_GET, { leadId: "$recordId" })
wiredRecordDetailsCaregivers(result) {
    this.handleDataFetch(result, 'caregivers', function () {
        this.age = false;
        this.head = false;
        if (!this.age) {
            this.messageContent = resource.THANKYOU_MSG_THREE;
            this.messageContentTwo = resource.THANKYOU_MSG_FOUR + ' ' + this.caregivers[0]?.Email;
        }
    });
}

@wire(COTHANKS_GET, { caregiverCreateId: "$recordId" })
wiredRecordDetailContact(result) {
    this.handleDataFetch(result, 'contData', function (data) {
        if (data && data.length > 0) {
            this.generateThankYouMessage();
        }
    });
}
}