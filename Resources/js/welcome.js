let welcomeHeader = document.querySelector("h1");
let day = new Date().toLocaleString(navigator.language, {  weekday: "long" });

welcomeHeader.textContent = "Happy " + day;
