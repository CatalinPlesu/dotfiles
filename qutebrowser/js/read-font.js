if (!style){
    var style = document.createElement('style');
    style.type = 'text/css';
    style.innerHTML = '.font { font-family: Fira Code Medium; }';
    document.getElementsByTagName('head')[0].appendChild(style);
}

var font = font || "default";

function changeFont(element){
    element.classList.add("font");
    for(var i=0; i < element.children.length; i++){
        changeFont(element.children[i]);
    }
}

function resetFont(element){
    element.classList.remove("font");
    for(var i=0; i < element.children.length; i++){
        resetFont(element.children[i]);
    }
}

if (font == "default") {
    changeFont(document.getElementsByTagName("body")[0]);
    font = "changed";
} else {
    resetFont(document.getElementsByTagName("body")[0]);
    font = "default";
}
