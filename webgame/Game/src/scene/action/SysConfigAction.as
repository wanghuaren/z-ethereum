package scene.action
{
	import common.managers.Lang;
	
	import netc.DataKey;
	import netc.dataset.MyCharacterSet;
	
	import nets.packets.PacketCSHidePlayer;
	
	import scene.body.Body;
	import scene.king.IGameKing;
	import scene.manager.SceneManager;
	import scene.skill2.ISkillEffect;

	/**
	 * 0 始终显示玩家信息   1始终显示怪物信息   2隐藏其他玩家及伙伴
	 *
	 */
	public class SysConfigAction
	{
		/**
		 * 模式1 客户端隐藏
		 */
		public const MODE:int=1;

		public var alwaysShowHumanAndPetName:Boolean;
		public var alwaysShowMonName:Boolean;
		public var alwaysHideHumanAndPet:Boolean;

		//
		public var alwaysHidePlayer:Boolean;
		public var alwaysHideChengHao:Boolean;
		public var alwaysHideMonster:Boolean;
		
		public function SysConfigAction()
		{
			if (1 == MODE)
			{
				alwaysShowHumanAndPetName=false;
				alwaysShowMonName=false;
				alwaysHideHumanAndPet=false;
				
				//
				alwaysHidePlayer = false;
				alwaysHideChengHao = false;
				alwaysHideMonster = false;
			}

		}

		/**
		 * 始终显示玩家和伙伴信息
		 *
		 * 勾选后将始终显示所有玩家信息包括：名称、称号、标识等信息，包括自已
		 */
		public function alwaysShowPlayerName(open:Boolean=true):void
		{
			alwaysShowHumanAndPetName=open;

			//
			var list:Vector.<IGameKing>=Body.instance.sceneKing.GetAllHumanAndPet();

			var len:int=list.length;

			for (var i:int=0; i < len; i++)
			{
				if(list[i].getSkin())
				{
				//清除mouse信息
				list[i].mouseClicked=false;

				//
				list[i].getSkin().getHeadName().hideTxtNameAndBloodBar();
				list[i].getSkin().getHeadName().showTxtNameAndBloodBar();
				}
			}

		}

		/**
		 * 始终显示纯怪物信息
		 *
		 * 勾选后将始终显示所有怪物信息包括：名称、等级等信息
		 */
		public function alwaysShowMonsterName(open:Boolean=true):void
		{
			alwaysShowMonName=open;

			//
			var list:Vector.<IGameKing>=Body.instance.sceneKing.GetAllMon();

			var len:int=list.length;

			for (var i:int=0; i < len; i++)
			{
				if(list[i].getSkin())
				{
				//清除mouse信息
				list[i].mouseClicked=false;
				list[i].hasBeAttacked=false;
				//
				list[i].getSkin().getHeadName().hideTxtNameAndBloodBar();
				list[i].getSkin().getHeadName().showTxtNameAndBloodBar();
				}
			}
		}
		
		public function alwaysHideChengHaoAnd():void
		{
			var list:Vector.<IGameKing>=Body.instance.sceneKing.GetAllHumanAndPet(true, true, true);
			
			var len:int=list.length;
			
			var i:int;
			
			for (i=0; i < len; i++)
			{
				//清除mouse信息
				//list[i].mouseClicked=false;
				
				//
				if(list[i].getSkin())
				{
				list[i].getSkin().getHeadName().ChengHao.visible = !alwaysHideChengHao;
				}
				
			}
		}
		
		public function alwaysHideMonsterAnd():void
		{
			
			var list:Vector.<IGameKing>=Body.instance.sceneKing.GetAllMon();
			
			var len:int=list.length;
			
			var i:int;
			
			for (i=0; i < len; i++)
			{
				//清除mouse信息
				list[i].mouseClicked=false;
				if(list[i].getSkin())
				{
				//
					list[i].getSkin().visibleAll(alwaysHideMonster);
				}
				
			}
			
		}
		
		public function alwaysHidePlayerAndPet():void
		{
			
			var list:Vector.<IGameKing>=Body.instance.sceneKing.GetAllHumanAndPet(true, true, true);
	
			var len:int=list.length;
	
			var i:int;
	
			for (i=0; i < len; i++)
			{
				//清除mouse信息
				list[i].mouseClicked=false;
	
				//
				list[i].getSkin().visibleAll(alwaysHidePlayer);
	
			}

			//
//			var listBySkill:Vector.<ISkillEffect>=Body.instance.sceneKing.GetAllSkill(true, true, true);
//	
//			len=listBySkill.length;
//	
//			for (i=0; i < len; i++)
//			{
//				//
//				listBySkill[i].visible=!alwaysHideHumanAndPet;
//					
//			}
		}
		
		/**
		 * 优化方法用于EnterGrid
		 */
		public function setAlwaysHideMonsterBySingle(objid_:uint):void
		{
			
			var k:IGameKing = SceneManager.instance.GetKing_Core(objid_);
			
			if(null == k)
			{
				return;
			}
			if(!k.getSkin())return;
			k.getSkin().visibleAll(alwaysHideMonster);
		
			//额外的功能
			k.getSkin().getHeadName().hideTxtNameAndBloodBar();
			k.getSkin().getHeadName().showTxtNameAndBloodBar();
			
		}

		/**
		 * 优化方法用于EnterGrid
		 */
		public function setAlwaysHidePlayerAndPetBySingle(k:IGameKing):void
		{
			
			if(null == k)
			{
				return;
			}
			if(!k.getSkin())return
			if(k.getSkin())k.getSkin().visibleAll(alwaysHidePlayer);
			
//			var list:Vector.<IGameKing>=Body.instance.sceneKing.GetAllHumanAndPetBySingle(king, true, true);
//	
//			var len:int=list.length;
//	
//			for (var i:int=0; i < len; i++)
//			{
//				
//				list[i].getSkin().visibleAll(alwaysHidePlayer);
//	
//			}
			
			alwaysHideChengHaoAndBySingle(k);

		}

		
		public function alwaysHideChengHaoAndBySingle(k:IGameKing):void
		{
			if(!k&&!k.getSkin())return;
			if(k.getSkin())k.getSkin().getHeadName().ChengHao.visible = !alwaysHideChengHao;
			
		}
		


	}
}
