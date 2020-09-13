B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=7.8
@EndOfDesignText@
Sub Class_Globals
	Private fx As JFX
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	
End Sub

Public Sub Align(sourceList As List,targetList As List,translationList As List) As ResumableSub
	Dim sh As Shell
	Dim executable As String="python"
	Dim bleualighPath As String=File.Combine(File.Combine(File.DirApp,"bleualign"),"bleualign.py")
	sh.Initialize("sh",executable,Array As String(bleualighPath,"-s","source.txt","-t","target.txt","--srctotarget","sourcetranslation.txt","-o","outputfile"))
	sh.WorkingDirectory=File.DirApp
	sh.Run(-1)
	Dim result As Map
	result.Initialize
	wait for sh_ProcessCompleted (Success As Boolean, ExitCode As Int, StdOut As String, StdErr As String)
	Log(Success)
	Log(StdOut)
	Log(StdErr)
	If Success Then
		result.Put("success",True)
		result.Put("sourceList",File.ReadList(File.DirApp,"outputfile-s"))
		result.Put("targetList",File.ReadList(File.DirApp,"outputfile-t"))
	Else
		result.Put("success",False)
	End If
	Return result
End Sub


