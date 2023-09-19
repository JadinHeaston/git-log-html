#https://devhints.io/git-log-format
revlist=$(git rev-list --no-merges HEAD)
(
	echo '
<!DOCTYPE html>
<html lang="en">

<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta name="description" content="Changelog">
	<meta name="theme-color" content="#f7f7f7">
	<link rel="icon" type="image/svg+xml" href="favicon.svg">
	<title>Git Changelog</title>
</head>

<body>
	<style>
		html,
		body {
			background-color: #f7f7f7;
			color: #555;
		}

		h1,
		h2,
		h3 {
			margin: 0;
		}

		h1 {
			text-align: center;
		}

		.git-log-commit-title {
			text-align: center;
			margin: .2rem;
		}

		.git-log-commit-title-subtitle {
			font-size: 1.05rem;
		}

		.git-log-commit-list {
			list-style-type: none;
		}

		.git-log-data {
			display: flex;
			align-items: stretch;
			justify-content: space-between;
		}

		.git-log-data>div {
			display: flex;
			flex-direction: column;
			border: dotted .1rem black;
			width: 100%;
		}

		.git-log-info-header {
			text-align: center;
			text-decoration: underline;
			margin-top: .5rem;
		}

		.git-log-commit-message-header {
			text-align: center;
			text-decoration: underline;
			margin-top: .5rem;
			margin-bottom: -1rem;
		}

		.git-log-commit-message {
			white-space: pre-line;
		}

		.git-log-files-affected-header {
			text-align: center;
			text-decoration: underline;
			margin-top: .5rem;
		}

		.git-log-file-affected-change[--data-change-type="D"] {
			color: red;
		}

		.git-log-file-affected-change[--data-change-type="A"] {
			color: green;
		}

		.git-log-file-affected-change[--data-change-type="M"] {
			color: orange;
		}
	</style>

	<main>'


	echo "		<h1>Changelog<br>($(date +%I:%M%p\ %m/%d/%Y))</h1>"
	echo '		<ul class="git-log-commit-list">'
	for rev in $revlist
	do
		files=$(git log -1 --pretty="format:" --name-status $rev)
		commitTitle=$(git log -1 --pretty="%f" $rev | tr '-' ' ')
		signOff=$(git log -1 --pretty="format:%an &#60%ae&#62" $rev)
		commitMessageLines=$(git log -1 --pretty="format:%B" $rev)
		commitHash=$(git log -1 --pretty="%h" $rev)
		absoluteTime=$(git log -1 --pretty="%aD" $rev)

		echo '			<li class="git-log-commit">'
		echo '				<h2 class="git-log-commit-title">'
		echo "					$commitTitle ($commitHash)<br><span class=\"git-log-commit-title-subtitle\">$(date +%I:%M%p\ %m/%d/%Y -f <(echo $absoluteTime))</span>"
		echo '				</h2>'
		echo '				<div class="git-log-data">'
		echo '					<div>'
		echo '						<h3 class="git-log-info-header">Information</h3>'
		echo "						<span class=\"git-log-author\">Author: $signOff</span><br>"
		echo '					</div>'
		echo '					<div>'
		echo '						<h3 class="git-log-commit-message-header">Commit Message</h3>'
		echo '						<div class="git-log-commit-message">'
		IFS=$'\n'
		for commitMessage in $commitMessageLines;
		do
			echo "$commitMessage"
		done
		unset IFS
		echo '						</div>'
		echo '					</div>'
		echo '					<div>'
		echo '						<h3 class="git-log-files-affected-header">Files Affected</h3>'
		echo '						<ul class="git-log-files-affected-list">'
		while read change file; do 
			if [ ${#file} -gt 0 ]
			then
			echo "							<li>(<span class=\"git-log-file-affected-change\" --data-change-type="$change">$change</span>) $file</li>"; 
			fi
		done <<< "$files"
		echo '						</ul>'
		echo '					</div>'
		echo '				</div>'
		echo '				<hr>'
		echo '			</li>'
	done
	echo '		</ul>'
	echo '<main></body></html>'
) > index.html