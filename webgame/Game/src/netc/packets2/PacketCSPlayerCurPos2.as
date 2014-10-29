package netc.packets2
{
	import nets.packets.PacketCSPlayerCurPos;

	public class PacketCSPlayerCurPos2 extends PacketCSPlayerCurPos
	{
		private static var _instance:PacketCSPlayerCurPos2;

		public static function getInstance():PacketCSPlayerCurPos2
		{
			if (_instance == null)
			{
				_instance=new PacketCSPlayerCurPos2();
			}
			return _instance;
		}
		public static var vectorPoolItems:Vector.<PacketCSPlayerCurPos2>=new Vector.<PacketCSPlayerCurPos2>();

		public function get getItem():PacketCSPlayerCurPos2
		{
			if (PacketCSPlayerCurPos2.vectorPoolItems.length < 1)
			{
				for (var i:int=0; i < 200; i++)
				{
					PacketCSPlayerCurPos2.vectorPoolItems.push(new PacketCSPlayerCurPos2);		
				}
			}
			return PacketCSPlayerCurPos2.vectorPoolItems.pop();
		}
	}
}
