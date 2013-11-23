<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"  xmlns:fb="http://ogp.me/ns/fb#">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta property="og:title" content="มื้อนี้..มื้อไหน..ก็น่ากิน" />
<meta property="og:description" content="ตารางความสัมพันธ์ Entree' มื้อนี้..มื้อไหน..ก็น่ากิน ไปดูกันเลยว่า คุณคืออาหารจานไหนของเพื่อนๆกันแน่" />
<meta property="og:image" content="http://www.campaignhub.net/entreesnack/phototagging/script/logo.jpg" />
<title>มื้อนี้..มื้อไหน..ก็น่ากิน</title>
<link href="script/reset.css" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="script/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="script/swfobject.js"></script>
<script type="text/javascript" src="script/fbjsflow-2.1.js"></script>
<link  rel="stylesheet" href="script/reset.css"/>
<style type="text/css">
#flashcontent {width:100%; height: 100%;}
.popup {
	width:500px;
	height:120px;
	background:url("./script/logonoflash.jpg") no-repeat;
	padding-top:380px;
	text-align:center;
	margin-left:auto;
	margin-right:auto;
}
#content p {
	font-family:"Luiciada Granade",Arial,Tahoma;
	font-size:12px;
	width:100%;
	color: #fff;
}
#content p a {
	color:#f2e126;
}
#content p a:hover {
	color:#f2e126;
}
#content p a:visited {
	color:#f2e126;
}
#content p a:link {
	color:#f2e126;
}
</style>
<script type="text/javascript">

$(document).ready(function () {
	
	var cfg = new FBJSFlowConfig();
	
	cfg.fbAppCfg.isRequiredPermission = true;//isRedirectToRequire permission
	cfg.fbAppCfg.scope = "user_likes,email,user_photos,read_friendlists,user_birthday,friends_photos,photo_upload,publish_stream"; //photo_upload,publish_stream,offline_access,
	cfg.fbAppCfg.redirectURI = "http://localhost.com";
	
	cfg.fbAppCfg.channelUrl = window.location.href+"/channel.php";

	cfg.fbInitCfg.appId = "271635846214607";
	
	
	FBJSFlow.init(cfg, appIsInitialized);
	
});
function setHeight (h) {
	
	$("#flashcontent").height(h);
	FB.Canvas.setAutoResize();
}
function resizeShareBox () {

	$("#sharing-wrapper").css("top",$("#flashcontent").height()-27);
}
function resizeLikeBox () {
	var wHeight = $(window).height();
	var wWidth = $(window).width();
	//var wHeight = $(document).height();
	//var wWidth = $(document).width();
	$('#likebox').height(wHeight);
	$('#likebox').width(wWidth);
	$('#likeitem').offset({top:(wHeight-151)*.5, left:(wWidth-332)*.5});
	// $('#closebtn').offset({top:(wHeight-151)*.5-10, left:(wWidth-332)*.5+300});
	
}
function login () {
	FBJSFlow.log(FBJSFlow.initConfig.fbAppCfg.scope);
	FB.login(loginHandler,{scope:FBJSFlow.initConfig.fbAppCfg.scope});
}
function loginHandler (response) {
	if(response && response.status=="connected") {
		try {
			document.getElementById("flashcontent").logInSuccess(response.authResponse.accessToken,response.authResponse.userID);
		} catch (e) {
			FBJSFlow.log("Handler Function Error, Can't send login information.");
		}
	} else {
		try {
			document.getElementById("flashcontent").logInFailed();
		} catch (e) {
			FBJSFlow.log("Handler Function Error, Can't send login information.");

		}
	}
}
function appIsInitialized (response) {
	//FBJSFlow.log(response);
	//FB.Canvas.setSize({height:855})
	embedSWF(response.authResponse.accessToken ,response.authResponse.userID);
}
function closeLike () {
	FBJSFlow.hideLikeBox();
}
function embedSWF(token,fbuid) {
			
			var params = {};
			params.allowFullScreen = "true";
			params.allowScriptAccess = "always";
			params.allowNetworking = "all";
			params.base = ".";
			params.bgcolor = "#ffffff";
			params.menu = false;
			params.wmode = "opaque";
			params.scale = "noScale";
			var attributes = {};
			attributes.id = "flashcontent";
			attributes.name = "flashcontent";
			
			var flashvars = {};
			if(token) {
				flashvars.access_token = token;	 
				flashvars.fbuid = fbuid;
			}
			$("#wait").hide();
			$("#flashcontent").show();
			
			swfobject.embedSWF("main.swf?version="+Math.random(), "flashcontent", "100%", "100%", '10.2.0', 'expressinstall.swf', flashvars, params, attributes);   
			
			//FB.Canvas.setSize({width:810,height:1303});
}
function shareFacebook () {
	wallpost("AP Aspiring Heights","http://www.ap-thai.com/campaign/AP_Aspiring_Heights/","YES");
}
function wallpost (name,caption,desc,img,link) {
	//track("ShareToFacebook");
	var link_action = (link) ? link : 'http://www.ap-thai.com/campaign/AP_Aspiring_Heights/';
	var image = (img) ? img:'http://www.ap-thai.com/campaign/AP_Aspiring_Heights/script/logo.png';
	
	FB.ui(
	   {
	     method: 'stream.publish',
	     message: '',
	     attachment: {
	       name: name,
	       caption: caption,
	       description: desc,
	       href: link_action,
	       media:[{
				'type':'image',
			    'src':image,
			    'href':link_action
			}]
	     },
	     action_links: [
	       { text: 'Like', href: link_action }
	     ],
	     user_message_prompt: 'Post to Wall'
	    
	   },
	   function(response) {
	     if (response && response.post_id) {
		     //
	     } else {
	    	
	     }
	   }
	);
}

function callAlert(str)
{
    alert(str);
}
			
</script>
</head>
<body bgcolor="#ffffff" style="width:100%;height:100%;" onresize="resizeLikeBox()">
<div id="fb-root"></div>
<div id="content" style="width:760px; height:1200px;">
	<div id="wait"  class="popup"><p>กำลังเชื่อมต่อกับเฟชบุค...</p></div>
	<div id="flashcontent" style="display:none"><div id="play" class="popup"><p>Flash Player ของคุณเก่าเกินไปหน่อย<br/>Download <a href="http://get.adobe.com/flashplayer/" target="_blank">Flash player</a> Version ใหม่ล่าสุดที่นี่.</p></div></div>
</div>
</body>
</html>