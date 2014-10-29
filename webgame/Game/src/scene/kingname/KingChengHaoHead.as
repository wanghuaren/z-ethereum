package scene.kingname
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_TitleResModel;
	import common.utils.clock.GameClock;
	import engine.load.GamelibS;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import scene.manager.SceneManager;
	import world.WorldEvent;
	import world.WorldFactory;

	public class KingChengHaoHead extends Sprite
	{
		private var _v:MovieClip;
		private var _titleFullList:Array;

		public function KingChengHaoHead()
		{
		}

		public function init():void
		{
			if (null != v && !this.contains(v))
			{
				this.addChild(v);
			}
			if (null != v)
				v.gotoAndStop(1);
			this.x=0;
			this.y=0;
			GameClock.instance.removeEventListener(WorldEvent.CLOCK__SECOND200, checkTitleLoad);
		}

		public function gotoAndStop(frame:Object):void
		{
			v.gotoAndStop(frame);
		}

		public function gotoAndPlay(frame:Object):void
		{
			v.gotoAndPlay(frame);
		}

		//get 
		public function get v():MovieClip
		{
			if (null == _v)
			{
				_v=new MovieClip();
				_v.mouseChildren=_v.mouseEnabled=false;
				this.mouseChildren=this.mouseEnabled=false;
			}
			return _v;
		}

		//称号
		private function getTitle(value:int):MovieClip
		{
			if (null == titleFullList[value])
			{
				var title_mc:MovieClip=GamelibS.getswflink("game_index", "title" + value.toString()) as MovieClip;
				if (null != title_mc)
				{
					title_mc.mouseChildren=title_mc.mouseEnabled=false;
					titleFullList[value]=title_mc;
				}
				else
				{
					return null;
				}
			}
			return _titleFullList[value];
		}

		public function get titleFullList():Array
		{
			if (null == _titleFullList)
			{
				_titleFullList=new Array();
			}
			return _titleFullList;
		}

		private function getPre(d_value:int):int
		{
			var m:Pub_TitleResModel=XmlManager.localres.titleXml.getResPath(d_value) as Pub_TitleResModel;
			if (null == m)
			{
				throw new Error("can not find d_value:" + d_value);
			}
			return m.priority;
		}
		private var _titleList:Array;
		private var _titleListPrim:Array=[];

		public function set title(titleList:Array):void
		{
			while (this.numChildren)
			{
				this.removeChildAt(0);
			}
			//PK之王中隐藏所有称号显示
			if (20210065 == SceneManager.instance.currentMapId)
			{
				titleList=[];
			}
			var i:int;
			var len:int=titleList.length;
			_titleListPrim=new Array().concat(titleList);
			//----------------------------------
			var titleSortList:Array=[];
			for (var j:int=0; j < len; j++)
			{
				var d_index:int=getPre(titleList[j]);
				titleSortList.push({"d": titleList[j], "ind": d_index});
			}
			//
			titleSortList.sortOn("ind", Array.NUMERIC | Array.CASEINSENSITIVE);
			//
			_titleList=[];
			for (var k:int=0; k < len; k++)
			{
				_titleList.push(titleSortList[k]["d"]);
			}
			var needCheckLoad:Boolean=false;
			var h:int=-58;
			for (i=0; i < len; i++)
			{
				var title_mc:MovieClip=getTitle(_titleList[i]);
				if (null == title_mc)
				{
					needCheckLoad=true;
				}
				else
				{
					title_mc.name="title" + _titleList[i];
					this.addChild(title_mc);
//					if (0 == i)
//					{
//						h=getTitleHeight(i, title_mc.name);
//					}
//					else
//					{
//						h=h + 30 * -1;
//					}
					title_mc.y=h;
					h+=title_mc.height*-1;
//					if ("title16" == title_mc.name)
//					{
//						title_mc.y-=78;
//					}
//					else if ("title13" == title_mc.name || "title14" == title_mc.name || "title15" == title_mc.name)
//					{
//						h=title_mc.y + 30 - title_mc.height;
//						title_mc.y=h;
//					}
//					else if ("title17" == title_mc.name || "title29" == title_mc.name)
//					{
//						h=title_mc.y + 60 - title_mc.height;
//						title_mc.y=h;
//					}
				}
			}
			//
			if (needCheckLoad)
			{
				GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND, checkTitleLoad);
			}
			else
			{
				GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, checkTitleLoad);
			}
		}

		public function checkTitleLoad(e:WorldEvent):void
		{
			if (null != _titleListPrim)
			{
				title=_titleListPrim;
			}
		}

		public function getTitleHeight(i:int, title_name:String):int
		{
			if (0 == i)
			{
				return 0;
			}
			return 30;
		}
	}
}
