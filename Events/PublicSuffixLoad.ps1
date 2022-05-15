<#

.SYNOPSIS
	Download and format public_suffix_list.dat for use as RegEx pattern

.DESCRIPTION
	Download and format public_suffix_list.dat for use as RegEx pattern

.FUNCTIONALITY
	* Downloads public_suffix_list.dat
	* Converts public_suffix_list.dat to RegEx pattern 
	* Outputs to vbs file for use with EventHandlers.vbs
	* Outputs to powershell file for use with whatever you want

.NOTES
	Run weekly from task scheduler
	
.EXAMPLE

#>

<#  Set script variables  #>
$URL = "https://publicsuffix.org/list/public_suffix_list.dat"
$PubSufFile = "$PSScriptRoot\public_suffix_list.dat"
$CondensedDatList = "$PSScriptRoot\public_suffix_list.vbs"
$PSPubSuf = "$PSScriptRoot\public_suffix_list.ps1"

<#  Download latest Public Suffix data  #>
<#  First, if public_suffix_list.dat exists, get age in hours  #>
If (Test-Path $PubSufFile) {
	$LastDownloadTime = (Get-Item $PubSufFile).LastWriteTime
	$HoursSinceLastDownload = [int](New-Timespan $LastDownloadTime).TotalHours
}

<#  If public_suffix_list.dat doesn't exist or file at least 1 day old, then download  #> 
# If (($HoursSinceLastDownload -gt 23) -or (-not(Test-Path $PubSufFile))) {
	Try {
		Start-BitsTransfer -Source $URL -Destination $PubSufFile -ErrorAction Stop
	}
	Catch {
		$Err = $Error[0]
		Write-Output "$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss')) : Error downloading Public Suffix List : `n$Err" | Out-File "$PSScriptRoot\PubSufError.log" -Append
		Exit
	}
# }

<#  Read data file and output list formatted for RegEx (surround each with ^ and $)  #>
 Get-Content $PubSufFile | Where {((-not([string]::IsNullOrEmpty($_))) -and ($_ -notmatch "^//|^\*|^\!"))} | ForEach {
	Write-Output "^$_$"
} | Out-File $CondensedDatList

<#  Convert list to RegEx pattern  #>
(Get-Content -Path $CondensedDatList) -Replace '$','|' | Set-Content -NoNewline -Path $CondensedDatList
# (Get-Content -Path $CondensedDatList) -Replace '\.','\.' | Set-Content -NoNewline -Path $CondensedDatList
(Get-Content -Path $CondensedDatList) -Replace '^','Dim PubSufRegEx : PubSufRegEx = "' | Set-Content -NoNewline -Path $CondensedDatList
(Get-Content -Path $CondensedDatList) -Replace '\|$','' | Set-Content -NoNewline -Path $CondensedDatList
(Get-Content -Path $CondensedDatList) -Replace '$','"' | Set-Content -NoNewline -Path $CondensedDatList

(Get-Content -Path $CondensedDatList -Encoding UTF8) -Replace '^Dim PubSufRegEx : PubSufRegEx','[RegEx]$PubSufRegEx' | Set-Content -NoNewline -Path $PSPubSuf -Encoding UTF8