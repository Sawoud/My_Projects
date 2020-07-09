var ChannelNo = $('#ChannelNo').attr('data');

function W_Name(){
if (Cookies.get('name') == undefined){
var user_name = prompt("prompt","Please Input your username")
while(user_name == null || user_name == "null" || user_name == ""||user_name == "Please Input your username")
{user_name = prompt("prompt","Please input a proper username")}
Cookies.set("name",user_name,{expires:2});
}
window.location.href = "/index"
}
function storepage(){
Cookies.set("ChannelNo",ChannelNo,{expires:2});
}

function RestoreChat(){

  if(Cookies.get('ChannelNo') == undefined){alert("There are no cookies stored")}
  else{
    window.location.href = "/chat/"+Cookies.get('ChannelNo')
    }

}
