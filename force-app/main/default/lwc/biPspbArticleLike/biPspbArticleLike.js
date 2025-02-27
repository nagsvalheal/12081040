// This Lightning web component is used to display the like and unlike reactions on the article detail page
// To import Libraries
import { LightningElement, wire, api } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
// To import apex
import CHECK_REACTION from "@salesforce/apex/BI_PSPB_ArticleLikeCtrl.checkReaction";
import UPDATE_REACTION from "@salesforce/apex/BI_PSPB_ArticleLikeCtrl.updateReaction";
// To import Static Resource
import THUMBS_UP_ICON from '@salesforce/resourceUrl/BI_PSP_ThumbsUpIcon';
import THUMBS_RESPONSE from '@salesforce/resourceUrl/BI_PSP_ThumbsResponse';
// To import Custom Labels
import { LABELS } from 'c/biPspbLabelForInfoCenter';
// To get Current UserId
import ID from '@salesforce/user/Id';

export default class BiPspbArticleLike extends LightningElement {
	@api siteUrlq;
	thumbsUpIcon = THUMBS_UP_ICON;
	thumbsResponse = THUMBS_RESPONSE;
	result;
	articleTitle = '';
	userId = ID;
	showSpinner = false;
	artlicleLikeQuestion  = LABELS.ARTICLE_LIKE_QUESTION;


	// To change the response to like and dislike
	handleReaction() {
		this.showSpinner = true;
		const isLike = this.thumbsUpIcon !== THUMBS_RESPONSE;
		const reaction = isLike ? LABELS.LIKE_LABEL : LABELS.DISLIKE_LABEL;
		const newIcon = isLike ? THUMBS_RESPONSE : THUMBS_UP_ICON;
		const newTitle = `${reaction}: ${this.result}`;
	
		this.thumbsUpIcon = newIcon;
		UPDATE_REACTION({
			articleName: this.result,
			reaction: reaction
		})
		.then(() => {
			this.articleTitle = newTitle;
			this.showSpinner = false;
		})
		.catch((error) => {
			this.showSpinner = false;
			this.navigateToErrorPage(error.body.message);
		});
	}
	

	// To retrieve the current state id from current url
	// We are unable to utilize "data" or "error" as CurrentPageReference is default API.
	@wire(CurrentPageReference)
	pageReference({ state }) {
		try {
			if (state?.id) {
				this.result = state.id;
				this.articleTitle = 'Like: '+this.result;
			}
		} catch (err) {
			this.navigateToErrorPage(err.message); // Catching Potential Error
		}
	}
	// navigateToErrorPage used for all the error messages caught
	navigateToErrorPage(errorMessage) {
		let globalThis = window;
		globalThis.sessionStorage.setItem('errorMessage', errorMessage);
		globalThis.location.assign(this.siteUrlq + LABELS.ERROR_PAGE); 
	}

	// To retrieve the like response
	@wire(CHECK_REACTION, { articleName: "$result" })
	wiredreactdata({ error, data }) {
		try {
			if (data) {
				// Assign the data to the reactive property
				if (data === LABELS.LIKE_LABEL) {
					this.thumbsUpIcon = THUMBS_RESPONSE;
				} else {
					this.thumbsUpIcon = THUMBS_UP_ICON;
				}
			} else if (error) {
				this.navigateToErrorPage(error.body.message); // Catching Potential Error from apex
			}

		} catch (err) {
			this.navigateToErrorPage(err.message); // Catching Potential Error from lwc
		}
	}
}