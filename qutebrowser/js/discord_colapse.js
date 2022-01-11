// discord script to collapse bars but now wont make the changell view bigger :(
(()=>{
function swap(v) {
    switch(v) {
        case "collapse":
        return "visible"
        default:
        return "collapse"
    }
}

function chat_fullscreen(sidebar, chat, members) {
    console.log(chat)
    switch(sidebar) {
        case "collapse": 
            members.style.position = "absolute";
            chat.style.position = "absolute";
            chat.style.top = "0px";
            chat.style.bottom = "0px";
            chat.style.left = "0px";
            chat.style.right = "0px";
        break;
        default: 
            chat.style.position = "relative";
            members.style.position = "relative";
    }
}

var sidebar = document.getElementsByClassName("sidebar-1tnWFu")[0];
sidebar.style.visibility=swap(sidebar.style.visibility);

var memeber_list = document.getElementsByClassName("membersWrap-3NUR2t hiddenMembers-8kpYM0")[0];
if (memeber_list)
memeber_list.style.visibility=swap(memeber_list.style.visibility);

var chat = document.getElementsByClassName("chat-2ZfjoI")[0]; 
chat = chat_fullscreen(sidebar.style.visibility, chat, memeber_list);

})()

