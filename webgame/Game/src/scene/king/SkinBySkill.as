package scene.king
{
	import com.xh.display.XHLoadIcon;
	
	import com.bellaxu.res.ResMc;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import scene.event.KingActionEnum;
	import scene.utils.MapCl;
	
	import world.WorldEvent;
	import world.model.file.SkillFilePath;
	import world.type.BeingType;

	public class SkinBySkill extends Sprite
	{
		public static const SKIN_NUM:int=1;

		/**
		 * 主显示
		 */
		public static const MAIN_DISPLAY_LAYER:int=0;

		
		//skin
		public var skinLoaderList:Array;

		public var filePath:SkillFilePath;

		private var _roleList:Array;

		private var _roleZT:String;
		private var _roleFX:String;
		private var _playCount:int;
		private var _playOverAct:Function;

		public function SkinBySkill()
		{
		}

		public function init():void
		{
			removeAll();

			_roleZT=KingActionEnum.DJ;
			_roleFX="F1";

			//
			skinLoaderList=new Array();

			//
			var skLoader:SkinLoader;

			for (var i:int=0; i < SKIN_NUM; i++)
			{
				skLoader=new SkinLoader(i);
				skinLoaderList.push(skLoader);
			}

			//
			_roleList=new Array();
			for (i=0; i < SKIN_NUM; i++)
			{
				_roleList[i]=null;
			}



		}
		/**
		 * 技能需要旋转的角度
		 * */
		private var _angle:int=0;
		
		/**
		 * 技能施法方向
		 */
		private var _skillFX:String = null;

		public function setSkin(bfp:SkillFilePath, ag:int=0, skillFX:String=null):void
		{
			_angle=ag;
			_skillFX = skillFX;
//			_roleFX = "F"+bfp.direction;
			//
			if (null == this.getRole())
			{
				//this.addChild(this.loading);
				//this.loading.Show();
			}

			//
			var changedList:Array=new Array();

			if (null == this.filePath)
			{
				this.filePath=bfp;

				//
				for (var i:int=0; i < SKIN_NUM; i++)
				{
					changedList.push(true);
				}



			}
			else
			{
				//compare
				changedList=this.filePath.compare(bfp);

			}

			//
			this.UpdateAndLoadSkin(changedList)
		}

		private function UpdateAndLoadSkin(changedList:Array):void
		{
			var isHuman:Boolean;

			isHuman=false;

			//
			var i:int;
			var len:int=changedList.length;

			for (i=0; i < len; i++)
			{
				if (changedList[i])
				{
					this.removeSkin(i);

					this.skinLoaderList[i].removeEventListener(WorldEvent.PROGRESS_HAND, skinLoaderProgress, false);
					this.skinLoaderList[i].removeEventListener(WorldEvent.COMPLETE_HAND, skinLoaderComplete, false);
					this.skinLoaderList[i].addEventListener(WorldEvent.PROGRESS_HAND, skinLoaderProgress, false, 0, true);
					this.skinLoaderList[i].addEventListener(WorldEvent.COMPLETE_HAND, skinLoaderComplete, false, 0, true);

					if(this.skinLoaderList[i] is SkinLoader&&this.filePath!=null)	
					(this.skinLoaderList[i] as SkinLoader).loading(BeingType.SKILL, false, false, this.filePath["xml_path" + i.toString()]);



				}
				else
				{
					//nothing
				}

			} //end for
		}

		public function skinLoaderProgress(e:WorldEvent):void
		{

//			var layer:int = e.data["layer"];
//			var arr:Array = e.data["data"];
//			
//			var progressNum:int;
//			
//			if (MAIN_DISPLAY_LAYER == layer)
//			{
//				progressNum = arr[0];
//				
//				if (progressNum < 99)
//				{
//					//this.getHeadName().setLoadPress=progressNum;
//				}
//				else
//				{
//					//this.getHeadName().setLoadPress=progressNum;
//					//this.setKingNameColor();
//				}
//			}

		}

		public function skinLoaderComplete(e:WorldEvent):void
		{
			// fux
			var layer:int=e.data["layer"];
			var role:ResMc=e.data["movie"];

			
			
			role.mouseEnabled=false;
			role.mouseChildren=false;

			//role.rightHand = this.filePath.rightHand;

			removeSkin(layer);
			this.skinLoaderList[layer].removeEventListener(WorldEvent.COMPLETE_HAND, skinLoaderComplete, false);
			
			roleList[layer]=role;

			//
//			if(this.MAIN_DISPLAY_LAYER == layer)
//			{
//				this.MainRoleLoadComplete(role);
//			}

			//
			this.UpdateSkin();

			//主动激发
			this.setAction(_roleZT, _roleFX, _playCount, _playOverAct);

			
		}

//		private function MainRoleLoadComplete(role:Movie):void
//		{
//			//this.loading.Hide();			
//			
//		
//		}
		/**
		 * 强制更新外观
		 */
		public function UpdateSkin():void
		{
			var movie:ResMc=roleList[MAIN_DISPLAY_LAYER];

			if (movie != null)
			{
				/*movie.mattrix(roleList[0], 0);
				movie.mattrix(roleList[1], 1);
				movie.mattrix(roleList[3], 3);*/
//				if (_angle == 0)
//				{
					movie.isFixMiddle=true;
//				}
//				else
//				{
//					movie.isFixMiddle=false;
//				}
				this.addChild(movie);
				//this.addChild(rect);

				//this.rect.addChild(movie);
				movie.loopFromFrame = filePath.loopFrame;
				movie.playTime  = filePath.playTime;
//				movie.play();
				movie.rotation=_angle;
				
				if (filePath.skillId == 401207 || filePath.skillId == 401106 || filePath.skillId == 401103 || filePath.skillId == 401101)
				{
					updateSkinDisplay(movie);
				}
			}
		}
		
		public function updateSkinDisplay(skillMovie:ResMc):void
		{
			if (skillMovie != null && skillMovie.skillPoint != null && skillMovie.skillPoint.length>0)
			{
				//更新时父容器存在
//				if (parent)
//				{
//					parent.x = parent.y = 0;
//				}
				
				x=0;
				y=0;
				skillMovie.setContentXY(0, 0);
				var fx:String = _skillFX;
//				var fx:String = _roleFX;
				switch (fx)
				{
					case "F1":
						if (skillMovie.skillPoint[0] != 0)
						{
							skillMovie.x=skillMovie.skillPoint[0];
							skillMovie.y=skillMovie.skillPoint[1];
							if (filePath.skillId == 401207)
							{
								skillMovie.x -= 30 - 5;
								skillMovie.y -= 50 + 30;
							}else if (filePath.skillId == 401106)
							{
								skillMovie.y -= 70;
							}
						}else if (filePath.skillId == 401106)
						{
							skillMovie.y -= 70;
						}else if (filePath.skillId == 401103)
						{
							skillMovie.x += 10;
							skillMovie.y += 40;
						}
						else if (filePath.skillId == 401101)
						{
							skillMovie.x += 0;
							skillMovie.y += 0;
						}
						break;
					case "F2":
						if (skillMovie.skillPoint[2] != 0)
						{
							skillMovie.x=skillMovie.skillPoint[2];
							skillMovie.y=skillMovie.skillPoint[3];
							if (filePath.skillId == 401207)
							{
								skillMovie.x -= 50-30;
								skillMovie.y -= 150 ;
							}else if (filePath.skillId == 401106)
							{
								skillMovie.x += -5;
								skillMovie.y -= 70;
							}
						}else if (filePath.skillId == 401106)
						{
							skillMovie.x += 10;
							skillMovie.y -= 30;
						}else if (filePath.skillId == 401103)
						{
							skillMovie.x -= 80;
							skillMovie.y += 10;
						}else if (filePath.skillId == 401101)
						{
							skillMovie.x -= 50;
							skillMovie.y -= 70;
						}
						break;
					case "F3":
						if (skillMovie.skillPoint[4] != 0)
						{
							skillMovie.x=skillMovie.skillPoint[4];
							skillMovie.y=skillMovie.skillPoint[5];
							if (filePath.skillId == 401207)
							{
								skillMovie.x;
								skillMovie.y -= 50+5;
							}else if (filePath.skillId == 401106)
							{
								skillMovie.y -= 80;
							}
						}else if (filePath.skillId == 401106)
						{
							skillMovie.y -= 80;
						}else if (filePath.skillId == 401103)
						{
							skillMovie.x -= 100;
							skillMovie.y -= 50;
						}else if (filePath.skillId == 401101)
						{
							skillMovie.x -= 50;
							skillMovie.y -= 95;
						}
						break;
					case "F4":
						if (skillMovie.skillPoint[6] != 0)
						{
							skillMovie.x=skillMovie.skillPoint[6];
							skillMovie.y=skillMovie.skillPoint[7];
							if (filePath.skillId == 401207)
							{
//								skillMovie.x += 10;
								skillMovie.y += 10 - 15 - 30;
							}else if (filePath.skillId == 401106)
							{
								skillMovie.x += 30;
								skillMovie.y -= 90;
							}
						}else if (filePath.skillId == 401106)
						{
							//								skillMovie.x += 15;
							skillMovie.y -= 80;
						}else if (filePath.skillId == 401103)
						{
							skillMovie.x -= 95;
							skillMovie.y -= 110;
						}else if (filePath.skillId == 401101)
						{
							skillMovie.x -= 40;
							skillMovie.y -= 40;
						}
						break;
					case "F5":
						if (skillMovie.skillPoint[8] != 0)
						{
							skillMovie.x=skillMovie.skillPoint[8];
							skillMovie.y=skillMovie.skillPoint[9];
							if (filePath.skillId == 401207)
							{
								skillMovie.x += 30;
								skillMovie.y -= 10;
							}else if (filePath.skillId == 401106)
							{
//								skillMovie.x += 15;
								skillMovie.y -= 50;
							}
						}else if (filePath.skillId == 401106)
						{
							//								skillMovie.x += 15;
							skillMovie.y -= 50;
						}else if (filePath.skillId == 401103)
						{
							skillMovie.x -= 10;
							skillMovie.y -= 150;
						}else if (filePath.skillId == 401101)
						{
							skillMovie.x += 10;
							skillMovie.y -= 70;
						}
						break;
					case "F6":
						if (skillMovie.skillPoint[10] != 0)
						{
							skillMovie.x=skillMovie.skillPoint[10];
							skillMovie.y=skillMovie.skillPoint[11];
							if (filePath.skillId == 401207)
							{
								skillMovie.x += 25;
								skillMovie.y += 55 - 70 - 10;
							}else if (filePath.skillId == 401106)
							{
								skillMovie.x += 50;
								skillMovie.y -= 50;
							}
						}else if (filePath.skillId == 401106)
						{
							skillMovie.x += 50;
							skillMovie.y -= 50;
						}else if (filePath.skillId == 401103)
						{
							skillMovie.x += 100;
							skillMovie.y -= 110;
						}else if (filePath.skillId == 401101)
						{
							skillMovie.x += 40;
							skillMovie.y -= 40;
						}
						break;
					case "F7":
						if (skillMovie.skillPoint[12] != 0)
						{
							skillMovie.x=skillMovie.skillPoint[12];
							skillMovie.y=skillMovie.skillPoint[13];
							if (filePath.skillId == 401207)
							{
								skillMovie.x += 5;
								skillMovie.y += 10;
							}else if (filePath.skillId == 401106)
							{
								skillMovie.x += 80;
								skillMovie.y -= 45;
							}
						}else if (filePath.skillId == 401106)
						{
							skillMovie.x += 80;
							skillMovie.y -= 40;
						}else if (filePath.skillId == 401103)
						{
							skillMovie.x += 100;
							skillMovie.y -= 55;
						}else if (filePath.skillId == 401101)
						{
							skillMovie.x += 60;
							skillMovie.y -= 95;
						}
						break;
					case "F8":
						if (skillMovie.skillPoint[14] != 0)
						{
							skillMovie.x=skillMovie.skillPoint[14];
							skillMovie.y=skillMovie.skillPoint[15];
							if (filePath.skillId == 401207)
							{
								skillMovie.x += 10;
								skillMovie.y -= 10;
							}else if (filePath.skillId == 401106)
							{
								skillMovie.x += 70;
								skillMovie.y -= 60;
							}
						}else if (filePath.skillId == 401106)
						{
							skillMovie.x += 70;
							//								skillMovie.y -= 50;
						}else if (filePath.skillId == 401103)
						{
							skillMovie.x += 100;
							skillMovie.y += 0;
						}else if (filePath.skillId == 401101)
						{
							skillMovie.x += 50;
							skillMovie.y -= 70;
						}
						break;
				}
			}
		}

		private function removeSkin(layer:int):void
		{
			if (roleList[layer] != null && roleList[layer].parent != null)
			{
				roleList[layer].parent.removeChild(roleList[layer]);
				(roleList[layer] as ResMc).playOverAct=null;
				//(roleList[layer] as Movie).close();

				roleList[layer]=null;
			}

		}

		public function setAction(ZT:String, FX:String, PlayCount:int=0, PlayOverAct:Function=null):void
		{
			//
			if (null != ZT)
			{
				_roleZT=ZT;
			}

			if (null != FX)
			{
				_roleFX=FX;
			}

			_playCount=PlayCount;
			_playOverAct=PlayOverAct;

			if (null == this.getRole())
			{
				return;
			}

			//
			var i:int;

			for (i=0; i < SKIN_NUM; i++)
			{
				MapCl.setFangXiang(roleList[i], ZT, FX, null, PlayCount, PlayOverAct);
					
			}

		}

		public function StopLoadSkin():void
		{
			if (null == skinLoaderList)
			{
				return;
			}

			for (var i:int=0; i < SKIN_NUM; i++)
			{
				this.getSkinLoader(i).clearCallback();
			}
		}

		/**
		 *
		 */
		public function removeAll():void
		{
			//
			var i:int;

			//
			StopLoadSkin();

			//
			for (i=0; i < SKIN_NUM; i++)
			{
				if (null != skinLoaderList)
				{
					if (null != skinLoaderList[i])
					{
						SkinLoader(skinLoaderList[i]).destory();
						skinLoaderList[i].removeEventListener(WorldEvent.PROGRESS_HAND, skinLoaderProgress, false);
						skinLoaderList[i].removeEventListener(WorldEvent.COMPLETE_HAND, skinLoaderComplete, false);

					}
				}
			}

			skinLoaderList=null;

			_roleList=null;

			var d:DisplayObject;
			while (this.numChildren > 0)
			{
				d=this.removeChildAt(0);
				if (d as ResMc)
				{
					(d as ResMc).playOverAct=null;
					//(d as Movie).stop();
					(d as ResMc).close();
				}
			}
			//==whr===
			d=null;
		}

		//------------------------ get 区  begin ---------------------------------------------------------------------------

		public function get roleList():Array
		{
			return _roleList;
		}

		public function getSkinLoader(INDEX:int):SkinLoader
		{
			if (SKIN_NUM > INDEX)
			{
				return skinLoaderList[INDEX];
			}
			throw new Error("INDEX out side array:" + INDEX);
			return null;
		}

		/**
		 * 主显示
		 */
		public function getRole():ResMc
		{
			var movie:ResMc=roleList[MAIN_DISPLAY_LAYER];
			return movie;
		}
	}
}
