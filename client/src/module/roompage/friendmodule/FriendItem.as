package module.roompage.friendmodule
{
	import net.area80.display.loader.ImageBox;

	public class FriendItem extends friendItem
	{
		public function FriendItem(_friendData:FriendData,_num:int)
		{
			super();
			nameText.text = _friendData.nameFriend;
			moneyText.text = _friendData.money;
			numText.text = _num.toString();
			var image:ImageBox = new ImageBox("https://graph.facebook.com/"+_friendData.uid+"/picture",50,50);
			imageContainer.addChild(image);
			image.load();
		}
	}
}