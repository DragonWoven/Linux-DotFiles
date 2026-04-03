//@ pragma UseQApplication
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.SystemTray
PanelWindow {
  id: rootWindow
	visible: true
	implicitHeight: 30
	anchors.top: true
	anchors.left: true
	anchors.right: true
	color: "#1a1b26"

	WlrLayershell.layer: WlrLayer.Top
    	WlrLayershell.namespace: "quickshell"
      
       
	RowLayout {
		anchors.fill: parent
		anchors.margins: 8

		Repeater {
			model: 9
			Text {
				property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
                		property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
                		text: index + 1
                		color: isActive ? "#0db9d7" : (ws ? "#7aa2f7" : "#444b6a")
                		font { pixelSize: 14; bold: true }

				MouseArea {
					anchors.fill: parent
					onClicked: Hyprland.dispatch("workspace " + (index +1))
				}
			}

		}
		Item { Layout.fillWidth: true}
		Row {
      spacing: 5
			height: 24

      
			    
    	Repeater {
      model: SystemTray.items // Automatically tracks active tray apps
              
      delegate: MouseArea {
        id: trayItemRoot
        width: 24
        height: 24 
			  acceptedButtons: Qt.LeftButton | Qt.RightButton
        QsMenuAnchor{
          id: trayMenuAnchor
          menu: ModelData.menu
          anchor.rect: Qt.rect(trayItemRoot.x, trayItemRoot.y, trayItemRoot.width, trayItemRoot.height)
          anchor.edges: Quickshell.Bottom // Tells it to pop up below the icon
        }

			  onClicked: (mouse) => {
				  if (mouse.button === Qt.LeftButton) {
				  modelData.activate()
				  }
				  else if (mouse.button === Qt.RightButton) {
          var windowPos = trayItemRoot.mapToItem(null, mouse.x, mouse.y);
          modelData.display(rootWindow, windowPos.x, windowPos.y)
					}
				  } 

            
            		// The Icon
          Image {
            anchors.fill: parent
            source: modelData.icon // The service provides the icon path or name
          }
	    		
        
    			}	
		}
	}



		Text {
			id: clock
			color:"#7aa2f7"
    			text: Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm")

    		Timer {
        		interval: 1000
        		running: true
        		repeat: true
        		onTriggered: clock.text = Qt.formatDateTime(new Date(), "ddd, MMM dd - hh:mm AP")
    			}
		}

	}
}
