package
{
	import flash.display.Sprite;
	
	import vo.RoomConfig;
	
	public class generate_room2 extends Sprite
	{
		
		public const ZONE_1_1:RoomConfig = new RoomConfig( 400 , 8000 , 20 , 40 );
		public const ZONE_1_2:RoomConfig = new RoomConfig( 500 , 10000 , 25 , 50 );
		
		public const ZONE_2_1:RoomConfig = new RoomConfig( 1000 ,  20000 ,  50 , 100 );
		public const ZONE_2_2:RoomConfig = new RoomConfig( 2000 ,  80000 ,  100 , 200 );
		public const ZONE_2_3:RoomConfig = new RoomConfig( 5000 ,  100000 , 250 , 500 );
		public const ZONE_2_4:RoomConfig = new RoomConfig( 10000 , 200000 , 500 , 1000 );
		
		public const ZONE_3_1:RoomConfig = new RoomConfig( 10000 , 2000000 , 5000 , 10000 );
		public const ZONE_3_2:RoomConfig = new RoomConfig( 40000 , 2000000 , 5000 , 10000 );
		public function generate_room2()
		{
//			getHead("BasicExamples");
			gen("จังหวัดกำแพงเพชร",ZONE_1_1,4);
//			getFooter();
		}
		
		
		private function gen(_roomName:String , _roomConfig:RoomConfig , _numRoom:int ):void
		{
			var str:String ="<rooms>\n";
			for( var i:int=0;i<=_numRoom-1;i++){
				str+="<room>\n"+
					"	<name>"+_roomName+""+(i+1)+"</name>\n"+
					"	<groupId>default</groupId>\n"+
					"	<password></password>\n"+
					"	<maxUsers>10</maxUsers>\n"+
					"	<maxSpectators>100</maxSpectators>\n"+
					"	<isDynamic>false</isDynamic>\n"+
					"	<isGame>true</isGame>\n"+
					"	<isHidden>false</isHidden>\n"+
					"	<autoRemoveMode>NEVER_REMOVE</autoRemoveMode>\n"+
					"	<permissions>\n"+
					"	  <flags>PASSWORD_STATE_CHANGE,PUBLIC_MESSAGES</flags>\n"+
					"	  <maxRoomVariablesAllowed>10</maxRoomVariablesAllowed>\n"+
					"	</permissions>\n"+
					"	<events>USER_ENTER_EVENT,USER_EXIT_EVENT,USER_COUNT_CHANGE_EVENT,USER_VARIABLES_UPDATE_EVENT,USER_JOIN_ROOM,USER_DISCONNECT,USER_LEAVE_ROOM,PLAYER_TO_SPECTATOR</events>\n"+
					"	<badWordsFilter isActive=\"false\"/>\n"+
					"	<roomVariables>\n"+
					"	  <variable>\n"+
					"		<name>min</name>\n"+
					"		<value>"+_roomConfig.minCoin+"</value>\n"+
					"		<type>STRING</type>\n"+
					"		<isPrivate>false</isPrivate>\n"+
					"		<isPersistent>false</isPersistent>\n"+
					"		<isGlobal>false</isGlobal>\n"+
					"		<isHidden>false</isHidden>\n"+
					"	  </variable>\n"+
					"	  <variable>\n"+
					"		<name>max</name>\n"+
					"		<value>"+_roomConfig.maxCoin+"</value>\n"+
					"		<type>STRING</type>\n"+
					"		<isPrivate>false</isPrivate>\n"+
					"		<isPersistent>false</isPersistent>\n"+
					"		<isGlobal>false</isGlobal>\n"+
					"		<isHidden>false</isHidden>\n"+
					"	  </variable>\n"+
					"	  <variable>\n"+
					"		<name>sb</name>\n"+
					"		<value>"+_roomConfig.sb+"</value>\n"+
					"		<type>STRING</type>\n"+
					"		<isPrivate>false</isPrivate>\n"+
					"		<isPersistent>false</isPersistent>\n"+
					"		<isGlobal>false</isGlobal>\n"+
					"		<isHidden>false</isHidden>\n"+
					"	  </variable>\n"+
					"	  <variable>\n"+
					"		<name>bb</name>\n"+
					"		<value>"+_roomConfig.bb+"</value>\n"+
					"		<type>STRING</type>\n"+
					"		<isPrivate>false</isPrivate>\n"+
					"		<isPersistent>false</isPersistent>\n"+
					"		<isGlobal>false</isGlobal>\n"+
					"		<isHidden>false</isHidden>\n"+
					"	  </variable>\n"+
					"	</roomVariables>\n"+
					"	<extension>\n"+
					"	  <name>texas</name>\n"+
					"	  <type>JAVA</type>\n"+
					"	  <file>com.exitapplication.TexasExtension</file>\n"+
					"	  <propertiesFile></propertiesFile>\n"+
					"	  <reloadMode>AUTO</reloadMode>\n"+
					"	</extension>\n"+
					"</room>\n";
			}
			str +="</rooms>\n";			
			trace(str);
		}
		private function getHead(_zone:String):void
		{
			//BasicExamples
			var str:String = "";
			str +="<zone>\n";
			str +="  <name>"+_zone+"</name>\n";
			str +="  <isCustomLogin>false</isCustomLogin>\n";
			str +="  <isForceLogout>false</isForceLogout>\n";
			str +="  <applyWordsFilterToUserName>true</applyWordsFilterToUserName>\n";
			str +="  <applyWordsFilterToRoomName>true</applyWordsFilterToRoomName>\n";
			str +="  <applyWordsFilterToPrivateMessages>true</applyWordsFilterToPrivateMessages>\n";
			str +="  <isFilterBuddyMessages>true</isFilterBuddyMessages>\n";
			str +="  <maxUsers>1000</maxUsers>\n";
			str +="  <maxUserVariablesAllowed>10</maxUserVariablesAllowed>\n";
			str +="  <maxRoomVariablesAllowed>10</maxRoomVariablesAllowed>\n";
			str +="  <minRoomNameChars>1</minRoomNameChars>\n";
			str +="  <maxRoomNameChars>20</maxRoomNameChars>\n";
			str +="  <maxRooms>500</maxRooms>\n";
			str +="  <maxRoomsCreatedPerUser>10</maxRoomsCreatedPerUser>\n";
			str +="  <userCountChangeUpdateInterval>1000</userCountChangeUpdateInterval>\n";
			str +="  <userReconnectionSeconds>0</userReconnectionSeconds>\n";
			str +="  <overrideMaxUserIdleTime>300</overrideMaxUserIdleTime>\n";
			str +="  <allowGuestUsers>true</allowGuestUsers>\n";
			str +="  <guestUserNamePrefix>Guest#</guestUserNamePrefix>\n";
			str +="  <publicRoomGroups>default,games,chats</publicRoomGroups>\n";
			str +="  <defaultRoomGroups>default,games,chats</defaultRoomGroups>\n";
			str +="  <defaultPlayerIdGeneratorClass></defaultPlayerIdGeneratorClass>\n";
			str +="  <wordsFilter active=\"false\">\n";
			str +="	<useWarnings>false</useWarnings>\n";
			str +="	<warningsBeforeKick>3</warningsBeforeKick>\n";
			str +="	<kicksBeforeBan>2</kicksBeforeBan>\n";
			str +="	<banDuration>1440</banDuration>\n";
			str +="	<maxBadWordsPerMessage>0</maxBadWordsPerMessage>\n";
			str +="	<kicksBeforeBanMinutes>3</kicksBeforeBanMinutes>\n";
			str +="	<secondsBeforeBanOrKick>5</secondsBeforeBanOrKick>\n";
			str +="	<warningMessage>Stop swearing or you will be banned</warningMessage>\n";
			str +="	<kickMessage>Swearing not allowed: you are being kicked</kickMessage>\n";
			str +="	<banMessage>Too much swearing: you are banned</banMessage>\n";
			str +="	<wordsFile>config/wordsFile.txt</wordsFile>\n";
			str +="	<filterMode>BLACKLIST</filterMode>\n";
			str +="	<banMode>NAME</banMode>\n";
			str +="	<hideBadWordWithCharacter>*</hideBadWordWithCharacter>\n";
			str +="  </wordsFilter>\n";
			str +="  <floodFilter active=\"false\">\n";
			str +="	<banDurationMinutes>1440</banDurationMinutes>\n";
			str +="	<maxFloodingAttempts>5</maxFloodingAttempts>\n";
			str +="	<secondsBeforeBan>5</secondsBeforeBan>\n";
			str +="	<banMode>NAME</banMode>\n";
			str +="	<logFloodingAttempts>true</logFloodingAttempts>\n";
			str +="	<banMessage>Too much flooding, you are banned</banMessage>\n"+
			"  </floodFilter>\n";
			trace(str);
		}
		
		private function getFooter():void
		{
			var str:String = "";
			str +="<disabledSystemEvents/>\n";
			str +="  <privilegeManager active=\"false\">\n";
			str +="	<profiles>\n";
			str +="	  <profile id=\"0\">\n";
			str +="		<name>Guest</name>\n";
			str +="		<deniedRequests/>\n";
			str +="		<permissionFlags>\n";
			str +="		  <string>ExtensionCalls</string>\n";
			str +="		</permissionFlags>\n";
			str +="	  </profile>\n";
			str +="	  <profile id=\"1\">\n";
			str +="		<name>Standard</name>\n";
			str +="		<deniedRequests/>\n";
			str +="		<permissionFlags>\n";
			str +="		  <string>ExtensionCalls</string>\n";
			str +="		</permissionFlags>\n";
			str +="	  </profile>\n";
			str +="	  <profile id=\"2\">\n";
			str +="		<name>Moderator</name>\n";
			str +="		<deniedRequests/>\n";
			str +="		<permissionFlags>\n";
			str +="		  <string>ExtensionCalls</string>\n";
			str +="		  <string>SuperUser</string>\n";
			str +="		</permissionFlags>\n";
			str +="	  </profile>\n";
			str +="	  <profile id=\"3\">\n";
			str +="		<name>Administrator</name>\n";
			str +="		<deniedRequests/>\n";
			str +="		<permissionFlags>\n";
			str +="		  <string>ExtensionCalls</string>\n";
			str +="		  <string>SuperUser</string>\n";
			str +="		</permissionFlags>\n";
			str +="	  </profile>\n";
			str +="	</profiles>\n";
			str +="  </privilegeManager>\n";
			str +="  <extension>\n";
			str +="	<name>texas</name>\n";
			str +="	<type>JAVA</type>\n";
			str +="	<file>com.exitapplication.TexasExtension</file>\n";
			str +="	<propertiesFile></propertiesFile>\n";
			str +="	<reloadMode>AUTO</reloadMode>\n";
			str +="  </extension>\n";
			str +="  <buddyList active=\"true\">\n";
			str +="	<allowOfflineBuddyVariables>true</allowOfflineBuddyVariables>\n";
			str +="	<maxItemsPerList>100</maxItemsPerList>\n";
			str +="	<maxBuddyVariables>15</maxBuddyVariables>\n";
			str +="	<offlineBuddyVariablesCacheSize>500</offlineBuddyVariablesCacheSize>\n";
			str +="	<customStorageClass></customStorageClass>\n";
			str +="	<useTempBuddies>true</useTempBuddies>\n";
			str +="	<buddyStates>\n";
			str +="	  <string>Available</string>\n";
			str +="	  <string>Away</string>\n";
			str +="	  <string>Occupied</string>\n";
			str +="	</buddyStates>\n";
			str +="	<badWordsFilter isActive=\"true\"/>\n";
			str +="  </buddyList>\n";
			str +="  <databaseManager active=\"false\">\n";
			str +="	<driverName></driverName>\n";
			str +="	<connectionString></connectionString>\n";
			str +="	<userName></userName>\n";
			str +="	<password></password>\n";
			str +="	<testSql></testSql>\n";
			str +="	<maxActiveConnections>10</maxActiveConnections>\n";
			str +="	<maxIdleConnections>10</maxIdleConnections>\n";
			str +="	<exhaustedPoolAction>FAIL</exhaustedPoolAction>\n";
			str +="	<blockTime>3000</blockTime>\n";
			str +="  </databaseManager>\n";
			str +="</zone>\n";
			trace(str);
		}
	}
}