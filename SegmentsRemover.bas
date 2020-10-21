B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=7.8
@EndOfDesignText@
Sub Class_Globals
	Private fx As JFX
	Private frm As Form
	Private ListView1 As ListView
	Private TextField1 As TextField
	Private TextField2 As TextField
	Private TextField3 As TextField
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	frm.Initialize("frm",500,500)
	frm.RootPane.LoadLayout("SegmentsRemover")
End Sub

Public Sub Show
	frm.Show
End Sub

Sub RemoveButton_MouseClicked (EventData As MouseEvent)
	Main.RemoveSegments(ListView1.Items,True)
End Sub

Sub AppendButton_MouseClicked (EventData As MouseEvent)
	If TextField1.Text<>"" Then
		ListView1.Items.Add(TextField1.Text)
	End If
End Sub

Sub RemoveEmptySegmentsButton_MouseClicked (EventData As MouseEvent)
	Main.RemoveEmptySegments
End Sub

Sub RemoveRangeButton_MouseClicked (EventData As MouseEvent)
	Main.RemoveRange(TextField2.Text,TextField3.Text)
End Sub


Sub RemoveDuplicateButton_MouseClicked (EventData As MouseEvent)
	Main.RemoveDuplicate
End Sub
