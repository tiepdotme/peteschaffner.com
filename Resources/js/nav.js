let nav = document.querySelector("nav");
let cancelAutoHide = false;

setTimeout(function () {
	if (!cancelAutoHide) nav.classList.add("collapsed");
}, 2000);

nav.onmouseover = function () {
	if (!cancelAutoHide) cancelAutoHide = true;
	
	nav.classList.remove("collapsed");
}

nav.onmouseout = function ()  {
	nav.classList.add("collapsed");
}