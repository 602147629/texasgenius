package net.area80.enum
{
	import flash.utils.Dictionary;

	public class ThailandProvince
	{
		public static const REGION_NORTH:String = "north";
		public static const REGION_EAST:String = "east";
		public static const REGION_NORTHEAST:String = "northeast";
		public static const REGION_CENTRAL:String = "central";
		public static const REGION_SOUTH:String = "central";
		
		private static var _list:Vector.<ThailandProvince>;
		private static var _provinceByRegion:Dictionary;
		public static function listByTHName ():Vector.<ThailandProvince> {
			var l:Vector.<ThailandProvince> = list;
			l.sort(sortTHProvince);
			return l;
		}
		public static function listByENName ():Vector.<ThailandProvince> {
			var l:Vector.<ThailandProvince> = list;
			l.sort(sortENProvince);
			return l;
		}
		public static function sortTHProvince (a:ThailandProvince,b:ThailandProvince):int {
			var ca:uint = a.thname.charCodeAt(0);
			var cb:uint = b.thname.charCodeAt(0);
			if(ca>cb) {
				return 1;
			} else if(ca<cb) {
				return -1;
			} else {
				return 0;
			}
		}
		
		public static function sortENProvince (a:ThailandProvince,b:ThailandProvince):int {
			var ca:uint = a.enname.charCodeAt(0);
			var cb:uint = b.enname.charCodeAt(0);
			if(ca>cb) {
				return 1;
			} else if(ca<cb) {
				return -1;
			} else {
				return 0;
			}
		}
		public static function get list ():Vector.<ThailandProvince> {
			if(!_list) createList();
			return _list;
		}
		public static function getListByRegion (region:String):Vector.<ThailandProvince> {
			if(!_list) createList();
			
			return _provinceByRegion[region] as Vector.<ThailandProvince>;
		}
		
		private static function createList ():void {
			_list = new Vector.<ThailandProvince>;
			_provinceByRegion = new Dictionary();
			//NORTH
			_list.push(new ThailandProvince("Chiang Mai", "เชียงใหม่", REGION_NORTH));
			_list.push(new ThailandProvince("Chiang Rai", "เชียงราย", REGION_NORTH));
			_list.push(new ThailandProvince("Nan", "น่าน", REGION_NORTH)); 
			_list.push(new ThailandProvince("Phayao", "พะเยา", REGION_NORTH));
			_list.push(new ThailandProvince("Mae Hong Son", "แม่ฮ่องสอน", REGION_NORTH));
			_list.push(new ThailandProvince("Lampang", "ลำปาง", REGION_NORTH));
			_list.push(new ThailandProvince("Phrae", "แพร่", REGION_NORTH));
			_list.push(new ThailandProvince("Lamphun", "ลำพูน", REGION_NORTH));
			_list.push(new ThailandProvince("Uttaradit", "อุตรดิตถ์", REGION_NORTH));
			
			//NORTHEAST
			_list.push(new ThailandProvince("Chaiyaphum", "ชัยภูมิ", REGION_NORTHEAST));
			_list.push(new ThailandProvince("Kalasin", "กาฬสินธุ์", REGION_NORTHEAST));
			_list.push(new ThailandProvince("Khon Kaen", "ขอนแก่น", REGION_NORTHEAST));
			_list.push(new ThailandProvince("Nakhon Phanom", "นครพนม", REGION_NORTHEAST));
			_list.push(new ThailandProvince("Nakhon Ratchasima", "นครราชสีมา", REGION_NORTHEAST));
			_list.push(new ThailandProvince("Buri Ram", "บุรีรัมย์", REGION_NORTHEAST));
			_list.push(new ThailandProvince("Maha Sarakham", "มหาสารคาม", REGION_NORTHEAST));
			_list.push(new ThailandProvince("Mukdahan", "มุกดาหาร", REGION_NORTHEAST));
			_list.push(new ThailandProvince("Yasothon", "ยโสธร", REGION_NORTHEAST));
			_list.push(new ThailandProvince("Roi Et", "ร้อยเอ็ด", REGION_NORTHEAST));
			_list.push(new ThailandProvince("Loei", "เลย", REGION_NORTHEAST));
			_list.push(new ThailandProvince("Si Sa Ket", "ศรีสะเกษ", REGION_NORTHEAST));
			_list.push(new ThailandProvince("Surin", "สุรินทร์", REGION_NORTHEAST));
			_list.push(new ThailandProvince("Sakon Nakhon", "สกลนคร", REGION_NORTHEAST));
			_list.push(new ThailandProvince("Amnat Charoen", "อำนาจเจริญ", REGION_NORTHEAST));
			_list.push(new ThailandProvince("Nong Bua Lam Phu", "หนองบัวลำภู", REGION_NORTHEAST));
			_list.push(new ThailandProvince("Nong Khai", "หนองคาย", REGION_NORTHEAST));
			_list.push(new ThailandProvince("Ubon Ratchathani", "อุบลราชธานี", REGION_NORTHEAST));
			_list.push(new ThailandProvince("Udon Thani", "อุดรธานี", REGION_NORTHEAST));
			
			//CENTRAL
			_list.push(new ThailandProvince("Bangkok", "กรุงเทพมหานคร", REGION_CENTRAL));
			_list.push(new ThailandProvince("Kamphaeng Phet", "กำแพงเพชร", REGION_CENTRAL));
			_list.push(new ThailandProvince("Chai Nat", "ชัยนาท", REGION_CENTRAL));
			_list.push(new ThailandProvince("Nakhon Sawan", "นครสวรรค์", REGION_CENTRAL));
			_list.push(new ThailandProvince("Nakhon Nayok", "นครนายก", REGION_CENTRAL));
			_list.push(new ThailandProvince("Nakhon Pathom", "นครปฐม", REGION_CENTRAL));
			_list.push(new ThailandProvince("Ayutthaya", "พระนครศรีอยุธยา", REGION_CENTRAL));
			_list.push(new ThailandProvince("Pathum Thani", "ปทุมธานี", REGION_CENTRAL));
			_list.push(new ThailandProvince("Nonthaburi", "นนทบุรี", REGION_CENTRAL));
			_list.push(new ThailandProvince("Phichit", "พิจิตร", REGION_CENTRAL));
			_list.push(new ThailandProvince("Phitsanulok", "พิษณุโลก", REGION_CENTRAL));
			_list.push(new ThailandProvince("Phetchabun", "เพชรบูรณ์", REGION_CENTRAL));
			_list.push(new ThailandProvince("Lop Buri", "ลพบุรี", REGION_CENTRAL));
			_list.push(new ThailandProvince("Samut Prakan", "สมุทรปราการ", REGION_CENTRAL));
			_list.push(new ThailandProvince("Samut Sakhon", "สมุทรสาคร", REGION_CENTRAL));
			_list.push(new ThailandProvince("Samut Songkram", "สมุทรสงคราม", REGION_CENTRAL));
			_list.push(new ThailandProvince("Saraburi", "สระบุรี", REGION_CENTRAL));
			_list.push(new ThailandProvince("Sing Buri", "สิงห์บุรี", REGION_CENTRAL));
			_list.push(new ThailandProvince("Sukhothai", "สุโขทัย", REGION_CENTRAL));
			_list.push(new ThailandProvince("Ang Thong", "อ่างทอง", REGION_CENTRAL));
			_list.push(new ThailandProvince("Suphan Buri", "สุพรรณบุรี", REGION_CENTRAL));
			_list.push(new ThailandProvince("Uthai Thani", "อุทัยธานี", REGION_CENTRAL));
			_list.push(new ThailandProvince("Tak", "ตาก", REGION_CENTRAL));
			_list.push(new ThailandProvince("Kanchanaburi", "กาญจนบุรี", REGION_CENTRAL));
			_list.push(new ThailandProvince("Phetchaburi", "เพชรบุรี", REGION_CENTRAL));
			_list.push(new ThailandProvince("Prachuap KhiriKhan", "ประจวบคีรีขันธ์", REGION_CENTRAL));
			_list.push(new ThailandProvince("Ratchaburi", "ราชบุรี", REGION_CENTRAL));
			
			//EAST
			_list.push(new ThailandProvince("Chanthaburi", "จันทบุรี", REGION_EAST));
			_list.push(new ThailandProvince("Chachoengsao", "ฉะเชิงเทรา", REGION_EAST));
			_list.push(new ThailandProvince("Chon Buri", "ชลบุรี", REGION_EAST));
			_list.push(new ThailandProvince("Trat", "ตราด", REGION_EAST));
			_list.push(new ThailandProvince("Rayong", "ระยอง", REGION_EAST));
			_list.push(new ThailandProvince("Sa Kaeo", "สระแก้ว", REGION_EAST));
			_list.push(new ThailandProvince("Prachin Buri", "ปราจีนบุรี", REGION_EAST));
			
			//SOUTH
			_list.push(new ThailandProvince("Chumphon", "ชุมพร", REGION_SOUTH));
			_list.push(new ThailandProvince("Krabi", "กระบี่", REGION_SOUTH));
			_list.push(new ThailandProvince("Nakhon Si Thammarat", "นครศรีธรรมราช", REGION_SOUTH));
			_list.push(new ThailandProvince("Trang", "ตรัง", REGION_SOUTH));
			_list.push(new ThailandProvince("Narathiwat", "นราธิวาส", REGION_SOUTH));
			_list.push(new ThailandProvince("Pattani", "ปัตตานี", REGION_SOUTH));
			_list.push(new ThailandProvince("Phatthalung", "พัทลุง", REGION_SOUTH));
			_list.push(new ThailandProvince("Phang Nga", "พังงา", REGION_SOUTH));
			_list.push(new ThailandProvince("Phuket", "ภูเก็ต", REGION_SOUTH));
			_list.push(new ThailandProvince("Ranong", "ระนอง", REGION_SOUTH));
			_list.push(new ThailandProvince("Yala", "ยะลา", REGION_SOUTH));
			_list.push(new ThailandProvince("Satun", "สตูล", REGION_SOUTH));
			_list.push(new ThailandProvince("Songkhla", "สงขลา", REGION_SOUTH));
			_list.push(new ThailandProvince("Surat Thani", "สุราษฎร์ธานี", REGION_SOUTH));
		}
		
		public var enname:String;
		public var thname:String;
		public var region:String;
		
		public function ThailandProvince($en:String, $th:String, region:String)
		{
			if(!_provinceByRegion[region]) _provinceByRegion[region] = new Vector.<ThailandProvince>;
			Vector.<ThailandProvince>(_provinceByRegion[region]).push(this);
			this.enname = $en;
			this.thname = $th;
			this.region = region.toLowerCase();
		}
	}
}