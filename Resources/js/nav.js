let nav = document.querySelector("nav");
let avatar = document.querySelector("nav svg");

nav.classList.add("collapsed");

nav.onmouseover = function () {
	nav.classList.remove("collapsed");
}

nav.onmouseout = function ()  {
	nav.classList.add("collapsed");
}