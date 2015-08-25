import bb.cascades 1.0
import nemory.WebImageView 1.0
import bb.cascades.maps 1.0
import bb.system 1.0
import nemory.ParseAPI 1.0

import "../components"
import "../dialogs"

Page 
{
    id: page
    
    titleBar: CustomTitleBar 
    {
        id: titleBar
        label_title.text: "ABOUT"
        image_left.defaultImageSource: "asset:///media/images/instagram/nav_arrow_back.png"
        image_right.visible: false
        
        onLeftButtonClicked: 
        {
            Qt.navigationPane.pop();
        }
    }
    
    Container 
    {
        id: mainContainer
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        
        layout: DockLayout {}

        ScrollView 
        {
            id: scrollView
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            
            Container 
            {
                id: content
                topPadding: 50
                bottomPadding: 100
                leftPadding: 30
                rightPadding: 30
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
                
                Container 
                {
                    horizontalAlignment: HorizontalAlignment.Center
                    
                    ImageView 
                    {
                        id: imageLogo
                        scalingMethod: ScalingMethod.AspectFit
                        imageSource: "asset:///images/480.png"   
                        preferredWidth: 200
                    }
                    
                    gestureHandlers: TapHandler 
                    {
                        onTapped: 
                        {
                            Qt.pictureViewer.invokePictureViewer(imageLogo.imageSource);
                        }
                    }
                }
                
                Label 
                {
                    text: "Version " + _app.app_version(); 
                    horizontalAlignment: HorizontalAlignment.Center
                    textStyle.fontSize: FontSize.Large
                    textStyle.fontWeight: FontWeight.W100
                    multiline: true
                }
                
                Label 
                {
                    text: "Your OS Version " + _app.os_version(); 
                    horizontalAlignment: HorizontalAlignment.Center
                    textStyle.fontSize: FontSize.XXSmall
                    textStyle.fontWeight: FontWeight.W100
                    multiline: true
                }
                
                Label 
                {
                    text: "Developed using QT, C++, QML, Javascript, JSON, HTML, CSS, BlackBerry Cascades UI Framework, Momentics IDE/QDE and The NemEngine";
                    horizontalAlignment: HorizontalAlignment.Center
                    textStyle.fontSize: FontSize.XXSmall
                    textStyle.textAlign: TextAlign.Center
                    multiline: true
                }
                
                Label 
                {
                    text: "Developed by: <a href='http://nemoryoliver.com'>Nemory Studios - Oliver Martinez</a>"
                    multiline: true
                    textFormat: TextFormat.Html
                    horizontalAlignment: HorizontalAlignment.Center
                    textStyle.textAlign: TextAlign.Center
                    textStyle.fontSize: FontSize.XXSmall
                    textStyle.fontWeight: FontWeight.W400
                    maxWidth: 500
                }
                
                Container 
                {
                    id: applications
                    horizontalAlignment: HorizontalAlignment.Fill
                    
                    Header 
                    {
                        title: "Nemory Studios' Applications"
                    }
                    
                    Container 
                    {
                        id: apps_loading
                        topPadding: 30
                        horizontalAlignment: HorizontalAlignment.Center
                        
                        ActivityIndicator 
                        {
                            visible: apps_loading.visible
                            running: visible
                            horizontalAlignment: HorizontalAlignment.Center
                        }
                    }
                    
                    PullToRefreshListView 
                    {
                        id: listView
                        horizontalAlignment: HorizontalAlignment.Fill
                        snapMode: SnapMode.Default
                        pullToRefresh: false
                        preferredHeight: 50
                        
                        dataModel: ArrayDataModel
                        {
                            id: dataModel
                        }
                        
                        listItemComponents:
                        [
                            ListItemComponent
                            {
                                content: ApplicationItem
                                {
                                    id: rootApplication
                                    image_size: 100;
                                }
                            }
                        ]
                        
                        onTriggered: 
                        {
                            var item = dataModel.data(indexPath);
                            
                            _app.invokeBBWorld("appworld://content/" + item.content_id + "/");
                        }
                    }
                }

                Container 
                {    
                    topPadding: 10
                    bottomPadding: 10
                    
                    Header 
                    {
                        title: "LINKS"
                    }
                }
                
                Label 
                {
                    text: "Frequently Asked Questions (FAQS)"
                    textStyle.fontWeight: FontWeight.W400
                    horizontalAlignment: HorizontalAlignment.Fill
                    
                    gestureHandlers: TapHandler 
                    {
                        onTapped:
                        {
                            Qt.invokeBrowser.open("http://goo.gl/I0kgUE");
                            
                            Qt.app.flurryLogEvent("faqs_opened");
                        }
                    }
                }
                
                Divider {}
                
                Label 
                {
                    text: "Nemory Studios: BBM Channels"
                    textStyle.fontWeight: FontWeight.W400
                    horizontalAlignment: HorizontalAlignment.Fill
                    textFormat: TextFormat.Html
                    
                    gestureHandlers: TapHandler 
                    {
                        onTapped:
                        {
                            bbmChannelsInvoke.trigger("bb.action.OPENBBMCHANNEL");
                            
                            Qt.app.flurryLogEvent("bbm_channels_invoked");
                        }
                    }
                    
                    attachedObjects: 
                    [
                        Invocation 
                        {
                            id: bbmChannelsInvoke
                            query.invokeTargetId: "sys.bbm.channels.card.previewer"
                            query.invokeActionId: "bb.action.OPENBBMCHANNEL"
                            query.uri: "bbmc:C0042916B"
                        }
                    ]
                }
                
                Divider {}
                
                Label 
                {
                    text: "Nemory Studios: Facebook Page"
                    textStyle.fontWeight: FontWeight.W400
                    horizontalAlignment: HorizontalAlignment.Fill
                    
                    gestureHandlers: TapHandler 
                    {
                        onTapped:
                        {
                            Qt.invokeBrowser.open("https://www.facebook.com/nemorystudios");
                            
                            Qt.app.flurryLogEvent("facebook_nemorystudios");
                        }
                    }
                }
                
                Divider {}
                
                Label 
                {
                    text: "<a href='twitter:connect:nemory' style='text-decoration:none;'>Nemory Studios: Twitter</a>"
                    textStyle.fontWeight: FontWeight.W400
                    horizontalAlignment: HorizontalAlignment.Fill
                    textFormat: TextFormat.Html
                }
                
                Divider {}
                
                Label 
                {
                    text: "<a href='twitter:connect:nemoryoliver' style='text-decoration:none;'>Nemory Oliver: Twitter</a>"
                    textStyle.fontWeight: FontWeight.W400
                    horizontalAlignment: HorizontalAlignment.Fill
                    textFormat: TextFormat.Html
                }
                
                Divider {}
                
                Label 
                {
                    text: "<a href='appworld://content/57537888/' style='text-decoration:none;'>Rate " + _app.app_name() + " in BlackBerry World</a>"
                    textStyle.fontWeight: FontWeight.W400
                    horizontalAlignment: HorizontalAlignment.Fill
                    textFormat: TextFormat.Html
                }
                
                Divider {}
                
                Label 
                {
                    text: "Share " + Qt.app.app_name() + " to your friends"
                    textStyle.fontWeight: FontWeight.W400
                    horizontalAlignment: HorizontalAlignment.Fill
                    
                    gestureHandlers: TapHandler 
                    {
                        onTapped:
                        {
                            var value = Qt.app.app_hashtag() + " - The Best Uber Client for BlackBerry 10 http://appworld.blackberry.com/webstore/content/57537888/ ";
                            Qt.invokeShare.invoke(value);
                        }
                    }
                }
                
                Divider {}
                
                Label 
                {
                    text: "Invite your BBM Friends to download " + Qt.app.app_name()
                    textStyle.fontWeight: FontWeight.W400
                    horizontalAlignment: HorizontalAlignment.Fill
                    
                    gestureHandlers: TapHandler 
                    {
                        onTapped:
                        {
                            _app.inviteUserToDownloadViaBBM();
                            
                            Qt.app.flurryLogEvent("bbm_invite_friends");
                        }
                    }
                }
                
                Divider {}
                
                Label 
                {
                    text: "View Tutorial / Instructions"
                    textStyle.fontWeight: FontWeight.W400
                    horizontalAlignment: HorizontalAlignment.Fill
                    
                    gestureHandlers: TapHandler 
                    {
                        onTapped:
                        {
                            Qt.tutorialSheet.open();
                        }
                    }
                }
                
                Divider {}
                
                Label 
                {
                    text: "Contact our Support Email"
                    textStyle.fontWeight: FontWeight.W400
                    horizontalAlignment: HorizontalAlignment.Fill
                    
                    gestureHandlers: TapHandler 
                    {
                        onTapped:
                        {
                            contactFaqsDialog.show();
                        }
                    }
                    
                    attachedObjects: 
                    [
                        SystemDialog 
                        {
                            id: contactFaqsDialog
                            title: "Attention"
                            body: "Would you like to view the FAQs Page first for commonly asked questions before contacting our support?"
                            cancelButton.label: "Contact"
                            confirmButton.label: "View FAQs"
                            onFinished: 
                            {
                                if(buttonSelection().label == "View FAQs")
                                {
                                    Qt.invokeBrowser.open("http://goo.gl/I0kgUE");
                                    
                                    Qt.app.flurryLogEvent("faqs_opened");
                                }
                                else 
                                {
                                    Qt.invokeEmail.query.uri = "mailto:nemorystudios@gmail.com?subject=Support: Ober&body=\n\nApp_v: " + _app.app_version() + "\nOS_v: " + _app.os_version() + "\nDevice: " + _app.device();
                                    Qt.invokeEmail.query.updateQuery();
                                    
                                    Qt.app.flurryLogEvent("contact_support");
                                }
                                
                                cancel();
                            }
                        }
                    ]
                }
            }
        }
    }
    
    attachedObjects: 
    [
        ParseAPI 
        {
            id: parseAPI
            
            function loadApplications()
            {
                var params         = new Object();
                params.endpoint    = "functions/applications";
                params.data        = "";
                parseAPI.post(params);
                
                apps_loading.visible = true;
            }
            
            onComplete: 
            {
                console.log("**** ABOUT endpoint: " + endpoint + ", httpcode: " + httpcode + ", response: " + response);
                
                if(httpcode != 200)
                {
                    _app.flurryLogError(httpcode + " - " + endpoint + " - " + response);
                }
                else 
                {
                    var responseJSON = JSON.parse(response);
                    
                    if(endpoint == "functions/applications")
                    {
                        dataModel.clear();
                        
                        if(responseJSON.result && responseJSON.result.length > 0)
                        {
                            dataModel.insert(0, responseJSON.result);
                        }
                        
                        apps_loading.visible = false;
                        listView.preferredHeight = (130 * dataModel.size());
                    }
                }
            }
        }
    ]
}