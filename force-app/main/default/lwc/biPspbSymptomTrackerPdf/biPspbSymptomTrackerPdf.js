//This LWC is used UserSymptomTracker graph download in pdf - biPspbSymptomTrackerPdf
// To import Libraries
import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// To import Custom labels and static resources
import * as label from 'c/biPspbLabelAndResourceSymptom';
//import jsPDF from '@salesforce/resourceUrl/JsFile';
//import { loadScript } from 'lightning/platformResourceLoader';

// To import Apex Classes
import FETCH_SYMPTOM_EROLLE from '@salesforce/apex/BI_PSP_SymptomTrackerGraphCtrl.getSymptomTrackerDetails';
import USER_DETAILS from '@salesforce/apex/BI_PSP_CurrentUser.getCurrentUser';
import GET_SELECTED_PATIENT from '@salesforce/apex/BI_PSP_CurrentUser.returnTheAccounts';
//import html2canvas from '@salesforce/resourceUrl/htmljs';

export default class BiPspbSymptomTrackerPdf extends LightningElement {
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	//@track variable declaration
	dateWithAllery = [];
	remainingItems = [];
	highlight = false;
	showLine;
	dateWithAlleryTwo = [];
	dateWithAlleryThree = [];
	dateWithAlleryFour = [];
	dateWithAlleryFive = [];
	dateWithAlleryAll = [];
	rightLess;
	nextSeven;
	nextSevenOne;
	nextSevenTwo;
	nextSevenThree;
	//Variable declaration
	monthName;
	monthValue;
	currentYear;
	selectedMonthValue;
	yellowEllipse = label.YELLOW_ELLIPSE;
	verticalLine =label.VERTICAL_LINE;
	darkRedEllipse = label.DARK_RED_ELLIPSE;
	blueEllipse = label.BLUE_ELLIPSE;
	greenEllipse = label.GREEN_ELLIPSE;
	violetEllipse = label.VIOLET_ELLIPSE;
	redEllipse = label.RED_ELLIPSE;
	darkYellowEllipse = label.DARK_YELLOW_ELLIPSE;
	navLogo = label.SITE_LOGO;
	userId = label.ID;
	errorMessage;
	userName;
	patientName = label.PATIENT_NAME;
	periodLabel = label.PERIOD_LABEL;
	itchinessLabel = label.ITCHINESS_VALUES;
	rednessLabel = label.REDNESS_VALUE;
	temperatureLabel = label.TEMPERATURE_VALUES;
	pustulesLabel = label.PUSTULES_VALUE;
	painLabel = label.PAIN_VALUES;
	fatigueLabel = label.FATIGUE_VALUES;
	moodLabel = label.MOOD_IMG;
	placeholder = label.MONTH;
	showEditBtn = false;
	picklistOptions = [
		{ label: label.JANUARY, value: label.JANUARY },
		{ label: label.FEBRUARY, value: label.FEBRUARY },
		{ label: label.MARCH, value: label.MARCH },
		{ label: label.APRIL, value: label.APRIL },
		{ label: label.MAY, value: label.MAY },
		{ label: label.JUNE, value: label.JUNE },
		{ label: label.JULY, value: label.JULY },
		{ label: label.AUGUST, value: label.AUGUST },
		{ label: label.SEPTEMBER, value: label.SEPTEMBER },
		{ label: label.OCTOBER, value: label.OCTOBER },
		{ label: label.NOVEMBER, value: label.NOVEMBER },
		{ label: label.DECEMBER, value: label.DECEMBER }
	];
	html2pdfInitialized = false;

