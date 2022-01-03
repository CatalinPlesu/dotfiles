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
var sidebar = document.getElementsByClassName("sidebar-2K8pFh")[0];
sidebar.style.visibility=swap(sidebar.style.visibility);

var idk_what = document.getElementsByClassName("membersWrap-2h-GB4 hiddenMembers-2dcs_q")[0];
idk_what.style.visibility=swap(document.getElementsByClassName("membersWrap-2h-GB4 hiddenMembers-2dcs_q")[0].style.visibility);

})()

