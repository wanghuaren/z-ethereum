package common.utils
{
	import common.config.GameIni;
	import common.config.PubData;
	import common.managers.Lang;
	import common.utils.font.FontStyle;
	import common.utils.md5.MD5;
	import common.utils.res.ResCtrl;
	
	import display.components.CmbArrange;
	
	import engine.event.DispatchEvent;
	import engine.utils.Debug;
	
	import fl.containers.UILoader;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	
	import ui.frame.ImageUtils;

	/**
	 * @author wanghuaren
	 */
	public final class UICtrl
	{
		/*
		 * 私聊
		 */
		public function privateChat(username:String, userid:int):void
		{
			PubData.chat.dispatchEvent(new DispatchEvent(DispatchEvent.EVENT_CHAT_TEXT_LINK, username + "|||" + userid));
		}

		/*
		* 时间转换 1 时:分:秒 2 时:分 3分:秒
		*/
		public function formatTime(second:int, type:int=1):String
		{
			var str:String="";
			var tn:int=0;
			switch (type)
			{
				case 1:
					tn=int(second / 3600);
					str=int(second) / 3600 < 1 ? "00:" : tn < 10 ? "0" + tn + ":" : tn + ":";
					tn=int((int(second) % 3600) / 60);
					str+=(int(second) % 3600) / 60 < 1 ? "00:" : tn < 10 ? "0" + tn + ":" : tn + ":";
					tn=(int(second) % 3600) % 60;
					str+=tn < 10 ? "0" + tn : tn;
					break;
				case 2:
					tn=int(second / 3600);
					str=int(second) / 3600 < 1 ? "00:" : tn < 10 ? "0" + tn + ":" : tn + ":";
					tn=int((int(second) % 3600) / 60);
					str+=(int(second) % 3600) / 60 < 1 ? "00" : tn < 10 ? "0" + tn : tn;
					break;
				case 3:
					tn=int(second / 3600);
					//str=int(second) / 3600 < 1 ? "00:" : tn < 10 ? "0" + tn + ":" : tn + ":";
					tn=int((int(second) % 3600) / 60);
					str+=(int(second) % 3600) / 60 < 1 ? "00:" : tn < 10 ? "0" + tn + ":" : tn + ":";
					tn=(int(second) % 3600) % 60;
					str+=tn < 10 ? "0" + tn : tn;
					break;
			}
			return str;
		}

		/**
		 *	X天 X时 X分 X秒
		 *  @param type 1.X天 X时 X分 X秒 2.X天 X时 X分
		 */
		public function formatTime2(second:int, type:int=1):String
		{
			var str:String="";
			var remainTime:int=0;
			var tn:int=0;
			switch (type)
			{
				case 1:
					//天
					tn=int(second / (3600 * 24));
					str=tn > 0 ? tn + Lang.getLabel("pub_tian") : "";
					//时
					remainTime=int(second % (3600 * 24));
					tn=int(remainTime / 3600);
					str+=tn > 0 ? tn + Lang.getLabel("pub_shi") : "";
					//分
					remainTime=int(remainTime % 3600);
					tn=int(remainTime / 60);
					str+=tn > 0 ? tn + Lang.getLabel("pub_fen") : "";
					//秒
					remainTime=int(remainTime % 60);
					tn=remainTime;
					str+=tn + Lang.getLabel("pub_miao");
					break;
				case 2:
					//天
					tn=int(second / (3600 * 24));
					str=tn > 0 ? tn + Lang.getLabel("pub_tian") : "";
					//时
					remainTime=int(second % (3600 * 24));
					tn=int(remainTime / 3600);
					str+=tn > 0 ? tn + Lang.getLabel("pub_shi") : "";
					//分
					remainTime=int(remainTime % 3600);
					tn=int(remainTime / 60);
					str+=tn + Lang.getLabel("pub_fen");
					break;
				default:
					break;
			}
			return str;
		}

		/*
		 * 取得一个填充数据后的Combobox
		 */
		// public function getComb(array:Array,myKey:Object):ComboBox {
		public function getComb(array:Array, myKey:Object):CmbArrange
		{
			// var cmb:ComboBox=new ComboBox();
			var cmb:CmbArrange=new CmbArrange();
			CtrlFactory.getUIShow().comboboxFill(cmb, array, myKey);
			return cmb;
		}

		/*
		 * 文本中文字的格式
		 */
		public function getTextFormat(info:Object=null):TextFormat
		{
			return FontStyle.instance().getTextFormat(info);
		}

		public function getTextFormat_14(info:Object=null):TextFormat
		{
			return FontStyle.instance().getTextFormat_14(info);
		}

		/*
		 * 文本框滤镜
		 */
		public function getFilter():Array
		{
			return FontStyle.instance().getFilter();
		}

		/*
		 * 取得悬浮窗信息
		 */
		public function getDesc(data:Object):Object
		{
			return ResCtrl.instance().getNewDesc(data);
		}

		/*
		 * 對一個不能傳值的對象進行克隆
		 */
		public function getObject(object:Object):Object
		{
			var ba:ByteArray=new ByteArray();
			ba.writeObject(object);
			ba.position=0;
			return ba.readObject();
		}

		/*
		 * 数据库中物品ID字段名称不统一,进行筛选
		 */
		public function getID(rowData:Object):String
		{
			return ResCtrl.instance().getID(rowData);
		}

		/*
		 * 数据库中物品图标(icon)字段名称不统一,进行筛选
		 */
		public function getICON(rowData:Object):String
		{
			return ""; //ResCtrl.instance().getICON(rowData);
		}

		/*
		 * 数据库中物品名称字段名称不统一,进行筛选
		 */
		public function getTitle(rowData:Object):String
		{
			return ""; //ResCtrl.instance().getTitle(rowData);
		}


		/*
		 * MD5加密
		 */
		public function md5(num:Object):String
		{
			return MD5.hash(num + "");
		}

		/*
		 * UILoader控件加载外部元件或图片
		 */
		public function UILLoad(uil:UILoader, url:Object, loadIcoComplete:Function=null):void
		{
			if (!(url is String))
			{
				for (var str:String in url)
				{
					if (str.indexOf("icon") >= 0)
					{
						url=url[str];
						break;
					}
				}
			}
			if (url != null && url.hasOwnProperty("length") && url.length > 3 && url != "meiyou")
			{
				if (loadIcoComplete != null)
				{
					uil.addEventListener(Event.COMPLETE, loadComplete);
					uil.addEventListener(IOErrorEvent.IO_ERROR, loadError);
					function loadComplete(e:Event):void
					{
						uil.removeEventListener(Event.COMPLETE, loadComplete);
						loadIcoComplete(e.target);
					}
					function loadError(e:IOErrorEvent):void
					{
						uil.removeEventListener(IOErrorEvent.IO_ERROR, loadError);
						Debug.instance.traceMsg("load " + url + " io error!");
					}
				}

				// uil.load(new URLRequest(GameIni.GAMESERVERS+url));
				if (uil.source == GameIni.GAMESERVERS + url)
				{
					if (loadIcoComplete != null)
					{
						loadIcoComplete(uil);
					}
				}
				else
				{
					uil.source=GameIni.GAMESERVERS + url;
				}
			}
			else
			{
//				uil.source=GameIni.GAMESERVERS + "img/" + Lang.getLabel("pub_hua_hua_niu") + ".png";
				ImageUtils.replaceImage(uil.parent,uil,GameIni.GAMESERVERS + "img/" + Lang.getLabel("pub_hua_hua_niu") + ".png");
			}
		}


		/*
		 * 画一个指定長度,高度,颜色的正方形
		 */
		public function getRect(lx:int=50, ly:int=50, color:Number=0x0000ff, alpha:Number=0.5):Sprite
		{
			var sprite:Sprite=new Sprite();
			with (sprite.graphics)
			{
				beginFill(color, alpha);
				drawRect(0, 0, lx, ly);
				endFill();
			}
			return sprite;
		}

		/*
		 * 文字简单排版,使之成為正方形
		 */
		public function fmText(str:String, len:int=15):String
		{
			str=str == null || str.length < 2 ? "" : str;
			return FontStyle.instance().fmText(str, len);
		}

		/*
		 * 深度清理元件,2級
		 */
		public function clearMC(sprite:Sprite):void
		{
			try
			{
				var temp:Sprite=null;
				if (sprite != null)
				{
					while (0 < sprite.numChildren)
					{
						temp=sprite.getChildAt(0) as Sprite;
						if (temp != null)
						{
							while (0 < temp.numChildren)
							{
								temp.removeChildAt(0);
							}
						}

						sprite.removeChildAt(0);
					}
				}
			}
			catch (e:Error)
			{
				if (sprite != null && sprite.parent != null)
				{
					sprite.parent.removeChild(sprite);
				}
			}
		}

		/**
		 * 设置输入文本框国的字数
		 */
		public function setTextFieldLength(textField:TextField, len:int):void
		{
			FontStyle.instance().setTextLength(textField, len);
		}

		/**
		 * 检查父级名称
		 */
		public function checkParent(currMC:Object, p_name:String, indexOf:Boolean=false):Boolean
		{
			if (currMC == null || !currMC.hasOwnProperty("numChildren"))
			{
				return false;
			}
			var blm:Boolean=false;
			if (indexOf)
			{
				var CNum:int=currMC.numChildren;
				for (var cn:int=0; cn < CNum; cn++)
				{
					var obj:DisplayObject=currMC.getChildAt(cn);
					if (obj.name == p_name || getQualifiedClassName(obj) == p_name)
					{
						return true;
					}
					else if (obj is Sprite || obj is MovieClip)
					{
						if (checkParent(obj, p_name, indexOf))
						{
							return true;
						}
					}
				}
			}
			else
			{
				while (currMC != null)
				{
					if (currMC.name == p_name || getQualifiedClassName(currMC) == p_name)
					{
						blm=true;
						break;
					}
					else
					{
						currMC=currMC.parent;
					}
				}
			}
			return blm;
		}

		/**
		 * 钱币总数到金 银 铜的转换
		 */
		public function coinTransfrom(coin:String, suffix:Array=null):Array
		{
			var c:int=int(coin);
			if (suffix == null)
			{
				// return [int(c/10000),int(c/100)%100,c%100];
				return [c];
			}
			else
			{
				// return [int(c/10000)+suffix[0]+(int(c/100)%100)+suffix[1]+(c%100)+suffix[2]];
				return [c + suffix[0]];
			}
		}

		/**
		 * 目标移动
		 */
		public function moveItem(target:Object):void
		{
			PubData.mainUI.stage.addEventListener(MouseEvent.MOUSE_MOVE, targetHandler);
			function targetHandler(e:MouseEvent):void
			{
				if (target.visible)
				{
					PubData.mainUI.Layer5.addChild(target as DisplayObject);
					Mouse.hide();

					target.x=PubData.mainUI.stage.mouseX + PubData.mainUI.x;
					target.y=PubData.mainUI.stage.mouseY + PubData.mainUI.y;
				}
				else
				{
					Mouse.show();
					PubData.mainUI.stage.removeEventListener(MouseEvent.MOUSE_MOVE, targetHandler);
					if (target.parent != null)
					{
						target.parent.removeChild(target as DisplayObject);
					}
				}
				e.updateAfterEvent();
			}
		}


		//去左右空格;
		public function trim(char:String, noEnter:Boolean=true):String
		{
			if (char == null)
			{
				return null;
			}
			if (noEnter)
				char=trimEnter(char);
			return rtrim(ltrim(char));
		}

		//去左空格; 
		public function ltrim(char:String):String
		{
			if (char == null)
			{
				return null;
			}
			var pattern:RegExp=/^\s*/;
			return char.replace(pattern, "");
		}

		//去右空格;
		public function rtrim(char:String):String
		{
			if (char == null)
			{
				return null;
			}
			var pattern:RegExp=/\s*$/;
			return char.replace(pattern, "");
		}

		//去掉回车
		public function trimEnter(char:String):String
		{
			return char.replace(/[\r\n]/g, "")
		}

		//按钮不可用
		public function setUnEnable(mcObj:Object):void
		{
			mcObj.mouseEnabled=false;
			var filterObj:ColorMatrixFilter=new ColorMatrixFilter();
			filterObj.matrix=new Array(1 / 3, 1 / 3, 1 / 3, 0, 0, 1 / 3, 1 / 3, 1 / 3, 0, 0, 1 / 3, 1 / 3, 1 / 3, 0, 0, 0, 0, 0, 1, 0);
			mcObj.filters=[filterObj];
		}

		//按钮可用
		public function setEnable(mcObj:Object):void
		{
			mcObj.mouseEnabled=true;
			mcObj.filters=[];
		}

		public function initEquipIcon(item:DisplayObject):void
		{
			if (item == null)
				return;
			if (item.hasOwnProperty("qianghua"))
				item["qianghua"].gotoAndStop(1);
			if (item.hasOwnProperty("huoyan"))
				item["huoyan"].gotoAndStop(1);
			if (item.hasOwnProperty("shanbian"))
				item["shanbian"].gotoAndStop(1);
		}

		//StringUtils.initEquipIcon(e.getInfo as DisplayObject);
		//StringUtils.setEquipIcon(e.getInfo as DisplayObject, MainDrag.currData);

		public function setEquipIcon(item:DisplayObject, obj:Object):void
		{
			var enhace:int=int(obj.enhace);
			if (enhace == 0)
			{
				enhace=int(obj.strong_level);
			}
			if (enhace > 0 && enhace < 13 && item.hasOwnProperty("qianghua"))
			{
				item["qianghua"].gotoAndStop(2);
				//item["qianghua"]["num"].text = enhace + "";
				item["qianghua"]["num"].text=enhace.toString();
			}
			else if (enhace >= 13 && item.hasOwnProperty("qianghua"))
			{
				item["qianghua"].gotoAndStop(3);
			}
			if (enhace > 5 && enhace < 10)
			{
				item["huoyan"].gotoAndStop(2);
			}
			else if (enhace > 9 && enhace < 13)
			{
				item["huoyan"].gotoAndStop(3);
			}
			else if (enhace >= 13)
			{
				item["huoyan"].gotoAndStop(4);
			}
			if (int(obj.color) >= 3 || int(obj.equip_color) >= 3 || int(obj.res_color) >= 3)
			{
				item["shanbian"].gotoAndStop(2);
			}
			if (obj.hasOwnProperty("gem1") && int(obj.gem1) >= 6 && int(obj.gem2) >= 6 && int(obj.gem3) >= 6)
			{
				item["qianghua"].gotoAndStop(4);
			}
		}

		public function twoTOten(arr:Array):uint
		{
			var res:int=0;
			var arrLen:int=arr.length;
			for (var i:int=0; i < arrLen; i++)
			{
				res+=arr[i] * (Math.pow(2, i));
			}
			return res;
		}

		/**
		 *	测试两次操作时间 andy
		 */
		private var lastTime:Number=0;

		public function showTime(desc:String=""):void
		{
			if (lastTime == 0)
			{
				lastTime=new Date().time;
				trace("开始计时：====");
			}
			else
			{
				trace(desc + "耗时:" + (new Date().time - lastTime) + "毫秒");
				lastTime=new Date().time;
			}
		}
	}
}
