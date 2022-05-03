Option Explicit

Private Const hMSPASSWORD = "SuperSecrecthMailServerPassword"
Private Const hMSdbPW = "SuperSecretDatabasePassword"
Private Const pURIBLURITable = "hm_puribluri"
Private Const pURIBLDomTable = "hm_puribldom"
Private Const PublicSuffix = "C:\Program Files (x86)\hMailServer\Events\public_suffix_list.vbs"
Private pURIBLDict : Set pURIBLDict = CreateObject("Scripting.Dictionary")

Function Lookup(strRegEx, strMatch) : Lookup = False
	With CreateObject("VBScript.RegExp")
		.Pattern = strRegEx
		.Global = False
		.MultiLine = True
		.IgnoreCase = True
		If .Test(strMatch) Then Lookup = True
	End With
End Function

Function oLookup(strRegEx, strMatch, bGlobal)
	If strRegEx = "" Then strRegEx = StrReverse(strMatch)
	With CreateObject("VBScript.RegExp")
		.Pattern = strRegEx
		.Global = bGlobal
		.MultiLine = True
		.IgnoreCase = True
		Set oLookup = .Execute(strMatch)
	End With
End Function

Function GetDatabaseObject()
	Dim oApp : Set oApp = CreateObject("hMailServer.Application")
	Call oApp.Authenticate("Administrator", hMSPASSWORD)
	Set GetDatabaseObject = oApp.Database
End Function

Function Include(sInstFile)
	Dim f, s, oFSO
	Set oFSO = CreateObject("Scripting.FileSystemObject")
	On Error Resume Next
	If oFSO.FileExists(sInstFile) Then
		Set f = oFSO.OpenTextFile(sInstFile)
		s = f.ReadAll
		f.Close
		ExecuteGlobal s
	End If
	On Error Goto 0
	Set f = Nothing
	Set oFSO = Nothing
End Function

Sub BlackList(oMessage, strMatch, iScore)
    Dim i, Done : Done = False
    If CInt(oMessage.HeaderValue("X-hMailServer-Reason-Score")) > 0 Then
        i = CInt(oMessage.HeaderValue("X-hMailServer-Reason-Score"))
    Else
        oMessage.HeaderValue("X-hMailServer-Spam") = "YES"
        i = 0
    End If
	oMessage.HeaderValue("X-hMailServer-Blacklist") = "YES"
	oMessage.HeaderValue("X-hMailServer-Reason-0") = "BlackListed - (Score: " & iScore & ")"
	oMessage.HeaderValue("X-hMailServer-Reason-Score") = iScore + i
    i = 1
    Do Until Done
        If (oMessage.HeaderValue("X-hMailServer-BlackList-" & i) = "") Then
            oMessage.HeaderValue("X-hMailServer-BlackList-" & i) = strMatch
            Exit Do
        Else
            i = i + 1
        End If
    Loop
    oMessage.Save
End Sub

Function GetMainDomain(strDomain)
	Dim strRegEx, Match, Matches
	Dim TestDomain, DomainParts, a, i, PubSuffMatch
	Include(PublicSuffix)
	
	DomainParts = Split(strDomain,".")
	a = UBound(DomainParts)
	If a > 1 Then
		TestDomain = DomainParts(1)
		For i = 2 to a
			TestDomain = TestDomain & "." & DomainParts(i)
		Next
	ElseIf a = 1 Then
		TestDomain = DomainParts(1)
	Else
		Exit Function
	End If

	Set Matches = oLookup(PubSufRegEx, TestDomain, False)
	For Each Match In Matches
		PubSuffMatch = True
	Next

	If PubSuffMatch Then 
		GetMainDomain = DomainParts(0) & "." & TestDomain
	Else
		GetMainDomain = GetMainDomain(TestDomain)
	End If
End Function

Function ExcludeHead(strStr)
	Dim Head
	If InStr(strStr, "</HEAD>") Then Head = "</HEAD>" Else If InStr(strStr, "</head>") Then Head = "</head>" Else Head = "</Head>"
	If InStr(strStr, Head) > 0 Then
		ExcludeHead = Right(strStr, ((Len(strStr)) - (InStr(strStr, Head) + 7)))
	Else
		ExcludeHead = strStr
	End If
End Function

