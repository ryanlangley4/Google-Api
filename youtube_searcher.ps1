function Get-youtubesearch() {
Param(
	[Parameter(Mandatory = $true)][string]$search,
	[AllowEmptyString()]$max_page = 5,
	[AllowEmptyString()]$copyright = "any",
	[AllowEmptyString()]$youtube_key="<your key>"
)
	
$Search_results = invoke-restmethod "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&videoLicense=$copyright&key=$youtube_key"
$page_count = 1
$video_list = @()

	while(($Search_results.nextPageToken) -and ($page_count -le $max_page)) {
	$next_page=$Search_results.nextPageToken

		foreach($video_info in $search_results.items) {
		$video_id = $video_info.id.videoid
		$video_stats = invoke-restmethod "https://www.googleapis.com/youtube/v3/videos?part=statistics&id=$video_id&key=$youtube_key"
		[int]$views = $video_stats.items.statistics.viewcount
		[int]$likes = $video_stats.items.statistics.likecount
		[int]$dislikes = $video_stats.items.statistics.dislikeCount
		$title = $video_info.snippet.title
		$link = "https://youtube.com/watch?v=$video_id"

			$video_list += new-object psobject -Property @{
				title = "$title";
				video_id = "$video_id";
				likes = $likes;
				dislikes = $dislikes;
				views = "$views";
				link = "$link";
			}			
		
		}

	$Search_results = invoke-restmethod "https://www.googleapis.com/youtube/v3/search?part=snippet&pageToken=$next_page&type=video&q=$search&videoLicense=$copyright&key=$youtube_key"
	$page_count++
	}
	
return $video_list
}

function get-youtubepopular() {
Param(
	[AllowEmptyString()]$max_page = 5,
	[AllowEmptyString()]$copyright = "any",
	[AllowEmptyString()]$youtube_key="<your key>"
)
echo "First search"
$Search_results = invoke-restmethod "https://www.googleapis.com/youtube/v3/videos?chart=mostPopular&key=$youtube_key&part=snippet"
$page_count = 1
$video_list = @()

	while(($Search_results.nextPageToken) -and ($page_count -le $max_page)) {
	$next_page=$Search_results.nextPageToken

		foreach($video_info in $search_results.items) {
		$video_id = $video_info.id
		echo "second search"
		$video_stats = invoke-restmethod "https://www.googleapis.com/youtube/v3/videos?part=statistics&id=$video_id&key=$youtube_key"
		[int]$views = $video_stats.items.statistics.viewcount
		[int]$likes = $video_stats.items.statistics.likecount
		[int]$dislikes = $video_stats.items.statistics.dislikeCount
		$title = $video_info.snippet.title
		$link = "https://youtube.com/watch?v=$video_id"

			$video_list += new-object psobject -Property @{
				title = "$title";
				video_id = "$video_id";
				likes = $likes;
				dislikes = $dislikes;
				views = $views;
				link = "$link";
			}			
		
		}
echo "3rd search"
	$Search_results = invoke-restmethod "https://www.googleapis.com/youtube/v3/videos?chart=mostPopular&pageToken=$next_page&key=$youtube_key"
	$page_count++
	}
	
return $video_list
}