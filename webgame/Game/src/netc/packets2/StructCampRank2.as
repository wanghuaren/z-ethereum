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
	import engine.net.packet.PacketFactory;
	import nets.packets.StructCampRank;
	
	public class StructCampRank2 extends StructCampRank
	{
		
		public function get arrItemactsFull():Vector.<StructActCampPoint2>
		{
			
			var fullList:Vector.<StructActCampPoint2> = new Vector.<StructActCampPoint2>();
			
			var hasAct1:Boolean = false;
			var hasAct2:Boolean = false;
			var hasAct3:Boolean = false;
			var hasAct4:Boolean = false;
			
			for(var i:int=0;i<this.arrItemacts.length;i++)
			{
					if(1 == this.arrItemacts[i].actid){hasAct1 = true;fullList.push(this.arrItemacts[i]);}	
					if(2 == this.arrItemacts[i].actid){hasAct2 = true;fullList.push(this.arrItemacts[i]);}						
					if(3 == this.arrItemacts[i].actid){hasAct3 = true;fullList.push(this.arrItemacts[i]);}	
					if(4 == this.arrItemacts[i].actid){hasAct4 = true;fullList.push(this.arrItemacts[i]);}			
			}
			
			if(!hasAct1)
			{
				var act1:StructActCampPoint2 = new StructActCampPoint2()
				act1.actid = 1;
				fullList.push(act1);
			}
			
			if(!hasAct2)
			{
				var act2:StructActCampPoint2 = new StructActCampPoint2()
				act2.actid = 2;
				fullList.push(act2);
			}
			
			if(!hasAct3)
			{
				var act3:StructActCampPoint2 = new StructActCampPoint2()
				act3.actid = 3;
				fullList.push(act3);
			}
			
			if(!hasAct4)
			{
				var act4:StructActCampPoint2 = new StructActCampPoint2()
				act4.actid = 4;
				fullList.push(act4);
			}
			
			
			return fullList;
		
		}
		
	}
}
