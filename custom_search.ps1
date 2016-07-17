function search-custom() {
	Param(
		[Parameter(Mandatory = $true)][string]$search,
		[AllowEmptyString()] $customsearch_id = "006759091738829999417%3A-ynq7qhchoc",
		[AllowEmptyString()]$api_key="<your key>"
	)
	
	try {
	$Search_results = invoke-restmethod "https://www.googleapis.com/customsearch/v1?q=$search&cr=us&cx=$customsearch_id&key=$api_key"
	$search_results = ($search_results.items) | select title, snippet,link
	return $search_results
	} catch {
	return $false
	}
}


function search-nearby() {
Param(
	[Parameter(Mandatory = $true)][string]$search,
	[AllowEmptyString()]$api_key="<your key>"
)

try {
	$Search_results = invoke-restmethod "https://maps.googleapis.com/maps/api/place/textsearch/json?query=$search&key=$api_key"
	$search_results = ($search_results.results) | select Name,types,Formatted_address,price_level,Rating
	return $search_results
	} catch {
	return $false
	}

}