package ui.view.view4.chengjiu
{
	import com.greensock.TweenLite;
	import com.xh.display.XHButton;
	
	import common.config.GameIni;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_AchievementResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	
	import engine.event.DispatchEvent;
	import engine.load.GamelibS;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import model.chengjiu.ChengjiuEvent;
	import model.chengjiu.ChengjiuModel;
	
	import netc.Data;
	import netc.DataKey;
	import netc.dataset.MyCharacterSet;
	import netc.packets2.StructActInfo2;
	import netc.packets2.StructActRecInfo2;
	
	import nets.packets.PacketCSGetArPrize;
	import nets.packets.PacketSCGetArPrize;
	import nets.packets.StructActRecInfo;
	
	import scene.music.GameMusic;
	import scene.music.WaveURL;
	
	import ui.base.paihang.PaiHang;
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view7.UI_Exclamation;
	
	import world.FileManager;

	public class ChengjiuWin extends UIWindow
	{
		private var sp:Sprite=null;
		
		
		public function ChengjiuWin(DO:DisplayObject=null, arrayData:Object=null, layer:int=1, addLayer:Boolean=true)
		{
			super(getLink(WindowName.win_cheng_jiu));
		}
		private static var _instance:ChengjiuWin;

		public static function getInstance():ChengjiuWin
		{
			if (_instance == null)
				_instance=new ChengjiuWin();
			return _instance;
		}


		public function setType(v:int, must:Boolean=false):void
		{
			type=v;
			super.open(must);
		}

		override public function open(must:Boolean=false, type:Boolean=true):void
		{
			super.open(must, type);
			//			DataKey.instance.register(PacketSCWingLevelUp.id, chibangSCWingLevelUp);
			//			Data.myKing.addEventListener(MyCharacterSet.WING_UPDATA, _wing_updata);
		}

		override protected function init():void
		{
			super.init();
			super.blmBtn=2;
			Data.myKing.addEventListener(MyCharacterSet.CHENGJIU_UPDATA, _chengJiuPoint_updata);
			Data.myKing.addEventListener(MyCharacterSet.SUI_PIAN3_UPD, pageChengjiu);
			ChengjiuModel.getInstance().addEventListener(ChengjiuEvent.CHENG_JIU_EVENT, _processEvent);
			if(sp==null){
				sp=new Sprite();
				mc.addChild(sp);
			}
			if (type == 0)
				type=1;
			mcHandler({name: "cbtn" + type});
			showGetCount();
		}
		private var idx:int=1;

		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			var name:String=target.name;

			if (name.indexOf("cbtn") >= 0)
			{
				type=int(name.replace("cbtn", ""));
				(mc as MovieClip).gotoAndStop(type);
				mc["slider_sp"].visible=true;
				if (type == 2)
				{
					mc["slider_sp"].visible=false;
					Chengjiu_zhanpao.getInstance().setUi(mc);
					return;
				}
				else if (type == 1)
				{

					clickChengjiu();
				}

			}
			if (type == 2)
			{
				Chengjiu_zhanpao.getInstance().mcHandler(target);
			}
			else
			{
			}
			if (name.indexOf("dbtn") >= 0)
			{
				var getidx:int=target.parent.parent["arid"]
				ChengjiuModel.getInstance().getReward(getidx);
				return;
			}
			if (name.indexOf("chengjiu_") >= 0)
			{
				idx=int(name.replace("chengjiu_", ""));
				clickChengjiu();
			}
			if (target.parent)
			{
				if (target.parent.name.indexOf("chengjiu_") >= 0)
				{
					idx=int(target.parent.name.replace("chengjiu_", ""));
					clickChengjiu();
				}
			}


			switch (target.name)
			{
				case "btn_chakan": //查看成就榜
					PaiHang.getInstance().setType(18);
					break;
				case "btn_yijianlingqu": //一键领取
					ChengjiuModel.getInstance().getReward(0);
					break;

				default:
					break;

			}
		}


		private function clickChengjiu():void
		{
			//外网有可能报错 未查出原因
			try
			{
				
				showGetCount();
				for (var i:int=1; i <= 5; i++)
				{
					if (i == idx)
					{
						mc["chengjiu_" + i].gotoAndStop(2);
					}
					else
					{
						mc["chengjiu_" + i].gotoAndStop(1);
					}
				}
				setTxtFromSever();
				mc["tf_leiji_value"].htmlText=String(Data.myKing.chengjiuPoint);
				mc["tf_curr_value"].htmlText=String(Data.myKing.value3);
				var chengjiuData:Array=XmlManager.localres.AchievementXml.getIdListBySort(idx);
				chengjiuData.sortOn("ar_id", Array.NUMERIC);
				
				var arr1:Array=[];
				var arr2:Array=[];
				for (var k:int=0; k < chengjiuData.length; k++)
				{
					var itemData:Pub_AchievementResModel=chengjiuData[k];
					itemAct=ChengjiuModel.getInstance().getArById(itemData.ar_id);
					if (itemAct != null)
					{
						if (itemAct.para1 == 1){
							arr1.push(itemData);
						}else{
							arr2.push(itemData);
						}
					}else{
						arr2.push(itemData);
					}
				}
				chengjiuData=arr1.concat(arr2);
//				var sp:Sprite=new Sprite();
				while(sp.numChildren>0)sp.removeChildAt(0);
				for (var k:int=0; k < chengjiuData.length; k++)
				{
					var d:DisplayObject=ItemManager.instance().getChengJiuList(k);
					var itemData:Pub_AchievementResModel=chengjiuData[k];
					if (k % 2 == 0)
					{
						d["item_bg"].gotoAndStop(1);
					}
					else
					{
						d["item_bg"].gotoAndStop(2);
					}
					d["arid"]=itemData.ar_id;
//				d["item_icon"]["uil"].source =FileManager.instance.getChengJiuIconById(itemData.achievement_icon);
					ImageUtils.replaceImage(d["item_icon"], d["item_icon"]["uil"], FileManager.instance.getChengJiuIconById(itemData.achievement_icon));
					d["item_icon"]["txt_num"].text="";
					d["tf_dengji"].htmlText=itemData.target_desc;
					d["tf_jiangli"].htmlText="成就点"+itemData.achievement_value;
					d["txt_coin1"].htmlText=itemData.prize_coin1;
					d["txt_coin2"].htmlText=itemData.prize_coin2;
					var countStr:String="";
					var itemAct:StructActRecInfo;
					var countx:int=0;

					countStr="0" + "/" + itemData.max_count;
					d["btn_lingqu"].visible=false;
					
//				StringUtils.setUnEnable(d["btn_lingqu"]);
					itemAct=ChengjiuModel.getInstance().getArById(itemData.ar_id);
					if (itemAct != null)
					{
						countx=itemAct.count;
						if (countx > itemData.max_count)
						{
							countx=itemData.max_count;
						}
						countStr=String(countx);
						if (itemAct.para1 == 0)
						{ //未完成
							d["btn_lingqu"].visible=false;
								//StringUtils.setUnEnable(d["btn_lingqu"]);
						}
						else if (itemAct.para1 == 1)
						{ //已完成
							d["btn_lingqu"].visible=true;
							d["btn_lingqu"].gotoAndStop(1);
								//StringUtils.setEnable(d["btn_lingqu"]);
						}
						else if (itemAct.para1 == 2)
						{ //已领取
							d["btn_lingqu"].visible=true;
							d["btn_lingqu"].gotoAndStop(2);
								//StringUtils.setEnable(d["btn_lingqu"]);
						}
						countStr=countStr + "/" + itemData.max_count;
					}

					d["tf_jindu"].htmlText=Lang.getLabel("201232_chengjiujindu", [countStr]);
					sp.addChild(d);
					sp.cacheAsBitmap=true;
					CtrlFactory.getUIShow().showList2(sp, 1, 458, 72);
					mc['slider_sp'].position=0;
					mc["slider_sp"].source=sp;
				}
			}
			catch (e:Error)
			{
			}
		}

		/**
		 * 成就按钮角标
		 *
		 */
		private function showGetCount():void
		{
			var count:int=0;
			for (var m:int=1; m <= 5; m++)
			{
				var chengjiuData:Array=XmlManager.localres.AchievementXml.getIdListBySort(m);
				count=0;
				for (var k:int=0; k < chengjiuData.length; k++)
				{
					var itemData:Pub_AchievementResModel=chengjiuData[k];

					var itemAct:StructActRecInfo=ChengjiuModel.getInstance().getArById(itemData.ar_id);
					if (itemAct != null && itemAct.para1 == 1)
					{
						count++;
					}
				}
				//显示
				if (mc["chengjiu_" + m] != null)
				{
					mc["chengjiu_" + m]["txt_cj_not_enough"]["txt_bag_not_enough"].text=count;
					mc["chengjiu_" + m]["txt_cj_not_enough"].visible=count > 0;
				}
			}
		}

		/**
		 * 排名
		 */
		private function setTxtFromSever():void
		{
			var rank:int=ChengjiuModel.getInstance().rank;
			if (rank == 0)
			{
				mc["tf_paiming"].htmlText=Lang.getLabel("20067_ZhanLiZhi");
			}
			else
			{
				mc["tf_paiming"].htmlText=rank.toString();
			}
		}

		private function _processEvent(e:ChengjiuEvent):void
		{
			var _sort:int=e.sort;

			switch (_sort)
			{
				case ChengjiuEvent.CHENG_IUE_UPDATA: //排队人数更新
					chengjiuUpData();
					break;
				default:
					break;
			}
		}

		private function chengjiuUpData():void
		{
			var infoChange:StructActRecInfo2=ChengjiuModel.getInstance().info2;

			var chengjiuData:Array=XmlManager.localres.AchievementXml.getIdListBySort(idx);
			var countStr:String="";
			var countx:int=0;
			for (var k:int=0; k < chengjiuData.length; k++)
			{
				var d:DisplayObject=ItemManager.instance().getChengJiuList(k);
				var itemData:Pub_AchievementResModel=chengjiuData[k];
				d["arid"]=itemData.ar_id;
				if (itemData.ar_id == infoChange.arid)
				{
					countx=infoChange.count;
					if (countx > itemData.max_count)
					{
						countx=itemData.max_count;
					}
					countStr=String(countx);
					if (infoChange.para1 == 0)
					{ //未完成
						d["btn_lingqu"].visible=false;
						d["btn_lingqu"].gotoAndStop(3);
							//StringUtils.setUnEnable(d["btn_lingqu"]);
					}
					else if (infoChange.para1 == 1)
					{ //已完成
						d["btn_lingqu"].visible=true;
						d["btn_lingqu"].gotoAndStop(1);
							//StringUtils.setEnable(d["btn_lingqu"]);
					}
					else if (infoChange.para1 == 2)
					{ //已领取
						d["btn_lingqu"].visible=true;
						d["btn_lingqu"].gotoAndStop(2);
							//StringUtils.setEnable(d["btn_lingqu"]);
					}
					countStr=countStr + "/" + itemData.max_count;
					d["tf_jindu"].htmlText=Lang.getLabel("201232_chengjiujindu", [countStr]);
					break;
				}
			}
			showGetCount();
		}

		/**
		 *累计成就点
		 * @param e
		 */
		private function _chengJiuPoint_updata(e:DispatchEvent=null):void
		{
			if (mc["tf_leiji_value"])
				mc["tf_leiji_value"].htmlText=Data.myKing.chengjiuPoint;
			clickChengjiu();
		}

		private function pageChengjiu(e:DispatchEvent=null):void
		{
			if (mc["tf_curr_value"])
				mc["tf_curr_value"].htmlText=String(Data.myKing.value3);
		}

		override public function get height():Number
		{
			return 574;
		}

		override public function winClose():void
		{
			super.winClose();
			ChengjiuModel.getInstance().removeEventListener(ChengjiuEvent.CHENG_JIU_EVENT, _processEvent);
		}

		override public function getID():int
		{
			return 0;
		}
	}
}
