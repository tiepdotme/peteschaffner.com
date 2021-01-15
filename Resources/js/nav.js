let nav = document.querySelector("nav");

nav.classList.add("collapsed");

nav.onmouseover = function () {
	nav.classList.remove("collapsed");
}

nav.onmouseout = function ()  {
	nav.classList.add("collapsed");
}