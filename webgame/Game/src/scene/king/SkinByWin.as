package scene.king
{
	import com.bellaxu.res.ResMc;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.setTimeout;

	import scene.event.KingActionEnum;
	import scene.utils.MapCl;

	import world.WorldEvent;
	import world.model.file.BeingFilePath;
	import world.type.BeingType;

	public class SkinByWin extends Sprite
	{
		public static const SKIN_NUM:int=4;


		/**
		 * 主显示
		 */
		public static const MAIN_DISPLAY_LAYER:int=2;

		//skin
		public var skinLoaderList:Array;

		public var filePath:BeingFilePath;

		private var _roleList:Array;

		private var _changedList:Array;

		private var _s2Visible:Boolean;

		private var _fx:String="F1";

		//		
		public function SkinByWin(value:String="F2")
		{
			_fx=value;
			init();
		}


		public function init():void
		{
			filePath=null;

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

			_s2Visible=true;
		}

		public function unload():void
		{


			var i:int;

			for (i=0; i < SKIN_NUM; i++)
			{

				this.skinLoaderList[i].removeEventListener(WorldEvent.PROGRESS_HAND, skinLoaderProgress, false);
				this.skinLoaderList[i].removeEventListener(WorldEvent.COMPLETE_HAND, skinLoaderComplete, false);


			}

			for (i=0; i < SKIN_NUM; i++)
			{
				removeSkin(i);
			}

			//
			while (this.numChildren > 0)
			{
				this.removeChildAt(0);
			}

			//
			init();

		}


		public function get changedList():Array
		{
			if (null == _changedList)
			{
				_changedList=new Array();

				_changedList.push(false);
				_changedList.push(false);
				_changedList.push(false);
				_changedList.push(false);

			}

			return _changedList;
		}

		public function set changedList(value:Array):void
		{
			_changedList=value;
		}



		public function setSkin(bfp:BeingFilePath, s2See:Boolean=true):void
		{
			//
			unload();

			//
			_s2Visible=s2See;

			//
			if (null == this.filePath)
			{
				this.filePath=bfp;

				//
				for (var i:int=0; i < SKIN_NUM; i++)
				{
					//_changedList.push(true);
					changedList[i]=true;
				}
			}
			else
			{
				//compare
				changedList=this.filePath.compare(bfp);

			}

			//
			this.UpdateAndLoadSkin()
		}

		public function get isHuman():Boolean
		{
			return true;
		}

		//private function UpdateAndLoadSkin(changedList:Array):void
		private function UpdateAndLoadSkin():void
		{
			//
			var i:int=MAIN_DISPLAY_LAYER;

			//
			if (changedList[i])
			{
				changedList[i]=false;

				this.removeSkin(i);

				if ("" != this.filePath["swf_path" + i.toString()])
				{
					this.skinLoaderList[i].removeEventListener(WorldEvent.PROGRESS_HAND, skinLoaderProgress, false);
					this.skinLoaderList[i].removeEventListener(WorldEvent.COMPLETE_HAND, skinLoaderComplete, false);
					this.skinLoaderList[i].addEventListener(WorldEvent.PROGRESS_HAND, skinLoaderProgress, false, 0, true);
					this.skinLoaderList[i].addEventListener(WorldEvent.COMPLETE_HAND, skinLoaderComplete, false, 0, true);


					(this.skinLoaderList[i] as SkinLoader).loading(BeingType.HUMAN, true, true, this.filePath["xml_path" + i.toString()]);


				}

			}
			else
			{
				this.roleComplete();

			}


		}

		public function skinLoaderProgress(e:WorldEvent):void
		{
			this.dispatchEvent(new WorldEvent(e.type, e.data));
		}

		public function skinLoaderComplete(e:WorldEvent):void
		{
			// fux
			var layer:int=e.data["layer"];
			var role:ResMc=e.data["movie"];

			role.mouseEnabled=false;
			role.mouseChildren=false;
			role.playTime = 2000;

			role.rightHand=this.filePath.rightHand;

			roleList[layer]=role;

			//this.UpdateSkin();
			this.UpdateSkin(layer);

			if (MAIN_DISPLAY_LAYER == layer)
				roleComplete();

			for (var i:int=0; i < changedList.length; i++)
			{
				if (changedList[i])
				{
					return;
				}
			}

			//全部加载成功
			this.dispatchEvent(new Event(Event.COMPLETE));

		}

		/**
		 * 主显示加载成功
		 */
		public function roleComplete():void
		{


			var i:int;
			var len:int=changedList.length;


			for (i=0; i < len; i++)
			{
				if (changedList[i])
				{
					changedList[i]=false;

					this.removeSkin(i);

					if ("" != this.filePath["swf_path" + i.toString()])
					{
						this.skinLoaderList[i].removeEventListener(WorldEvent.PROGRESS_HAND, skinLoaderProgress, false);
						this.skinLoaderList[i].removeEventListener(WorldEvent.COMPLETE_HAND, skinLoaderComplete, false);
						this.skinLoaderList[i].addEventListener(WorldEvent.PROGRESS_HAND, skinLoaderProgress, false, 0, true);
						this.skinLoaderList[i].addEventListener(WorldEvent.COMPLETE_HAND, skinLoaderComplete, false, 0, true);

						(this.skinLoaderList[i] as SkinLoader).loading(BeingType.HUMAN, true, true, this.filePath["xml_path" + i.toString()]);

					}

				}
				else
				{
					//nothing
				}

			} //end for


		}

		/**
		 * 强制更新外观
		 */
		public function UpdateSkin(layer:int):void
		{
			var movie:ResMc=roleList[MAIN_DISPLAY_LAYER];

			if (movie != null)
			{
				//
				this.addChild(movie);

				//
				movie.mattrix(roleList[0], 0);
				movie.mattrix(roleList[1], 1);
				movie.mattrix(roleList[3], 3);

				movie.isMonster=true;
				//
//				movie.play();

				//
				setAction(_fx);

				var size:int=movie.numChildren;
				var index:int=0;
				var dis:DisplayObject;
				if (_s2Visible)
				{
					while (index < size)
					{
						dis=movie.getChildAt(index);
						if (dis.name == "wing" || dis.name == "horse")
						{
							index++;
							continue;
						}
						dis.alpha=1.0;
						index++;
					}
					if (movie.wing != null)
					{
						movie.wing.visible=true;
						movie.wing.alpha=1;
					}
//					movie["depth2"].alpha = 1.0;
//					movie["depth3"].alpha = 1.0;
				}
				else
				{
					index=0;
					while (index < size)
					{
						dis=movie.getChildAt(index);
						if (dis.name == "wing" || dis.name == "horse")
						{
							index++;
							continue;
						}
						dis.alpha=0.0;
						index++;
					}
				}
				movie.alpha=0;
				setTimeout(function(m_mc:Sprite):void
				{
					m_mc.alpha=1;
				}, 1000, movie);
			}
		}

		public function setAction(FX:String):void
		{

			if (null == this.getRole())
			{
				return;
			}

			var i:int;

			var ZT:String=KingActionEnum.DJ; //KingActionEvent.Dead;

			//var FX:String ="F1";

			if (hasHorse)
			{
				ZT=KingActionEnum.ZOJ_DJ;
				FX="F2";
			}

			//只用设主显示
			MapCl.setFangXiang(this.getRole(), ZT, FX, null, 0, null);

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

		public function get hasHorse():Boolean
		{
			if (null == this.filePath)
			{
				return false;
			}

			return this.filePath.hasHorse;

		}

		private function removeSkin(layer:int):void
		{
			if (roleList[layer] != null && roleList[layer].parent != null)
			{

				roleList[layer].parent.removeChild(roleList[layer]);

				//(roleList[layer] as Movie).stop();
				(roleList[layer] as ResMc).close();

				roleList[layer]=null;

			}

			this.UpdateSkin(layer);

		}



	}
}
