/**
 * 要加什么属性自已加，但是不可覆写父类的方法
 * 如 父类有个job整数属性，此类可加个job_ch字符串属性
 * 复杂类型用继承，并在类名后加2，比如StructPlayerInfo2，然后自已加需要的属性，传到上层逻辑，减少上层编码量
 * 这些加的属性所需要的数据在该类的process中进行处理和赋值
 *
 */
package netc.packets2
{
	import flash.utils.ByteArray;
	import engine.support.ISerializable;
	import engine.support.IPacket;
	import engine.net.packet.PacketFactory;
	import nets.packets.PacketSCFight;

	/**
	 *
	 */
	public class PacketSCFight2 extends PacketSCFight
	{
		private static var _instance:PacketSCFight2;

		public static function getInstance():PacketSCFight2
		{
			if (_instance == null)
			{
				_instance=new PacketSCFight2();
			}
			return _instance;
		}

		public function PacketSCFight2()
		{
		}
		public static var vectorPoolItems:Vector.<PacketSCFight2>=new Vector.<PacketSCFight2>();

		public function get getItem():PacketSCFight2
		{
			if (PacketSCFight2.vectorPoolItems.length <1)
			{
				for (var i:int=0; i < 200; i++)
				{
					PacketSCFight2.vectorPoolItems.push(new PacketSCFight2());
				}
			}
			return PacketSCFight2.vectorPoolItems.pop();
		}
	}
}