Function pURIBLRegEx(pURIBLDict, pType) : pURIBLRegEx = ""
	Dim strData, pID, pRecord, pURL, pSQL
	Dim oRecord, oDB : Set oDB = CreateObject("ADODB.Connection")
	oDB.Open "Driver={MariaDB ODBC 3.1 Driver}; Server=localhost; Database=hmailserver; User=hmailserver; Password=" & hMSdbPW & ";"
	If oDB.State <> 1 Then
		EventLog.Write( "pURIBLRegEx - ERROR: Could not connect to database" )
		pURIBLRegEx = "VOID"
		Exit Function
	End If

	pURIBLDict.RemoveAll

	If pType = "DOM" Then 
		pSQL = "SELECT * FROM " & pURIBLDomTable & " WHERE shortcircuit = 1;"
		pRecord = "domain"
	Else
		pSQL = "SELECT * FROM " & pURIBLURITable & " WHERE active = 1;"
		pRecord = "uri"
	End If
	
	Set oRecord = oDB.Execute(pSQL)
	Do Until oRecord.EOF
		pID = CStr(Trim(oRecord("id")))
		pURL = CStr(Trim(oRecord(pRecord)))
		If (pURL <> "") Then
			strData = strData & pURL & "|"
			pURIBLDict.Add pID, pURL
		End If
		oRecord.MoveNext
	Loop
	
	If (Trim(strData) <> "") Then
		pURIBLRegEx = Left(strData,Len(strData)-1)
	Else
		EventLog.Write("ERROR: pURIBLEDomRegEx: Database returned no records")
		pURIBLRegEx = "VOID"
	End If

	Set oRecord = Nothing
	oDB.Close
	Set oDB = Nothing
End Function

Function pURIBLStat(pURIBLDict, oMatchValue, pType)
	Dim strSQL, oDB, objKey, pTable
	Set oDB = CreateObject("ADODB.Connection")
	oDB.Open "Driver={MariaDB ODBC 3.1 Driver}; Server=localhost; Database=hmailserver; User=hmailserver; Password=" & hMSdbPW & ";"
	If oDB.State <> 1 Then
		EventLog.Write( "pURIBLStat - ERROR: Could not connect to database" )
		pURIBLStat = "VOID"
		Exit Function
	End If

	If pType = "DOM" Then pTable = pURIBLDomTable Else pTable = pURIBLURITable
	For Each objKey In pURIBLDict
		If Lookup(CStr(pURIBLDict(objKey)), oMatchValue) Then
			strSQL = "UPDATE " & pTable & " SET timestamp = NOW(), hits = (hits + 1) WHERE id = '" & CStr(objKey) & "';"
			Call oDB.Execute(strSQL)
			Exit For
		End If
	Next
	Set oDB = Nothing
End Function

Sub OnAcceptMessage(oClient, oMessage)

	REM - Exclude authenticated users test
	If (oClient.Username <> "") Then Exit Sub

	Dim strRegEx, Match, Matches
	Dim oMatch, oMatchCollection
	Dim Done

	REM - Blacklist on pURIBL
	Dim pURIBLBlacklistScore : pURIBLBlacklistScore = 5 'Blacklist Score
	Done = False
	Do Until Done

		REM - Blacklist on pURIBL Domain match - plain text body
		strRegEx = pURIBLRegEx(pURIBLDict, "DOM")
		If strRegEx <> "VOID" Then
			Set oMatchCollection = oLookup(strRegEx, oMessage.Body, False)
			For Each oMatch In oMatchCollection
				Call pURIBLStat(pURIBLDict, oMatch.Value, "DOM")
				Call BlackList(oMessage, "pURIBL Dom = '" & oMatch.Value & "'", pURIBLBlacklistScore)
				Exit Do
			Next
		End If

		REM - Blacklist on pURIBL Domain match - HTML body
		strRegEx = pURIBLRegEx(pURIBLDict, "DOM")
		If strRegEx <> "VOID" Then
			Set oMatchCollection = oLookup(strRegEx, ExcludeHead(oMessage.HTMLBody), False)
			For Each oMatch In oMatchCollection
				Call pURIBLStat(pURIBLDict, oMatch.Value, "DOM")
				Call BlackList(oMessage, "pURIBL Dom = '" & oMatch.Value & "'", pURIBLBlacklistScore)
				Exit Do
			Next
		End If

		REM - Blacklist on pURIBL URI match - plain text body
		strRegEx = pURIBLRegEx(pURIBLDict, "URI")
		If strRegEx <> "VOID" Then
			Set oMatchCollection = oLookup(strRegEx, oMessage.Body, False)
			For Each oMatch In oMatchCollection
				Call pURIBLStat(pURIBLDict, oMatch.Value, "URI")
				Call BlackList(oMessage, "pURIBL URI = '" & oMatch.Value & "'", pURIBLBlacklistScore)
				Exit Do
			Next
		End If

		REM - Blacklist on pURIBL URI match - HTML body
		strRegEx = pURIBLRegEx(pURIBLDict, "URI")
		If strRegEx <> "VOID" Then
			Set oMatchCollection = oLookup(strRegEx, ExcludeHead(oMessage.HTMLBody), False)
			For Each oMatch In oMatchCollection
				Call pURIBLStat(pURIBLDict, oMatch.Value, "URI")
				Call BlackList(oMessage, "pURIBL URI = '" & oMatch.Value & "'", pURIBLBlacklistScore)
				Exit Do
			Next
		End If

		Done = True
	Loop

