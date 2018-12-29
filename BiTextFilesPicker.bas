B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=6.8
@EndOfDesignText@
Sub Class_Globals
	Private fx As JFX
	Private frm As Form
	Private result As Map
	Private SourcePathTextField As TextField
	Private TargetPathTextField As TextField
	Private LanguagePair As Map
	Private sourceDrag As B4JDragToMe
	Private targetDrag As B4JDragToMe
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	frm.Initialize("frm",500,200)
	frm.RootPane.LoadLayout("BiTextFilesPicker")
	result.Initialize
	LanguagePair.Initialize
	sourceDrag.Initialize(SourcePathTextField, "sourceDrag")
	targetDrag.Initialize(TargetPathTextField,"targetDrag")
End Sub


Public Sub ShowAndWait(langPair As Map) As Map
	LanguagePair=langPair
	
	frm.ShowAndWait
	Return result
End Sub

Sub ReadButton_MouseClicked (EventData As MouseEvent)
	result.Put("source",txtFilter.readFileIntoParagraphs(SourcePathTextField.Text))
	result.Put("target",txtFilter.readFileIntoParagraphs(TargetPathTextField.Text))
	frm.Close
End Sub

Sub ChooseTargetButton_MouseClicked (EventData As MouseEvent)
	Dim fc As FileChooser
	fc.Initialize
	fc.SetExtensionFilter("Text Files",Array As String("*.txt"))
	TargetPathTextField.Text=fc.ShowOpen(frm)
End Sub

Sub ChooseSourceButton_MouseClicked (EventData As MouseEvent)
	Dim fc As FileChooser
	fc.Initialize
	fc.SetExtensionFilter("Text Files",Array As String("*.txt"))
	SourcePathTextField.Text=fc.ShowOpen(frm)
End Sub


Sub sourceDrag_ReceivedFilePath (Filepath As String)
	SourcePathTextField.Text=Filepath
End Sub

Sub targetDrag_ReceivedFilePath (Filepath As String)
	TargetPathTextField.Text=Filepath
End Sub