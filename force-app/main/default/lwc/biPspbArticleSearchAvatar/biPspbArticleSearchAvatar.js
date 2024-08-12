// This lightning web component is used to display the avatar message in the Information Center search article Page
// To import Libraries
import { LightningElement, wire, api } from 'lwc';
// To import Apex Classes
import GET_LOGGEDIN_USER_ACCOUNT from '@salesforce/apex/BI_PSP_CurrentUser.getEnrolleeRecords';
// To import Static Resource
import DEFAULT_IMG from '@salesforce/resourceUrl/BI_PSPB_ProfileAvatar';
// To import Custom Labels
import { LABELS } from 'c/biPspbLabelForInfoCenter';

export default class BiPspbArticleSearchAvatar extends LightningElement {
	@api siteUrlq;
	renderedCount = 0;
	cardImage = '';
	acuteMessage = 'This is your information center. Find all the information you need to understand GPP. Learn the tips and tricks to better...';
	articleSearchAvatarMessage = LABELS.ARTICLE_SEARCH_AVATAR_MESSAGE;
	// Method to display message for mobile
	displayMessage() {
		this.acuteMessage = 'This is your information center. Find all the information you need to understand GPP. Learn the tips and tricks to better...';
		this.template.querySelector('.paranew').style.display = 'block';
	}

	// Method to display message for desktop
	displayExpandedMessage() {
		this.acuteMessage = 'This is your information center. Find all the information you need to understand GPP. Learn the tips and tricks to better manage your condition.';
		this.template.querySelector('.paranew').style.display = 'none';
	}

	// renderedCallback to dispatch event for parent component to identify component is rendered
	renderedCallback(){
		try{
			const event = new CustomEvent('childrendered', {
				detail: { rendered: true }
			});
			if(this.renderedCount<=2){
			this.dispatchEvent(event);
			this.renderedCount = this.rendedCount+1;
			}
			
		}
		catch(error){
			this.navigateToErrorPage(error.message);
		}
	}
	
	/* There's no need to check for null because in Apex, we're throwing an AuraHandledException. 
		Therefore, null data won't be encountered. */
	// To retrieve the logged in user name and selected avatar
	@wire(GET_LOGGEDIN_USER_ACCOUNT)
	wiredUserDetails({ error, data }) {
		try {
		if (data) {
			this.cardImage = data[0]?.BI_PSP_AvatarUrl__c
			? data[0]?.BI_PSP_AvatarUrl__c
			: DEFAULT_IMG;
		} else if (error) {
			this.navigateToErrorPage(error.body.message); // Catching Potential Error from Apex
		}
		} catch (err) {
		this.navigateToErrorPage(err.message); // Catching Potential Error from Lwc
		}
	}	

	// navigateToErrorPage used for all the error messages caught
	navigateToErrorPage(errorMessage) {
		let globalThis = window;
		globalThis.sessionStorage.setItem('errorMessage', errorMessage);
		globalThis.location.assign(this.siteUrlq + LABELS.ERROR_PAGE); 
	}
}