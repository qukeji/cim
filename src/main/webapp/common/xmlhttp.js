HTTPRequest = function () {
	var xmlhttp=null;
	try {
	xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
	} catch (_e) {
	try {
	xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
	} catch (_E) { }
	}
	if (!xmlhttp && typeof XMLHttpRequest != 'undefined') {
	try {
	xmlhttp = new XMLHttpRequest();
	} catch (e) {
	xmlhttp = false;
	}
	}
	return xmlhttp;
}

function ask_(url,fieldToFill,lookupField) {
	var http = new HTTPRequest();
	http.open("GET",url,true);
	http.onreadystatechange = function (){ handleHttpResponse(http,fieldToFill,lookupField)};
	http.send(null);
}

function handleHttpResponse_(http,fieldToFill,lookupField) {
	if (http.readyState == 4) {
	result = http.responseText;
	if ( -1 != result.search("null") ) {
	lookupField.style.borderColor = "red";
	fieldToFill.value = "";
	} else {
	lookupField.style.borderColor = "";
	fieldToFill.value = result;
	}
	}
}
