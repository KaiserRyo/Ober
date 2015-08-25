import bb.cascades 1.0
import nemory.NemAPI 1.0
import nemory.WebImageView 1.0
import bb.cascades.maps 1.0
import bb.system 1.0

import "../components"

Page 
{
    id: page

    titleBar: CustomTitleBar 
    {
        id: titleBar
        label_title.text: "SETTINGS"
        image_left.defaultImageSource: "asset:///media/images/instagram/nav_arrow_back.png"
        
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
        
        
    }
}