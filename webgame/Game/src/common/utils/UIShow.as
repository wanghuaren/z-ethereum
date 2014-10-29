package common.utils
{
	import com.greensock.TweenLite;
	
	import common.config.GameIni;
	import common.config.PubData;
	import common.managers.GameKeyBoard;
	import common.managers.Lang;
	import common.utils.component.GameMenu;
	import common.utils.component.ToolTip;
	
	import display.components.CmbArrange;
	import display.components2.UILd;
	
	import engine.load.GamelibS;
	import engine.support.ISerializable;
	import engine.utils.Debug;
	
	import fl.containers.UILoader;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.ui.ContextMenu;
	import flash.utils.getQualifiedClassName;
	import flash.xml.XMLNode;
	
	import netc.MsgPrint;
	
	import scene.utils.ContextMenuItems;
	import scene.utils.MapData;
	
	import ui.frame.ItemManager;
	import ui.base.mainStage.UI_index;


	/**
	 * @author wanghuaren
	 */
	public final class UIShow
	{
		/**
		 * 标准组件填充
		 * label:
		 * data:
		 */
		public function comboboxFill2(combobox:CmbArrange, array:Array):void
		{
			if (combobox == null)
				return;
			var len:int=array.length;
			var item:Object=null;
			var dataArray:Array=[];

			for (var i:int=0; i < len; i++)
			{
				item={label: array[i].label, data: array[i].data};

				dataArray.push(item);
			}
			combobox.addItems=dataArray;

		}

		/*
		 * ComboBox填充
		 */
		// public function comboboxFill(combobox:ComboBox,array:Array,myKey:Object):void {
		public function comboboxFill(combobox:CmbArrange, array:Array, myKey:Object):void
		{
			if (combobox == null)
				return;
			var len:int=array.length;
			var item:Object=null;
			var dataArray:Array=[];
			for (var i:int=0; i < len; i++)
			{
				for (var s:String in myKey)
				{
					item={label: array[i][s], data: array[i][myKey[s]]};
						// Debug.instance.traceMsg(item.label+","+item.data);
				}
				// combobox.addItem(item);
				dataArray.push(item);
			}
			combobox.addItems=dataArray;
			// combobox.dropdown.setRendererStyle("textFormat",CtrlFactory.getUICtrl().getTextFormat());
			// combobox.textField.setStyle("textFormat",CtrlFactory.getUICtrl().getTextFormat());
		}

		/*
		 * 元件中文本填充
		 */
		public function textFill(sprite:Sprite, itemData:Object, myKey:Object=null, specMC:Object=null, mcFunc:Function=null, funcArgs:Array=null):void
		{
			// try {
			if (sprite == null)
				return;
			var s:Object=null;
			if (myKey != null)
			{
				for (var key:String in myKey)
				{
					sprite[key]=itemData[myKey[key]];
				}
			}

			if (specMC != null)
			{
				for (s in specMC)
				{
					if (sprite[s] is TextField)
					{
						sprite[s].htmlText=specMC[s] + "";
					}
					else
					{
						var arrayMC:Array=[];
						var len:int=specMC.length;
						for (var i:int=0; i < len; i++)
						{
							arrayMC[i]=sprite[specMC[i]];
						}
						mcFunc(arrayMC, funcArgs);
					}
				}
			}
			for (s in itemData)
			{
				if (itemData == null)
				{
					return;
				}
				// sprite["data"]=itemData;
				if ((s.indexOf("movie") >= 0 || s.indexOf("ico") >= 0 || s.indexOf("card") >= 0))
				{
					if (sprite.hasOwnProperty("uil") && sprite["uil"] != null && s.indexOf("ico") >= 0)
					{
						CtrlFactory.getUICtrl().UILLoad(sprite["uil"], itemData[s]);
					}
					else if (sprite.hasOwnProperty("sp") && sprite["sp"] != null && s.indexOf("ico") >= 0)
					{
						CtrlFactory.getUICtrl().UILLoad(sprite["sp"], itemData[s]);
					}
					else if (sprite.hasOwnProperty("card") && sprite["card"] != null && s.indexOf("card") >= 0)
					{
						// fux_net
//						var card_path:String;
//						var card_skin:int=parseInt(itemData[s]);
//						var card_model:HumanResModel;
//
//						if (0 != card_skin)
//						{
//					//		card_model=XmlManager.localres.getHumanXml.getResPath(card_skin);
//						}
//
//						if (null != card_model)
//						{
//							card_path=card_model.Skin;
//						}
//
//						// CtrlFactory.getUICtrl().UILLoad(sprite["card"],itemData[s]);
//						CtrlFactory.getUICtrl().UILLoad(sprite["card"], card_path);
					}
					else if (sprite.hasOwnProperty("uilSwf") && sprite["uilSwf"] != null && s.indexOf("movie") >= 0)
					{
						CtrlFactory.getUICtrl().UILLoad(sprite["uilSwf"], itemData[s] + GameIni.suffix);
					}
				}
				else
				{
					if (sprite.hasOwnProperty(s) && sprite[s] is TextField)
					{
						sprite[s].htmlText=itemData[s] + "";
							// sprite[s].width=sprite[s].textWidth+5;
					}
					// suhang   当物品不可叠加时,不显示数量
					if (s == "r_num")
					{
						if (sprite.hasOwnProperty("r_num") && itemData.hasOwnProperty("is_stack") && int(itemData["is_stack"]) == 0)
						{
							sprite["r_num"].text="";
						}
						if (sprite.hasOwnProperty("txtnum"))
						{
							sprite["txtnum"].htmlText=itemData[s] + "";
						}
					}
				}
			}

			// CtrlFactory.getPubData()==null?"":CtrlFactory.getPubData().refresh(itemData);
			// }catch(e:Error) {
			// Debug.instance.traceMsg("文本填充错误!!!");
			// }
		}

		/*
		 * 金币 银币 铜币 填充
		 */
		// suhang 去掉银币铜币
		public function fillGSC(coinCount:int, content:Object, str:String="txt"):void
		{
			if (content.getChildByName(str + "G") == null)
				return;
			// var coin:Array=CtrlFactory.getUICtrl().coinTransfrom(coinCount+"");
			content[str + "G"].htmlText=coinCount + "";
			// content[str+"S"].htmlText=coin[1]+"";
			// content[str+"C"].htmlText=coin[2]+"";
		}

		/*
		 * 金币 银币 铜币 取总钱数
		 */
		public function getGSC(content:Object, gcsName:Array=null):int
		{
			if (gcsName == null)
			{
				gcsName=["txtG", "txtS", "txtC"];
			}
			var coin:int=content[gcsName[0]].text == "" ? 0 : int(content[gcsName[0]].text);
			// coin+=content[gcsName[0]].text==""?0:int(content[gcsName[0]].text)*10000;

			// coin+=content[gcsName[1]].text==""?0:int(content[gcsName[1]].text)*100;

			// coin+=content[gcsName[2]].text==""?0:int(content[gcsName[2]].text);
			return coin;
		}

		/*
		 * 元件中文本清空,清空Menu
		 */
		public function unTextFill(sprite:Sprite):void
		{
			if (sprite == null)
			{
				return;
			}
			var count:int=0;
			if (sprite.hasEventListener(MouseEvent.CLICK) && sprite.hasOwnProperty("menu"))
			{
				sprite.removeEventListener(MouseEvent.CLICK, sprite["menu"].f);
			}
			if (sprite.hasEventListener(MouseEvent.MOUSE_OVER) && sprite.hasOwnProperty("tFunc"))
			{
				sprite.removeEventListener(MouseEvent.MOUSE_OVER, sprite["tFunc"]);
				removeTip(sprite);
				sprite["newData"]=null;
			}

			sprite.buttonMode=false;
			sprite["data"]=null;
			while (sprite.numChildren > count)
			{
				//andy 如果是静态文本，无需修改其值为空
				if (sprite.getChildAt(count) is TextField && sprite.getChildAt(count).name.indexOf("instance") == -1)
				{
					(sprite.getChildAt(count) as TextField).htmlText="";
				}
				else if (sprite.getChildAt(count) is UILd)
				{
					(sprite.getChildAt(count) as UILd).unload();
				}
				else if (sprite.getChildAt(count) is UILoader)
				{
					(sprite.getChildAt(count) as UILoader).unload();
				}
				count++;
			}
		}

		private var colorMatrixFiltersCache:Array=[];

		/**
		 * 元件中滤镜设置
		 * 1恢复正常色 2去掉颜色(变灰) 3正常高亮 4去色高亮 5边缘发光 6 变红 7 变绿
		 */
		public function setColor(mc:DisplayObject, n:uint=2, c:Number=-1):void
		{
			if (mc == null)
				return;
			var colorMatrix:Array=colorMatrixFiltersCache[n];

//			if(null == colorMatrix){
//				
//				return;
//			}
			switch (n)
			{
				case 1:
					// 正常颜色
					if (colorMatrix == null)
					{
						colorMatrix=[1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0];
						colorMatrixFiltersCache[n]=colorMatrix;
					}
					break;
				case 2:
					// 去掉颜色-灰
					if (colorMatrix == null)
					{
						colorMatrix=[0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0];
						colorMatrixFiltersCache[n]=colorMatrix;
					}
					break;
				case 3:
					// 正常高亮
					if (colorMatrix == null)
					{
						colorMatrix=[2, 0, 0, 0, -63.5, 0, 2, 0, 0, -63.5, 0, 0, 2, 0, -63.5, 0, 0, 0, 1, 0];
						colorMatrixFiltersCache[n]=colorMatrix;
					}
					break;
				case 4:
					// 去色高亮
					if (colorMatrix == null)
					{
						colorMatrix=[0.6172, 1.2188, 0.164, 0, -63.5, 0.6172, 1.2188, 0.164, 0, -63.5, 0.6172, 1.2188, 0.164, 0, -63.5, 0, 0, 0, 1, 0];
						colorMatrixFiltersCache[n]=colorMatrix;
					}
					break;
				case 5:
					// 边缘发光
					if (colorMatrix == null)
					{
						colorMatrix=[];
					}
					var BitmapFilters:BitmapFilter=getBitmapFilter(c);
					colorMatrix.push(BitmapFilters);
					mc.filters=colorMatrix;
					return;
				case 6:
					// 红色
					if (colorMatrix == null)
					{
						colorMatrix=[1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0];
						colorMatrixFiltersCache[n]=colorMatrix;
					}
					break;
				case 7:
					// 绿色
					if (colorMatrix == null)
					{
						colorMatrix=[1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0];
						colorMatrixFiltersCache[n]=colorMatrix;
					}
					break;
			}
			mc.filters=[new ColorMatrixFilter(colorMatrix)];
		}

		private function getBitmapFilter(c:Number=0):BitmapFilter
		{
			c=c < 0 ? 0xfff5d2 : c;
			var color:Number=c;
			var alpha:Number=0.7;
			var blurX:Number=3;
			var blurY:Number=3;
			var strength:Number=8;
			var inner:Boolean=false;
			var knockout:Boolean=false;
			//var quality:Number=BitmapFilterQuality.HIGH;
			var quality:Number=BitmapFilterQuality.LOW;
			return new GlowFilter(color, alpha, blurX, blurY, strength, quality, inner, knockout);
		}

		/**
		 * 列表排版显示--desc为null显示TIP
		 */
		public function showList(container:Sprite, itemClass:Class, data:Array, count:String, itemPosition:Point=null, column:int=1, WH:Object=null, desc:Array=null, itemEvent:Function=null, tipEvent:Function=null):void
		{
			var item:Sprite=null;
			var len:int=int(count);
			var rowNum:int=0;
			var hasItem:Object={};
			for (var n:int=0; n < container.numChildren; n++)
			{
				if ((container.getChildAt(n).name.indexOf("item") == 0 && (!(container.getChildAt(n) is itemClass)) || (data.length == 0 && itemPosition != null)))
				{
					container.removeChildAt(n);
					n--;
				}
				else if (itemPosition != null && container.getChildAt(n) is itemClass)
				{
					container.getChildAt(n).visible=false;
					container.getChildAt(n).y=0;
				}
			}

			for (var i:int=0; i < len; i++)
			{
				if (data.length > rowNum)
				{
					if (data[rowNum].hasOwnProperty("pos_id") && itemPosition == null)
					{
						n=int(data[rowNum].pos_id) % len;
						n=n == 0 ? len : n;
						item=container.getChildByName("item" + n) as Sprite;
						hasItem[n + ""]="";
					}
					else
					{
						item=container.getChildByName("item" + (i + 1)) as Sprite;
						// if(item!=null&&!(item is itemClass)) {
						// container.removeChild(item);
						// item=null;
						// }
						if (item == null)
						{
							item=new itemClass();
							container.addChild(item);

							item.name="item" + (i + 1);
						}
						if (item.hasOwnProperty("bg"))
						{
							item["bg"].gotoAndStop(1);
						}
						if (itemPosition != null)
						{
							//andy 横竖间隔
							WH=WH == null ? {w: 0, h: 0} : WH;
							item.x=column == 1 ? itemPosition.x : itemPosition.x + item.width * (i % column) + int(WH.w) * i;

							item.y=column == 1 ? itemPosition.y + item.height * i + int(WH.h) * i : itemPosition.y + item.height * (int(i / column)) + int(WH.h) * i;
						}
						if (item.getChildByName("num") != null)
						{
							item["num"].htmlText=(i + 1) + ".";
						}

						hasItem[(i + 1) + ""]="";
					}
					if (item != null)
					{
						item.mouseEnabled=true;
						item.visible=true;
						if (desc == null)
						{
							addTip(item);
						}
						else
						{
							var str:String="";
							var arrayLen:int=desc.length;
							for (n=0; n < arrayLen; n++)
							{
								str+=data[rowNum][desc[n]];
							}
							str == "" ? "" : addTip(item);
						}
						if (data[rowNum] is ISerializable)
						{
							textFill(item, MsgPrint.packHelp.helpByReflect(data[rowNum]));
						}
						else
						{
							textFill(item, data[rowNum]);
						}
						itemEvent == null ? "" : itemEvent(item, data[rowNum]);
					}
					rowNum++;
				}
				if (!hasItem.hasOwnProperty((i + 1) + ""))
				{
					var sprite:Sprite=container.getChildByName("item" + (i + 1)) as Sprite;
					if (sprite != null)
					{
						unTextFill(sprite);
					}
				}
			}
		}

		/**
		 * 移除对象的ToolTips
		 */
		public function removeTip(item:DisplayObject):void
		{
			ToolTip.instance().removeTip(item);
		}

		/**
		 * 主动强制关闭当前屏幕上的任何tip
		 *
		 */
		public function closeCurrentTip():void
		{
			ToolTip.instance().notShow();
		}

		/**
		 * 向对象添加ToolTips
		 */
		public function addTip(item:DisplayObject):void
		{
			ToolTip.instance().addTip(item);
		}

		/**
		 * 向对象添加菜单
		 */
		public function addMenu(displayObject:DisplayObject, itemData:Array, handler:Function, width:int=0):void
		{
			// new Menu(sprite,itemData,handler,width);
			GameMenu.getInstance().setMenu(displayObject, itemData, {data: displayObject}, handler);
		}

		/*
		 * 移除对象菜单
		 */
		public function removeMenu(sprite:Sprite):void
		{
			// Menu.removeMenu(sprite);
			GameMenu.getInstance().setMenu(sprite);
		}

		/**
		 * 取得一个带框的文本段
		 */
		public function getTextRect():void
		{
		}


		/**
		 * fux
		 * td = target DisplayObject
		 * {td:mc["btnTidy"],ts:DirectMsg.setp.s14}
		 *
		 *
		 */
		public var tdArr:Array
		public var tdStep:Array;
		public var tdStep2:Array;
		/**
		 * 方向
		 */
		public var tdDirect:Array;
		public var tdColor:Array;

		/**
		 *   dir    1 右下 2左下  3左上 4右上
		 */
		public function addMultiDirect(tdNewArr:Array):void
		{
			if (null == tdNewArr)
			{
				throw new Error("tdNewArr can not be null");
			}

			// remove
			removeMultiDirect();

			// loop use
			var i:int;
			var len:int;
			var td:DisplayObject;

			//
			tdArr=new Array();
			tdStep=new Array();
			//string2
			tdStep2=new Array();
			tdDirect=new Array();

			len=tdNewArr.length;

			for (i=0; i < len; i++)
			{
				var tdObj:Object=tdNewArr[i];

				if (null == tdObj || "undefined" == tdObj)
				{
					throw new Error("tdObj can not be null");
				}

				if (null == tdObj.td || "undefined" == tdObj.td)
				{
					throw new Error("td can not be null");
				}

				if (null == tdObj.ts || "undefined" == tdObj.ts)
				{
					throw new Error("ts can not be null");
				}

				if (null == tdObj.dir || "undefined" == tdObj.dir)
				{
					//默认值3
					tdDirect.push(3);

				}
				else
				{
					tdDirect.push(tdObj.dir);
				}

				if (null == tdObj.ts2 || "undefined" == tdObj.ts2)
				{
					//默认值""
					tdStep2.push("");

				}
				else
				{
					tdStep2.push(tdObj.ts2);
				}

				tdArr.push(tdObj.td);
				tdStep.push(tdObj.ts);

				/*if(null == tdObj.tc  || "undefined" == tdObj.tc)
				{
				tdColor.push(
				}*/
			}

			//
			len=tdArr.length;

			for (i=0; i < len; i++)
			{
				var p:Point;
				td=tdArr[i];
				var ts:int=tdStep[i];
				var dir:int=tdDirect[i];
				var ts2:String=tdStep2[i];

				if (null != td.parent)
				{
					p=td.globalToLocal(td.parent.localToGlobal(new Point(td.x, td.y)));
					p.x+=td.width / 2;
					p.y+=td.height / 2;


					var dirMsg2Str:String; //=DirectMsg.directMSG2[ts];

					if (dirMsg2Str.indexOf("%s") > -1 && "" != ts2)
					{
						dirMsg2Str=dirMsg2Str.replace("%s", ts2);
					}

						// "this is addMultiDirect"
//					new ToolTip(null).addMultiTip(p, dirMsg2Str, td, i, dir);

				}
				else
				{
					p=new Point(td.x, td.y);
					p.x+=td.width / 2;
					p.y+=td.height / 2;
				}
			}
		}

		/**
		 *
		 */
		public function removeMultiDirect(DO:DisplayObject=null):void
		{
			// loop use
			var i:int;
			var len:int;
			var td:DisplayObject;
			// remove

			if (null != tdArr)
			{
				len=tdArr.length;
				if (DO != null)
				{
					if (len != 0 && tdArr[0].hasOwnProperty("parent") && tdArr[0].parent.hasOwnProperty("directionMC0"))
					{
						if (!CtrlFactory.getUICtrl().checkParent(tdArr[0].parent.getChildByName("directionMC0"), getQualifiedClassName(DO)))
						{
							return;
						}
					}
				}
				for (i=0; i < len; i++)
				{
					td=tdArr[i];

					removeMultiTip(td, i);
				}

				// destory
				len=tdArr.length;
				for (i=0; i < len; i++)
				{
					tdArr.pop();
				}

				len=tdStep.length;
				for (i=0; i < len; i++)
				{
					tdStep.pop();
				}

				len=tdDirect.length;
				for (i=0; i < len; i++)
				{
					tdDirect.pop();
				}

			}
		}

		// fux
		public function removeMultiTip(td:DisplayObject, i:int):void
		{
			var mc:Sprite;
			var mc_name:String="directionMC" + i.toString();

			if (null != td)
			{
				if (null != td.parent)
				{
					// td.parent.removeChild(td);

					var dMC:DisplayObject=td.parent.getChildByName(mc_name) as DisplayObject;

					if (null != dMC)
					{
						td.parent.removeChild(dMC);
					}
				}
			}
		}

		/**
		 * 添加指引向导 addMC 父容器 direct 箭头位置(0自动 1 右下 2左下  3左上 4右上) removeContent上步要删除对象的父容器
		 */
		public function addDirect(DO:DisplayObject, step:int, addMC:Sprite=null, direct:int=0, removeContent:Sprite=null, DO2:DisplayObject=null, addMC2:Sprite=null, step2:int=0):void
		{
//			Guide.removeMC1=addMC;
//			Guide.removeMC2=addMC2;
//			if (DO != null && DO.parent != null)
//			{
//				var can:int=30;
//				//var status:Array=PubData.newStep.split(",");
//				var canUpdata:Boolean=false;
//				if (step > 10 && step < 20)
//				{
//					if ((status[0] != 0))
//					{
//						return;
//					}
//					else if (step == 19 || int(PubData.level) > can)
//					{
//						Guide.setNewStepComplete(1);
//					}
//				}
//				if (step == 21)
//				{
//					if ((status[2] != 0))
//					{
//						// 杀怪指引
//						// CtrlFactory.getUIShow().removeDirect(addMC);
//						return;
//					}
//					else if (step == 21 || int(PubData.level) > can)
//					{
//						Guide.setNewStepComplete(2);
//					}
//				}
//				if (step > 30 && step < 34)
//				{
//					if ((status[3] != 0))
//					{
//						// 技能指引
//						// CtrlFactory.getUIShow().removeDirect(addMC);
//						return;
//					}
//					else if (step == 33 || int(PubData.level) > can)
//					{
//						Guide.setNewStepComplete(3);
//					}
//				}
//				if (step > 40 && step < 49)
//				{
//					if ((status[3] != 0))
//					{
//						// 帮派指引
//						// CtrlFactory.getUIShow().removeDirect(addMC);
//						return;
//					}
//					else if (step == 46 || int(PubData.level) > can)
//					{
//						Guide.setNewStepComplete(4);
//					}
//				}
//				if (step > 50 && step < 61)
//				{
//					if ((status[4] != 0))
//					{
//						// suhang
//						return;
//					}
//					else if (step == 60 || int(PubData.level) > can)
//					{
//						Guide.setNewStepComplete(5);
//					}
//				}
//				if (step == 61)
//				{
//					if ((status[6] != 0))
//					{
//						// 传送指引
//						// CtrlFactory.getUIShow().removeDirect(addMC);
//						return;
//					}
//					else if (step == 61 || int(PubData.level) > can)
//					{
//						Guide.setNewStepComplete(6);
//						UIActMap.wsWelcome=true;
//					}
//				}
//				if (step == 71)
//				{
//					if (status[7] != 0)
//					{
//						// 調車復活點指引
//						// CtrlFactory.getUIShow().removeDirect(addMC);
//						return;
//					}
//					else if (step == 75 || int(PubData.level) > can)
//					{
//						Guide.setNewStepComplete(7);
//					}
//				}
//
//				if (step > 130 && step < 140)
//				{
//					if ((status[12] != 0))
//					{
//						// suhang
//						return;
//					}
//					else if (step == 139 || int(PubData.level) > can)
//					{
//						Guide.setNewStepComplete(13);
//					}
//				}
//				if (step > 120 && step < 130)
//				{
//					if ((status[11] != 0))
//					{
//						// suhang
//						return;
//					}
//					else if (step == 129 || int(PubData.level) > can)
//					{
//						Guide.setNewStepComplete(12);
//					}
//				}
//				if (step > 150 && step < 160)
//				{
//					if ((status[14] != 0))
//					{
//						// suhang
//						return;
//					}
//					else if (step == 159 || int(PubData.level) > can)
//					{
//						Guide.setNewStepComplete(15);
//					}
//				}
//				if (step > 180 && step < 190)
//				{
//					if ((status[17] != 0))
//					{
//						// suhang
//						return;
//					}
//					else if (step == 187 || int(PubData.level) > can)
//					{
//						Guide.setNewStepComplete(18);
//					}
//				}
//				if (step > 230 && step < 240)
//				{
//					if ((status[22] != 0))
//					{
//						// suhang
//						return;
//					}
//					else if (step == 235 || int(PubData.level) > can)
//					{
//						Guide.setNewStepComplete(23);
//					}
//				}
//				if (step > 240 && step < 251)
//				{
//					if ((status[23] != 0))
//					{
//						// suhang
//						return;
//					}
//					else if (step == 250 || int(PubData.level) > can)
//					{
//						Guide.setNewStepComplete(24);
//					}
//				}
//
//				CtrlFactory.getUIShow().removeDirect(removeContent);
//				CtrlFactory.getUIShow().removeDirect(addMC);
//
//				// suhang
//				var p:Point=null;
//				var p2:Point=null;
//				if (Guide.glint1 == null)
//				{
//					Guide.glint1=GamelibS.getswflink("game_index", "提示框") as Sprite;
//					Guide.glint2=GamelibS.getswflink("game_index", "提示框") as Sprite;
//				}
//				Guide.glint1.width=DO.width + 8;
//				Guide.glint1.height=DO.height + 8;
//				if (addMC == null || addMC == PubData.mainUI)
//				{
//					p=DO.parent.localToGlobal(new Point(DO.x, DO.y));
//					p.x+=DO.width / 2;
//					p.y+=DO.height / 2;
//					//andy indexUI单独使用红色框框
//					var index_glint:Sprite=GamelibS.getswflink("game_index", "提示框") as Sprite;
//					index_glint.width=DO.width + 8;
//					index_glint.height=DO.height + 8;
//					index_glint.x=p.x - 1;
//					index_glint.y=p.y - 1;
//					index_glint.name="index_glint" + DO.name;
//					//PubData.mainUI.addChild(index_glint);
//					PubData.mainUI.Layer5.addChild(index_glint);
//				}
//				else
//				{
//					p=addMC.globalToLocal(DO.parent.localToGlobal(new Point(DO.x, DO.y)));
//					p.x+=DO.width / 2;
//					p.y+=DO.height / 2;
//					Guide.glint1.x=p.x - 1;
//					Guide.glint1.y=p.y - 1;
//					//任务文字指引框太靠右
//					if (Guide.glint1.width > 150 && Guide.glint1.height < 30)
//					{
//						Guide.glint1.x-=12;
//					}
//					addMC.addChild(Guide.glint1);
//				}
//
////				new ToolTip(null).addPointTip(p, DirectMsg.getDirectMsg(step), addMC, direct, true, DO.name);
//
//				if (DO2 != null)
//				{
//					Guide.glint2.width=DO2.width + 8;
//					Guide.glint2.height=DO2.height + 8;
//					if (addMC2 == null)
//					{
//						p2=DO2.parent.localToGlobal(new Point(DO2.x, DO2.y));
//						p2.x+=DO2.width / 2;
//						p2.y+=DO2.height / 2;
//						Guide.glint2.x=p2.x - 1;
//						Guide.glint2.y=p2.y - 1;
//						//PubData.mainUI.addChild(Guide.glint2);
//						PubData.mainUI.Layer5.addChild(Guide.glint2);
//						
//					}
//					else
//					{
//						p2=addMC2.globalToLocal(DO2.parent.localToGlobal(new Point(DO2.x, DO2.y)));
//						p2.x+=DO2.width / 2;
//						p2.y+=DO2.height / 2;
//						Guide.glint2.x=p2.x - 1;
//						Guide.glint2.y=p2.y - 1;
//						addMC2.addChild(Guide.glint2);
//					}
////					new ToolTip(null).addPointTip(p2, DirectMsg.getDirectMsg(step2), addMC2, direct, false);
//				}
//				copyClick(DO, DO2);
//				if (UI_index.indexMC != null) {
//					UI_index.indexMC["directMissionTrack"].visible = false;
//				}
			// }
//			}
		}

		/**
		 * 指引蒙版
		 */
		private function copyClick(target:DisplayObject, target2:DisplayObject):void
		{
			GameKeyBoard.hotKeyEnabled=false;
		/*if (target != null)
		{
			var p:Point=target.parent.localToGlobal(new Point(target.x, target.y));
			var p2:Point;
			var rect:Sprite=new Sprite();
			with (rect.graphics)
			{
				beginFill(0x000000, 0.5);
				drawRect(0, 0, GameIni.MAP_SIZE_W, GameIni.MAP_SIZE_H);
				if (target2 != null)
				{
					//var p2 : Point = target2.parent.localToGlobal(new Point(target2.x, target2.y));
					p2=target2.parent.localToGlobal(new Point(target2.x, target2.y));
					drawRect(p2.x, p2.y, target2.width, target2.height);
				}
				drawRect(p.x, p.y, target.width, target.height);
				endFill();
			}

			PubData.mainUI.Layer5.addChild(rect);

			rect.name="WARREN_DIRECT";
		}*/
		}

		/**
		 * 删除指引向导
		 */
		public function removeDirect(DO:DisplayObject=null):void
		{
//			new ToolTip(null).removePointTip(DO);
		}

		public function fillBar(arrayMC:Array, hmp:Array):void
		{
			if (arrayMC[0] != null)
			{
				//TweenLite.to(arrayMC[0], 0.5, {scaleX: hmp[0] / hmp[1] > 1 ? 1 : hmp[0] / hmp[1]});
				TweenLite.to(arrayMC[0], 0.25, {scaleX: hmp[0] / hmp[1] > 1 ? 1 : hmp[0] / hmp[1]});
				if (arrayMC[0].scaleX < 0)
				{
					arrayMC[0].scaleX=0;
				}
			}
			if (arrayMC[1] != null)
			{
				//TweenLite.to(arrayMC[1], 0.5, {scaleX: hmp[2] / hmp[3] > 1 ? 1 : hmp[2] / hmp[3]});
				TweenLite.to(arrayMC[1], 0.25, {scaleX: hmp[2] / hmp[3] > 1 ? 1 : hmp[2] / hmp[3]});
				if (arrayMC[1].scaleX < 0)
				{
					arrayMC[1].scaleX=0;
				}
			}
			if (arrayMC[2] != null)
			{
				//TweenLite.to(arrayMC[2], 0.5, {scaleX: hmp[4] / hmp[5] > 1 ? 1 : hmp[4] / hmp[5]});
				TweenLite.to(arrayMC[2], 0.25, {scaleX: hmp[4] / hmp[5] > 1 ? 1 : hmp[4] / hmp[5]});
				if (arrayMC[2].scaleX < 0)
				{
					arrayMC[2].scaleX=0;
				}
			}
		}

		/*
		 * 创建一个填充数据后的树形菜单
		 */
		private function getIndex(array:Array, key:String):int
		{
			var arrayLen:int=array.length;
			for (var i:int=0; i < arrayLen; i++)
			{
				if (array[i].t == key)
				{
					return i;
				}
			}
			return -1;
		}

		private var currItemMC1:MovieClip=null;

		public function showTree(array:Array, itemField:Array, key:String, arrayItemMC:Array, pos:Point=null, itemEvent:Function=null, showNum:int=0):MovieClip
		{
			pos=pos == null ? new Point(0, 0) : pos;
			var data:Array=[];
			var len:int=array.length;
			for (var i:int=0; i < len; i++)
			{
				if (getIndex(data, array[i][itemField[0]]) < 0)
				{
					data.push({t: array[i][itemField[0]], a: []});
				}
				if (getIndex(data[getIndex(data, array[i][itemField[0]])].a, array[i][itemField[1]]) < 0)
				{
					data[getIndex(data, array[i][itemField[0]])].a.push({t: array[i][itemField[1]], id: array[i][key]});
				}
			}
			var mc:MovieClip=new MovieClip();
			var sprite:Sprite=null;
			var panel1:MovieClip=null;
			var count:int=0;
			mc.addEventListener(MouseEvent.MOUSE_DOWN, treeHandler);
			mc["func"]=treeHandler;
			for (var s:* in data)
			{
				sprite=new arrayItemMC[0]();
				sprite.buttonMode=true;
				if (sprite.hasOwnProperty("btn"))
				{
					sprite["btn"].gotoAndStop(1);
				}
				sprite.mouseChildren=false;
				sprite.x=pos.x;
				sprite.y=pos.y + (sprite.height + 5) * count;
				sprite["title"].htmlText=data[s].t + "";
				mc.addChild(sprite);
				count++;
				panel1=new MovieClip();
				panel1.x=pos.x + 20;
				panel1.y=pos.y + (sprite.height + 5) * count;
				panel1["h"]=sprite.height + 5;
				mc.addChild(panel1);
				sprite["mc"]=panel1;
				panel1.name="l1" + count;
				if (showNum < len && showNum >= 0 && s != showNum)
				{
					panel1.visible=false;
					if (sprite.hasOwnProperty("btn"))
					{
						sprite["btn"].gotoAndStop(2);
					}
				}
				else
				{
					if (sprite.hasOwnProperty("btn"))
					{
						sprite["btn"].gotoAndStop(1);
					}
				}
				for (var ss:* in data[s].a)
				{
					sprite=new arrayItemMC[1]();
					sprite.buttonMode=true;
					if (sprite.hasOwnProperty("btn"))
					{
						sprite["btn"].gotoAndStop(1);
					}
					sprite.mouseChildren=false;
					sprite.x=-5;
					sprite.y=panel1["h"] * ss;
					sprite["title"].htmlText=data[s].a[ss].t + "";
					panel1.addChild(sprite);
					sprite["d"]={id: data[s].a[ss]["id"], t: data[s].a[ss].t};
					if (panel1.visible)
						count++;
				}
				panel1["h"]=panel1.height;
			}
			function treeHandler(e:MouseEvent):void
			{
				if (e.target.hasOwnProperty("mc"))
				{
					currItemMC1 == null ? "" : currItemMC1.gotoAndStop(1);
					currItemMC1=e.target as MovieClip;
					currItemMC1.gotoAndStop(2);
					e.target["mc"].visible=!e.target["mc"].visible;
					if (e.target.hasOwnProperty("btn"))
					{
						if (e.target["mc"].visible)
						{
							e.target["btn"].gotoAndStop(1);
						}
						else
						{
							e.target["btn"].gotoAndStop(2);
						}
					}
					var len:int=mc.numChildren;
					var tmc:MovieClip=null;
					for (var i:int=0; i < len; i++)
					{
						tmc=mc.getChildAt(i) as MovieClip;
						if (tmc.name.indexOf("l1") >= 0)
						{
							if (tmc.name == e.target["mc"].name)
							{
								var offset:int=tmc.visible ? tmc.height : -tmc.height;
								i++;
								while (i < len)
								{
									mc.getChildAt(i).y+=offset;
									i++;
								}
								return;
							}
						}
					}
				}
				else if (e.target.hasOwnProperty("d"))
				{
					currItemMC1 == null ? "" : currItemMC1.gotoAndStop(1);
					currItemMC1=e.target as MovieClip;
					currItemMC1.gotoAndStop(2);
					itemEvent(e.target["d"], e.target);
				}
			}
			return mc;
		}




		/*
		 * 按钮选中显示状态
		 */
		public function changeColor(content:Sprite, mark:String, num:int, key:String, arrayMC:Array=null):void
		{
			if (arrayMC == null)
			{
				for (var i:int=1; i < num + 1; i++)
				{
					content.getChildByName(mark + i) == null ? "" : setColor(content.getChildByName(mark + i), 1);
				}
			}
			else
			{
				var len:int=arrayMC.length;
				for (i=1; i < len; i++)
				{
					content.getChildByName(arrayMC[i]) == null ? "" : setColor(content.getChildByName(arrayMC[i]), 1);
				}
			}
			setColor(content.getChildByName(key), 3);
		}

		/**
		 * 文本框点击改变颜色
		 */
		public function addTextColorEvent(targetText:TextField):void
		{
			if (targetText == null)
				return;
			var htmlText:String=targetText.htmlText;

			targetText.hasEventListener(MouseEvent.MOUSE_DOWN) ? "" : targetText.addEventListener(MouseEvent.MOUSE_DOWN, textDownHandler);
			function textDownHandler(e:MouseEvent):void
			{
				htmlText=targetText.htmlText;
				targetText.setTextFormat(CtrlFactory.getUICtrl().getTextFormat({color: 0xffff00}));
				targetText.hasEventListener(MouseEvent.MOUSE_UP) ? "" : targetText.addEventListener(MouseEvent.MOUSE_UP, textUpHandler);
			}
			// function textHandler(e:TextEvent):void {
			// targetText.removeEventListener(TextEvent.LINK,textHandler);
			// }
			function textUpHandler(e:MouseEvent):void
			{
				targetText.removeEventListener(MouseEvent.MOUSE_UP, textUpHandler);

				targetText.htmlText=htmlText + "";
			}
		}

		/*
		 * 画网格矩阵
		 */
		public function drawMatrix(len:Object, initData:Array=null):void
		{
			var v:int=0, h:int=0, cv:int=GameIni.MAP_SIZE_W / len.lx, ch:int=GameIni.MAP_SIZE_H / len.ly;
			var array:Array=[];
			var shape:Shape=new Shape();
			var spr:MovieClip=null;
			var cm:Object=null;
			var isShit:Boolean=false;
			for (v=0; v < cv + 1; v++)
			{
				with (shape.graphics)
				{
					lineStyle(1, 0x999999);
					moveTo(v * len.lx, 0);
					lineTo(v * len.lx, GameIni.MAP_SIZE_H);
					endFill();
				}
			}
			for (h=0; h < ch + 1; h++)
			{
				with (shape.graphics)
				{
					lineStyle(1, 0x999999);
					moveTo(0, h * len.ly);
					lineTo(GameIni.MAP_SIZE_W, h * len.ly);
					endFill();
				}
			}
			PubData.mainUI.stage.addChild(shape);
			PubData.mainUI.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
			PubData.mainUI.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpListener);
			function keyDownListener(e:KeyboardEvent):void
			{
				if (PubData.mainUI.stage.focus is TextField)
				{
					return;
				}
				if (e.keyCode == 16)
				{
					isShit=true;
				}
			}
			function keyUpListener(e:KeyboardEvent):void
			{
				if (e.keyCode == 16)
				{
					isShit=false;
					cm=null;
				}
			}
			for (v=0; v < cv; v++)
			{
				var arr:Array=[];
				for (h=0; h < ch; h++)
				{
					arr[h]=0;
					spr=new MovieClip();

					spr.addChild(CtrlFactory.getUICtrl().getRect(len.lx, len.ly));

					PubData.mainUI.stage.addChild(spr);
					spr.name="mc_" + v + "_" + h;
					spr.x=v * len.lx;
					spr.y=h * len.ly;
					spr["px"]=v;
					spr["py"]=h;
					spr.mouseChildren=false;
					if (initData == null)
					{
						spr.alpha=0;
					}
					else
					{
						if (initData[v][h] == 0)
						{
							spr.alpha=0;
						}
						else if (initData[v][h] == 1)
						{
							spr.alpha=1;
						}
						else if (initData[v][h] == 2)
						{
							spr.alpha=1;
							setColor(spr, 4);
						}
						arr[h]=initData[v][h];
					}
					spr.addEventListener(MouseEvent.CLICK, listener);
					PubData.mainUI.stage.addEventListener(MouseEvent.MOUSE_WHEEL, dcListener);
				}
				array[v]=arr;
			}
			function listener(e:MouseEvent):void
			{
				// setColor(e.target as Sprite,1);
				if (isShit)
				{
					if (cm == null)
					{
						cm=e.target;
					}
					else
					{
						if (cm.px > e.target.px)
						{
							v=e.target.px;
							cv=cm.px;
						}
						else
						{
							v=cm.px;
							cv=e.target.px;
						}
						if (cm.py > e.target.py)
						{
							h=e.target.py;
							ch=cm.py;
						}
						else
						{
							h=cm.py;
							ch=e.target.py;
						}
						for (var i:int=v; i < cv + 1; i++)
						{
							for (var ii:int=h; ii < ch + 1; ii++)
							{
								var spr:Sprite=PubData.mainUI.stage.getChildByName("mc_" + i + "_" + ii) as Sprite;
								spr.alpha=cm.alpha;

								if (cm.alpha == 0)
								{
									array[i][ii]=0;
									setColor(spr, 1);
								}
								else
								{
									if (array[i][ii] == 0)
									{
										setColor(spr, 1);
										array[i][ii]=1;
									}
									else if (array[i][ii] == 1)
									{
										setColor(spr, 4);
										array[i][ii]=2;
									}
									else if (array[i][ii] == 2)
									{
										spr.alpha=0;
										setColor(spr, 1);
										array[i][ii]=0;
									}
								}
							}
						}
							// e.target.alpha=e.target.alpha==0?1:0;
					}
				}
				else
				{
					if (array[e.target.px][e.target.py] == 0)
					{
						array[e.target.px][e.target.py]=1;
						e.target.alpha=1;
						setColor(e.target as Sprite, 1);
					}
					else if (array[e.target.px][e.target.py] == 1)
					{
						array[e.target.px][e.target.py]=2;
						e.target.alpha=1;
						setColor(e.target as Sprite, 4);
					}
					else if (array[e.target.px][e.target.py] == 2)
					{
						array[e.target.px][e.target.py]=0;
						e.target.alpha=0;
						setColor(e.target as Sprite, 1);
					}
				}
				//Debug.instance.traceMsg(e.target.px + "," + e.target.py);
			}
			function dcListener(e:MouseEvent):void
			{
				var dx:int=array.length;
				var str:String="[";
				for (var i:int=0; i < dx; i++)
				{
					var dy:int=array[i].length;
					str+="[";
					for (var ii:int=0; ii < dy; ii++)
					{
						str+=array[i][ii] + ",";
					}
					str=str.substr(0, str.length - 1);
					str+="],";
				}
				str+="]";
				Debug.instance.traceMsg(str);
			}
		}

		// --------------------------------
		// public function formatIMG(content:Object,str:String,row:int=3):void {
		// var UILArray:Array=content["UILArray"];
		// var uil:UILoader=null;
		// var arr:Array=null;
		// var array:Array=str.split(";");
		// var count:int=0;
		// var arrayLen:int=array.length;
		// content.mc["txtContent"].htmlText+="任务奖励:\n";
		// str="";
		// for(var i:int=0;i < arrayLen;i++) {
		//
		// arr=array[i].split(",");
		//
		// if(arr[0]!="") {
		//
		// if(UILArray.length > count) {
		//
		// uil=UILArray[count];
		// } else {
		//
		// uil=new UILoader();
		// UILArray.push(uil);
		// }
		// uil.visible=true;
		// count++;
		// CtrlFactory.getUICtrl().UILLoad(uil,arr[0].split(":")[0]);
		//
		// str+="[X]"+arr[1];
		// content.mc.addChild(uil);
		// } else {
		// str+=arr[1];
		// }
		// if(i%row==(row-1)||i==arrayLen-1) {
		// content.mc["txtContent"].htmlText+="\n        "+str+"\n";
		// str="";
		// }
		// }
		// var rect:Rectangle=null;
		// for(i=0;i < count;i++) {
		// rect=content.mc["txtContent"].getCharBoundaries(content.mc["txtContent"].text.indexOf("[X]"));
		// UILArray[i].x=content.mc["txtContent"].x+rect.x;
		// UILArray[i].x+=12;
		// UILArray[i].y=content.mc["txtContent"].y+rect.y-rect.height;
		// if(row==3) {
		// content.mc["txtContent"].htmlText=content.mc["txtContent"].htmlText.replace("[X]","                ");
		// }else if(row==2) {
		// content.mc["txtContent"].htmlText=content.mc["txtContent"].htmlText.replace("[X]","        ");
		// }
		// UILArray[i].width=35;
		// UILArray[i].height=35;
		// }
		// }
		public function formatText(taskDesc:String):String
		{
			if (taskDesc == null)
				return "";
			taskDesc=taskDesc.replace(/\r/g, "");
			var desc:String="";
			var dataArray:Array=null;
			while (taskDesc != null && taskDesc.indexOf("{") >= 0)
			{
				dataArray=taskDesc.substr(1 + taskDesc.indexOf("{"), taskDesc.indexOf("}") - taskDesc.indexOf("{") - 1).split(":");
				// Debug.instance.traceMsg(dataArray[0],",",dataArray[1]);
				desc="<a href='event:" + dataArray[1] + "@1@1'><u><font color='#48D9D2'>" + dataArray[0] + "</font></u></a>";
				// desc="<a href='event:"+dataArray[1]+"@1@1'><u>"+dataArray[0]+"</u></a>";
				taskDesc=taskDesc.replace("{" + dataArray[0] + ":" + dataArray[1] + "}", desc);
			}
			return taskDesc;
		}

		/**
		 *	设置按钮 可用【正常色】;不可用【灰色】
		 */
		public function setBtnEnabled(dis:InteractiveObject, status:Boolean=true):void
		{
			if (dis == null)
				return;
			if (status)
			{
				dis.mouseEnabled=true;
				CtrlFactory.getUIShow().setColor(dis, 1);
			}
			else
			{
				dis.mouseEnabled=false;
				CtrlFactory.getUIShow().setColor(dis);
			}
		}

		/**
		 * 显示对象排列 (布局)
		 * @param dc    需要排列的容器
		 * @param cell  列
		 * @param wt    宽
		 * @param ht    高
		 */
		public function showList2(dc:DisplayObjectContainer, cell:int=1, wt:int=0, ht:int=0):void
		{
			if (dc == null)
				return;
			if (dc.numChildren == 0)
				return;
			if (wt == 0)
			{
				wt=dc.getChildAt(0).width;
			}
			if (ht == 0)
			{
				ht=dc.getChildAt(0).height;
			}
			var len:int=dc.numChildren;
			var rowIndex:int=0;
			var cellIndex:int=0;
			var child:Object=null;
			for (var m:int=0; m < len; m++)
			{
				child=dc.getChildAt(m);
				if (m % cell == 0)
				{
					rowIndex=m / cell;
					cellIndex=0;
				}
				child.x=cellIndex * wt;
				child.y=rowIndex * ht;
				cellIndex++;
			}
		}

		/**
		 *	小地图画导航点
		 */
		public function DrawPathLine(parents:DisplayObjectContainer, mc:Sprite, path:Array, beiW:Number, beiH:Number, lineStyle:Number=3, length:Number=2, color:uint=0xff0000):Array
		{
			if (path == null)
				path=[];
			//复制一个路径，不改变原数组
			path=path.concat();
			var count:int=0;
			var len:int=5;
			var i:int=0;
			var p1:Point=new Point();
			var p2:Point=new Point();
			var xx:int=0;
			var yy:int=0;
			//while (mc.numChildren > 0)
				//mc.removeChildAt(0);
				mc.graphics.clear();
				mc.graphics.lineStyle(2,0,0,true);
				mc.graphics.beginFill(0xf9a41f);
			var sort:int=0;
			for (var s:* in path)
			{
				if (s > 0 && path[s].x > 0 && path[s].y > 0)
				{
					p1.x=path[s - 1].x*MapData.TW;
					p1.y=path[s - 1].y*MapData.TH;
					p2.x=path[s].x*MapData.TW;
					p2.y=path[s].y*MapData.TH;
					if (p1.x > 0 && p1.y > 0 && p2.x > 0 && p2.y > 0)
					{
						p1.x=int(p1.x / beiW);
						p1.y=int(p1.y / beiH);
						p2.x=int(p2.x / beiW);
						p2.y=int(p2.y / beiH);

						xx=p1.x - p2.x;
						yy=p1.y - p2.y;

						len=int(Math.sqrt(Math.pow(xx, 2) + Math.pow(yy, 2)));
						count=int(len / 3);
						count=int(len / 3);
						for (i=0; i < count; i++)
						{
//							sort++;
//							var sp:Sprite=ItemManager.instance().getMapPoint(sort);
//							if(sp!=null){
//								sp.x=p1.x - xx * i / count;
//								sp.y=p1.y - yy * i / count;
//								mc.addChild(sp);
//							}
							mc.graphics.drawCircle((p1.x-xx*i/count),(p1.y-yy*i/count),2);
						}
					}

				}
			}
			//mc.graphics.endFill();

			return path;
		}

		/**
		 *	锁屏
		 */
		private var _Enabled:Sprite=new Sprite();

		public function SetIndexEnabled(bo:Boolean, color:uint=0xA60000):void
		{
			if (bo)
			{
				_Enabled.graphics.clear();
			}
			else
			{
				//UI_index.indexMC.addChild(_Enabled);	
				_Enabled.graphics.clear();
					//_Enabled.graphics.beginFill(color,0.2);
					//_Enabled.graphics.drawRect(0,0,GameIni.MAP_SIZE_W,GameIni.MAP_SIZE_H);
					//_Enabled.graphics.endFill();
			}
		}
		/**
		 *	鼠标右键
		 */
		private var cm:ContextMenu=null;

		public function AddGameMenu():void
		{
			if (cm == null)
			{
				var xml:XML=GameIni.GAMELOADXML;
				xml.appendChild(<Menu name="chongzhi" str="充值" link={GameIni.url_pay}/>);
				var cms:ContextMenuItems;
				cm=new ContextMenu();
				cm.hideBuiltInItems();
				PubData.mainUI.contextMenu=cm;
				for (var s:* in xml[0].Menu)
				{
					if (xml.Menu[s].@name == "chongzhi")
					{
						xml.Menu[s].@link=GameIni.url_pay;
					}
					else if (xml.Menu[s].@name == "guanwang")
					{
						xml.Menu[s].@link=GameIni.url_home;
					}
					else if (xml.Menu[s].@name == "luntan")
					{
						xml.Menu[s].@link=GameIni.url_bbs;
					}
					cms=new ContextMenuItems(xml.Menu[s].@str, xml.Menu[s], clickMenu, false, true, true);
					cm.customItems.push(cms.getContextMenuItem());
				}

				cms=new ContextMenuItems("version:" + GameIni.ver, null, null, false, false, true);
				cm.customItems.push(cms.getContextMenuItem());

				// xml = XML("<s><Menu name=\"全屏切换\"/></s>");
				// cms = new ContextMenuItems(xml.Menu.@name, xml.Menu, clickMenu, false, true, true);
				// cm.customItems.push(cms.getContextMenuItem());
				function clickMenu(MenuData:Object):void
				{
					if (MenuData == null)
						return;
					if (MenuData.hasOwnProperty("@name"))
					{
						if (MenuData.@name.indexOf("shoucang") != -1)
						{
							CallAddFavorite();
						}
						//else if (MenuData.@name.indexOf("全屏切换") != -1)
						else if (MenuData.@name.indexOf(Lang.getLabel("pub_switch_full_screen")) != -1)
						{
							// PubData.mainUI.stage.displayState = PubData.mainUI.stage.displayState == "normal" ? "fullScreen" : "normal";
						}
						else
						{
							if (MenuData.@link != "")
								flash.net.navigateToURL(new URLRequest(MenuData.@link), "_blank");
						}
					}
				}
			}
		}

		public function CallAddFavorite():void
		{
			ExternalInterface.call("bookmark");
		}

		public function setfilters(txt:TextField):void
		{
			txt.filters=[];
			var myDropFilter:DropShadowFilter=new DropShadowFilter(0, 0, 0x000000, 1, 3, 3, 10, 1, false, false);
			var tarr:Array=[];
			tarr=txt.filters;
			tarr.push(myDropFilter);
			txt.filters=tarr;
		}
	}
}
