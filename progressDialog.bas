﻿B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=6.51
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
	Private frm As Form
	Private Label1 As Label
	Private ProgressBar1 As ProgressBar
    Private progressTypeValue As String
End Sub

'input a random type name
Sub Show(title As String,progressType As String)
	frm.Initialize("frm",600,200)
	frm.RootPane.LoadLayout("progress")
	frm.Title=title
	progressTypeValue=progressType
	frm.Show
End Sub

Sub ShowWithoutProgressBar(title As String,progressType As String)
	frm.Initialize("frm",400,120)
	frm.RootPane.LoadLayout("progress")
	frm.Title=title
	Label1.Top=60-Label1.Height/2
	ProgressBar1.Visible=False
	progressTypeValue=progressType
	frm.Show
End Sub

Sub update(completed As Int,segmentSize As Int)
	ProgressBar1.Visible=True
	Label1.Text=completed&"/"&segmentSize
	ProgressBar1.Progress=completed/segmentSize
End Sub

Sub update2(info As String)
	Label1.Text=info
End Sub

Sub delayedInfo(info As String)
	Label1.Text=info
	Sleep(2000)
	close
End Sub

Sub close
	If frm.IsInitialized Then
		frm.Close
	End If
End Sub

Sub frm_CloseRequest (EventData As Event)

End Sub