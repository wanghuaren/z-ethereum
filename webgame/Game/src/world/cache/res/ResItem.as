package world.cache.res
{
	import com.bellaxu.res.ResTool;
	import com.bellaxu.util.MathUtil;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Elastic;

	import common.config.xmlres.lib.TablesLib;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.res.ResCtrl;

	import engine.load.Gamelib;
	import engine.load.GamelibS;

	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;

	import scene.human.GameRes;

	import ui.view.view3.drop.ResDrop;

	/**
	 * @author  WangHuaRen
	 * @version 2012-1-8-上午09:10:20
	 */
	public final class ResItem extends Sprite
	{
		public var objID:int=0;
		public var itemID:int=0;
		public var indexID:int=0;
		public var resDate:Pub_ToolsResModel;
		public var num:int=0;

		public var txt:TextField;
		private var _format:TextFormat;
		private var _bitmap:Bitmap;
		private var _starPos:Point=null;
		private var _endPos:Point=null;

		/**
		 * 服务器发过来的该掉落物的拾取精确位置  x 值
		 */
		private var m_posx:int;

		/**
		 * 服务器发过来的该掉落物的拾取精确位置  y 值
		 */
		private var m_posy:int;

		public function ResItem()
		{
			this.mouseChildren=false;
			this.buttonMode=true;
			this._bitmap=new Bitmap();
			addChild(this._bitmap);

			this._format=new TextFormat();
			this._format.color=0xfff5d2;
			this._format.size=12;
			this._format.font="SimSun";

			this.txt=new TextField();
			this.txt.defaultTextFormat=_format;
			CtrlFactory.getUIShow().setColor(txt, 5, 0x000000);
			addChild(txt);

			if (!ResDrop.away)
				txt.visible=false;
//			gd=Body.instance.sceneKing.CDrop();
//			this.hitArea=gd;
//			gd.buttonMode=true;
//			gd.setData(_itemID, resDate, tipParam, num);
		}
		private var m_effect:MovieClip;
		private var arrCoin:Array=[11600010, 11600011, 11600012];

		public function update():void
		{
			if (resDate)
			{
//				if (resDate.tool_color > 2 || arrCoin.indexOf(resDate.tool_id) >= 0)
				if (resDate.tool_color > 2)
				{
					m_effect=ResDrop.instance.getDropEffect();
					addChild(m_effect);
				}
				var str:String=ResCtrl.instance().arrColor[resDate.tool_color];
				_format.color="0x" + str;
				txt.htmlText="<font color='#" + str + "'>" + (tipParam[0]) + "</font>";
				if (arrCoin.indexOf(resDate.tool_id) < 0)
				{
					txt.htmlText="<font color='#" + str + "'>" + (tipParam[0]) + "</font>";
				}
				else
				{
					txt.htmlText="<font color='#" + str + "'>" + num + " " + (tipParam[0]) + "</font>";
				}
				txt.width=txt.textWidth + 5;
				txt.height=txt.textHeight + 5;
				txt.x=0;
				txt.y=-txt.height + 10;
				ResTool.load("Icon/Drop_" + resDate.tool_dropicon + "S.png", loadCompleteHandler);
			}
		}

		//private var dropEffect:DisplayObject;

		private function loadCompleteHandler(url:String):void
		{
			if (_bitmap)
			{
				_bitmap.bitmapData=ResTool.getBmd(url);
				txt.x=_bitmap.width - txt.textWidth >> 1;
				if (m_effect)
				{
					m_effect.x=-(m_effect.width - _bitmap.width) / 2;
					m_effect.y=-(m_effect.height - _bitmap.height) / 2;
				}
			}
		}

//		private function mouseOverHandler(e:MouseEvent):void
//		{
//			if (ResDrop.away)
//				return;
//			this.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
//			CtrlFactory.getUIShow().setColor(loader.content, 5, 0x47fb01);
//			txt.visible=true;
//		}
//
//		private function mouseOutHandler(e:MouseEvent):void
//		{
//			this.removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
//			CtrlFactory.getUIShow().setColor(loader.content, 1);
//			txt.visible=false;
//		}

		public function destory():void
		{
			while (this.numChildren > 0)
			{
				this.removeChildAt(0);
			}

			if (this.parent != null)
			{
				this.parent.removeChild(this);
			}
			objID=0;
			itemID=0;
			resDate=null;
			if (_bitmap)
				_bitmap.bitmapData=null;
			_bitmap=null;
			if (m_effect)
			{
				ResDrop.instance.cleanEffect(m_effect);
				m_effect.stop();
			}
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

		public function playDrop(startX:uint, startY:uint, toX:uint, toY:uint):void
		{
			this.x=toX;
			this.y=toY - MathUtil.getRandomInt(60, 120);
			var _this:ResItem=this;
			setTimeout(function():void
			{
				TweenLite.to(_this, 0.1, {x: toX, y: toY, onComplete: function(target:ResItem):void
				{
					var flag:Boolean=MathUtil.getRandomInt(1, 100) % 2 == 0;
					if (flag)
						TweenLite.to(target, 0.1, {x: toX, y: toY - MathUtil.getRandomInt(10, 20), onComplete: function(target:ResItem):void
						{
							TweenLite.to(target, 0.1, {x: toX, y: toY});
						}, onCompleteParams: [_this]});
				}, onCompleteParams: [_this]});
			}, MathUtil.getRandomInt(100, 600));

		}

		public function get tipParam():Array
		{
			return [resDate.tool_name];
		}

		private function dropPlayComplete():void
		{
			Lang.addTip(this, "drop_res_tip");
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
