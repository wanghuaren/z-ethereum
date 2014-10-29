package com.bellaxu.mgr
{
	import com.bellaxu.res.ResMc;
	
	import engine.load.GamelibS;
	
	import flash.display.MovieClip;
	
	import netc.Data;
	
	import scene.action.Action;
	import scene.king.IGameKing;

	/**
	 * 目标管理
	 * @author BellaXu
	 */
	public class TargetMgr
	{
		private static var sameCampMc:MovieClip;
		public static var otherCampMc:MovieClip;

		public static function init():void
		{
//			sameCampMc=ResTool.getMc(ResPathDef.GAME_CORE, "select_person") as MovieClip;
			sameCampMc=GamelibS.getswflink("game_utils", "person_xuan_ze") as MovieClip;
			sameCampMc.mouseEnabled=false;
			sameCampMc.mouseChildren=false;
			sameCampMc.gotoAndStop(1);

//			otherCampMc=ResTool.getMc(ResPathDef.GAME_CORE, "select_enemy") as MovieClip;
			otherCampMc=GamelibS.getswflink("game_utils", "enemy_xuan_ze") as MovieClip;
			otherCampMc.mouseEnabled=false;
			otherCampMc.mouseChildren=false;
			otherCampMc.gotoAndStop(1);
		}

		public static function hideOtherCampMc():void
		{
			hideMc(otherCampMc);
		}

		public static function hideSameCampMc():void
		{
			hideMc(sameCampMc);
		}

		public static function showCampMc(GameKing:IGameKing, updPos:Boolean=true):void
		{
			if (!GameKing)
				return;
			var tempMC:MovieClip=null;
			//怪物，且非本人公宠物
			var isSameCamp:Boolean=Action.instance.fight.chkSameCamp(Data.myKing.king, GameKing);
			if (isSameCamp)
			{
				hideSameCampMc();
				hideOtherCampMc();

				tempMC=sameCampMc;
				tempMC.name="TKingMC";
			}
			else
			{
				hideOtherCampMc();
				hideSameCampMc();

				tempMC=otherCampMc;
				tempMC.name="TEnemyMC";
			}
			if (!GameKing.selectable)
				return;

			tempMC.gotoAndStop("show");
			tempMC.visible=true;
			var m_movie:ResMc=GameKing.getSkin().getRole();
			if (m_movie && m_movie.act == "D7")
				return;
			tempMC.x=0;
			tempMC.y=0;

			GameKing.getSkin().foot.addChild(tempMC);

			if (updPos)
				GameKing.getSkin().UpdOtherPos();
		}

		private static function hideMc(mc:MovieClip):void
		{
			if (mc.parent)
				mc.parent.removeChild(mc);
			mc.visible=false;
			mc.stop();
		}
	}
}