    renderedCallback() {
        if (this.html2pdfInitialized) {
            return;
        }

        // loadScript(this, html2canvas,this,jsPDF)
        //     .then(() => {
        //         this.html2pdfInitialized = true;
        //         console.log('html2pdf.js loaded successfully');
        //     })
        //     .catch(error => {
        //         console.error('Error loading html2pdf.js:', error);
        //     });
    }
	generatePdf() {
    const element = this.template.querySelector('.printDoc');

    if (!element) {
        console.error('Element with class "printDoc" not found');
        return;
    }

//     console.log('Attempting to generate PDF for element:', element);
// setTimeout(() => {
//     window.html2canvas(element, { 
//         useCORS: true, // Enable CORS to handle cross-origin images
//         logging: true, // Enable logging for better debugging
//         scale: 2, // Increase scale to improve quality
//         backgroundColor: null // Ensures the background is transparent
//     })
//     .then(canvas => {
//         const imgData = canvas.toDataURL('image/png');
//     	//const { jsPDF } = window.jspdf;
//        // const doc = new jsPDF('p', 'mm', 'a4');
//         const pdfWidth = doc.internal.pageSize.getWidth();
//         const pdfHeight = (canvas.height * pdfWidth) / canvas.width;

//         doc.addImage(imgData, 'PNG', 0, 0, pdfWidth, pdfHeight);
//         doc.save('content.pdf');
//     })
//     .catch(error => {
//         console.error('Error generating canvas:', error);
//         alert('Failed to generate PDF. Check the console for more details.');
//     });
// }, 100); // Slight delay to ensure element is fully rendered


}


   
	//Each bar represents a date entry and its height is proportional to the number of image URLs.
	get bars() {
		return this.dateWithAllery.map(entry => ({
			height: `${entry.imageUrls.length * 20}px`,
			dates: entry.dates,
			imageUrls: entry.imageUrls
		}));
	}
	//Each bar represents a date entry and its height is proportional to the number of image URLs.
	get barsone() {
		return this.dateWithAlleryTwo.map(entry => ({
			height: `${entry.imageUrls.length * 20}px`,
			dates: entry.dates,
			imageUrls: entry.imageUrls
		}));
	}
	// Each bar represents a date entry and its height is proportional to the number of image URLs.
	get barsTwo() {
		return this.dateWithAlleryThree.map(entry => ({
			height: `${entry.imageUrls.length * 20}px`,
			dates: entry.dates,
			imageUrls: entry.imageUrls
		}));
	}
	//Each bar represents a date entry and its height is proportional to the number of image URLs.
	get barsThree() {
		return this.dateWithAlleryFour.map(entry => ({
			height: `${entry.imageUrls.length * 20}px`,
			dates: entry.dates,
			imageUrls: entry.imageUrls
		}));
	}
	//Each bar represents a date entry and its height is proportional to the number of image URLs.
	get barsFour() {
		return this.dateWithAlleryFive.map(entry => ({
			height: `${entry.imageUrls.length * 20}px`,
			dates: entry.dates,
			imageUrls: entry.imageUrls
		}));
	}

