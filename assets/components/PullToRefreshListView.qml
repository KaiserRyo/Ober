import bb.cascades 1.0
import bb.platform 1.2

ListView 
{
    id: refreshableListView
    leadingVisualSnapThreshold: 0
    snapMode: SnapMode.LeadingEdge
    bufferedScrollingEnabled: true
    focusRetentionPolicyFlags: FocusRetentionPolicy.LoseToFocusable
    
    onCreationCompleted: 
    {
        if(Qt.app.getSetting("leadingEdgeScrolling", "false") == "true")
        {
            snapMode = SnapMode.LeadingEdge;
        }    
        else 
        {
            snapMode = SnapMode.Default;
        }
    }
    
    property bool refreshing : false;
    property string loadTopBottom : "top";
    property bool pullToRefresh : true;
    property string lastIDTop : "";
    property string lastIDBottom : "";
    property string lastSinceID : "";
    property string lastMaxID : "";
    property string prev_cursor : "";
    property string next_cursor : "";
    property bool canNowScroll : false;

    property bool force_bar_hiding : false;
    property bool being_touched : false;
    property int last_event_y : 0;
    property int scroll_offset : 10;
    property string last_scroll_direction : "";
    
    signal refreshTriggered();
    signal startRefreshing();
    signal stopRefreshing();
    signal scrolledUp();
    signal scrolledDown();
    
    onStartRefreshing: 
    {
        refreshing = true;
        refreshHeaderComponent.startRefreshing();
    }
    
    onStopRefreshing: 
    {
        refreshing = false;
        refreshHeaderComponent.stopRefreshing();
    }
    
    leadingVisual: RefreshHeader 
    {
        id: refreshHeaderComponent
        
        onRefreshTriggered:
        {
            refreshableListView.refreshTriggered();
            
            Qt.mediaPlayer.load();
        }
    }
    
    onTouch: 
    {
        if(pullToRefresh)
        {
            refreshHeaderComponent.onListViewTouch(event);
        }
        
        if(event.isDown())
        {
            last_event_y = event.localY;
            
            being_touched = true;
        }
        
        if(event.isMove())
        {
            being_touched = true;
        }
        
        if(event.isUp())
        {
            being_touched = false;
            
            if(last_event_y != event.localY)
            {
                var touch_difference = Math.abs((last_event_y - event.localY));
                
                if(touch_difference > scroll_offset)
                {
                    if(last_event_y < event.localY) // up
                    {
                        if(last_scroll_direction != "up")
                        {
                            if(Qt.app.getSetting("autoHideBars", "true") == "true" || force_bar_hiding)
                            {
                                scrolledUp();
                            }
                            
                            last_scroll_direction = "up";
                        }
                    }
                    else if(last_event_y > event.localY) // down
                    {
                        if(last_scroll_direction != "down")
                        {
                            if(Qt.app.getSetting("autoHideBars", "true") == "true" || force_bar_hiding)
                            {
                                scrolledDown();
                            }
                            
                            last_scroll_direction = "down";
                        }
                    }
                }
            }
        }  
    }

    function refreshHeader()
    {
        refreshTriggered();
        refreshHeaderComponent.refreshTriggered();
    }
    
    function scrollToTop()
    {
        scrollToPosition(ScrollPosition.Beginning, ScrollAnimation.Smooth);
    }
    
    function scrollToBottom()
    {
        scrollToPosition(ScrollPosition.End, ScrollAnimation.Smooth);
    }
}
