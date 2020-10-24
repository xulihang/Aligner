B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=6.8
@EndOfDesignText@
Sub Class_Globals
	Private fx As JFX
	Private frm As Form
	Private SrxPathTextField As TextField
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	frm.Initialize("frm",500,200)
	frm.RootPane.LoadLayout("srxPicker")
End Sub

Public Sub ShowAndWait As String
	If File.Exists(File.DirData("BasicCAT"),"segmentationRules.srx")=False Then
		File.Copy(File.DirAssets,"segmentationRules.srx",File.DirData("BasicCAT"),"segmentationRules.srx")
	End If
	SrxPathTextField.Text=File.Combine(File.DirData("BasicCAT"),"segmentationRules.srx")
	frm.ShowAndWait
	Return SrxPathTextField.Text
End Sub

Sub ChooseSrxButton_MouseClicked (EventData As MouseEvent)
	Dim fc As FileChooser
	fc.Initialize
	fc.SetExtensionFilter("SRX Files",Array As String("*.srx"))
	SrxPathTextField.Text=fc.ShowOpen(frm)
End Sub

Sub OkButton_MouseClicked (EventData As MouseEvent)
	If File.Exists(SrxPathTextField.Text,"") Then
		segmentation.resetLangs
		frm.Close
	Else
		fx.Msgbox(frm,"Wrong srx path","")
	End If
End Sub