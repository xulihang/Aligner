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

Sub getBitext(text As String,langPair As Map,highPrecisionForZH As Boolean) As Map
	Dim sourceLang As String = langPair.Get("source")
	Dim targetLang As String = langPair.Get("target")
	Dim result As Map
	result.Initialize
	Dim lines As List
	lines.Initialize
	lines.AddAll(Regex.Split(CRLF,text))
	Dim sourceLines As List
	sourceLines.Initialize
	Dim targetLines As List
	targetLines.Initialize
	For i=0 To lines.Size-1
		Dim line As String=lines.Get(i)
		If highPrecisionForZH Then
			Dim matcher As Matcher
			matcher = Regex.Matcher("[a-zA-Z]",line)
			Dim existEnglish As Boolean=matcher.Find
			If isChinese(line) And existEnglish Then
				Continue
			Else if isChinese(line) And existEnglish=False Then
				Try
					Dim englisgLine As String
					If sourceLang.StartsWith("zh") Then
						englisgLine=lines.Get(i+1)
					Else if targetLang.StartsWith("zh") Then
						englisgLine=lines.Get(i-1)
					End If
				
					If isChinese(englisgLine)=False Then
						targetLines.Add(englisgLine)
						sourceLines.Add(line)
					End If
				Catch
					Log(LastException)
				End Try
			End If
		Else
			If i Mod 2 =0 Then
				targetLines.Add(line)
			Else
				sourceLines.Add(line)
			End If
		End If
	Next
	result.Put("source",sourceLines)
	result.Put("target",targetLines)
	Return result
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

Sub isChinese(text As String) As Boolean
	Dim jo As JavaObject
	jo=Me
	Return jo.RunMethod("isChinese",Array As String(text))
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

private static boolean isChinese(char c) {

    Character.UnicodeBlock ub = Character.UnicodeBlock.of(c);

    if (ub == Character.UnicodeBlock.CJK_UNIFIED_IDEOGRAPHS || ub == Character.UnicodeBlock.CJK_COMPATIBILITY_IDEOGRAPHS

            || ub == Character.UnicodeBlock.CJK_UNIFIED_IDEOGRAPHS_EXTENSION_A || ub == Character.UnicodeBlock.CJK_UNIFIED_IDEOGRAPHS_EXTENSION_B

            || ub == Character.UnicodeBlock.CJK_SYMBOLS_AND_PUNCTUATION || ub == Character.UnicodeBlock.HALFWIDTH_AND_FULLWIDTH_FORMS

            || ub == Character.UnicodeBlock.GENERAL_PUNCTUATION) {

        return true;

    }

    return false;

}



// 完整的判断中文汉字和符号

public static boolean isChinese(String strName) {

    char[] ch = strName.toCharArray();

    for (int i = 0; i < ch.length; i++) {

        char c = ch[i];

        if (isChinese(c)) {

            return true;

        }

    }

    return false;

}

#End If