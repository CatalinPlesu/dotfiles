var cool_font = "fira";
var not_cool_font = "not " + cool_font;
var font = font || not_cool_font;

function changeFont(element){ if (element.getAttribute("style"))
    element.setAttribute("style",element.getAttribute("style")+";font-family: Fira Code Medium");
    for(var i=0; i < element.children.length; i++){
        changeFont(element.children[i]);
    }
}

function changeFontBack(element){
    if (element.getAttribute("style"))
    element.style.fontFamily = "";
    for(var i=0; i < element.children.length; i++){
        changeFontBack(element.children[i]);
    }
}

switch(font) {
  case cool_font:
    font = not_cool_font;
    changeFontBack(document.getElementsByTagName("body")[0]);
    break;
  case not_cool_font:
    font = cool_font;
    changeFont(document.getElementsByTagName("body")[0]);
    break;
  default:
}
