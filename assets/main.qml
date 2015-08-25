import bb.cascades 1.0
import bb.system 1.0
import bb.platform 1.0
import bb.platform 1.2
import QtQuick 1.0

import "pages"

NavigationPane 
{
    id: navigationPane
    
    property string appname : "Ober"
    property string appurl : "http://m.uber.com"
    property bool checkedAnnouncements : false;
    property bool checkedAnnouncementsHub : false;
    property bool ready : false;
    
    Page 
    {
        id: page

        actionBarVisibility: ChromeVisibility.Hidden
        
        Container 
        {
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
            
            layout: DockLayout {}
            
            ImageView 
            {
                visible: !ready
                imageSource: "asset:///images/Z10Splash.png"
                horizontalAlignment: HorizontalAlignment.Fill
                scalingMethod: ScalingMethod.AspectFill
            }
            
            Container 
            {
                id: loadingWithTexts
                visible: !ready
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Bottom
                
                bottomPadding: 100
                
                ProgressIndicator 
                {
                    id: progressBar
                    fromValue: 0.0
                    toValue: 1.0
                    value: browser.loadProgress
                    preferredWidth: 500
                    horizontalAlignment: HorizontalAlignment.Center
                }
                
                Label  
                {
                    id: loadingText
                    text: "Loading "+ appname +"... 0%"
                    horizontalAlignment: HorizontalAlignment.Center
                    textStyle.fontWeight: FontWeight.W100
                    textStyle.fontSize: FontSize.XXSmall
                    textStyle.fontStyle: FontStyle.Italic
                }
                
                Label  
                {
                    text: "Make sure your Location Services are on :)"
                    horizontalAlignment: HorizontalAlignment.Center
                    textStyle.fontSize: FontSize.XXSmall
                    textStyle.color: Color.Yellow
                }
            }
            
            Container 
            {
                id: stackContainer
                horizontalAlignment: HorizontalAlignment.Fill
                
                ScrollView 
                {
                    id: scrollView
                    visible: ready
                    verticalAlignment: VerticalAlignment.Fill
                    horizontalAlignment: HorizontalAlignment.Fill
                    
                    scrollViewProperties
                    {
                        scrollMode: ScrollMode.None
                    }
                    
                    WebView 
                    {
                        id: browser
                        url: "https://m.uber.com"
                        minHeight: _app.getDeviceHeight()
                        settings.background: Color.Transparent
                        
                        onLoadingChanged: 
                        {
                            if(!ready)
                            {
                                if (loadRequest.status == WebLoadStatus.Succeeded) 
                                {
                                    loadingText.text = "Preparing " + appname + "...";
                                    ready = true;
                                }
                                else if (loadRequest.status == WebLoadStatus.Failed) 
                                {
                                    progressBar.resetValue();
                                }
                            }
                        }
                        
                        onLoadProgressChanged: 
                        {
                            if(!ready)
                            {
                                progressBar.value = loadProgress / 100.0
                                loadingText.text = "Loading " + appname + "... " + loadProgress + "%";
                            }
                        }
                    }
                }
            }
            
            ProgressIndicator 
            {
                visible: ready && browser.loading
                fromValue: 0.0
                toValue: 1.0
                value: browser.loadProgress
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Bottom
            }
        }

        Menu.definition: MenuDefinition 
        {
            actions: 
            [
                ActionItem 
                {
                    title: "About"
                    imageSource: "asset:///images/titleInfo.png"
                    onTriggered: 
                    {
                        var page = aboutComponent.createObject();
                        navigationPane.push(page);
                    }
                },
                ActionItem 
                {
                    title: "Settings"
                    imageSource: "asset:///images/settings.png"
                    
                    onTriggered:
                    {
                        var page = settingsComponent.createObject();
                        navigationPane.push(page);
                    }
                },
                ActionItem  
                {
                    title: "Contact"
                    imageSource: "asset:///images/menuEmail.png"
                    
                    onTriggered: 
                    {
                        invokeEmail.query.uri = "mailto:nemorystudios@gmail.com?subject=Support : Ober"
                        invokeEmail.query.updateQuery();
                        
                        _app.flurryLogEvent("CONTACT");
                    }
                },
                ActionItem 
                {
                    title: "Rate & Review"
                    imageSource: "asset:///images/rate.png"
                    enabled: true
                    
                    onTriggered:
                    {
                        invokeBBWorld.query.uri = "appworld://content/57537888";
                        invokeBBWorld.trigger("bb.action.OPEN")
                        
                        _app.flurryLogEvent("RATE");
                    }
                },
                ActionItem 
                {
                    title: "Logout"
                    imageSource: "asset:///images/tabLogout.png"
                    enabled: true
                    
                    onTriggered:
                    {
                        logout();
                    }
                }
            ]
        }
    }   
    
    attachedObjects: 
    [
        ComponentDefinition 
        {
            id: aboutComponent
            source: "asset:///pages/About.qml"  
        },
        ComponentDefinition 
        {
            id: settingsComponent
            source: "asset:///pages/Settings.qml"  
        },
        Invocation 
        {
            id: invokeShare
            query.mimeType: "text/plain"
            query.invokeActionId: "bb.action.SHARE"
            query.invokerIncluded: true
            query.data: "Ober -Uber App for BlackBerry 10. Get it http://appworld.blackberry.com/webstore/content/57537888"
        },
        Invocation 
        {
            id: invokeBBWorld
            query.mimeType: "text/html"
            query.uri: "appworld://content/57537888"
            query.invokeActionId: "bb.action.OPEN"
        },
        Invocation 
        {
            id: invokeEmail
            query.mimeType: "text/plain"
            query.invokeTargetId: "sys.pim.uib.email.hybridcomposer"
            query.invokeActionId: "bb.action.SENDEMAIL"
            onArmed: 
            {
                invokeEmail.trigger(query.invokeActionId);
            }
        },
        SystemDialog
        {
            id: dialog
            title: "Attention"
            
            function pop(message)
            {
                dialog.body = message;
                dialog.show();
            }
        },
        SystemToast 
        {
            id: toast
            position: SystemUiPosition.BottomCenter
            
            function pop(message)
            {
                toast.body = message;
                toast.show();
            }
        }
    ]
    
    function clearBrowserData()
    {
        browser.storage.clearCache();
        browser.storage.clearLocalStorage();
        browser.storage.clearWebFileSystem();
        browser.reload();
    }
    
    function logout()
    {
        browser.storage.clearCookies();
        browser.reload();
    }
    
    onCreationCompleted: 
    {
        Qt.app                   = _app;
        Qt.dialog                = dialog;
        Qt.toast                 = toast;
        Qt.invokeShare           = invokeShare;
        Qt.invokeBBWorld         = invokeBBWorld;
        Qt.invokeEmail           = invokeEmail;  
        Qt.navigationPane        = navigationPane;
    }  
}