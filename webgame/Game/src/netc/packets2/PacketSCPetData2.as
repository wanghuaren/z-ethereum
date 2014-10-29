/**
 * 要加什么属性自已加，但是不可覆写父类的方法
 * 如 父类有个job整数属性，此类可加个job_ch字符串属性
 * 复杂类型用继承，并在类名后加2，比如StructPlayerInfo2，然后自已加需要的属性，传到上层逻辑，减少上层编码量 
 * 这些加的属性所需要的数据在该类的process中进行处理和赋值
 *  
 */ 
package netc.packets2
{
	import nets.packets.PacketSCPetData;

	/** 
	 *
	 */
	public class PacketSCPetData2  extends PacketSCPetData
	{
		public var head_icon:String="";
		public var head_iconX:String="";
		public var head_iconC:String="";
		public var metier:int;
		public var arrSkill:Array=new Array();
		public var isRequest:Boolean=false;
		public var maxLevel:int=0;
		
		/**
		 *	服务器skillstate是位1111，把位转换成数字完成几个 
		 */
		public function get skillNo():int{
			var ret:int=0;
			for(var i:int=0;i<4;i++){
				if(SkillState&Math.pow(2,i))ret++;
			}
			return ret;
		}
	}
}
