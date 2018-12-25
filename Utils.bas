B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=6.51
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
End Sub

Sub getMap(key As String,parentmap As Map) As Map
	Return parentmap.Get(key)
End Sub

Sub LanguageHasSpace(lang As String) As Boolean
	Dim languagesWithoutSpaceList As List
	languagesWithoutSpaceList=File.ReadList(File.DirAssets,"languagesWithoutSpace.txt")
	For Each code As String In languagesWithoutSpaceList
		If lang.StartsWith(code) Then
			Return False
		End If
	Next
	Return True
End Sub

Sub readLanguageCode(codesfilePath As String) As Map
	Dim linesList As List
	linesList=File.ReadList(File.DirAssets,"langcodes.txt")
	If codesfilePath<>"" Then
		If File.Exists(codesfilePath,"") Then
			linesList=File.ReadList(codesfilePath,"")
		End If
	End If
	
	Dim headsList As List
	headsList.Initialize
	headsList.AddAll(Regex.Split("	",linesList.Get(0)))
	'Log(headsList)
	
	Dim langcodes As Map
	langcodes.Initialize
	Dim lineNum As Int=1
	For Each line As String In linesList
		If lineNum=1 Then
			lineNum=lineNum+1
			Continue
		End If
		Dim colIndex As Int=0
		Dim code As String=Regex.Split("	",line)(0)
		Dim codesMap As Map
		codesMap.Initialize
		For Each value As String In Regex.Split("	",line)
			If colIndex=0 Then
				colIndex=colIndex+1
				Continue
			End If
			If value<>"" Then
				codesMap.Put(headsList.Get(colIndex),value)
			End If
			colIndex=colIndex+1
		Next
		langcodes.Put(code,codesMap)
	Next
	Return langcodes
End Sub

Sub shouldAddSpace(sourceLang As String,targetLang As String,index As Int,segmentsList As List) As Boolean
	Dim bitext As List=segmentsList.Get(index)
	Dim fullsource As String=bitext.Get(2)

	If LanguageHasSpace(sourceLang)=False And LanguageHasSpace(targetLang)=True Then
		If index+1<=segmentsList.Size-1 Then
			Dim nextBitext As List
			nextBitext=segmentsList.Get(index+1)
			Dim nextfullsource As String=nextBitext.Get(2)
			If fullsource.EndsWith(CRLF)=False And nextfullsource.StartsWith(CRLF)=False Then
				Try
					If Regex.IsMatch("\s",nextfullsource.CharAt(0))=False And Regex.IsMatch("\s",fullsource.CharAt(fullsource.Length-1))=False Then
						Return True
					End If
				Catch
					Log(LastException)
				End Try
			End If
		End If
	End If
	Return False
End Sub

Sub MeasureMultilineTextHeight (Font As Font, Width As Double, Text As String) As Double
	Dim jo As JavaObject = Me
	Return jo.RunMethod("MeasureMultilineTextHeight", Array(Font, Text, Width))
End Sub

#If JAVA
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import javafx.scene.text.Font;
import javafx.scene.text.TextBoundsType;

public static double MeasureMultilineTextHeight(Font f, String text, double width) throws Exception {
  Method m = Class.forName("com.sun.javafx.scene.control.skin.Utils").getDeclaredMethod("computeTextHeight",
  Font.class, String.class, double.class, TextBoundsType.class);
  m.setAccessible(true);
  return (Double)m.invoke(null, f, text, width, TextBoundsType.LOGICAL);
  }
#End If