End Sub

Sub OnDeliveryStart(oMessage)

	REM - Populate pURIBL
	If oMessage.HeaderValue("X-hMailServer-Reason-Score") <> "" Then
		If CInt(oMessage.HeaderValue("X-hMailServer-Reason-Score") > 6) Then

			Dim strSQL, strSQLD, oDB : Set oDB = GetDatabaseObject
			Dim strRegEx, Match, Matches
			Dim strRegExD, MatchD, MatchesD

			strRegEx = "(\b((https?(:\/\/|%3A%2F%2F))((([a-zA-Z0-9-]+)\.)+[a-zA-Z0-9-]+)(:\d+)?((?:\/[\+~%\/\.\w\-_]*)?\??(?:[\-\+=&;%@\.\w_]*)#?(?:[\.\!\/\\\w]*))?)\b)"
			Set Matches = oLookup(strRegEx, oMessage.Body, True)
			For Each Match In Matches
				strSQL = "INSERT INTO " & pURIBLURITable & " (uri,timestamp,adds,active) VALUES ('" & Match.SubMatches(0) & "',NOW(),1,1) ON DUPLICATE KEY UPDATE adds=(adds+1),timestamp=NOW();"
				Call oDB.ExecuteSQL(strSQL)
				strRegExD = "(?:^https?)(?::\/\/|%3A%2F%2F)(?:[^@\/\n]+@)?([^:\/%?\n]+)"
				Set MatchesD = oLookup(strRegExD, Match.SubMatches(0), True)
				For Each MatchD In MatchesD
					strSQLD = "INSERT INTO " & pURIBLDomTable & " (domain,timestamp,adds,shortcircuit) VALUES ('" & GetMainDomain(MatchD.SubMatches(0)) & "',NOW(),1,0) ON DUPLICATE KEY UPDATE adds=(adds+1),timestamp=NOW();"
					Call oDB.ExecuteSQL(strSQLD)
				Next
			Next

			Set Matches = oLookup(strRegEx, oMessage.HTMLBody, True)
			For Each Match In Matches
				strSQL = "INSERT INTO " & pURIBLURITable & " (uri,timestamp,adds,active) VALUES ('" & Match.SubMatches(0) & "',NOW(),1,1) ON DUPLICATE KEY UPDATE adds=(adds+1),timestamp=NOW();"
				Call oDB.ExecuteSQL(strSQL)
				strRegExD = "(?:^https?)(?::\/\/|%3A%2F%2F)(?:[^@\/\n]+@)?([^:\/%?\n]+)"
				Set MatchesD = oLookup(strRegExD, Match.SubMatches(0), True)
				For Each MatchD In MatchesD
					strSQLD = "INSERT INTO " & pURIBLDomTable & " (domain,timestamp,adds,shortcircuit) VALUES ('" & GetMainDomain(MatchD.SubMatches(0)) & "',NOW(),1,0) ON DUPLICATE KEY UPDATE adds=(adds+1),timestamp=NOW();"
					Call oDB.ExecuteSQL(strSQLD)
				Next
			Next

		End If
	End If

End Sub