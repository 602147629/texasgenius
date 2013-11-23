/*
Copyright © 2008-2011, Area80 Co.,Ltd.
All rights reserved.

Facebook: http://www.fb.com/Area80/
Website: http://www.area80.net/


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
package net.area80.youtube
{
	public class YoutubeUtils
	{
		/**
		 * Get VDO Thumbnail for specify vdoid 
		 * @param $vdoid Youtube vdo id
		 * @param thumb inteleget corresponds to one of the 3 thumbnails that YouTube automatically generates
		 * @return 
		 * 
		 */
		public static function getThumbURI($vdoid:String, thumb:uint=1):String
		{
			return "http://img.youtube.com/vi/"+$vdoid+"/"+thumb+".jpg";
		}
		
		/**
		 * Get VDOID from specify URI 
		 * @param $uri Youtube uri
		 * @return Youtube's VDOURI, null if wrong format input URI
		 * 
		 */
		public static function extractVDOIDFromURI($uri:String):String
		{
			var reg:RegExp = new RegExp("#(?<=v=)[a-zA-Z0-9-]+(?=&)|(?<=v\/)[^&\n]+|(?<=v=)[^&\n]+|(?<=youtu.be/)[^&\n]+#");
			var has:Boolean = (reg.test($uri));
			if(has && ($uri.indexOf("youtube.com")!=-1 || $uri.indexOf("youtu.be")!=-1)) {
				return String(reg.exec($uri)).split("#")[0];
			} else {
			
				return null;
			}
		}
	}
}