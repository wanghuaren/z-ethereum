package scene.body
{
	import engine.event.DispatchEvent;
	
	import flash.events.EventDispatcher;
	
	import netc.DataKey;
	
	import nets.packets.PacketCSTeamInvit;
	
	import scene.event.HumanEvent;
	import scene.king.IGameKing;
	import scene.manager.SceneManager;
	import com.bellaxu.def.MusicDef;
	import scene.skill2.SkillEffect12;
	import scene.skill2.SkillEffectManager;
	import scene.utils.MapData;
	
	import ui.frame.UIActMap;
	import ui.base.jiaose.JiaoSeLook;
	import ui.base.shejiao.haoyou.ChatWarningControl;
	import ui.base.shejiao.haoyou.GameFindFriend;
	
	import world.WorldEvent;

	public class EventBody extends EventDispatcher
	{		
		//查看  组队  结交  聊天
//		public static var CHAKAN_EVENT:String = "CHAKAN_EVENT"; 
//		public static var ZUDUI_EVENT:String = "ZUDUI_EVENT";
//		public static var HAOYOU_EVENT:String = "HAOYOU_EVENT";
//		public static var LIAOTIAN_EVENT:String = "LIAOTIAN_EVENT";
		
		public function EventBody()
		{
			this.addEventListener(HumanEvent.OnStop, meOnStop);
//			this.addEventListener(EventBody.CHAKAN_EVENT, CHAKAN_EVENT);
//			this.addEventListener(EventBody.ZUDUI_EVENT, ZUDUI_EVENT);
//			this.addEventListener(EventBody.HAOYOU_EVENT, HAOYOU_EVENT);
//			this.addEventListener(EventBody.LIAOTIAN_EVENT, LIAOTIAN_EVENT);
			
			this.addEventListener(HumanEvent.LEVEL_UPDATE, human_lvl_up);
		}
		
		private function human_lvl_up(e:DispatchEvent):void
		{
			if (-1 == e.getInfo){
				return;
			}
			
			var value:int=e.getInfo;
			
			var k:IGameKing = SceneManager.instance.GetKing_Core(value);
			
			if (null == k)
			{
				return;
			}			
			
			//			var lvlOld:int=Data.myKing.level - value;
			//		
			//			var propertyOld:Pub_Role_PropertyResModel=XmlManager.localres.RolePropertyXml.getM(lvlOld,Data.myKing.metier);
			//			
			//			var lvlNow:int=Data.myKing.level;
			//			var propertyNow:Pub_Role_PropertyResModel=XmlManager.localres.RolePropertyXml.getM(lvlNow,Data.myKing.metier);
			//			
			//			
			//			var lifeAdd:int=0; //propertyNow.hp - propertyOld.hp;
			//			var ackAdd:int=0; //propertyNow.atk - propertyOld.atk;
			//			var defendAdd:int=0; //propertyNow.def - propertyOld.def;
			//			var defend2Add:int =0;
			//			var baojiAdd:int=0; //propertyNow.cri - propertyOld.cri;
			//			var ackMissAdd:int=0; //propertyNow.miss - propertyOld.miss;
			//			var lingliAdd:int =0;
			//			
			//			if(null != propertyOld && 
			//				null != propertyNow)
			//			{
			//				//				生命 attr_1 基础最大生命
			//				//				灵力 attr_2 基础最大魔法
			//				//				外攻 attr_3 基础物攻
			//				//				内攻 attr_5 基础魔法攻击
			//				//				外防 attr_4 基础物理防御
			//				//				内防 attr_6 基础魔法防御 
			//				lifeAdd =propertyNow.attr_1 - propertyOld.attr_1;
			//				ackAdd = propertyNow.attr_3 - propertyOld.attr_3;
			//				defendAdd = propertyNow.attr_6 - propertyOld.attr_6;
			//				defend2Add = propertyNow.attr_4 - propertyOld.attr_4;
			//				baojiAdd = propertyNow.attr_5 - propertyOld.attr_5;
			//				//ackMissAdd =0; //propertyNow.miss - propertyOld.miss;
			//				lingliAdd =propertyNow.attr_2 - propertyOld.attr_2;
			//				
			//			}
			//			
			//			//
			//			Action.instance.fight.ShowWaftNumber(k, lifeAdd, k.hp, WaftNumType.LVLUP_LIFE_ADD);
			//			Action.instance.fight.ShowWaftNumber(k, lingliAdd, k.hp, WaftNumType.LVLUP_LING_LI_ADD);
			//			Action.instance.fight.ShowWaftNumber(k, baojiAdd, k.hp, WaftNumType.LVLUP_BAOJI_ADD);
			//			Action.instance.fight.ShowWaftNumber(k, ackAdd, k.hp, WaftNumType.LVLUP_ATTACK_ADD);
			//			Action.instance.fight.ShowWaftNumber(k, defendAdd, k.hp, WaftNumType.LVLUP_DEFEND_ADD);
			//			Action.instance.fight.ShowWaftNumber(k, defend2Add, k.hp, WaftNumType.LVLUP_DEFEND2_ADD);
			//			
			
			var se_lvlUp:SkillEffect12=new SkillEffect12();
			se_lvlUp.setData(k.objid, "lvlUp");
			SkillEffectManager.instance.send(se_lvlUp);
		}
//		点地效果以前是一直在播放，直至角色走到点击位置后消失
//		现在改为：
//		点地效果只播放一次，即消失
		public function meOnStop(e:DispatchEvent):void
		{
			//MouseTarget.HideLuoDian();
		}
		
//		private function CHAKAN_EVENT(e:DispatchEvent):void
//		{
//			JiaoSeLook.instance().setRoleId(UIActMap.playerID);
//		}
//		
//		private function ZUDUI_EVENT(e:DispatchEvent):void
//		{
//			var vo:PacketCSTeamInvit=new PacketCSTeamInvit();
//			vo.roleid=UIActMap.playerID;
//			DataKey.instance.send(vo);
//		}
//		
//		private function HAOYOU_EVENT(e:DispatchEvent):void
//		{
//			GameFindFriend.addFriend(UIActMap.playerName,1);
//		}
//		
//		private function LIAOTIAN_EVENT(e:DispatchEvent):void
//		{
//			ChatWarningControl.getInstance().getChatPlayerInfo(UIActMap.playerID);
//		}
//		
		
		
		
		
		
	}
}