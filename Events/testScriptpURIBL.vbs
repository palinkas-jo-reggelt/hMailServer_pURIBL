Option Explicit

' CREATE TABLE IF NOT EXISTS hm_puribluri (
	' id int(11) NOT NULL AUTO_INCREMENT,
	' uri text NOT NULL,
	' timestamp datetime NOT NULL,
	' adds mediumint(9) NOT NULL,
	' hits mediumint(9) NOT NULL,
	' active tinyint(1) NOT NULL,
	' PRIMARY KEY (id),
	' UNIQUE KEY uri (uri) USING HASH
' ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
' COMMIT;

' CREATE TABLE IF NOT EXISTS hm_puribldom (
	' id int(11) NOT NULL AUTO_INCREMENT,
	' domain text NOT NULL,
	' timestamp datetime NOT NULL,
	' adds mediumint(9) NOT NULL,
	' hits mediumint(9) NOT NULL,
	' shortcircuit tinyint(1) NOT NULL,
	' PRIMARY KEY (id),
	' UNIQUE KEY uri (domain) USING HASH
' ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
' COMMIT;

Dim oMessageBody : oMessageBody = "" & _
"*ENGINEER TEE SHIRTS*" & _
"*NEW COLLECTION 2022*" & _
"" & _
"" & _
"" & _
"  <https://engineershirt4ae.blogspot.com/engineer1.html>" & _
"<https://engineershirt4ae.blogspot.com/engineer42.html>" & _
"" & _
"  <https://engineershirt4ae.blogspot.com/engineer82.html>" & _
"<https://engineershirt4ae.blogspot.com/engineer4.html>" & _
"" & _
"  <https://engineershirt4ae.blogspot.com/engineer5.html>" & _
"<https://engineershirt4ae.blogspot.com/engineer6.html>" & _
"" & _
"  <https://engineershirt4ae.blogspot.com/engineer7.html>" & _
"<https://engineershirt4ae.blogspot.com/engineer8.html>" & _
"" & _
"  <https://engineershirt4ae.blogspot.com/engineer9.html>" & _
"<https://engineershirt4ae.blogspot.com/engineer10.html>" & _
"" & _
"  <https://engineershirt4ae.blogspot.com/engineer11.html>" & _
"<https://engineershirt4ae.blogspot.com/engineer12.html>" & _
"" & _
"  <https://engineershirt4ae.blogspot.com/engineer13.html>" & _
"<https://engineershirt4ae.blogspot.com/engineer72.html>" & _
"" & _
"  <https://engineershirt4ae.blogspot.com/engineer15.html>" & _
"<https://engineershirt4ae.blogspot.com/engineer16.html>" & _
"" & _
"  <https://engineershirt4ae.blogspot.com/engineer17.html>" & _
"<https://engineershirt4ae.blogspot.com/engineer76.html>" & _
"" & _
"  <https://engineershirt4ae.blogspot.com/engineer83.html>" & _
"<https://engineershirt4ae.blogspot.com/engineer20.html>" & _
"" & _
"  <https://engineershirt4ae.blogspot.com/engineer21.html>" & _
"<https://engineershirt4ae.blogspot.com/engineer22.html>" & _
"" & _
"  <https://engineershirt4ae.blogspot.com/engineer33.html>" & _
"<https://engineershirt4ae.blogspot.com/engineer53.html>" & _
"  <https://engineershirt4ae.blogspot.com/engineer25.html>" & _
"<https://engineershirt4ae.blogspot.com/engineer26.html>" & _
"  <https://engineershirt4ae.blogspot.com/engineer81.html>" & _
"<https://engineershirt4ae.blogspot.com/engineer64.html>" & _
"  <https://engineershirt4ae.blogspot.com/engineer66.html>" & _
"" & _
"" & _
"**LIMITED TIME OFFER** This is a limited time print that will only be" & _
"available for 4-10 days." & _
"*SHIPPING WORLDWIDE!!!*" & _
"Guaranteed safe and secure checkout via:" & _
"Paypal | VISA | MASTERCARD" & _
"Order 2 or more and SAVE on shipping!" & _
"100% Designed, Shipped, and Printed in the U.S.A." & _
"*If you're not like receive more mails*" & _
" *Click Here To Unsubscribe*" & _
"<https://docs.google.com/forms/d/e/1FAIpQLSeIKevXpPNE2NexTuaXOvF31w5wKayx0qxPWkZrnyv8ltJ0zg/viewform>"

