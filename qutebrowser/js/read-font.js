function changeFont(element){
    element.setAttribute("style",element.getAttribute("style")+";font-family: Fira Code Medium");
    for(var i=0; i < element.children.length; i++){
        changeFont(element.children[i]);
    }
}
changeFont(document.getElementsByTagName("body")[0]);
