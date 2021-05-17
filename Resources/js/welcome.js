let welcomeHeader = document.querySelector("#home h1");
let day = new Date().toLocaleString(navigator.language, {  weekday: "long" });

if (welcomeHeader.textContent == "Welcome") {
	welcomeHeader.textContent = "Happy " + day;
}