Dim oMessageHTMLBody : oMessageHTMLBody = "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.0 Transitional//EN'>" & _
"<HTML xmlns=3D'http://www.w3.org/1999/xhtml' xmlns:v =3D=20" & _
"'urn:schemas-microsoft-com:vml' xmlns:o =3D=20" & _
"'urn:schemas-microsoft-com:office:office'><HEAD><TITLE></TITLE>" & _
"<META content=3D'text/html; charset=3Dutf-8' http-equiv=3DContent-Type >" & _
"<META name=3Dx-apple-disable-message-reformatting>" & _
"<META name=3Dviewport content=3D'width=3Ddevice-width, initial-scale=3D 1.0'>" & _
"<STYLE type=3Dtext/css>" & _
"    body, .maintable { height:100% !important; width:100% !important;  margin:0; padding:0;}" & _
"    img, a img { border:0; outline:none; text-decoration:none;}" & _
"    p {margin-top:0; margin-right:0; margin-left:0; padding:0;}" & _
"    .ReadMsgBody {width:100%;}" & _
"    .ExternalClass {width:100%;}" & _
"    .ExternalClass, .ExternalClass p, .ExternalClass span, .ExternalCl ass font, .ExternalClass td, .ExternalClass div {line-height:100%;}" & _
"    img {-ms-interpolation-mode: bicubic;}" & _
"    body, table, td, p, a, li, blockquote {-ms-text-size-adjust:100%;  -webkit-text-size-adjust:100%;}" & _
"   /*p {display: table; table-layout: fixed; width: 100%; word-wrap: b reak-word;} */" & _
"</STYLE>" & _
"" & _
"<STYLE type=3Dtext/css>" & _
"@media only screen and (max-width: 480px) {" & _
" .rtable {width: 100% !important;}" & _
" .rtable tr {height:auto !important; display: block;}" & _
" .contenttd {max-width: 100% !important; display: block; width: auto ! important;}" & _
" .contenttd:after {content: ''; display: table; clear: both;}" & _
" .hiddentds {display: none;}" & _
" .imgtable, .imgtable table {max-width: 100% !important; height: auto;  float: none; margin: 0 auto;}" & _
" .imgtable.btnset td {display: inline-block;}" & _
" .imgtable img {width: 100%; height: auto !important;display: block;}" & _
" table {float: none;}" & _
" .mobileHide {display: none !important; width: 0 !important; max-heigh t: 0 !important; overflow: hidden !important;}" & _
" .desktopHide {display: block !important; width: 100% !important; max- height: unset !important; overflow: unset !important;}" & _
" .noresponsive p {display: table; table-layout: fixed; width: 100%; wo rd-wrap: break-word;}" & _
"}" & _
"@media only screen and (min-width: 481px) {" & _
" .desktopHide {display: none !important; width: 0 !important; max-heig ht: 0 !important; overflow: hidden !important;}" & _
"}" & _
"</STYLE>" & _
"<!--[if gte mso 9]>" & _
"<xml>" & _
"  <o:OfficeDocumentSettings>" & _
"    <o:AllowPNG/>" & _
"    <o:PixelsPerInch>96</o:PixelsPerInch>" & _
"  </o:OfficeDocumentSettings>" & _
"</xml>" & _
"<![endif]-->" & _
"<META name=3DGENERATOR content=3D'MSHTML 11.00.9600.17037'></HEAD>" & _
"<BODY=20" & _
"style=3D'OVERFLOW: auto; CURSOR: auto; FONT-SIZE: 15px; FONT-FAMILY: M ongolian Baiti; PADDING-BOTTOM: 0px; PADDING-TOP: 0px; PADDING-LEFT: 0 px; MARGIN: 0px; PADDING-RIGHT: 0px; BACKGROUND-COLOR: #feffff'>" & _
"<TABLE style=3D'BACKGROUND-COLOR: #feffff' cellSpacing=3D0 cellPadding =3D0=20" & _
"width=3D'100%'>" & _
"  <TBODY>" & _
"  <TR>" & _
"    <TD style=3D'FONT-SIZE: 0px; HEIGHT: 0px; LINE-HEIGHT: 0'></TD></T R>" & _
"  <TR>" & _
"    <TD vAlign=3Dtop>" & _
"      <TABLE class=3Drtable style=3D'WIDTH: 600px; MARGIN: 0px auto' c ellSpacing=3D0=20" & _
"      cellPadding=3D0 width=3D600 align=3Dcenter border=3D0>" & _
"        <TBODY>" & _
"        <TR>" & _
"          <TH class=3Dcontenttd=20" & _
"          style=3D'BORDER-TOP: medium none; BORDER-RIGHT: medium none;  WIDTH: 600px; BORDER-BOTTOM: medium none; FONT-WEIGHT: normal; PADDIN G-BOTTOM: 0px; TEXT-ALIGN: left; PADDING-TOP: 0px; PADDING-LEFT: 0px;  BORDER-LEFT: medium none; PADDING-RIGHT: 0px; BACKGROUND-COLOR: #fefff f'>" & _
"            <TABLE style=3D'WIDTH: 100%' cellSpacing=3D0 cellPadding=3D 0 align=3Dleft>" & _
"              <TBODY>" & _
"              <TR style=3D'HEIGHT: 1363px' height=3D1363>" & _
"                <TH class=3Dcontenttd=20" & _
"                style=3D'BORDER-TOP: medium none; BORDER-RIGHT: medium  none; WIDTH: 590px; VERTICAL-ALIGN: top; BORDER-BOTTOM: medium none;  FONT-WEIGHT: normal; PADDING-BOTTOM: 5px; TEXT-ALIGN: left; PADDING-TO P: 5px; PADDING-LEFT: 5px; BORDER-LEFT: medium none; PADDING-RIGHT: 5p x; BACKGROUND-COLOR: transparent'>" & _
"                  <P=20" & _
"                  style=3D'MARGIN-BOTTOM: 1em; FONT-SIZE: 15px; FONT-F AMILY: Mongolian Baiti; COLOR: #090808; TEXT-ALIGN: center; MARGIN-TOP : 0px; LINE-HEIGHT: 18px; BACKGROUND-COLOR: transparent; mso-line-heig ht-rule: exactly'=20" & _
"                  align=3Dcenter>If you can't read this email, please  <A title=3D''=20" & _
"                  style=3D'TEXT-DECORATION: underline; COLOR: #090808' =20" & _
"                  href=3D'https://www.lsymk.com/' target=3D_blank>view  it=20" & _
"                  online</A></P><!--[if gte mso 12]>" & _
"    <table cellspacing=3D'0' cellpadding=3D'0' border=3D'0' width=3D'1 00%'><tr><td align=3D'center'>" & _
"<![endif]-->" & _
"                  <TABLE class=3Dimgtable style=3D'MARGIN: 0px auto' c ellSpacing=3D0=20" & _
"                  cellPadding=3D0 align=3Dcenter border=3D0>" & _
"                    <TBODY>" & _
"                    <TR>" & _
"                      <TD=20" & _
"                      style=3D'PADDING-BOTTOM: 0px; PADDING-TOP: 0px;  PADDING-LEFT: 0px; PADDING-RIGHT: 0px'=20" & _
"                      align=3Dcenter>" & _
"                        <TABLE cellSpacing=3D0 cellPadding=3D0 border=3D 0>" & _
"                          <TBODY>" & _
"                          <TR>" & _
"                            <TD=20" & _
"                            style=3D'BORDER-TOP: medium none; BORDER-R IGHT: medium none; BORDER-BOTTOM: medium none; BORDER-LEFT: medium non e; BACKGROUND-COLOR: transparent'><A=20" & _
"                              href=3D'https://www.lsymk.com/' target=3D _blank><IMG=20" & _
"                              style=3D'BORDER-TOP: medium none; BORDER -RIGHT: medium none; BORDER-BOTTOM: medium none; BORDER-LEFT: medium n one; DISPLAY: block'=20" & _
"                              hspace=3D0 alt=3D'Louis Vuitton Bags 202 2 New Styles'=20" & _
"                              src=3D'https://cc.lsymk.com/3506303015310396586808058605188647832029.jpg'=20" & _
"                              width=3D564></A></TD></TR></TBODY></TABL E></TD></TR></TBODY></TABLE><!--[if gte mso 12]>" & _
"    </td></tr></table>" & _
"<![endif]--><!--[if gte mso 12]>" & _
"    <table cellspacing=3D'0' cellpadding=3D'0' border=3D'0' width=3D'1 00%'><tr><td align=3D'center'>" & _
"<![endif]-->" & _
"                  <TABLE class=3Dimgtable style=3D'MARGIN: 0px auto' c ellSpacing=3D0=20" & _
"                  cellPadding=3D0 align=3Dcenter border=3D0>" & _
"                    <TBODY>" & _
"                    <TR>" & _
"                      <TD=20" & _
"                      style=3D'PADDING-BOTTOM: 0px; PADDING-TOP: 0px;  PADDING-LEFT: 0px; PADDING-RIGHT: 0px'=20" & _
"                      align=3Dcenter>" & _
"                        <TABLE cellSpacing=3D0 cellPadding=3D0 border=3D 0>" & _
"                          <TBODY>" & _
"                          <TR>" & _
"                            <TD=20" & _
"                            style=3D'BORDER-TOP: medium none; BORDER-R IGHT: medium none; BORDER-BOTTOM: medium none; BORDER-LEFT: medium non e; BACKGROUND-COLOR: transparent'><A=20" & _
"                              href=3D'https://www.lsymk.com/' target=3D _blank><IMG=20" & _
"                              style=3D'BORDER-TOP: medium none; BORDER -RIGHT: medium none; BORDER-BOTTOM: medium none; BORDER-LEFT: medium n one; DISPLAY: block'=20" & _
"                              hspace=3D0 alt=3D'Save up to 90% Off'=20 " & _
"                              src=3D'https://cc.lsymk.com/1186311546259765332428646221537709454484.jpg'=20" & _
"                              width=3D561></A></TD></TR></TBODY></TABL E></TD></TR></TBODY></TABLE><!--[if gte mso 12]>" & _
"    </td></tr></table>" & _
"<![endif]--><!--[if gte mso 12]>" & _
"    <table cellspacing=3D'0' cellpadding=3D'0' border=3D'0' width=3D'1 00%'><tr><td align=3D'center'>" & _
"<![endif]-->" & _
"                  <TABLE class=3Dimgtable style=3D'MARGIN: 0px auto' c ellSpacing=3D0=20" & _
"                  cellPadding=3D0 align=3Dcenter border=3D0>" & _
"                    <TBODY>" & _
"                    <TR>" & _
"                      <TD=20" & _
"                      style=3D'PADDING-BOTTOM: 0px; PADDING-TOP: 0px;  PADDING-LEFT: 0px; PADDING-RIGHT: 0px'=20" & _
"                      align=3Dcenter>" & _
"                        <TABLE cellSpacing=3D0 cellPadding=3D0 border=3D 0>" & _
"                          <TBODY>" & _
"                          <TR>" & _
"                            <TD=20" & _
"                            style=3D'BORDER-TOP: medium none; BORDER-R IGHT: medium none; BORDER-BOTTOM: medium none; BORDER-LEFT: medium non e; BACKGROUND-COLOR: transparent'><A=20" & _
"                              href=3D'https://www.lsymk.com/' target=3D _blank><IMG=20" & _
"                              style=3D'BORDER-TOP: medium none; BORDER -RIGHT: medium none; BORDER-BOTTOM: medium none; BORDER-LEFT: medium n one; DISPLAY: block'=20" & _
"                              hspace=3D0 alt=3D'Shop Now!'=20" & _
"                              src=3D'https://cc.lsymk.com/1843327051466927238393425360149744374538.jpg'=20" & _
"                              width=3D564></A></TD></TR></TBODY></TABL E></TD></TR></TBODY></TABLE><!--[if gte mso 12]>" & _
"    </td></tr></table>" & _
"<![endif]--><!--[if gte mso 12]>" & _
"    <table cellspacing=3D'0' cellpadding=3D'0' border=3D'0' width=3D'1 00%'><tr><td align=3D'center'>" & _
"<![endif]-->" & _
"                  <TABLE class=3Dimgtable style=3D'MARGIN: 0px auto' c ellSpacing=3D0=20" & _
"                  cellPadding=3D0 align=3Dcenter border=3D0>" & _
"                    <TBODY>" & _
"                    <TR>" & _
"                      <TD=20" & _
"                      style=3D'PADDING-BOTTOM: 0px; PADDING-TOP: 0px;  PADDING-LEFT: 0px; PADDING-RIGHT: 0px'=20" & _
"                      align=3Dcenter>" & _
"                        <TABLE cellSpacing=3D0 cellPadding=3D0 border=3D 0>" & _
"                          <TBODY>" & _
"                          <TR>" & _
"                            <TD=20" & _
"                            style=3D'BORDER-TOP: medium none; BORDER-R IGHT: medium none; BORDER-BOTTOM: medium none; BORDER-LEFT: medium non e; BACKGROUND-COLOR: transparent'><A=20" & _
"                              href=3D'https://www.lsymk.com/' target=3D _blank><IMG=20" & _
"                              style=3D'BORDER-TOP: medium none; BORDER -RIGHT: medium none; BORDER-BOTTOM: medium none; BORDER-LEFT: medium n one; DISPLAY: block'=20" & _
"                              hspace=3D0 alt=3D''=20" & _
"                              src=3D'https://cc.lsymk.com/0591223566774170134267194518752780294581.jpg'=20" & _
"                              width=3D564></A></TD></TR></TBODY></TABL E></TD></TR></TBODY></TABLE><!--[if gte mso 12]>" & _
"    </td></tr></table>" & _
"<![endif]-->" & _
"                  <P=20" & _
"                  style=3D'MARGIN-BOTTOM: 1em; FONT-SIZE: 15px; FONT-F AMILY: Mongolian Baiti; COLOR: #090808; TEXT-ALIGN: center; MARGIN-TOP : 0px; LINE-HEIGHT: 22px; BACKGROUND-COLOR: transparent; mso-line-heig ht-rule: exactly'=20" & _
"                  align=3Dcenter><A title=3D''=20" & _
"                  style=3D'TEXT-DECORATION: underline; COLOR: #090808' =20" & _
"                  href=3D'https://cc.lsymk.com/return.php?p=3DTUsxP2JyaWFuQHJnYi1ueWMuY29tPzk0MDA2'=20" & _
"                  target=3D_blank>Unsubscribe</A> | Privacy Policy<BR> You have=20" & _
"                  subscribed to receive&nbsp;LV email=20" & _
"                  communications.&nbsp;<BR>FR Corporate Address: 417 R ue de=20" & _
"                  Babylone, 75007 Paris,=20" & _
"        France</P></TH></TR></TBODY></TABLE></TH></TR></TBODY></TABLE> </TD></TR>" & _
"  <TR>" & _
"    <TD=20" & _
"  style=3D'FONT-SIZE: 0px; HEIGHT: 8px; LINE-HEIGHT: 0'>&nbsp;</TD></T R></TBODY></TABLE></BODY></HTML>"

