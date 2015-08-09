package netc.dataset
{
	import com.engine.utils.HashMap;
	
	import engine.event.DispatchEvent;
	import engine.net.dataset.VirtualSet;
	
	import netc.Data;
	import netc.packets2.PacketSCHorseList2;
	import netc.packets2.PacketSCHorseListUpdate2;
	import netc.packets2.StructHorseList2;

	/**
	 * 角色【炼骨，坐骑，丹药】
	 * 2011－01－30	 
	 */	
	public class JiaoSeSet extends VirtualSet
	{	
		
		/**
		 *	获得装备位置名字
		 */
		public static const EQUIPTYPE_WEAPON:int		=1;		//武器
		public static const EQUIPTYPE_HEAD:int				=2;		//头盔
		public static const EQUIPTYPE_CUIRASS:int			=3;		//护镜
		public static const EQUIPTYPE_CLOTHES:int			=4;		//衣服
		public static const EQUIPTYPE_SHOULDER:int			=5;		//披风  战袍
		public static const EQUIPTYPE_BELT:int			    =6;		//腰带
		public static const EQUIPTYPE_BOOT:int				=7;		//鞋子
		public static const EQUIPTYPE_NECK:int		        =8;		//项链
		public static const EQUIPTYPE_SECRETWEAPON:int		=9;		//暗器
		public static const EQUIPTYPE_TRINKET:int			=10;    //玉佩    官印  
		public static const EQUIPTYPE_GOLDSTAMP:int			=11;	//金印
		public static const EQUIPTYPE_BRACELET:int	      =12;    //手镯
		public static const EQUIPTYPE_DUMMY_1:int			=13;	//占位用(不表示任何类型)
		public static const EQUIPTYPE_RING:int	          =14;    //戒指
		public static const EQUIPTYPE_DUMMY_2:int			=15;	//占位用(不表示任何类型)
		
		
		public var horseList:PacketSCHorseList2;
		public static const BONE_NPC_ID:int=30100084;
		//事件
		public static const HORSE_UPDATE:String="HORSE_UPDATE";
		public function JiaoSeSet(pz:HashMap)
		{
			refPackZone(pz);
		}
		
		/**
		 * 检查职业是否和自己相同
		 * 2013-12-23 andy
		 */
		public function checkMetier(toolMetier:int,playerMetier:int=0):Boolean{
			if(playerMetier==0)playerMetier=Data.myKing.metier;
			if(toolMetier==0||toolMetier==playerMetier)
				return true;
			else 
				return false;
		}
		/**************坐骑***************/
		public function setHorseList(v:PacketSCHorseList2):void{
			horseList=v;
		}

		
		/**
		 *	角色坐骑数据有变化 
		 */
		public function setHorseUpdate(v:PacketSCHorseListUpdate2):void{		
			if(horseList==null){
				horseList=new PacketSCHorseList2();
			}	
			horseList.arrItemhorselist=v.arrItemhorselist;
			this.dispatchEvent(new DispatchEvent(HORSE_UPDATE,v));
		}
		/**
		 *	获得某个栏位的坐骑【为了扩展，程序提供栏位，策划暂时没有使用栏位】
		 *  @param pos 坐骑栏位位置 
		 */
		public function getHorseByPos(pos:int):StructHorseList2{
			if(horseList==null)return null;
			var ret:StructHorseList2=null;
			for each(var item:StructHorseList2 in horseList.arrItemhorselist){
				if(item.pos==pos){ret=item;break;}
			}
			return ret;
		}

	}
}