	//It retrieves URL parameters such as 'eroll', 'firstdate', and 'lastdate' to fetch symptom data for a specific enrollee within a given date range.
	connectedCallback() {
	
			let globalThis = window;

			let urlParams = new URLSearchParams(globalThis.location?.href.split(label.QUESTION_MARK)[1]);
			let eroll = urlParams.get(label.EROLLS);
			let firstdate = urlParams.get(label.FIRST_DATE);
			let lastdate = urlParams.get(label.LAST_DATE);
			const DATE = new Date(firstdate);
			const MONTH_NAMES = [label.JANUARY, label.FEBRUARY, label.MARCH, label.APRIL, label.MAY, label.JUNE, label.JULY, label.AUGUST, label.SEPTEMBER, label.OCTOBER, label.NOVEMBER, label.DECEMBER];
			this.monthName = MONTH_NAMES[DATE.getMonth() + 1];
			let month = this.monthName?.substr(0, 3);
			this.monthValue = month;
			const CURRENT_DATE = new Date();
			this.currentYear = CURRENT_DATE.getFullYear();
			this.getsymptomdatewithallergy(eroll, firstdate, lastdate);
			if (label.ID !== null && label.ID !== undefined) {
				USER_DETAILS()
					// Null data is checked and AuraHandledException is thrown from the Apex
					.then(user => {
						if (user.BI_PSPB_Caregiver__c === false) {
							this.userName = user.FirstName + ' ' + user.LastName;
						} else {
							// this.getSelectedPatientId();
							GET_SELECTED_PATIENT()
							.then(data => {
					
						
								// Null data is checked and AuraHandledException is thrown from the Apex
								this.userName = data[0].Name;
								console.log(this.userName,'this.userName',data.Name)
							})
							.catch(error => {
								this.showToast(label.ERROR_MESSAGE, error.message, label.ERROR_VARIANT);
							})
						}
					})
					.catch(error => {
						this.showToast(label.ERROR_MESSAGE, error.message, label.ERROR_VARIANT);
					})
			}
	
	}
	//This method is used to get the selected patient name of the current loggedin Caregiver
	// getSelectedPatientId() {
	// 	GET_SELECTED_PATIENT({ userId: ID })
	// 		.then(data => {
	// 			// Null data is checked and AuraHandledException is thrown from the Apex
	// 			this.userName = data.Name;
	// 		})
	// 		.catch(error => {
	// 			this.showToast(label.ERROR_MESSAGE, error.message, label.ERROR_VARIANT);
	// 		})
	// }
	//The formatted date string.		
	parsedDat(dateToFormat) {
		const PARSED_DATE = new Date(dateToFormat);
		const OPTIONS = { Month: label.SHORTS, day: label.NUMERICS };
		this.formattedDate = PARSED_DATE.toLocaleDateString(undefined, OPTIONS);
		return this.formattedDate;
	}
	// Handles the change event when the user selects a new month in the category dropdown.
	handleCategoryChange(event) {
		this.dateWithAllery = [];
		this.remainingItems = [];
		this.selectedMonthValue = event.target.value;
		const CURRENT_DATE = new Date();
		const SELECTED_MONTH_INDEX = new Date(Date.parse(this.selectedMonthValue + label.TWO_THOUSAND)).getMonth();
		if (SELECTED_MONTH_INDEX <= CURRENT_DATE.getMonth()) {
			const FIRST_DATE = new Date(CURRENT_DATE.getFullYear(), SELECTED_MONTH_INDEX, 1, 18, 30, 0);
			const LAST_DATE = new Date(CURRENT_DATE.getFullYear(), SELECTED_MONTH_INDEX + 1, 0, 18, 30, 0);
			this.getsymptomdatewithallergy(this.enrolleId, FIRST_DATE.toISOString(), LAST_DATE.toISOString());
		} else {
			const FIRST_DATE = new Date(CURRENT_DATE.getFullYear() - 1, SELECTED_MONTH_INDEX, 1, 18, 30, 0);
			const LAST_DATE = new Date(CURRENT_DATE.getFullYear() - 1, SELECTED_MONTH_INDEX + 1, 0, 18, 30, 0);
			this.getsymptomdatewithallergy(this.enrolleId, FIRST_DATE.toISOString(), LAST_DATE.toISOString());
		}
	}
	//Handles errors by displaying a toast message.
	getsymptomdatewithallergy(erolles, firstdate, lastdate) {
		try {
			FETCH_SYMPTOM_EROLLE({ erolleId: erolles, firstDate: firstdate, lastDate: lastdate })
				// Null data is checked and AuraHandledException is thrown from the Apex
				.then(result => {
					//If the result is not null, iterates through each item in the result array.
					if (result !== null) {
						result.forEach(item => {
							//Checks if there is an existing date entry in the dateWithAllery array matching the date of the current item.
							const EXISTING_DATE = this.dateWithAllery.find(entry => entry.dates === this.parsedDat(item.dates));
							if (EXISTING_DATE) {
								EXISTING_DATE.imageUrls.push(this.getImagesForName(item.name));
							} else {
								this.dateWithAllery.push({
									dates: this.parsedDat(item.dates),
									imageUrls: [this.getImagesForName(item.name)],
									symptom: item.symptom
								});
							}
						});
						this.dateWithAllery.sort((a, b) => new Date(a.dates) - new Date(b.dates));
						if (this.dateWithAllery.length > 7) {
							this.rightLess = true;
						} else {
							this.rightLess = false;
						}
						this.dateWithAlleryAll = this.dateWithAllery;
						this.dateWithAllery = this.dateWithAlleryAll.slice(0, 7);
						//If there are entries in the dateWithAllery array after slicing, assigns a subset of the entries to the dateWithAlleryTwo property.
						if (this.dateWithAllery.length > 0) {
							this.dateWithAlleryTwo = this.dateWithAlleryAll.slice(7, 14);
							if (this.dateWithAlleryTwo.length > 0) {
								this.nextSeven = true;
							} else {
								this.nextSeven = false;
							}
						}
						//If there are entries in the dateWithAllery array after slicing, assigns a subset of the entries to the dateWithAlleryThree property.
						if (this.dateWithAllery.length > 0) {
							this.dateWithAlleryThree = this.dateWithAlleryAll.slice(14, 21);
							if (this.dateWithAlleryThree.length > 0) {
								this.nextSevenOne = true;
							} else {
								this.nextSevenOne = false;
							}
						}
						//If there are entries in the dateWithAllery array after slicing, assigns a subset of the entries to the dateWithAlleryFour property.
						if (this.dateWithAllery.length > 0) {
							this.dateWithAlleryFour = this.dateWithAlleryAll.slice(21, 28);
							if (this.dateWithAlleryFour.length > 0) {
								this.nextSevenTwo = true;
							} else {
								this.nextSevenTwo = false;
							}
						}
						//If there are entries in the dateWithAllery array after slicing, assigns a subset of the entries to the dateWithAlleryFive property.
						if (this.dateWithAllery.length > 0) {
							this.dateWithAlleryFive = this.dateWithAlleryAll.slice(28, 35);
							if (this.dateWithAlleryFive.length > 0) {
								this.nextSevenThree = true;
							} else {
								this.nextSevenThree = false;
							}
						}
						//If there are entries in the dateWithAllery array, sets the showLine property to true to display a line chart.
						try {
							if (this.dateWithAllery.length > 0) {
								this.showLine = true;
								setTimeout(() => {
									this.myFunction();
								}, 10000);
							} else {
								this.showLine = false;
							}
						} catch (error) {
							this.showToast(label.ERROR_MESSAGE, error.message, label.ERROR_VARIANT);
							// Handle the error as needed
						}

					}
				})
				.catch(error => {
					this.showToast(label.ERROR_MESSAGE, error.message, label.ERROR_VARIANT);
				});
		} catch (error) {
			this.showToast(label.ERROR_MESSAGE, error.message, label.ERROR_VARIANT);
		}

	}
	//This function is typically called to allow users to print the content of the page.
	myFunction() {
		let globalThis = window;
		globalThis.print();
	}
	//The image URL corresponding to the symptom name.
	getImagesForName(name) {
		switch (name) {
			case label.REDNESS_VALUE:
				return label.RED_ELLIPSE;
			case label.ITCHINESS_VALUES:
				return label.DARK_YELLOW_ELLIPSE;
			case label.PAIN_VALUES:
				return label.VIOLET_ELLIPSE;
			case label.PUSTULES_VALUE:
				return label.GREEN_ELLIPSE;
			case label.FATIGUE_VALUES:
				return label.BLUE_ELLIPSE;
			case label.TEMPERATURE_VALUES:
				return label.DARK_RED_ELLIPSE;
			case label.MOOD_VALUES:
				return label.YELLOW_ELLIPSE;
			default:
				return label.DARK_RED_ELLIPSE;
		}
	}
	showToast(title, message, variant) {
		if (typeof window !== 'undefined') {
			const event = new ShowToastEvent({
				title: title,
				message: message,
				variant: variant
			});
			this.dispatchEvent(event);
		}
	}
}