Private Const hMSPASSWORD = "SuperSecrecthMailServerPassword" 'hMailServer COM password (Administrator password)
Private Const hMSdbPW = "SuperSecretDatabasePassword"         'hMailServer MySQL database user password
Private Const pURIBLURITable = "hm_puribluri"                 'pURIBL URI table name
Private Const pURIBLDomTable = "hm_puribldom"                 'pURIBL domain table name
Private Const PublicSuffix = "C:\Program Files (x86)\hMailServer\Events\public_suffix_list.vbs" 'Path to public_suffix_list.vbs
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
		WScript.Echo pURIBLRegEx
	Else
		' EventLog.Write("ERROR: pURIBLEDomRegEx: Database returned no records")
		WScript.Echo("ERROR: pURIBLRegEx: Database returned no records")
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
			' Call oDB.Execute(strSQL)
			Exit For
		End If
	Next
	Set oDB = Nothing
End Function

	' WScript.Echo ExcludeHead(oMessageHTMLBody)

	Dim strRegEx, Match, Matches
	Dim oMatch, oMatchCollection
	Dim Done

	REM - Blacklist on pURIBL
	Dim pURIBLBlacklistScore : pURIBLBlacklistScore = 4 'Blacklist Score
	Done = False
	Do Until Done

		REM - Blacklist on pURIBL Domain match - plain text body
		strRegEx = pURIBLRegEx(pURIBLDict, "DOM")
		If strRegEx <> "VOID" Then
			Set oMatchCollection = oLookup(strRegEx, oMessageBody, False)
			For Each oMatch In oMatchCollection
				Call pURIBLStat(pURIBLDict, oMatch.Value, "DOM")
				' Call BlackList(oMessage, "pURIBL Dom = '" & oMatch.Value & "'", pURIBLBlacklistScore)
				WScript.Echo "DOM hit on oMessageBody: " & oMatch.Value
				' Exit Do
			Next
		End If

		REM - Blacklist on pURIBL Domain match - HTML body
		strRegEx = pURIBLRegEx(pURIBLDict, "DOM")
		If strRegEx <> "VOID" Then
			Set oMatchCollection = oLookup(strRegEx, oMessageHTMLBody, False)
			For Each oMatch In oMatchCollection
				Call pURIBLStat(pURIBLDict, oMatch.Value, "DOM")
				' Call BlackList(oMessage, "pURIBL Dom = '" & oMatch.Value & "'", pURIBLBlacklistScore)
				WScript.Echo "DOM hit on oMessageHTMLBody: " & oMatch.Value
				' Exit Do
			Next
		End If

		REM - Blacklist on pURIBL URI match - plain text body
		strRegEx = pURIBLRegEx(pURIBLDict, "URI")
		If strRegEx <> "VOID" Then
			Set oMatchCollection = oLookup(strRegEx, oMessageBody, False)
			For Each oMatch In oMatchCollection
				Call pURIBLStat(pURIBLDict, oMatch.Value, "URI")
				' Call BlackList(oMessage, "pURIBL URI = '" & oMatch.Value & "'", pURIBLBlacklistScore)
				WScript.Echo "URI hit on oMessageBody: " & oMatch.Value
				' Exit Do
			Next
		End If

		REM - Blacklist on pURIBL URI match - HTML body
		strRegEx = pURIBLRegEx(pURIBLDict, "URI")
		If strRegEx <> "VOID" Then
			Set oMatchCollection = oLookup(strRegEx, oMessageHTMLBody, False)
			For Each oMatch In oMatchCollection
				Call pURIBLStat(pURIBLDict, oMatch.Value, "URI")
				' Call BlackList(oMessage, "pURIBL URI = '" & oMatch.Value & "'", pURIBLBlacklistScore)
				WScript.Echo "URI hit on oMessageHTMLBody: " & oMatch.Value
				' Exit Do
			Next
		End If

		Done = True
	Loop

