package world.cache.res.loader
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Elastic;
	
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.res.ResCtrl;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	import scene.human.GameDrop;
	
	import ui.frame.UIMovieClip;
	import ui.view.view3.drop.ResDrop;
	
	import world.WorldFactory;

	/**
	 * @author  WangHuaRen
	 * @version 2012-1-8-上午09:10:20
	 */
	public final class ResLoader extends UIMovieClip
	{

		private static var bitmapDataHash:Dictionary=new Dictionary;
		private static var resLoaderHash:Array=[]
		public var isuse:Boolean=false;
		private var loader:Loader=null;
		private var _itemID:int=0;
		private var _objID:int=0;
		private var _indexID:int=0;
		private var path:String=null;
		private var _starPos:Point=null;
		private var _endPos:Point=null;
		private var resDate:Pub_ToolsResModel;
		private var num:int=0;

		/**
		 * 服务器发过来的该掉落物的拾取精确位置  x 值
		 */
		private var m_posx:int;

		/**
		 * 服务器发过来的该掉落物的拾取精确位置  y 值
		 */
		private var m_posy:int;

		public function ResLoader(_objID:int, _itemID:int, _path:String, _index:int, _resDate:Pub_ToolsResModel, _num:int)
		{
			this._itemID=_itemID;
			this._objID=_objID;
			num=_num;
			path=_path;
			_indexID=_index;

			mouseChildren=false;



			cacheAsBitmap=true;
			if (bitmapDataHash[_path] == null)
			{
				loader=new Loader();
				addEvent();
				loader.load(new URLRequest(_path));
			}
			else
			{
				var bmd:BitmapData=bitmapDataHash[_path] as BitmapData
				draw(bmd)
			}


			buttonMode=true;
			resDate=_resDate;
			if (txtFormat == null)
			{
				txtFormat=new TextFormat();
				txtFormat.color=0xfff5d2;
				txtFormat.size=12;
				txtFormat.font="SimSun";
			}
			txt=new TextField();

			// 测试缓存效果
			txt.cacheAsBitmap=true
			addChild(txt);
			txtFormat.color="0x" + ResCtrl.instance().arrColor[resDate.tool_color];
			txt.defaultTextFormat=txtFormat;
//			if ((_itemID + "").substr(0, 3) == "113")
//			{
////				txt.htmlText="<b>" + ResCtrl.instance().arrTitle[resDate.tool_color ] + "·" + tipParam[0] + (num > 1 ? " × " + num : "") + "</b>";
//				txt.htmlText="<b>" + tipParam[0] + (num > 1 ? " × " + num : "") + "</b>";
//			}
//			else
//			{
				txt.htmlText= (num > 1 ?num+" " : "")+tipParam[0]
//			}
			txt.width=txt.textWidth + 10;
			txt.height=txt.textHeight + 5;
			txt.x=-12;
			txt.y=-txt.height;
			CtrlFactory.getUIShow().setColor(txt, 5, 0x000000);
			if (!ResDrop.away)
			{
				txt.visible=false;
			}
//			gd=Body.instance.sceneKing.CDrop();
//			this.hitArea=gd;
//			gd.buttonMode=true;
//			gd.setData(_itemID, resDate, tipParam, num);
		}
		private var gd:GameDrop;

		public function reset(_objID:int, _itemID:int, _path:String, _index:int, _resDate:Pub_ToolsResModel, _num:int):void
		{
			this._itemID=_itemID;
			this._objID=_objID;
			num=_num;
			path=_path;
			_indexID=_index;

			mouseChildren=false;



			cacheAsBitmap=true;
			if (bitmapDataHash[_path] == null)
			{
				loader=new Loader();
				addEvent();
				loader.load(new URLRequest(_path));
			}
			else
			{
				var bmd:BitmapData=bitmapDataHash[_path] as BitmapData
				draw(bmd)
			}


			buttonMode=true;
			resDate=_resDate;
			if (txtFormat == null)
			{
				txtFormat=new TextFormat();
				txtFormat.color=0xfff5d2;
				txtFormat.size=12;
				txtFormat.font="SimSun";
			}
			if (!txt)
				txt=new TextField();

			// 测试缓存效果
			txt.cacheAsBitmap=true
			addChild(txt);
			txtFormat.color="0x" + ResCtrl.instance().arrColor[resDate.tool_color];
			txt.defaultTextFormat=txtFormat;
//			if ((_itemID + "").substr(0, 3) == "113")
//			{
//				//				txt.htmlText="<b>" + ResCtrl.instance().arrTitle[resDate.tool_color ] + "·" + tipParam[0] + (num > 1 ? " × " + num : "") + "</b>";
//				txt.htmlText="<b>" + tipParam[0] + (num > 1 ? " × " + num : "") + "</b>";
//			}
//			else
//			{
				txt.htmlText=tipParam[0] + (num > 1 ? " × " + num : "");
//			}
			txt.width=txt.textWidth + 10;
			txt.height=txt.textHeight +5;
			txt.x=-12;
//			txt.y=-txt.height - 10;
			CtrlFactory.getUIShow().setColor(txt, 5, 0x000000);
			if (!ResDrop.away)
			{
				txt.visible=false;
			}

		}

		public static function createResLoader():ResLoader
		{
			if (resLoaderHash.length)
				resLoaderHash.pop();
			return null
		}

		private function draw(bitmapData:BitmapData):void
		{
			with (graphics)
			{
				clear();
				beginFill(0x000000, 0);
				drawRect(0, 0, bitmapData.width, bitmapData.height);
				endFill();
				beginBitmapFill(bitmapData);
				drawRect(0, 0, bitmapData.width, bitmapData.height);
			}

		}

		//private var dropEffect:DisplayObject;

		private function loadCompleteHandler(e:Event):void
		{
			dropLoaderRemoveEvent();
			var bmd:BitmapData=Bitmap(loader.content).bitmapData
			this.draw(bmd);
			bitmapDataHash[loader.contentLoaderInfo.url]=bmd;
			
//			var dropEffect:DisplayObject=WorldFactory.creatEffectDiaoLuo();
//			
//			if(null == dropEffect)
//			{
//				return;
//			}
//			
//			dropEffect.removeEventListener(Event.REMOVED_FROM_STAGE, WorldFactory.DROP_EFFECT_REMOVED_FROM_STAGE);
//			dropEffect.addEventListener(Event.REMOVED_FROM_STAGE, WorldFactory.DROP_EFFECT_REMOVED_FROM_STAGE);
//			
//			dropEffect.x=(loader.content.width - dropEffect.width) / 2;
//			dropEffect.y=(loader.content.height - dropEffect.height) / 2;
//			
//			addChild(dropEffect);
		}

		public var txt:TextField;
		private var txtFormat:TextFormat;

		private function mouseOverHandler(e:MouseEvent):void
		{
			if (ResDrop.away)
			{
				return;
			}
			this.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			CtrlFactory.getUIShow().setColor(loader.content, 5, 0x47fb01);
			txt.visible=true;
		}

		private function mouseOutHandler(e:MouseEvent):void
		{
			this.removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			CtrlFactory.getUIShow().setColor(loader.content, 1);
			txt.visible=false;
		}

		private function loadErrorHandler(e:IOErrorEvent):void
		{
			dropLoaderRemoveEvent();
			trace("文件:" + path + " 加载错误," + e.text);
//			_objID=_itemID=0;
			bitmapDataHash[loader.contentLoaderInfo.url]=new BitmapData(1, 1, true, 0);
		}

		private function loadSecurityErrorHandler(e:SecurityErrorEvent):void
		{
			dropLoaderRemoveEvent();
			trace("file:" + path + " load error," + e.text);
//			_objID=_itemID=0;
		}

		private function addEvent():void
		{
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadCompleteHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loadSecurityErrorHandler);
		}

		private function dropLoaderRemoveEvent():void
		{
			if (null != loader)
			{
				if (null != loader.contentLoaderInfo)
				{
					loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadCompleteHandler);
				}

				loader.removeEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler);
				loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loadSecurityErrorHandler);
			}
		}

		public function get objID():int
		{
			return _objID;
		}

		public function get itemID():int
		{
			return _itemID;
		}

		public function destory():void
		{
			//
			while (this.numChildren > 0)
			{
				this.removeChildAt(0);
			}

			if (this.parent != null)
			{
				this.parent.removeChild(this);
			}
			_objID=0;
			_itemID=0;
			isuse=false;
			dropLoaderRemoveEvent();
			this.removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			resLoaderHash.push(this)
		}

		public function set starPos(value:Point):void
		{
			_starPos=value;
			this.x=_starPos.x;
			this.y=_starPos.y;
			if (_endPos != null)
			{
				jumpJump();
			}
		}


		public function set endPos(value:Point):void
		{
			_endPos=value;

			if (_starPos != null)
			{
				jumpJump();
			}
		}

		private function jumpJump():void
		{
//			_endPos.x+=_starPos.x;
			_endPos.y+=_starPos.y;

//			gd.currIndex=indexID;
//			gd.currObj=objID;
//			gd.x=_starPos.x + _endPos.x;
//			gd.y=_endPos.y;

			TweenMax.to(this, 1, {ease: Elastic.easeOut, bezier: [{x: _starPos.x + _endPos.x / 2, y: _endPos.y - 300}, {x: _starPos.x + _endPos.x, y: _endPos.y}]});
		}

		public function get tipParam():Array
		{
			return [resDate.tool_name];
		}

		private function dropPlayComplete():void
		{
			Lang.addTip(this, "drop_res_tip");
		}

		public function get indexID():int
		{
			return _indexID;
		}

		public function set PosX(x:int):void
		{
			this.m_posx=x;
		}

		public function set PosY(y:int):void
		{
			this.m_posy=y;
		}

		public function get PosX():int
		{
			return this.m_posx;
		}

		public function get PosY():int
		{
			return this.m_posy;
		}

	}
}
