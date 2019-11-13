B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=7.8
@EndOfDesignText@
Sub Class_Globals
	Private fx As JFX
	Private ListView1 As ListView
	Private frm As Form
	Private result As Map
	Private TextField1 As TextField
	Private CheckBox1 As CheckBox
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	frm.Initialize("frm",500,600)
	frm.RootPane.LoadLayout("AssPicker")
	result.Initialize
End Sub

Public Sub ShowAndWait As Map
	frm.ShowAndWait
	Return result
End Sub

Sub OkayButton_MouseClicked (EventData As MouseEvent)
	result=assFilter.getBitext(ListView1.Items,TextField1.Text,CheckBox1.Checked)
	frm.Close
End Sub

Sub ChooseDirButton_MouseClicked (EventData As MouseEvent)
	Dim dc As DirectoryChooser
	dc.Initialize
	Dim dirPath As String=dc.Show(frm)
	If File.Exists(dirPath,"") Then
		addAss(dirPath)
	End If
End Sub

Sub addAss(dirpath As String)
	For Each filename As String In File.ListFiles(dirpath)
		If filename.EndsWith(".ass") Then
			ListView1.Items.Add(File.Combine(dirpath,filename))
			Continue
		End If
		If File.IsDirectory(dirpath,filename) Then
			addAss(File.Combine(dirpath,filename))
		End If
	Next
End Sub