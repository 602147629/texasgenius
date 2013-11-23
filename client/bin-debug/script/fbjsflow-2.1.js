/*
FBJSFlow version 2.0
this library required jquery 1.4.2+

Copyright © 2008-2011, Area80 Co.,Ltd.
All rights reserved.

Facebook: http://www.fb.com/Area80/
Website: http://www.area80.net/
Docs: http://www.area80.net/sitemanager/

Change Log
v 2.0
1. Support oauth 2.0
2. Remove permission verification
3. add function getStatus() which returns "connected", "not_authorized", "unknown"
4. change getSession() to getAuthResponse() which has 4 following properties
accessToken, expiresIn, signedRequest, userID
5. Like box will not shown if user's stus is not connected.
6. Change variable name fbAppCfg.extPermissions to fbAppCfg.scope

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

* Redistributions of source code must retain the above copyright notice,
this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.

* Neither the name of Area80 Incorporated nor the names of its
contributors may be used to endorse or promote products derived from
this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
/*global window*/
/*global $*/
/*global FB*/
/*global document*/
/**
 * @constructor
 */
function FBJSFlowConfig()
{
}


/**
 * Display log on console or not
 */
FBJSFlowConfig.prototype.logger = true;
/**
 * This Object will be send to FB.init
 */
FBJSFlowConfig.prototype.fbInitCfg = {
	appId : "", status : true, cookie : true, xfbml : true
};
/**
 * Config this if your app is deployed on apps.facebook.com
 * isRequiredPermission(If set to true, the page will redirect to facebook to get permission automatically), redirectURI, scope
 */
FBJSFlowConfig.prototype.fbAppCfg = {
	isRequiredPermission : false, redirectURI : "", scope : ""
};
/**
 * If you need to show like popup at start, config this.
 */
FBJSFlowConfig.prototype.fbLikePopup = {
	showLikePopup : false, divId : "", fanPageId : ""
};
/**
 * @constructor
 */
