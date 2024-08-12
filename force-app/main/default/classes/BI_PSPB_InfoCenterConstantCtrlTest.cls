/**
* @description This test class validates that the custom labels in the BI_PSPB_InfoCenterConstantCtrl class 
*              are correctly referenced and match the expected values.
* History:
* Version	Author			Date			Detail				Description
* 1.0		Angelin Irin	31-Jul-2024		Created				Initial development
*/
@isTest
public class BI_PSPB_InfoCenterConstantCtrlTest {



    /**
     * @description This method tests the custom labels in BI_PSPB_InfoCenterConstantCtrl to ensure they 
     *              match the expected values defined in the Salesforce setup.
     */
    @isTest
    static void testInfoCenterConstantCtrl() {
       
        Assert.areEqual('en_US', BI_PSPB_InfoCenterConstantCtrl.usEnglish, 'usEnglish custom label does not match');
        Assert.areEqual('news', BI_PSPB_InfoCenterConstantCtrl.cmsNews, 'cmsNews custom label does not match');
        Assert.areEqual('BI_PSPB_Branded', BI_PSPB_InfoCenterConstantCtrl.channelName, 'channelName custom label does not match');
        
        Assert.areEqual('Error retrieving cms news data', BI_PSPB_InfoCenterConstantCtrl.errorCmsNewsRetrieve, 'errorCmsNewsRetrieve custom label does not match');
        Assert.areEqual('Error in retrieving cms channel Id', BI_PSPB_InfoCenterConstantCtrl.errorCmsChannelIdRetrieve, 'errorCmsChannelIdRetrieve custom label does not match');
        Assert.areEqual('Error in retrieving cms news banner image and description', BI_PSPB_InfoCenterConstantCtrl.errorCmsNewsImageRetrieve, 'errorCmsNewsImageRetrieve custom label does not match');
        Assert.areEqual('Article parameter should not be null or blank.', BI_PSPB_InfoCenterConstantCtrl.articleParameterError, 'articleParameterError custom label does not match');
        
        Assert.areEqual('Insertion Failed', BI_PSPB_InfoCenterConstantCtrl.errorInsertLabel,'errorInsertLabel custom label does not match');
        Assert.areEqual('There was an error retrieving the article like or dislike response for the current user.', BI_PSPB_InfoCenterConstantCtrl.errorRetrieveLike, 'errorRetrieveLike custom label does not match');
        Assert.areEqual('Like', BI_PSPB_InfoCenterConstantCtrl.errorLikeLabel,'errorLikeLabel custom label does not match');
        Assert.areEqual('Dislike', BI_PSPB_InfoCenterConstantCtrl.errorDislikeLabel, 'errorDislikeLabel custom label does not match');
        Assert.areEqual('View', BI_PSPB_InfoCenterConstantCtrl.viewLabel, 'viewLabel custom label does not match');
    }
}