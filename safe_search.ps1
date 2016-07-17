#malware.testing.google.test/testing/malware/
function get-BrowseSafe() {
	Param(
		[Parameter(Mandatory = $true)][string]$search,
		[AllowEmptyString()]$api_key="<your key>"
	)

#build the json object to send to google:
$json = '{
    "client": {
      "clientId":      "BrowseSafe_monitor",
      "clientVersion": "1"
    },
    "threatInfo": {
      "threatTypes":      ["MALWARE", "SOCIAL_ENGINEERING"],
      "platformTypes":    ["ANY_PLATFORM" ],
      "threatEntryTypes": ["URL"],
      "threatEntries": ['

	#loop through multiple semi-colon delimited urls
	$search_arr = $search -split ";"
	$count_max = $search_arr.count
	$count = 1
	foreach($item in $search_arr) {
			if($count -eq $count_max) {
			$json = $json + "{""url"": ""$item""}"
			} else {
			$json = $json + "{""url"": ""$item""},"
			}
		$count++
	}
#close Json
$json = $json + ']}}'

#build url with correct api_key
$url = "https://safebrowsing.googleapis.com/v4/threatMatches:find?key=" + $api_key
	try {
	$result = Invoke-RestMethod "$url" -Method POST -Body $json -ContentType 'application/json'
	$result = $result.matches
	} catch {
	echo $_
	}

	if($($result.count) -eq 0) {
	return $false
	} else {
	return $result
	}
}