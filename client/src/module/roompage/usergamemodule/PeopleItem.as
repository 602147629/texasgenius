package module.roompage.usergamemodule
{
	import net.area80.display.loader.ImageBox;

	public class PeopleItem extends peopleItem
	{
		public function PeopleItem(_nameText:String,_uid:String)
		{
			super();
			nameText.text = _nameText;
			var image:ImageBox = new ImageBox("https://graph.facebook.com/"+_uid+"/picture",50,50);
			imageContainer.addChild(image);
			image.load();
		}
	}
}