// This lightning web component is used for display the article detail content with all child components
// To import Libraries
import { LightningElement, wire } from 'lwc';
// To import Apex Classes
import PATIENT_STATUS from '@salesforce/apex/BI_PSPB_TreatmentVideoCtrl.patientStatus';
// To import Custom Labels
import { LABELS } from 'c/biPspbLabelForInfoCenter';
// To get Current UserId
import ID from '@salesforce/user/Id';

export default class BiPspbArticleContentParent extends LightningElement {

	urlq;
	showVideo = false;
	patientStatusRecord = '';
	showSpinner=false;
	renderedChildrenCount = 0;
	currentPageUrl;
	urlSegments;
	baseUrl;
	siteUrlq;
	userId = ID;
	totalChildren = 2; // Total number of child components
	articles = LABELS.ARTICLES;
	patientTreatmentVideos = LABELS.PATIENT_TREATMENT_VIDEOS;
	spevigoArticleLabel=LABELS.SPEVIGO_ARTICLES;

    // Getter to check if all children have rendered
    get allChildrenRendered() {
        return this.renderedChildrenCount >= this.totalChildren;
    }
   /**
     * @param {boolean} val
     */
    // Setter to increment the count when a child is rendered
    set childRendered(val) {
        if (val) {
            this.renderedChildrenCount = this.renderedChildrenCount+1;
            if (this.allChildrenRendered) {
                this.showSpinner = false;
            }
        }
    }


	// To navigate informationcenterLABELS.LANDING_PAGE
	openArticlesPage() {
		window.location.assign(this.siteUrlq + LABELS.LANDING_PAGE);
	}

	// To navigate Acute and Chronic video page
	openPTVPage() {
		if (this.patientStatusRecord === LABELS.ACUTE_STATUS) {
			window.location.assign(this.siteUrlq + LABELS.ACUTE_VIDEO_PAGE);
		} else if (this.patientStatusRecord === LABELS.CHRONIC_STATUS) {
			if (this.urlq === LABELS.BRANDED_URL) {
				window.location.assign(this.siteUrlq + LABELS.CHRONIC_VIDEO_PAGE);
			} else {
				window.location.assign(this.siteUrlq + LABELS.ACUTE_VIDEO_PAGE);
			}
		}
	}

	// Navigate to spevigo article category
	openSpevigoCategory() {

		if(this.patientStatusRecord === LABELS.CHRONIC_STATUS){
			window.location.assign(this.siteUrlq+LABELS.CATEGORY_PAGE+LABELS.FLARE_PREVENTION_LABEL)
		}
		else{
			window.location.assign(this.siteUrlq+LABELS.CATEGORY_PAGE+LABELS.FLARE_TREATMENT_LABEL)
		}
	}

	/*There's no need to check for null because in Apex, we're throwing an AuraHandledException. 
	Therefore, null data won't be encountered.*/
	//  To get patient status value of current logged in user
	@wire(PATIENT_STATUS)
	wiredPatientStatus({ error, data }) {
		try {
			if (data) {
				this.patientStatusRecord = data;
				if (this.patientStatusRecord === LABELS.UNASSIGNED_STATUS) {
					this.showVideo = false;
				}else {
					this.showVideo =true;
				}
			} else if (error) {
				// Handle the error
				this.navigateToErrorPage(error.body.message); // Catching Potential Error from Apex
			}
		} catch (err) {
			this.navigateToErrorPage(err.message); // Catching Potential Error from Lwc
		}
	}

	
	handleChildRendered(event) {
    this.childRendered = event.detail.rendered;
	}

	handleComponentReady(event) {
    this.childRendered = event.detail.rendered;
	}

	

	// To get the site name from current site url
	connectedCallback() {
		try {

			//Here it close spinner after react cliked
			this.showSpinner=true;
			let globalThis = window;
			let currentUrl = globalThis.location.href;

			// Create a URL object
			let urlObject = new URL(currentUrl);

			// Get the path
			let path = urlObject.pathname;

			// Split the path using '/' as a separator
			let pathComponents = path.split('/');

			// Find the component you need (in this case, 'Branded')
			let desiredComponent = pathComponents.find((component) =>
				[LABELS.BRANDED_URL.toLowerCase(), LABELS.UNASSIGNED_URL.toLowerCase()].includes(
					component.toLowerCase()
				)
			);

			if (desiredComponent.toLowerCase() === LABELS.BRANDED_URL.toLowerCase()) {
				this.urlq = LABELS.BRANDED_URL;
				this.siteUrlq = LABELS.BRANDED_SITE_URL;
			} else {
				this.urlq = LABELS.UNASSIGNED_URL;
				this.siteUrlq = LABELS.UNASSIGNED_SITE_URL;
			}
			this.currentPageUrl = globalThis.location.href;
			this.urlSegments = this.currentPageUrl.split('/');
			this.baseUrl = `${this.urlSegments[0]}//${this.urlSegments[2]}`;
			
		} catch (error) {
			this.navigateToErrorPage(error.message); // Caching Error from lwc
		}
	}

	// To render sub header of article detail page
	renderedCallback() {
		try {
			let windowWidth = window.innerWidth;
			let displayvideotab = this.template.querySelector(
				'.grid-containerNavTab'
			);

			if (windowWidth <= 1000) {
				if (displayvideotab) {
					displayvideotab.style.display = 'none';
				}
			} else if (displayvideotab) {
					displayvideotab.style.display = '';
				}
			this.renderedChildrenCount = this.renderedChildrenCount +1;
		if (this.allChildrenRendered) {
                this.showSpinner = false;
            }
		} catch (error) {
			this.navigateToErrorPage(error.message);
		}
	}

	// navigateToErrorPage used for all the error messages caught
	navigateToErrorPage(errorMessage) {
		let globalThis = window;
		globalThis.sessionStorage.setItem('errorMessage', errorMessage);
		globalThis.location.assign(this.siteUrlq + LABELS.ERROR_PAGE); 
	}
}