import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

Panel {
  id: root
  moduleName: "io.github.pooriaarab.content-rabbit"
  manageIpc: false

  property var anchorItem: null
  property var hostWidget: null
  property int activeView: 0
  property string notice: ""
  readonly property int draftCount: draftModel.count
  readonly property string draftPath: Quickshell.env("HOME")
    + "/.local/state/omarchy/content-rabbit-drafts.json"

  function open() {
    root.controller.show()
  }

  function close() {
    root.controller.hide()
  }

  function switchPanel(direction) {
    if (root.bar && typeof root.bar.switchPanelFrom === "function")
      return root.bar.switchPanelFrom(root.hostWidget || root, direction)
    return false
  }

  function loadDrafts(raw) {
    draftModel.clear()
    try {
      var drafts = JSON.parse(raw)
      for (var i = 0; i < drafts.length; i++) {
        if (typeof drafts[i].text === "string" && drafts[i].text.trim())
          draftModel.append(drafts[i])
      }
    } catch (_) {
      notice = "Saved drafts could not be read."
    }
  }

  function saveDrafts() {
    var drafts = []
    for (var i = 0; i < draftModel.count; i++) drafts.push(draftModel.get(i))
    draftFile.setText(JSON.stringify(drafts, null, 2) + "\n")
  }

  function saveCurrentDraft() {
    var text = composer.text.trim()
    if (!text) {
      notice = "Write something before saving."
      return
    }
    draftModel.insert(0, { text: text, savedAt: new Date().toISOString() })
    saveDrafts()
    composer.text = ""
    notice = "Saved locally."
  }

  function handoff(text) {
    var value = text.trim()
    if (!value) {
      notice = "Write something before handing off."
      return
    }
    Quickshell.clipboardText = value
    Qt.openUrlExternally("https://contentrabbitai.com")
    notice = "Copied to your clipboard. Paste it into a new draft."
  }

  function openDraft(index) {
    if (index < 0 || index >= draftModel.count) return
    handoff(draftModel.get(index).text)
  }

  function deleteDraft(index) {
    if (index < 0 || index >= draftModel.count) return
    draftModel.remove(index)
    saveDrafts()
    notice = "Draft deleted."
  }

  ListModel { id: draftModel }

  FileView {
    id: draftFile
    path: root.draftPath
    watchChanges: true
    atomicWrites: true
    printErrors: false
    onLoaded: root.loadDrafts(text())
    onLoadFailed: root.loadDrafts("[]")
    onFileChanged: reload()
  }

  KeyboardPanel {
    id: panel
    anchorItem: root.anchorItem
    owner: root.hostWidget || root
    bar: root.bar
    open: root.opened
    focusTarget: keyCatcher
    contentWidth: panel.fittedContentWidth(Style.space(420))
    contentHeight: panel.fittedContentHeight(content.implicitHeight)

    PanelKeyCatcher {
      id: keyCatcher
      anchors.fill: parent
      onCloseRequested: root.close()
      onTabRequested: function(direction) { root.switchPanel(direction) }

      Column {
        id: content
        width: parent.width
        spacing: Style.space(8)

        Text {
          width: parent.width
          text: "Content Rabbit"
          color: root.barForeground
          font.family: root.bar ? root.bar.fontFamily : Style.font.family
          font.pixelSize: Style.font.subtitle
          font.bold: true
        }

        Text {
          width: parent.width
          text: "Capture an idea now. Review and publish it in Content Rabbit."
          color: root.barForeground
          font.family: root.bar ? root.bar.fontFamily : Style.font.family
          font.pixelSize: Style.font.body
          wrapMode: Text.WordWrap
        }

        Row {
          spacing: Style.space(6)

          Button {
            text: "Capture"
            selected: root.activeView === 0
            onClicked: root.activeView = 0
          }

          Button {
            text: "Saved " + root.draftCount
            selected: root.activeView === 1
            onClicked: root.activeView = 1
          }

          Button {
            text: "Open app"
            onClicked: Qt.openUrlExternally("https://contentrabbitai.com")
          }
        }

        Rectangle {
          width: parent.width
          height: root.activeView === 0 ? Style.space(230) : Style.space(230)
          color: root.bar ? root.bar.background : Color.background
          border.color: root.barForeground
          border.width: 1
          radius: Style.cornerRadius

          Column {
            anchors.fill: parent
            anchors.margins: Style.space(10)
            spacing: Style.space(8)

            Item {
              visible: root.activeView === 0
              width: parent.width
              height: visible ? parent.height : 0

              Column {
                anchors.fill: parent
                spacing: Style.space(8)

                Text {
                  text: "QUICK CAPTURE"
                  color: root.barForeground
                  font.family: root.bar ? root.bar.fontFamily : Style.font.family
                  font.pixelSize: Style.font.caption
                  font.bold: true
                }

                TextEdit {
                  id: composer
                  width: parent.width
                  height: Style.space(126)
                  color: root.barForeground
                  font.family: root.bar ? root.bar.fontFamily : Style.font.family
                  font.pixelSize: Style.font.body
                  wrapMode: TextEdit.Wrap
                  selectByMouse: true
                  focus: root.activeView === 0
                  Keys.onPressed: function(event) {
                    if (event.key === Qt.Key_Return && event.modifiers & Qt.ControlModifier) {
                      root.handoff(text)
                      event.accepted = true
                    }
                  }
                }

                Row {
                  spacing: Style.space(6)

                  Button {
                    text: "Paste"
                    onClicked: composer.text += Quickshell.clipboardText
                  }

                  Button {
                    text: "Save locally"
                    onClicked: root.saveCurrentDraft()
                  }

                  Button {
                    text: "Copy and open"
                    onClicked: root.handoff(composer.text)
                  }
                }
              }
            }

            Item {
              visible: root.activeView === 1
              width: parent.width
              height: visible ? parent.height : 0

              ListView {
                anchors.fill: parent
                model: draftModel
                clip: true
                spacing: Style.space(6)

                delegate: Rectangle {
                  required property string text
                  required property string savedAt
                  required property int index
                  width: ListView.view.width
                  height: Style.space(70)
                  color: root.bar ? root.bar.background : Color.background
                  border.color: root.barForeground
                  border.width: 1
                  radius: Style.cornerRadius

                  Column {
                    anchors.fill: parent
                    anchors.margins: Style.space(8)
                    spacing: Style.space(4)

                    Text {
                      width: parent.width
                      text: model.text
                      color: root.barForeground
                      font.family: root.bar ? root.bar.fontFamily : Style.font.family
                      font.pixelSize: Style.font.body
                      elide: Text.ElideRight
                    }

                    Row {
                      spacing: Style.space(6)

                      Button {
                        text: "Open"
                        onClicked: root.openDraft(index)
                      }

                      Button {
                        text: "Delete"
                        onClicked: root.deleteDraft(index)
                      }
                    }
                  }
                }
              }
            }
          }
        }

        Text {
          visible: root.notice !== ""
          width: parent.width
          text: root.notice
          color: root.barForeground
          font.family: root.bar ? root.bar.fontFamily : Style.font.family
          font.pixelSize: Style.font.caption
          wrapMode: Text.WordWrap
        }
      }
    }
  }
}
