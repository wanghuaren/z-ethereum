package scene.action{
	import com.bellaxu.def.CursorDef;
	import com.bellaxu.def.FilterDef;
	import com.bellaxu.mgr.CursorMgr;
	import com.bellaxu.mgr.TargetMgr;
	import com.bellaxu.util.TextUtil;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import netc.Data;
	
	import scene.king.ActionDefine;
	import scene.king.IGameKing;
	import scene.king.King;
	import scene.manager.MouseManager;
	import scene.mouse.MouseSkinType;
	
	import world.FileManager;
	import world.type.BeingType;
	import world.type.ItemType;
	import world.type.WorldType;

	public class ColorAction
	{
		private static var MouseType:int=0;
		public static function ResetMouseByBangPai():void
		{
			if(CursorMgr.currentCursor == CursorDef.DESTROY || CursorMgr.currentCursor == CursorDef.DONATE)
				CursorMgr.currentCursor = CursorDef.DEFAULT;
		}

		public static function XiaoMouse():void
		{
			MouseType=MouseSkinType.MouseBangPaiDestory;
			MouseManager.instance.show(MouseType);
		
		}
		public static function JuanMouse():void
		{
			MouseType=MouseSkinType.MouseBangPaiJuan;
			MouseManager.instance.show(MouseType);
		
		}
		/**
		 *  怪物 鼠标移上去有光没圈
		 *            点有光有圈
		 *            离无光有圈
		 * 
		 */ 
		public static function KingMouseOver(e:MouseEvent):void
		{
			var isSetColor:Boolean =false;
			var isQuan:Boolean = false;
			var isShowBloodBar:Boolean = false;
			
			if(e.target is IGameKing)
				KingMouseOverByKing(e.target as IGameKing);				
		}

		public static function KingMouseOut(e:MouseEvent):void
		{
			if(e.target.name.indexOf(WorldType.WORLD) >= 0)
			{
				if(e.target is IGameKing)
					KingMouseOutByKing(e.target as IGameKing);		
			}			
		}
		
		/**
		 * OverByKing
		 */ 
		private static function KingMouseOverByKing(GameKing:IGameKing):void
		{
			if(null == GameKing)
				return;
			//锁定目标
			FightAction.lockTarget(GameKing);
			
			if(!GameKing.selectable)
				return;
			var action:int = (Data.myKing.king as King).nAction;
			
			var isSetColor:Boolean =false;
			var isQuan:Boolean = false;
			var isShowNameAndBloodBar:Boolean = false;
			
			if(!Action.instance.fight)
				return;
						
			var isSameCamp:Boolean = Action.instance.fight.chkSameCamp(Data.myKing.king,GameKing);
			
			if(isSameCamp)
			{
				//相同阵营------------------------------------------------------------------------
				if(GameKing.name2.indexOf(BeingType.HUMAN) >= 0 )
				{
					isSetColor = true;
					isShowNameAndBloodBar = true;
					if(GameKing.isBooth)
						CursorMgr.currentCursor = CursorDef.BUY;
				}
				
				if(GameKing.name2.indexOf(BeingType.MONSTER) >= 0 )
				{
					
					if(GameKing.name2.indexOf(BeingType.MON) >= 0 )
					{
						isSetColor = true;
						isShowNameAndBloodBar = true;
					}
					else if(GameKing.name2.indexOf(BeingType.PET) >= 0 )
					{
						isSetColor = true;
						isShowNameAndBloodBar = true;
					}
					else if(GameKing.name2.indexOf(BeingType.NPC) >= 0 )
					{
						isSetColor = true;
						
						if(GameKing.getKingType!=4)
							CursorMgr.currentCursor = CursorDef.CHAT;
						isShowNameAndBloodBar = true;
					}
					else if(GameKing.name2.indexOf(BeingType.RES) >= 0)
					{
					}
					else if(GameKing.name2.indexOf(BeingType.TRANS) >= 0)
					{
						isShowNameAndBloodBar = true;
					}
					else
					{
						isSetColor = true;
					}
				}
			}
			else
			{
				//非相同阵营------------------------------------------------------------------------
				//潜行
				if(GameKing.isQianXing)
				{
					isSetColor = false;		
					isShowNameAndBloodBar = true;	
				}
				else
				{
					isSetColor = true;		
					isShowNameAndBloodBar = true;	
					CursorMgr.currentCursor = CursorDef.ATTACK;
				}
			}
			if(GameKing.name2.indexOf(ItemType.PICK) >= 0 )
			{
				isSetColor = true;
				isShowNameAndBloodBar = true;
				CursorMgr.currentCursor = CursorDef.PICKUP;
			}
			
			//如果当前有buff效果，则不处理滤镜效果【29-施毒术】
			if (GameKing.getSkin().getHeadName().hasBuff(29))
			{
				isSetColor = false;
			}
			
			if(isSetColor)
			{
				//移动中不设置目标滤镜
				if (action == ActionDefine.MOVE || action == ActionDefine.RUN)
				{
					return;
				}
				if(isSameCamp)
				{
					
					if(GameKing.name2.indexOf(BeingType.NPC) >= 0)
					{
//						if (GameKing.getSkin().filePath.s2 != 30120042)//皇城霸主不显示滤镜
//						{
//							GameKing.getSkin().rect.filters = [FilterDef.GLOW_NPC];
//						}
					}
					else if(GameKing.name2.indexOf(ItemType.PICK) >= 0)
						GameKing.getSkin().rect.filters = [FilterDef.GLOW_NPC];
					else
						GameKing.getSkin().rect.filters = [FilterDef.GLOW_PLAYER];
				}
				else
				{
					GameKing.getSkin().rect.filters = [FilterDef.GLOW_MONSTER];
				}				
			}
			if(isShowNameAndBloodBar)
				GameKing.getSkin().getHeadName().showTxtNameAndBloodBar(true);
			if(isQuan)
				TargetMgr.showCampMc(GameKing);
			GameKing.getSkin().ChkOther();
		}

		/**
		 * OutByKing
		 */ 
		private static function KingMouseOutByKing(GameKing:IGameKing):void
		{
			if(null == GameKing)
				return;
			//清除锁定目标
			FightAction.unlockTarget(GameKing);
			//如果当前有buff效果，则不处理滤镜效果
			//如果当前有buff效果，则不处理滤镜效果【29-施毒术】
			if (GameKing.getSkin().getHeadName().hasBuff(29)==false)
			{
				GameKing.getSkin().rect.filters = null;
			}
			GameKing.getSkin().getHeadName().hideTxtNameAndBloodBar(true);
			CursorMgr.currentCursor = CursorDef.DEFAULT;
		}
	}
}
