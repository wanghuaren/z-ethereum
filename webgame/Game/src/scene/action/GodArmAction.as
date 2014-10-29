package scene.action
{
	import common.utils.bit.BitUtil;
	
	import flash.display.DisplayObject;
	
	import scene.king.IGameKing;
	import scene.manager.SceneManager;
	import scene.skill2.SkillEffect12;
	import scene.skill2.SkillEffectManager;

	/**
	 * 神器效果
	 *
	 * 不从buff走，方向与Sword相反，以免叠到一起
	 */
	public class GodArmAction
	{
		public function GodArmAction()
		{

		}

		public function DetailUpdate(objid:uint, godArmPrimetive:int, k:IGameKing):void
		{


			if (null == k)
			{
				k=SceneManager.instance.GetKing_Core(objid);
			}

			//
			if (null == k)
			{
				return;
			}


			//godArmPrimetive原始数据，来自r1，低16位	
//			var dataList:Array = BitUtil.convertToBinaryArr(godArmPrimetive);
//						
//			var hasGodArm:Boolean = 1 == dataList[0]?true:false;
			var hasGodArm:Boolean=1 == BitUtil.getBitByPos(godArmPrimetive, 0) ? true : false;
			var se_godArm:SkillEffect12;
			var i:int;
			var d:DisplayObject;

			//神器特效
			var hasEffect:Boolean=false;

			for (i=0; i < k.getSkin().effectUp.numChildren; i++)
			{
				d=k.getSkin().effectUp.getChildAt(i);

				if (d as SkillEffect12)
				{
					if ("godArm" == (d as SkillEffect12).path)
					{
						hasEffect=true;
						break;
					}
				}
			}

			for (i=0; i < k.getSkin().effectDown.numChildren; i++)
			{
				d=k.getSkin().effectDown.getChildAt(i);

				if (d as SkillEffect12)
				{
					if ("godArm" == (d as SkillEffect12).path)
					{
						hasEffect=true;
						break;
					}
				}
			}

			//
			if (hasGodArm)
			{
				if (!hasEffect)
				{
					se_godArm=new SkillEffect12();
					se_godArm.setData(k.objid, "godArm");
					SkillEffectManager.instance.send(se_godArm);
				}

					//
					//GameMusic.playWave(WaveURL.ui_hun_release);

			}


			if (!hasGodArm)
			{
				if (hasEffect)
				{
					//-------------------------------------------------------------------
					for (i=0; i < k.getSkin().effectUp.numChildren; i++)
					{
						d=k.getSkin().effectUp.getChildAt(i);

						if (d as SkillEffect12)
						{
							if ("godArm" == (d as SkillEffect12).path)
							{
								(d as SkillEffect12).Four_MoveComplete();
									//break;
							}
						}
					}

					for (i=0; i < k.getSkin().effectDown.numChildren; i++)
					{
						d=k.getSkin().effectDown.getChildAt(i);

						if (d as SkillEffect12)
						{
							if ("godArm" == (d as SkillEffect12).path)
							{
								(d as SkillEffect12).Four_MoveComplete();
									//break;
							}
						}
					}


						//---------------------------------------------------------------------

				}

			}










		}


	}
}
