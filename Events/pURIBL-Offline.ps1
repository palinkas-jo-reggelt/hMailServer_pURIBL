<#

.SYNOPSIS
	pURI-BL (Offline)

.DESCRIPTION
	Feeds messages for pURI-BL inspection

.FUNCTIONALITY
	Inspects HAM messages for blacklisted URIs, scores them as spam and moves to spam folder.
	
	Inspects SPAM messages for URIs to add to blacklist.

.PARAMETER 

	
.NOTES
	Add "--allow-tell" argument to your SPAMD service to allow SPAMC to report SPAM.
	
	Run daily or hourly from task scheduler
	
.EXAMPLE


#>

<###   SCRIPT VARIABLES   ###>
$Simulate              = $True             # FOR TESTING - set to TRUE to run and report results without modifying database, moving messages or feeding SpamC
$MoveToJunk            = $True             # If hit on pURI-BL URI during inspection of HAM, move the message to the junk folder
$HamFolders            = ""                # Names of HAM folders to search messages for blacklisted URIs - uses regex (defaults to "inbox")
$SpamFolders           = ""                # Potential/actual names of SPAM folders - uses regex - (defaults to "spam|junk")
$SearchSubFolders      = $False            # True will search subfolders for messages to process
$SearchDays            = 1                 # Number of days worth of messages to process
$SkipAccounts          = ""                # User accounts to skip - uses regex (disable with "" or $NULL)
$SkipDomains           = ""                # Domains to skip - uses regex (disable with "" or $NULL)
$PubSufListLocation    = "C:\scripts\puribl\public_suffix_list.ps1"  # Location of public_suffix_list.ps1

<###   HMAILSERVER VARIABLES   ###>
$hMSAdminPass          = "secretpassword"  # hMailServer Admin password
$hMSDeleteThreshold    = 7                 # hMailServer spam delete threshold (used to determine whether to inspect spammy messages for URIs)

<###   SPAMASSASSIN VARIABLES   ###>
$FeedSpamC             = $False            # If hit on pURI-BL URI during inspection of HAM, TRUE will feed message to SpamC as SPAM for bayes learning
$SARuleCF              = $False            # If true, will create or update custom rule config "pURIBL.cf" in \ect\spamassassin folder 
$SADir                 = "C:\SpamAssassin" # SpamAssassin Install Directory (required to run SpamC and/or create custom rule file)

<###   LOGGING VARIABLES   ###>
$VerboseConsole        = $True             # If true, will output debug to console
$VerboseFile           = $True             # If true, will output debug to file

<###   MySQL VARIABLES   ###>
$pURIBLDomTable        = "hm_puribldom"    # Name of "domains" table
$pURIBLURITable        = "hm_puribluri"    # Name of "URI" table
$SQLAdminUserName      = "hmailserver"
$SQLAdminPassword      = "supersecretpassword"
$SQLDatabase           = "hmailserver"
$SQLHost               = "localhost"
$SQLPort               = 3306
$SQLSSL                = "none"
$SQLConnectTimeout     = 300
$SQLCommandTimeOut     = 9000000           # Leave high if read errors

<###   EMAIL VARIABLES   ###>
$EmailFrom             = "notify@mydomain.tld"
$EmailTo               = "admin@mydomain.tld"
$Subject               = "pURI-BL Routine Report"
$SMTPServer            = "mail.mydomain.tld"
$SMTPAuthUser          = "notify@mydomain.tld"
$SMTPAuthPass          = "supersecretpassword"
$SMTPPort              =  587
$UseSSL                = $True             # If true, will use tls connection to send email
$UseHTML               = $True             # If true, will format and send email body as html (with color!)
$AttachDebugLog        = $True             # If true, will attach debug log to email report - must also select $VerboseFile
$MaxAttachmentSize     = 1                 # Max attachment size in MB (will not attach log if greater than $MaxAttachmentSize)

<###   LOAD SUPPORTING FILES   ###>
Try {
	.($PubSufListLocation)
}
Catch {
	Write-Output "$(Get-Date -f G) : ERROR : Unable to load supporting PowerShell Scripts : $query `n$($Error[0])" | Out-File "$PSScriptRoot\PSError.log" -Append
}

