/**
 * 要加什么属性自已加，但是不可覆写父类的方法
 * 如 父类有个job整数属性，此类可加个job_ch字符串属性
 * 复杂类型用继承，并在类名后加2，比如StructPlayerInfo2，然后自已加需要的属性，传到上层逻辑，减少上层编码量
 * 这些加的属性所需要的数据在该类的process中进行处理和赋值
 *
 */
package netc.packets2
{
	import com.bellaxu.res.ResMc;

	import common.config.xmlres.server.Pub_SkillResModel;

	import engine.net.packet.PacketFactory;
	import engine.support.IPacket;
	import engine.support.ISerializable;

	import flash.utils.ByteArray;

	import nets.packets.PacketSCFightInstant;

	/**
	 *
	 */

	public class PacketSCFightInstant2 extends PacketSCFightInstant
	{
		public var skillInfo:Pub_SkillResModel;
		public var damage:int=0;
		private static var _instance:PacketSCFightInstant2;

		public static function getInstance():PacketSCFightInstant2
		{
			if (_instance == null)
			{
				_instance=new PacketSCFightInstant2();
			}
			return _instance;
		}

		public function PacketSCFightInstant2()
		{
		}
		public static var vectorPoolItems:Vector.<PacketSCFightInstant2>=new Vector.<PacketSCFightInstant2>();

		public function get getItem():PacketSCFightInstant2
		{
			if (PacketSCFightInstant2.vectorPoolItems.length < 1)
			{
				for (var i:int=0; i < 200; i++)
				{
					PacketSCFightInstant2.vectorPoolItems.push(new PacketSCFightInstant2());
				}
			}
			return PacketSCFightInstant2.vectorPoolItems.pop();
		}
	}
}
