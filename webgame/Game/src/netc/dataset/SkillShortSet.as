package netc.dataset
{
	import com.engine.utils.HashMap;
	
	import engine.event.DispatchEvent;
	import engine.net.dataset.VirtualSet;
	
	import netc.packets2.PacketSCShortKeyItem2;
	import netc.packets2.PacketSCShortKeyList2;
	import netc.packets2.StructShortKey2;
	
	import nets.packets.PacketSCShortKeyList;

	public class SkillShortSet extends VirtualSet
	{
		public static const SKILLSHORTCHANGE:String="SKILLSHORTCHANGE";
		
		public function SkillShortSet(pz:HashMap)
		{
			refPackZone(pz);
		}
		

		/**
		 * 初始化任务状态完成
		 * 服务器将把所有任务状态一次发过来
		 */ 
		public function contentListInitComplete():void
		{
			dispatchEvent(new DispatchEvent(SKILLSHORTCHANGE,contentList));
		}
		
		public function syncByOne(p:PacketSCShortKeyItem2):void
		{
			var vec:Vector.<StructShortKey2> = contentList;
			var i:int=0;
			var j:int=0;
			var hasValue:Boolean = false;
			var del:StructShortKey2=null;
			for(i=vec.length-1;i>=0;i--){
				if(vec[i].pos==p.pos){
					vec[i].id = p.objid;
					vec[i].type = p.objtype;
					vec[i].isNew=false;
					hasValue = true;
					j = i;
					continue;
				}
//				if (p.pos<SkillShort.LIMIT){
//					if(vec[i].id==p.objid){
//						del = vec[i];
//						del.del = true;
//						vec.splice(i,1);
//						j--;
//					}
//				}
			}
			if(!hasValue){
				var ssk:StructShortKey2 = new StructShortKey2();
				ssk.pos = p.pos;
				ssk.id = p.objid;
				ssk.type = p.objtype;
				ssk.isNew=true;
				vec.push(ssk);
				j = vec.length-1;
			}
			var result:Vector.<StructShortKey2> = new Vector.<StructShortKey2>;
			result.push(vec[j]);
			contentList[vec[j].pos-1]=vec[j];
			if(del)result.push(del);
			dispatchEvent(new DispatchEvent(SKILLSHORTCHANGE, result));
		}
		
		public function get contentList():Vector.<StructShortKey2>
		{
			if(packZone.get(PacketSCShortKeyList.id)!=null){
				return (packZone.get(PacketSCShortKeyList.id) as  PacketSCShortKeyList2).items.arrItemitem;	
			}else{
				return new Vector.<StructShortKey2>;
			}
//			return new Vector.<StructShortKey2>;
		}

	}
}