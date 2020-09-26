B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=7.8
@EndOfDesignText@
Sub Class_Globals
	Private fx As JFX
	Private frm As Form
	Private TabPane1 As TabPane
	Private BiTextArea As TextArea
	Private sourceTextArea As TextArea
	Private targetTextArea As TextArea
	Private result As Map
	Private mLangpair As Map
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(langpair As Map)
	frm.Initialize("frm",500,200)
	frm.RootPane.LoadLayout("clipboardreader")
    TabPane1.LoadLayout("TextArea","Bilingual")
	TabPane1.LoadLayout("TwoTextArea","Separate")
	result.Initialize
	mLangpair=langpair
End Sub

Public Sub ShowAndWait As Map
	frm.ShowAndWait
	Return result
End Sub


Sub ReadButton_MouseClicked (EventData As MouseEvent)
	If TabPane1.SelectedIndex=1 Then
		Dim sourceList,targetList As List
		sourceList.Initialize
		targetList.Initialize
		sourceList=txtFilter.Text2Paragraphs(sourceTextArea.Text)
		targetList=txtFilter.Text2Paragraphs(targetTextArea.Text)
		result.Put("source",sourceList)
		result.Put("target",targetList)
	Else
		result=Utils.getBitext(BiTextArea.Text,mLangpair,False)
	End If
	frm.Close
End Sub