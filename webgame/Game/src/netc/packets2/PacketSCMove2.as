/**
 * 要加什么属性自已加，但是不可覆写父类的方法
 * 如 父类有个job整数属性，此类可加个job_ch字符串属性
 * 复杂类型用继承，并在类名后加2，比如StructPlayerInfo2，然后自已加需要的属性，传到上层逻辑，减少上层编码量
 * 这些加的属性所需要的数据在该类的process中进行处理和赋值
 *
 */
package netc.packets2
{
	import engine.net.packet.PacketFactory;
	import engine.support.IPacket;
	import engine.support.ISerializable;

	import flash.utils.ByteArray;

	import nets.packets.PacketSCMove;

	/**
	 * 行走，由服务器通知
	 */
	public class PacketSCMove2 extends PacketSCMove
	{
		public var virtual:Boolean=false;
		private static var _instance:PacketSCMove2;

		public static function getInstance():PacketSCMove2
		{
			if (_instance == null)
			{
				_instance=new PacketSCMove2();
			}
			return _instance;
		}
		public static var vectorPoolItems:Vector.<PacketSCMove2>=new Vector.<PacketSCMove2>();

		public function get getItem():PacketSCMove2
		{
			if (PacketSCMove2.vectorPoolItems.length < 1)
			{
				for (var i:int=0; i < 200; i++)
				{
					PacketSCMove2.vectorPoolItems.push(new PacketSCMove2());
				}
			}
			return PacketSCMove2.vectorPoolItems.pop();
		}
	}
}