WScript.Echo " "

	REM - Populate pURIBL
	' If oMessage.HeaderValue("X-hMailServer-Reason-Score") <> "" Then
		' If CInt(oMessage.HeaderValue("X-hMailServer-Reason-Score") > 6) Then
			Dim strSQL, strSQLD, oDB : Set oDB = GetDatabaseObject
			' Dim strRegEx, Match, Matches
			Dim strRegExD, MatchD, MatchesD
			strRegEx = "(\b((https?(:\/\/|%3A%2F%2F))((([a-zA-Z0-9-]+)\.)+[a-zA-Z0-9-]+)(:\d+)?((?:\/[\+~%\/\.\w\-_]*)?\??(?:[\-\+=&;%@\.\w_]*)#?(?:[\.\!\/\\\w]*))?)\b)"
			Set Matches = oLookup(strRegEx, oMessageBody, True)
			For Each Match In Matches
				strRegExD = "(?:^https?)(?::\/\/|%3A%2F%2F)(?:[^@\/\n]+@)?([^:\/%?\n]+)"
				Set MatchesD = oLookup(strRegExD, Match.SubMatches(0), True)
				For Each MatchD In MatchesD
					strSQL = "INSERT INTO " & pURIBLURITable & " (uri,domain,timestamp,adds,active) VALUES ('" & Match.SubMatches(0) & "','" & GetMainDomain(MatchD.SubMatches(0)) & "',NOW(),1,1) ON DUPLICATE KEY UPDATE adds=(adds+1),timestamp=NOW();"
					' Call oDB.ExecuteSQL(strSQL)
					strSQLD = "INSERT INTO " & pURIBLDomTable & " (domain,timestamp,adds,shortcircuit) VALUES ('" & GetMainDomain(MatchD.SubMatches(0)) & "',NOW(),1,1) ON DUPLICATE KEY UPDATE adds=(adds+1),timestamp=NOW();"
					' Call oDB.ExecuteSQL(strSQLD)
				Next
			Next
			Set Matches = oLookup(strRegEx, ExcludeHead(oMessageHTMLBody), True)
			For Each Match In Matches
				strRegExD = "(?:^https?)(?::\/\/|%3A%2F%2F)(?:[^@\/\n]+@)?([^:\/%?\n]+)"
				Set MatchesD = oLookup(strRegExD, Match.SubMatches(0), True)
				For Each MatchD In MatchesD
					strSQL = "INSERT INTO " & pURIBLURITable & " (uri,domain,timestamp,adds,active) VALUES ('" & Match.SubMatches(0) & "','" & GetMainDomain(MatchD.SubMatches(0)) & "',NOW(),1,1) ON DUPLICATE KEY UPDATE adds=(adds+1),timestamp=NOW();"
					' Call oDB.ExecuteSQL(strSQL)
					strSQLD = "INSERT INTO " & pURIBLDomTable & " (domain,timestamp,adds,shortcircuit) VALUES ('" & GetMainDomain(MatchD.SubMatches(0)) & "',NOW(),1,1) ON DUPLICATE KEY UPDATE adds=(adds+1),timestamp=NOW();"
					' Call oDB.ExecuteSQL(strSQLD)
				Next
			Next
		' End If
	' End If