function _FBJSFlow()
{

	var self = this;
	var _config = new FBJSFlowConfig(), _authResponse, _callBack, _likeBoxId, _userID, _accessToken, _status;

	var STATUS_CONNECTED = "connected";
	var STATUS_NOT_AUTHORIZED = "not_authorized";
	var STATUS_UNKNOWN = "unknown";

	this.init = function($config, $callBack)
	{
		this.initConfig = $config;
		_config = $config;
		if (this._verifyElements()) {
			this._loadFacebookScript($callBack);
		}
	};

	this.getAuthResponse = function()
	{
		return (_authResponse) ? _authResponse : null;
	};
	this.getStatus = function()
	{
		return (_status) ? _status : STATUS_UNKNOWN;
	};

	this._loadFacebookScript = function($callBack)
	{

		this.log("Initializing Facebook component...");
		_callBack = $callBack;

		window.fbAsyncInit = function()
		{
			self._parseFbAsyncScript();
		}; ( function()
			{
				var e = document.createElement('script');
				e.src = document.location.protocol + '//connect.facebook.net/en_US/all.js';
				e.async = true;
				if (document.getElementById('fb-root')) {
					document.getElementById('fb-root').appendChild(e);
				}
			}());

	};

	this._parseFbAsyncScript = function()
	{
		this.log("Facebook component loaded.");
		FB.init(_config.fbInitCfg);

		if (!_config.fbAppCfg.isRequiredPermission) {// Not Required Permission
			_authResponse = null;

			FB.getLoginStatus(function(response)
			{
				self.log("Got login status");
				_authResponse = response.authResponse;
				_status = response.status;

				if (_status == STATUS_CONNECTED) {
					self.log("User is connected");
					_userID = _authResponse.userID;
					_accessToken = _authResponse.accessToken;
				}

				self._initVisual();
				_callBack(response);
			});

		} else {

			_authResponse = null;
			
			FB.getLoginStatus(function(response)
			{
				self.log("Got login status, checking permision...");
				_authResponse = response.authResponse;
				_status = response.status;

				if (response.status == STATUS_CONNECTED) {
					_authResponse = response.session;
					self.checkPermission(function(b)
					{
						if (b) {
							self._initVisual();
							_callBack(response);
						} else {
							self.error("User has no required permission.");
							self._redirectToGetPermission();
						}
					});

				} else if (response.status == STATUS_NOT_AUTHORIZED) {
					self.error("User has not authorized the application");
					self._redirectToGetPermission();
				} else {
					self.error("User has not loggedin");
					self._redirectToGetPermission();
				}

			});
		}

	};
	this.checkPermission = function(cb)
	{
		self.log("Verifying required permission...");
		FB.api('/me/permissions', function(response)
		{
			self.log("Aqquired permission list >");
			self.log(response);
			var perms = response.data[0];
			var scopes = _config.fbAppCfg.scope.split(",");
			for (var i = 0; i < scopes.length; i++) {
				var sc = self.trim(scopes[i]);
				if (sc != "" && sc != "offline_access") {
					if (!perms[sc])
						cb(false);
				}
			}
			cb(true);
		});
	};
	this.trim = function(s)
	{
		var l = 0;
		var r = s.length - 1;
		while (l < s.length && s[l] == ' ') {
			l++;
		}
		while (r > l && s[r] == ' ') {
			r -= 1;
		}
		return s.substring(l, r + 1);
	};
	this._redirectToGetPermission = function()
	{
		var uri = _config.fbAppCfg.redirectURI;
		var params = window.location.toString().slice(window.location.toString().indexOf('?'));
		if (!params) {
			params = "";
		}
		var permsuri = 'https://graph.facebook.com/oauth/authorize?client_id=' + _config.fbInitCfg.appId + '&scope=' + _config.fbAppCfg.scope + '&redirect_uri=' + encodeURIComponent(uri + params);
		this.log("redirecting to " + permsuri);
		top.location = permsuri;
	};

	this._verifyElementByID = function(e)
	{
		var length = $(e).length > 0;
		if (length == 1) {
			return true;
		} else if (length > 1) {
			this.error("Multiple element " + e + " is found.");
			return false;
		} else {
			this.error("Element ID " + e + " is not found.");
			return false;
		}
	};

	this._verifyElements = function()
	{
		this.log("Verifying config data and HTML elements...");
		if (_config.fbInitCfg.appId === "") {
			this.error("appId does not set [config.fbInitCfg.appId]");
			return false;
		}
		if(_config.fbAppCfg.scope != "") {
			if(!self.validatePermissions(_config.fbAppCfg.scope)) {
				return false;
			}
		}
		if (!this._verifyElementByID("#fb-root")) {
			this.error("Can't find Element #fb-root");
			return false;
		}

		if (_config.fbLikePopup.showLikePopup) {
			if (!this._verifyElementByID("#" + _config.fbLikePopup.divId)) {
				this.error("Can't find Element #"+_config.fbLikePopup.divId);
				return false;
			}
			if (_config.fbLikePopup.fanPageId === "") {
				this.error("fanPageId does not set [config.fbLikePopup.fanPageId]");
				return false;
			}
		}
		this.log("Config and HTML elements is verified");
		return true;
	};

	this._initVisual = function()
	{
		this.activateLikeBox();
	};

	this.hideLikeBox = function()
	{
		clearInterval(_likeBoxId);
		$('#' + _config.fbLikePopup.divId).hide();
	};

	this.activateLikeBox = function()
	{
		if (_config.fbLikePopup.showLikePopup) {
			if (_config.fbLikePopup.fanPageId === "") {
				this.error("Fan page is not set.");
				return;
			}
			if ($('#' + _config.fbLikePopup.divId).length > 0) {
				this._checkIfUserIsLike();
			} else {
				this.error("Like popup #" + _config.fbLikePopup.divId + " is not found");
			}

		}
	};

	this._checkIfUserIsLike = function()
	{
		this.log("check like fan page every 2s.");
		if (_status == STATUS_CONNECTED) {
			var uid = _userID;
			var fql = "SELECT page_id FROM page_fan WHERE uid=me() AND page_id=" + _config.fbLikePopup.fanPageId;
			var query = FB.Data.query(fql);
			query.wait(function(rows)
			{
				if (rows && rows[0] && rows[0].page_id) {
					self.hideLikeBox();
				} else {
					clearInterval(_likeBoxId);
					_likeBoxId = setInterval(function()
					{
						self._checkIfUserIsLike();
					}, 2000);
					$('#' + _config.fbLikePopup.divId).show();
				}
			});
		}
	};
	
	this.validatePermissions = function (permissions) {
		var perms = permissions.split(" ").join("");
		var permslist = perms.split(",");
		var list = "user_about_me,friends_about_me,user_activities,friends_activities,user_birthday,friends_birthday,user_checkins,friends_checkins,user_education_history";
		list += ",user_events,friends_events,user_groups,friends_groups,user_hometown,friends_hometown,user_interests,friends_interests,user_likes,friends_likes,user_location,friends_location";
		list += ",user_notes,friends_notes,user_photos,friends_photos,user_questions,friends_questions,user_relationships,friends_relationships";
		list += ",user_relationship_details,friends_relationship_details,user_religion_politics,friends_religion_politics,user_status,friends_status";
		list += ",user_subscriptions,friends_subscriptions,user_videos,friends_videos,user_website,friends_website,user_work_history,friends_work_history,email";
		
		//extended
		list += ",read_friendlists,read_insights,read_mailbox,read_requests,read_stream,xmpp_login,ads_management,create_event,manage_friendlists,manage_notifications,user_online_presence,friends_online_presence,publish_checkins,publish_stream,rsvp_event";
		
		//open graph
		list += "publish_actions,user_actions.music,friends_actions.music,user_actions.news,friends_actions.news,user_actions.video,friends_actions.video,user_actions:,friends_actions:,user_games_activity,friends_games_activity";
		
		//page
		list += ",manage_pages";
		
		//should'nt use anymore
		list += ",offline_access,photo_upload,status_update,sms,video_upload,create_note,share_item";
		
		for(var i=0;i<permslist.length;i++) {
			var p = permslist[i];
			if(p.indexOf(":")>-1) {
				p = p.substr(0,p.indexOf(":")-1);
			}
			if(list.indexOf(p)==-1) {
				self.error("Unknown scope "+p+", check https://developers.facebook.com/docs/authentication/permissions/");
				return false;
			}
		}
		return true;
	
	};

	this.log = function(a)
	{
		try {
		if (_config.logger) {
			if (window.Debug && window.Debug.writeln) {
				window.Debug.writeln("[FBJSFlow] " + a);
			} else if (window.console) {
				if ( typeof a != "string") {
					window.console.dir(a);
				} else {
					window.console.log("[FBJSFlow] " + a);
				}
			}
		}
		} catch (e) {}
	};
	this.error = function(a)
	{
		if (_config.logger) {
			if (window.Debug && window.Debug.writeln) {
				window.Debug.writeln("[FBJSFlow Error] " + a);
			} else if (window.console) {
				window.console.error("[FBJSFlow Error] " + a);
			}
		}
	};

}


//implementation
_FBJSFlow.prototype.initConfig = null;
/**
 * Start FBJSFlow
 *
 * @param {FBJSFlowConfig} $config
 * @param {function} $callBack
 */
_FBJSFlow.prototype.init = function($config, $callBack)
{
};
/**
 * @return {object} Session object, stored in FBJs response.
 */
_FBJSFlow.prototype.getAuthResponse = function()
{
};
/**
 * @return {string} Connection status
 */
_FBJSFlow.prototype.getStatus = function()
{
};
/**
 * Manualy hide Like box if config. Like box will automatically hide after user like the content.
 */
_FBJSFlow.prototype.hideLikeBox = function()
{
};
/**
 * Show Like box manualy if config. The Like box can be shown only if user haven't like the content yet.
 */
_FBJSFlow.prototype.activateLikeBox = function()
{
};
//
var FBJSFlow = new _FBJSFlow(); 