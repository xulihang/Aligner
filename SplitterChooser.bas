B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=6.51
@EndOfDesignText@
Sub Class_Globals
	Private fx As JFX
	Private frm As Form
	Private RadioButton1 As RadioButton
	Private RadioButton2 As RadioButton
	Private RadioButton3 As RadioButton
	Private TextArea1 As TextArea
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	frm.Initialize("frm",400,200)
	frm.RootPane.LoadLayout("splitterChooser")
End Sub

Public Sub showAndWait As String
	frm.ShowAndWait
	If RadioButton1.Selected Then
		Return CRLF
	else if RadioButton2.Selected Then
		Return "	"
	Else
		Return TextArea1.Text
	End If
End Sub

Sub Button1_MouseClicked (EventData As MouseEvent)
	frm.Close
End Sub

Public Sub setTitle(title As String)
	frm.Title=title
End Sub