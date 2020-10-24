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
	Dim sourceList,targetList As List
	sourceList.Initialize
	targetList.Initialize
	If SourcePathTextField.Text.ToLowerCase.EndsWith(".txt") Then
		sourceList=txtFilter.readFileIntoParagraphs(SourcePathTextField.Text)
	else if SourcePathTextField.Text.ToLowerCase.EndsWith(".docx") Then
		sourceList=openxmlFilter.readFileIntoParagraphs(SourcePathTextField.Text)
	else if SourcePathTextField.Text.ToLowerCase.EndsWith(".xlf") Then
		sourceList=xliffFilter.readFileIntoParagraphs(SourcePathTextField.Text,SourcePathTextField.Tag)
	else if SourcePathTextField.Text.ToLowerCase.EndsWith(".json") Then
		Dim workFileResult As Map=workfileFilter.getBitext(SourcePathTextField.Text)
		If SourcePathTextField.Tag=True Then
			sourceList=workFileResult.Get("source")
		Else
			sourceList=workFileResult.Get("target")
		End If
	End If
	
	If TargetPathTextField.Text.ToLowerCase.EndsWith(".txt") Then
		targetList=txtFilter.readFileIntoParagraphs(TargetPathTextField.Text)
	else if TargetPathTextField.Text.ToLowerCase.EndsWith(".docx") Then
		targetList=openxmlFilter.readFileIntoParagraphs(TargetPathTextField.Text)
	else if TargetPathTextField.Text.ToLowerCase.EndsWith(".xlf") Then
		targetList=xliffFilter.readFileIntoParagraphs(TargetPathTextField.Text,TargetPathTextField.Tag)
	else if TargetPathTextField.Text.ToLowerCase.EndsWith(".json") Then
		Dim workFileResult As Map=workfileFilter.getBitext(TargetPathTextField.Text)
		If TargetPathTextField.Tag=True Then
			targetList=workFileResult.Get("source")
		Else
			targetList=workFileResult.Get("target")
		End If
	End If

	result.Put("source",sourceList)
	result.Put("target",targetList)
	frm.Close
End Sub

Sub ChooseTargetButton_MouseClicked (EventData As MouseEvent)
	TargetPathTextField.Text=chooseFile
	askIsSource(TargetPathTextField)
End Sub

Sub ChooseSourceButton_MouseClicked (EventData As MouseEvent)
	SourcePathTextField.Text=chooseFile
	askIsSource(SourcePathTextField)
End Sub

Sub chooseFile As String
	Dim fc As FileChooser
	fc.Initialize
	fc.SetExtensionFilter("Text Files",Array As String("*.txt","*.docx","*.xlf","*.json"))
	Return fc.ShowOpen(frm)
End Sub

Sub sourceDrag_ReceivedFilePath (Filepath As String)
	SourcePathTextField.Text=Filepath
	askIsSource(SourcePathTextField)
End Sub

Sub targetDrag_ReceivedFilePath (Filepath As String)
	TargetPathTextField.Text=Filepath
	askIsSource(TargetPathTextField)
End Sub

Sub askIsSource(tf As TextField)
	If tf.Text.ToLowerCase.EndsWith(".xlf") Or tf.Text.ToLowerCase.EndsWith(".json")  Then
		Dim resp As Int=fx.Msgbox2(frm,"Read source or target?","","Source","","Target",fx.MSGBOX_CONFIRMATION)
		If resp=fx.DialogResponse.POSITIVE Then
			tf.Tag=True
		Else
			tf.Tag=False
		End If
	End If
End Sub