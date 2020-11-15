const url = "https://grep.fit.soptik.tech/";
isSearchRunning = false;
currentlySelectedTextbook = "ZMA";
resultDiv = document.getElementById('result');

function search(e, text) {
    if (e.preventDefault) e.preventDefault();
    if (isSearchRunning) return false;

    iframeDiv.innerHTML = '';
    resultDiv.innerHTML = 'Loading...';

    // Strip diacritics from search text
    text = text.normalize("NFD").replace(/[\u0300-\u036f]/g, "");

    // Encode search term to base64
    const searchTermB64 = btoa(text);

    let request = new XMLHttpRequest();
	request.open("GET", url + currentlySelectedTextbook + "/" + searchTermB64, true);

	request.onload = function() {
        resultDiv.innerHTML = '';
        isSearchRunning = false;
		if(this.status >= 200 && this.status < 400) {
			let response = this.response;
            let lines = response.split('\n');
            let first = true;
            for ( lineIdx in lines ) {
                let line = lines[lineIdx];
                let numberOfRecords = parseInt(line.split(' ')[0]);
                let link = line.split(' ')[1];
                insertResult(numberOfRecords, link);
                if ( first ) {
                    displayIframe(link);
                    first = false;
                }
            }
		}
	}
    request.onerror = function() {
        isSearchRunning = false;
    }

	request.send();
    isSearchRunning = true;


    return false;
}

function insertResult(numOfResults, link) {
    let tempName = link.split('/')[link.split('/').length-1];
    resultDiv.innerHTML += `<a href='https://${link}' onclick='displayIframe("${link}"); return false;'><div id='result-${tempName}' class="subresult"><h3>${tempName}</h3></div></a>`;
}

function displayIframe(link) {
    if ( link == '' ) {
        iframeDiv.innerHTML = '<img src="https://http.cat/404" />'
    } else {
        iframeDiv.innerHTML = `<p><a href="https://${link}" target="_blank">Open in new tab</a></p><iframe src=https://${link}></iframe>`;
    }
}

/// This updates result name after real name is fetched from server
function updateResult(tempName, newName) {
    document.getElementById(`result-${tempName}`).innerHTML = `<h3>${newName}</h3>`;
}

document.getElementById("searchForm").addEventListener("submit", function(e) { search(e, document.getElementById("searchField").value); });