<###   FUNCTIONS   ###>
Function Debug ($DebugOutput) {
	If ($VerboseFile) {Write-Output "$(Get-Date -f G) : $DebugOutput" | Out-File $DebugLog -Encoding ASCII -Append}
	If ($VerboseConsole) {Write-Host "$(Get-Date -f G) : $DebugOutput"}
}

Function Email ($EmailOutput) {
	If ($UseHTML){
		If ($EmailOutput -match "\[OK\]") {$EmailOutput = $EmailOutput -Replace "\[OK\]","<span style=`"background-color:green;color:white;font-weight:bold;font-family:Courier New;`">[OK]</span>"}
		If ($EmailOutput -match "\[INFO\]") {$EmailOutput = $EmailOutput -Replace "\[INFO\]","<span style=`"background-color:yellow;font-weight:bold;font-family:Courier New;`">[INFO]</span>"}
		If ($EmailOutput -match "\[ERROR\]") {$EmailOutput = $EmailOutput -Replace "\[ERROR\]","<span style=`"background-color:red;color:white;font-weight:bold;font-family:Courier New;`">[ERROR]</span>"}
		If ($EmailOutput -match "^\s$") {$EmailOutput = $EmailOutput -Replace "\s","&nbsp;"}
		Write-Output "<tr><td>$EmailOutput</td></tr>" | Out-File $EmailBody -Encoding ASCII -Append
	} Else {
		Write-Output $EmailOutput | Out-File $EmailBody -Encoding ASCII -Append
	}	
}

Function EmailResults {
	Try {
		$Body = (Get-Content -Path $EmailBody | Out-String )
		If (($AttachDebugLog) -and (Test-Path $DebugLog) -and (((Get-Item $DebugLog).length/1MB) -lt $MaxAttachmentSize)){$Attachment = New-Object System.Net.Mail.Attachment $DebugLog}
		$Message = New-Object System.Net.Mail.Mailmessage $EmailFrom, $EmailTo, $Subject, $Body
		$Message.IsBodyHTML = $UseHTML
		If (($AttachDebugLog) -and (Test-Path $DebugLog) -and (((Get-Item $DebugLog).length/1MB) -lt $MaxAttachmentSize)){$Message.Attachments.Add($DebugLog)}
		$SMTP = New-Object System.Net.Mail.SMTPClient $SMTPServer,$SMTPPort
		$SMTP.EnableSsl = $UseSSL
		$SMTP.Credentials = New-Object System.Net.NetworkCredential($SMTPAuthUser, $SMTPAuthPass); 
		$SMTP.Send($Message)
	}
	Catch {
		Debug "Email ERROR : $($Error[0])"
	}
}

Function ElapsedTime ($EndTime) {
	$TimeSpan = New-Timespan $EndTime
	If (([int]($TimeSpan).Hours) -eq 0) {$Hours = ""} ElseIf (([int]($TimeSpan).Hours) -eq 1) {$Hours = "1 hour "} Else {$Hours = "$([int]($TimeSpan).Hours) hours "}
	If (([int]($TimeSpan).Minutes) -eq 0) {$Minutes = ""} ElseIf (([int]($TimeSpan).Minutes) -eq 1) {$Minutes = "1 minute "} Else {$Minutes = "$([int]($TimeSpan).Minutes) minutes "}
	If (([int]($TimeSpan).Seconds) -eq 1) {$Seconds = "1 second"} Else {$Seconds = "$([int]($TimeSpan).Seconds) seconds"}
	If (($TimeSpan).TotalSeconds -lt 1) {
		$Return = "less than 1 second"
	} Else {
		$Return = "$Hours$Minutes$Seconds"
	}
	Return $Return
}

Function Plural ($Integer) {
	If ($Integer -eq 1) {$S = ""} Else {$S = "s"}
	Return $S
}

Function ValidatePath ($Path) {
	If (-not(Test-Path $Path)) {
		Debug "[ERROR] Path $Path does not exist : Quitting script"
		Email "[ERROR] Path $Path does not exist : Quitting script"
		EmailResults
		Exit
	}
}

Function MySQLQuery($Query) {
	$Today = (Get-Date).ToString("yyyyMMdd")
	$DBErrorLog = "$PSScriptRoot\DBError-$Today.log"
	$ConnectionString = "server=" + $SQLHost + ";port=" + $SQLPort + ";uid=" + $SQLAdminUserName + ";pwd=" + $SQLAdminPassword + ";database=" + $SQLDatabase + ";SslMode=" + $SQLSSL + ";Default Command Timeout=" + $SQLCommandTimeOut + ";Connect Timeout=" + $SQLConnectTimeout + ";"
	Try {
		[void][System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")
		$Connection = New-Object MySql.Data.MySqlClient.MySqlConnection
		$Connection.ConnectionString = $ConnectionString
		$Connection.Open()
		$Command = New-Object MySql.Data.MySqlClient.MySqlCommand($Query, $Connection)
		$DataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($Command)
		$DataSet = New-Object System.Data.DataSet
		$RecordCount = $dataAdapter.Fill($dataSet, "data")
		$DataSet.Tables[0]
	}
	Catch {
		Write-Output "$(Get-Date -f G) : ERROR : Unable to run query : $Query" | out-file $DBErrorLog -append
		Write-Output "$(Get-Date -f G) : ERROR : $($Error[0])" | out-file $DBErrorLog -append
	}
	Finally {
		$Connection.Close()
	}
}

Function CreateTableStructure {
	$SQLURI = "
		CREATE TABLE IF NOT EXISTS $pURIBLURITable (
			id int(11) NOT NULL AUTO_INCREMENT,
			uri text NOT NULL,
			strid varchar(32) NOT NULL,
			domain varchar(128) NOT NULL,
			timestamp datetime NOT NULL,
			adds mediumint(9) NOT NULL,
			hits mediumint(9) NOT NULL,
			active tinyint(1) NOT NULL,
			PRIMARY KEY (id),
			UNIQUE KEY uri (uri) USING HASH
		) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
		COMMIT;
	"
	MySQLQuery $SQLURI

	$SQLDom = "
		CREATE TABLE IF NOT EXISTS $pURIBLDomTable (
			id int(11) NOT NULL AUTO_INCREMENT,
			domain text NOT NULL,
			strid varchar(32) NOT NULL,
			timestamp datetime NOT NULL,
			adds mediumint(9) NOT NULL,
			hits mediumint(9) NOT NULL,
			shortcircuit tinyint(1) NOT NULL,
			PRIMARY KEY (id),
			UNIQUE KEY uri (domain) USING HASH
		) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
		COMMIT;
	"
	MySQLQuery $SQLDom
}

Function ExcludeHead ($Body) {
	If ($Body -match "</head>") {
		Return ($Body -Split "</head>")[1]
	} Else {
		Return $Body
	}
}

Function GetMainDomain($strDomain) {
	$DomainParts = $strDomain.Split(".")
	If ($DomainParts.Count -gt 1) {
		$TestDomain = $DomainParts[1]
		For ($i = 2; $i -lt $DomainParts.Count; $i++) {
			$TestDomain = "$TestDomain.$($DomainParts[$i])"
		}
	}
	ElseIf ($a -eq 1) {
		$TestDomain = $DomainParts[1]
	}
	Else {
		Return $Null
	}
	If ($TestDomain -match $PubSufRegEx) {
		Return "$($DomainParts[0]).$TestDomain"
	} Else {
		GetMainDomain $TestDomain
	}
}

Function GetSubFolders ($Folder) {
	If ($Folder.SubFolders.Count -gt 0) {
		For ($IterateFolder = 0; $IterateFolder -lt $Folder.SubFolders.Count; $IterateFolder++) {
			$SubFolder = $Folder.SubFolders.Item($IterateFolder)
			If ($SubFolder.Messages.Count -gt 0) {GetMessages $SubFolder} 
			If ($SubFolder.Subfolders.Count -gt 0) {GetSubFolders $SubFolder} 
		}
	}
}

Function GetMessages ($Folder) {
	$URIHits = 0
	$URIsAdded = 0
	$LearnedHamMessagesFolder = 0
	$LearnedSpamMessagesFolder = 0

	<#  Don't proceed if there are no messages  #>
	If ($Folder.Messages.Count -gt 0) {

		<###   INSPECT HAM   ###>
		
		<#  Process HAM: only proceed if this is a HAM folder  #>
		If ($Folder.Name -match $HamFolders) {
			
			<#  Loop through messages  #>
			For ($IterateMessage = 0; $IterateMessage -lt $Folder.Messages.Count; $IterateMessage++) {
				$Message = $Folder.Messages.Item($IterateMessage)
				
				<#  Only process messages younger than $SearchDays  #>
				If ($Message.InternalDate -gt ((Get-Date).AddDays(-$SearchDays))) {

					<#  Record inspected HAM message  #>
					$TotalHamFedMessages++

					<#  Fill message body properties for matching  #>
					$Body = $(ExcludeHead $Message.Body) + $(ExcludeHead $Message.HTMLBody)

					<#  Test message body against pURI-BL domain regex - if match found then consider the message to be spam  #>
					If ($Body -match $pURIBLRegEx) {

						<#  Log message details  #>
						Debug "----------------------------"
						Debug "pURI-BL hit on HAM message"
						Debug "Account    : $($hMSAccount.Address)"
						Debug "Folder     : $($Folder.Name)"
						Debug "Message ID : $($Message.ID)"
						Debug "File       : $($Message.FileName)"
						Debug "URI        : $($Matches[0])"
						
						<#  Record hit on HAM message  #>
						$URIHits++
						$HamHits++

						<#  Feed message to SpamC as SPAM  #>
						If ($FeedSpamC) {
							If (!$Simulate) {
								Try {
									If ((Get-Item $FileName).Length -lt 512000) {

										$SpamC = & cmd /c "`"$SADir\spamc.exe`" -d `"$SAHost`" -p `"$SAPort`" -L spam < `"$Message.FileName`""
										$SpamCResult = Out-String -InputObject $SpamC

										<#  If no error, then record as successful  #>
										If ($SpamCResult -match "Message successfully un/learned") {
											$LearnedSpamMessages++
										}

										<#  If learning results in error, then throw error and count as unsuccessful  #>
										If (($SpamCResult -notmatch "Message successfully un/learned") -and ($SpamCResult -notmatch "Message was already un/learned")) {
											Throw $SpamCResult
										}

									}
								}
								Catch {
									$SpamFedMessageErrors++
									Debug "[ERROR] Feeding SpamC message $($Message.FileName) in $($hMSAccount.Address)"
									Debug "[ERROR] $($Error[0])"
									$HamFedMessageErrors++
								}
							}
						}

						<#  Move message to junk folder  #>
						If ($MoveToJunk) {

							<#  Find junk folder for account and grab folder ID  #>
							$JunkFolderID = $Null
							For ($IterateIMAPFolders = 0; $IterateIMAPFolders -lt $hMSAccount.IMAPFolders.Count; $IterateIMAPFolders++) {
								$hMSIMAPFolder = $hMSAccount.IMAPFolders.Item($IterateIMAPFolders)
								If ($hMSIMAPFolder.Name -match $SpamFolders) {
									[int]$JunkFolderID = $hMSIMAPFolder.ID
									Debug "Identified Junk folder as folder ID $JunkFolderID with folder name `"$($hMSIMAPFolder.Name)`""
									Break
								}
							}

							<#  If junk folder found then copy message to junk folder and delete from original folder  #>
							If ($JunkFolderID) {
								Debug "Moving message with ID $($Message.ID) to folder `"$(($hMSAccount.IMAPFolders.ItemByDBID($JunkFolderID)).Name)`""
								If (!$Simulate) {
									Try {
										$Message.Copy($JunkFolderID)
										$Folder.Messages.DeleteByDBID($Message.ID)
									}
									Catch {
										Debug "[ERROR] Could not copy or delete message with ID $($Message.ID)"
										Debug "[ERROR] $($Error[0])"
									}
								}

							<#  If junk folder not found then create junk folder, copy message to junk folder and delete from original folder  #>
							} Else {
								Debug "Junk folder not found - create new one then move message to it"
								If (!$Simulate) {
									Try {
										$hMSAccount.IMAPFolders.Add('Spam')
										Debug "Added folder `"Spam`" to account $($hMSAccount.Address)"
										$NewJunkFolderID = ($hMSAccount.IMAPFolders.ItemByName('Spam')).ID
										Debug "Moving message with ID $($Message.ID) to folder $(($hMSAccount.IMAPFolders.ItemByDBID($NewJunkFolderID)).Name)"
										$Message.Copy($NewJunkFolderID)
										($hMSAccount.IMAPFolders.ItemByDBID($Folder.ID)).Messages.DeleteByDBID($Message.ID)
									}
									Catch {
										Debug "[ERROR] Could not copy or delete message with ID $($Message.ID)"
										Debug "[ERROR] $($Error[0])"
									}
								}
							}
						}
					}
				}
			}
		}

		<###   INSPECT SPAM   ###>
		
		<#  Process SPAM: only proceed if this is a spam folder  #>
		If ($Folder.Name -match $SpamFolders) {
			
			<#  Loop through messages  #>
			For ($IterateMessage = 0; $IterateMessage -lt $Folder.Messages.Count; $IterateMessage++) {
				$Message = $Folder.Messages.Item($IterateMessage)

				<#  Only process messages younger than $SearchDays  #>
				If ($Message.InternalDate -gt ((Get-Date).AddDays(-$SearchDays))) {
					Try {

						<#  If spam score > delete threshold, then process message  #>
						If ([int]$Message.HeaderValue('X-hMailServer-Reason-Score') -ge [int]$hMSDeleteThreshold) {
							
							<#  Reset message add counter  #>
							$MessageAdd = $False
							
							<#  Count messages scored over delete threshold  #>
							$TotalSpamMessages++

							<#  Fill message body properties for matching  #>
							$Body = $(ExcludeHead $Message.Body) + $(ExcludeHead $Message.HTMLBody)
							
							<#  Search body for URIs; if found then add to database  #>
							[RegEx]::Matches($Body, "(\b((https?(:\/\/|%3A%2F%2F))((([a-zA-Z0-9-]+)\.)+[a-zA-Z0-9-]+)(:\d+)?((?:\/[\+~%\/\.\w\-_]*)?\??(?:[\-\+=&;%@\.\w_]*)#?(?:[\.\!\/\\\w]*))?)\b)") | ForEach {

								$URIsAdded++
								$TotalURIsAdded++
								$MessageAdd = $True

								$URI = $_.Value
								$FullDomain = ([RegEx]::Matches($URI, "(?:^https?)(?::\/\/|%3A%2F%2F)(?:[^@\/\n]+@)?([^:\/%?\n]+)")).Value -Replace "https?:\/\/",""
								$MainDomain = GetMainDomain $FullDomain
								
								If ($MainDomain) {
									
									<#  Log message details  #>
									Debug "----------------------------"
									Debug "pURI-BL URI found in SPAM message"
									Debug "Account    : $($hMSAccount.Address)"
									Debug "Folder     : $($Folder.Name)"
									Debug "Message ID : $($Message.ID)"
									Debug "File       : $($Message.FileName)"
									Debug "URI        : $URI"
									If (!$Simulate) {
										MySQLQuery "INSERT INTO $pURIBLURITable (uri,strid,domain,timestamp,adds,hits,active) VALUES ('$URI',MD5('$URI'),'$MainDomain',NOW(),1,0,1) ON DUPLICATE KEY UPDATE adds=(adds+1),timestamp=NOW();"
										MySQLQuery "INSERT INTO $pURIBLDomTable (domain,strid,timestamp,adds,shortcircuit) VALUES ('$MainDomain',MD5('$MainDomain'),NOW(),1,0) ON DUPLICATE KEY UPDATE adds=(adds+1),timestamp=NOW();"
									}
								}
							}

							If ($MessageAdd) {
								$MessagesWithAdds++
							}
						}
					}
					Catch {
						$SpamFedMessageErrors++
						Debug "[ERROR] Feeding SPAM message $FileName in $($hMSAccount.Address)"
						Debug "[ERROR] $($Error[0])"
					}					
				}
			}
		}
	}

	If ($URIHits -gt 0) {
		Debug "----------------------------"
		Debug "pURI-BL hits on $URIHits HAM message$(Plural $URIHits) fed from $($Folder.Name) in $($hMSAccount.Address)"
	}
	If ($URIsAdded -gt 0) {
		Debug "----------------------------"
		Debug "pURI-BL added $URIsAdded URI$(Plural $URIsAdded) from $MessagesWithAdds SPAM message$(Plural $MessagesWithAdds) fed from $($Folder.Name) in $($hMSAccount.Address)"
	}
}

Function FeedpURIBL {
	
	$Error.Clear()
	
	$BeginFeedingMessages = Get-Date
	Debug "----------------------------"
	Debug "Begin processing pURI-BL from messages newer than $SearchDays days"
	If ($Simulate) {
		Debug "Simulation Mode - Test Run ONLY"
	}

	<#  Authenticate hMailServer COM  #>
	$hMS = New-Object -COMObject hMailServer.Application
	$AuthAdmin = $hMS.Authenticate("Administrator", $hMSAdminPass) #| Out-Null
	If ($AuthAdmin) {
	
		If ($FeedSpamC) {
			$SAHost = $hMS.Settings.AntiSpam.SpamAssassinHost
			$SAPort = $hMS.Settings.AntiSpam.SpamAssassinPort
		}
		
		If ([string]::IsNullOrEmpty($HamFolders)) {$HamFolders = "inbox"}
		If ([string]::IsNullOrEmpty($SpamFolders)) {$SpamFolders = "spam|junk"}
		If ([string]::IsNullOrEmpty($SkipAccounts)) {$SkipAccounts = $(-Join ((48..57) + (65..90) + (97..122) | Get-Random -Count 16 | % {[Char]$_}))}
		If ([string]::IsNullOrEmpty($SkipDomains)) {$SkipDomains = $(-Join ((48..57) + (65..90) + (97..122) | Get-Random -Count 16 | % {[Char]$_}))}
		
		If ($hMS.Domains.Count -gt 0) {
			For ($IterateDomains = 0; $IterateDomains -lt $hMS.Domains.Count; $IterateDomains++) {
				$hMSDomain = $hMS.Domains.Item($IterateDomains)
				If (($hMSDomain.Active) -and ($hMSDomain.Name -notmatch [RegEx]$SkipDomains) -and ($hMSDomain.Accounts.Count -gt 0)) {
					For ($IterateAccounts = 0; $IterateAccounts -lt $hMSDomain.Accounts.Count; $IterateAccounts++) {
						$hMSAccount = $hMSDomain.Accounts.Item($IterateAccounts)
						If (($hMSAccount.Active) -and ($hMSAccount.Address -notmatch [RegEx]$SkipAccounts) -and ($hMSAccount.IMAPFolders.Count -gt 0)) {
							For ($IterateIMAPFolders = 0; $IterateIMAPFolders -lt $hMSAccount.IMAPFolders.Count; $IterateIMAPFolders++) {
								$hMSIMAPFolder = $hMSAccount.IMAPFolders.Item($IterateIMAPFolders)
								GetMessages $hMSIMAPFolder
								If ($SearchSubFolders) {
									If ($hMSIMAPFolder.SubFolders.Count -gt 0) {
										GetSubFolders $hMSIMAPFolder
									}
								}
							}
						}
					}
				}
			}
		}

		Debug "----------------------------"
		Debug "Finished searching messages in $(ElapsedTime $BeginFeedingMessages)"
		Debug "----------------------------"
		
		If ($HamFedMessageErrors -gt 0) {
			Debug "Errors feeding HAM to pURI-BL : $HamFedMessageErrors Error$(Plural $HamFedMessageErrors) present"
			Email "[ERROR] HAM Inspection : $HamFedMessageErrors Errors present : Check debug log"
		}
		If ($TotalHamFedMessages -gt 0) {
			Debug "pURI-BL hits on $HamHits of $TotalHamFedMessages HAM message$(Plural $TotalHamFedMessages) inspected"
			Email "[OK] pURI-BL hits on $HamHits of $TotalHamFedMessages HAM message$(Plural $TotalHamFedMessages) inspected"
		} Else {
			Debug "No pURI-BL hits on HAM messages younger than $SearchDays days"
			Email "[OK] No pURI-BL hits on HAM messages younger than $SearchDays days"
		}

		If ($SpamFedMessageErrors -gt 0) {
			Debug "Errors feeding SPAM to pURI-BL : $SpamFedMessageErrors Error$(Plural $SpamFedMessageErrors) present"
			Email "[ERROR] SPAM SpamC : $SpamFedMessageErrors Errors present : Check debug log"
		}
		If ($MessagesWithAdds -gt 0) {
			Debug "Added $TotalURIsAdded URI$(Plural $TotalURIsAdded) from $TotalSpamMessages SPAM message$(Plural $TotalSpamMessages) found"
			Email "[OK] Added $TotalURIsAdded URI$(Plural $TotalURIsAdded) from $TotalSpamMessages SPAM message$(Plural $TotalSpamMessages) found"
		} Else {
			Debug "No SPAM messages found younger than $SearchDays days to inspect"
			Email "[OK] No SPAM messages found younger than $SearchDays days to inspect"
		}


	} Else {
		Debug "hMailServer COM application authentication failed - quitting script"
	}
}

Function CustomSARuleFile {
	$RuleDir = $SADir + "\etc\spamassassin"
	$RuleFile = $SADir + "\etc\spamassassin\pURIBL.cf"

	<#  Check for SA local config folder and pURI-BL custom rule file  #>
	ValidatePath $RuleDir
	Try {
		If (Test-Path $RuleFile) {
			Remove-Item -Force -Path $RuleFile
			New-Item $RuleFile
		} Else {
			New-Item $RuleFile
		}
	}
	Catch {
		Debug "[ERROR] Could not create custom spamassassin rule file : Quitting script"
		Email "[ERROR] Could not create custom spamassassin rule file : Quitting script"
		EmailResults
		Exit
	}

	<#  Fill pURI-BL regex comparators  #>
	Try {
		$N = 0
		$Query = "
			SELECT domain AS result, strid FROM $pURIBLDomTable WHERE shortcircuit = 1
			UNION
			SELECT uri AS result, strid FROM $pURIBLURITable WHERE active = 1;
		"
		MySQLQuery $Query | ForEach {
			$StrID = ($_.strid).ToUpper()
			$Result = $_.result -Replace "\/","\/"
			Write-Output "uri      PURIBL_$StrID  /$Result/is" | Out-File $RuleFile -Append -Encoding ASCII
			Write-Output "score    PURIBL_$StrID  $Score" | Out-File $RuleFile -Append -Encoding ASCII
			Write-Output "describe PURIBL_$StrID  pURI-BL personal URI Blacklist" | Out-File $RuleFile -Append -Encoding ASCII
			Write-Output " " | Out-File $RuleFile -Append -Encoding ASCII
			$N++
		}
	}
	Catch {
		Debug "[ERROR] Could not fill custom spamassassin rule file : Quitting script"
		Email "[ERROR] Could not fill custom spamassassin rule file : Quitting script"
		EmailResults
		Exit
	}
}

Function CheckForUpdates {
	Debug "----------------------------"
	Debug "Checking for script update at GitHub"
	$GitHubVersion = $LocalVersion = $NULL
	$GetGitHubVersion = $GetLocalVersion = $False
	$GitHubVersionTries = 1
	Do {
		Try {
			$GitHubVersion = [decimal](Invoke-WebRequest -UseBasicParsing -Method GET -URI https://raw.githubusercontent.com/palinkas-jo-reggelt/hMailServer_pURIBL/main/VERSION).Content
			$GetGitHubVersion = $True
		}
		Catch {
			Debug "[ERROR] Obtaining GitHub version : Try $GitHubVersionTries : Obtaining version number: $($Error[0])"
		}
		$GitHubVersionTries++
	} Until (($GitHubVersion -gt 0) -or ($GitHubVersionTries -eq 6))
	If (Test-Path "$PSScriptRoot\VERSION") {
		$LocalVersion = [decimal](Get-Content "$PSScriptRoot\VERSION")
		$GetLocalVersion = $True
	} 
	If (($GetGitHubVersion) -and ($GetLocalVersion)) {
		If ($LocalVersion -lt $GitHubVersion) {
			Debug "[INFO] Upgrade to version $GitHubVersion available at https://github.com/palinkas-jo-reggelt/hMailServer_pURIBL"
			If ($UseHTML) {
				Email "[INFO] Upgrade to version $GitHubVersion available at <a href=`"https://github.com/palinkas-jo-reggelt/hMailServer_pURIBL`">GitHub</a>"
			} Else {
				Email "[INFO] Upgrade to version $GitHubVersion available at https://github.com/palinkas-jo-reggelt/hMailServer_pURIBL"
			}
		} Else {
			Debug "pURI-BL script is latest version: $GitHubVersion"
		}
	} Else {
		If ((-not($GetGitHubVersion)) -and (-not($GetLocalVersion))) {
			Debug "[ERROR] Version test failed : Could not obtain either GitHub nor local version information"
			Email "[ERROR] Version check failed"
		} ElseIf (-not($GetGitHubVersion)) {
			Debug "[ERROR] Version test failed : Could not obtain version information from GitHub"
			Email "[ERROR] Version check failed"
		} ElseIf (-not($GetLocalVersion)) {
			Debug "[ERROR] Version test failed : Could not obtain local install version information"
			Email "[ERROR] Version check failed"
		} Else {
			Debug "[ERROR] Version test failed : Unknown reason - file issue at GitHub"
			Email "[ERROR] Version check failed"
		}
	}
}

<###   START SCRIPT   ###>

$StartScript = Get-Date
$DateString = (Get-Date).ToString("yyyy-MM-dd")
$ScriptCreatedFiles = $PSScriptRoot + "\ScriptCreatedFiles"

<#  Clear out error variable  #>
$Error.Clear()

<#  Create table structure if tables don't exist  #>
CreateTableStructure

<#  Set variables  #>
Set-Variable -Name TotalHamFedMessages -Value 0 -Option AllScope
Set-Variable -Name MessagesWithAdds -Value 0 -Option AllScope
Set-Variable -Name HamFedMessageErrors -Value 0 -Option AllScope
Set-Variable -Name SpamFedMessageErrors -Value 0 -Option AllScope
Set-Variable -Name HamHits -Value 0 -Option AllScope
Set-Variable -Name LearnedSpamMessages -Value 0 -Option AllScope
Set-Variable -Name TotalSpamMessages -Value 0 -Option AllScope
Set-Variable -Name TotalURIsAdded -Value 0 -Option AllScope

<#  Check for "ScriptCreatedFiles" folder  #>
If (-not(Test-Path $ScriptCreatedFiles -PathType Container)) {md $ScriptCreatedFiles}

<#  Remove trailing slashes from folder locations and validate paths  #>
ValidatePath $ScriptCreatedFiles
If ($FeedSpamC) {
	$SADir = $SADir -Replace('\\$','')
	ValidatePath $SADir
}

<#  Delete old debug files and create new with head info  #>
$EmailBody = "$PSScriptRoot\ScriptCreatedFiles\EmailBody.log"
$DebugLog = "$PSScriptRoot\ScriptCreatedFiles\hMailServerDebug.log"
If (Test-Path $EmailBody) {Remove-Item -Force -Path $EmailBody}
If (Test-Path $DebugLog) {Remove-Item -Force -Path $DebugLog}
New-Item $EmailBody
New-Item $DebugLog
Write-Output "::: pURI-BL Offline $(Get-Date -f D) :::" | Out-File $DebugLog -Encoding ASCII -Append
Write-Output " " | Out-File $DebugLog -Encoding ASCII -Append
If ($UseHTML) {
	Write-Output "
		<!DOCTYPE html><html>
		<head><meta name=`"viewport`" content=`"width=device-width, initial-scale=1.0 `" /></head>
		<body style=`"font-family:Arial Narrow`"><table>
		<center>:::&nbsp;&nbsp;&nbsp;pURI-BL Offline&nbsp;&nbsp;&nbsp;:::</center>
		<center>$(Get-Date -f D)</center>
		&nbsp;
	" | Out-File $EmailBody -Encoding ASCII -Append
} Else {
	Email ":::    pURI-BL Offline    :::"
	Email "       $(Get-Date -f D)"
	Email " "
}

<#  Fill pURI-BL regex comparators  #>
$pRegExQuery = "
	SELECT domain AS result FROM $pURIBLDomTable WHERE shortcircuit = 1
	UNION
	SELECT uri AS result FROM $pURIBLURITable WHERE active = 1;
"
MySQLQuery $pRegExQuery | ForEach {
	$pURIBLRegEx = $_.result + "|" + $pURIBLRegEx
}
[RegEx]$pURIBLRegEx = $pURIBLRegEx -Replace "\|$",""

<#  Run pURI-BL script  #>
FeedpURIBL

<#  Create/update custom rule file for spamassassin  #>
If ($SARuleCF) {If (!$Simulate) {CustomSARuleFile}}

<#  Check for updates  #>
CheckForUpdates

<#  Finish up and send email  #>
Debug "----------------------------"
Debug "pURI-BL Offline routine finished"
Email " "
Email "pURI-BL Offline routine finished"
If ($UseHTML) {Write-Output "</table></body></html>" | Out-File $EmailBody -Encoding ASCII -Append}
EmailResults
