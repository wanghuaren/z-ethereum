package ui.view.view2.mrfl_qiandao{
	import common.config.GameIni;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_DropResModel;
	import common.config.xmlres.server.Pub_UpDateResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	
	import engine.event.DispatchEvent;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.net.*;
	import flash.text.TextField;
	
	import netc.Data;
	import netc.DataKey;
	import netc.dataset.HuoDongSet;
	import netc.packets2.PacketSCActWeekOnlinePrize2;
	import netc.packets2.StructBagCell2;
	
	import nets.packets.PacketCSContinueAward;
	import nets.packets.PacketCSGetLogOffExerciseExp;
	import nets.packets.PacketCSGetLogOffExerciseInfo;
	import nets.packets.PacketCSSignIn;
	import nets.packets.PacketSCContinueAward;
	import nets.packets.PacketSCGetLogOffExerciseExp;
	import nets.packets.PacketSCGetLogOffExerciseInfo;
	import nets.packets.PacketSCSignIn;
	
	import ui.base.huodong.HuoDong;
	import ui.base.huodong.HuoDongTuiJian;
	import ui.base.mainStage.UI_index;
	import ui.base.vip.Vip;
	import ui.base.vip.VipGift;
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.view.view2.other.ExpAdd;
	import ui.view.view4.yunying.ZhiZunVIP;
	import ui.view.view4.yunying.ZhiZunVIPMain;
	import ui.view.view6.GameAlert;
	
	import world.FileManager;
	
	
	/**
	 * 签到
	 * @author andy
	 * @date   2012-06-12
	 */
	public final class QianDao{
		private const maxDay:int=28;
		//2012-10-08 累计奖励时间调整
		public static const arrLeiJiDay:Array=[0,3,6,10,14];
		private var child:MovieClip;
		private var i:int=0;
		private var mc:MovieClip;
		
		public function get is_m_ui_null():Boolean
		{
			if(null == mc)
			{
				return true;
			}
			return false;
		}
		
		private var leiJiType:int=0;
		
		private static var _instance:QianDao;
		public static function getInstance():QianDao{
			if(_instance==null)
				_instance=new QianDao();
			return _instance;
		}
		public function QianDao() {
			jingyanDanArr = Lang.getLabelArr("jingYanDanArr");//几倍经验需多少个经验丹
			jingyanZhaoHuiArr = Lang.getLabelArr("jingYanXuanZeArr");//免费找回 二倍找回 三倍找回
			DataKey.instance.register(PacketSCSignIn.id,qianReturn);
			DataKey.instance.register(PacketSCContinueAward.id,lingQuReturn);
			DataKey.instance.register(PacketSCGetLogOffExerciseInfo.id,lingQuLiXianXiuLianReturn);
			DataKey.instance.register(PacketSCGetLogOffExerciseExp.id,lingQuLiXianXiuLianExpReturn);
		}
		//签到
		private static var qianDao_:QianDao;
		public static function qianDao(mc_:Sprite = null):QianDao
		{
			if (null == qianDao_)
			{
				qianDao_=QianDao.getInstance();
				
			}			
			
			if(null != mc_ && qianDao_.is_m_ui_null)
			{
				qianDao_.setUI(mc_);
			}
			
			if(qianDao_.is_m_ui_null)
			{
				throw new Error("first run you must set mc_ param !");
			}
			
			
			return qianDao_;
		}
		
		public function setUI(v:Sprite):void{
	
			mc=v as MovieClip;
			mc.gotoAndStop(1);
			curFram = 1;
			
			msgLiXianXiuLianSend();
			mc["scollrDuihuanBar"].visible = false;
			mc["spdes"].visible = false;
			leiJiType=curFram = 1;
			leiJiList(leiJiType);
			show();
			var num:int=1;
			for(i=1;i<=4;i++){
				if(Data.huoDong.getIsLingJiangByDay(i)==false){
					num=i;break;
				}
			}
			if(num!=leiJiType)
				mcHandler({name:"dbtn"+num});
		}
		private var curFram:int;
		public function refresh():void{
			leiJiType=0;
			show();
		}
		private var _beiShu:int = 1;
		public function mcHandler(target:Object):void {
			
			if(null == target){
				return;
			}
//				QianDaoPage_2.getInstance().mcHandler(target);
//				DuiHuanLiBao_CDKey.getInstance().mcHandler(target);
			var name:String=target.name;
			if(name.indexOf("dbtn")>=0){
				leiJiType=int(name.replace("dbtn",""));
				selectMenu(target);
				leiJiList(leiJiType);
				return;
			}
			if(name.indexOf("fuxuankuang")>=0){
				_beiShu=int(name.replace("fuxuankuang",""));
				setLingQuJingYan(_beiShu);
				for(var t:int = 1;t<4;t++){
					if(t==_beiShu){
						mc["fuxuankuang"+t].selected = true;
					}else{
						mc["fuxuankuang"+t].selected = false;
					}
					
				}
				return;
			}
			switch(name) {
				case "btnQianDao":
					//签到
					var day:int=int(target.parent.name.replace("dao",""));
					qian(target.parent["type"],day);
					break;
				case "btnBuQian":
					//补签
					var day1:int=int(target.parent.name.replace("dao",""));
					var okFunction:Function=function():void{
						qian(target.parent["type"],day1);
					}
					//2014-02-13 至尊会员增加免费次数
					var freeTimes:int=Data.huoDong.getQianDao().freepatchtimes;
					if(freeTimes>0){
						okFunction();
					}else{
						new GameAlert().ShowMsg(Lang.getLabel("10078_qiandao"),4,null,okFunction);
					}
					break;
				case "btnLingQu":
					//领取 累计签到奖励
					lingQu(leiJiType);
					break;
				case "btnWeekOnlinePrize":
					//领取 累计l离线经验奖励
					lingQuLiXianJingYan(_beiShu);
					break;
				
			}
		}
	
		private var jingyanDanArr:Array = [];
		private var jingyanZhaoHuiArr:Array = [];
		/**
		 *显示  选择几倍领取可获得 XXX经验  第一针的离线经验
		 * @param _beiShu
		 * 
		 */
		private function setLingQuJingYan(_beiShu:int):void
		{
			
			var exp:int = liXianDanbeiExp*_beiShu;
			switch(_beiShu){
				case 1:
					mc["txt_unit_rmb_coin"].htmlText = Lang.getLabel("5007_zhaoHuiLixianJingyan",[jingyanZhaoHuiArr[0],exp]);
					mc["txt_unit_rmb_coin2"].htmlText = jingyanDanArr[0];
					break;
				case 2:
					mc["txt_unit_rmb_coin"].htmlText =Lang.getLabel("5007_zhaoHuiLixianJingyan",[jingyanZhaoHuiArr[1],exp]);
					mc["txt_unit_rmb_coin2"].htmlText = jingyanDanArr[1];
					break;
				case 3:
					mc["txt_unit_rmb_coin"].htmlText =Lang.getLabel("5007_zhaoHuiLixianJingyan",[jingyanZhaoHuiArr[2],exp]);
					mc["txt_unit_rmb_coin2"].htmlText = jingyanDanArr[2];
					break;
			}
		}
		
		/************通讯***************/
		/**
		 *领取累计离线经验奖励    
		 * @param leiJiType   几倍领取
		 * 
		 */
		private function lingQuLiXianJingYan(leiJiType:int):void
		{
			// TODO Auto Generated method stub
			var client:PacketCSGetLogOffExerciseExp=new PacketCSGetLogOffExerciseExp();
			client.type = leiJiType;
			DataKey.instance.send(client);
		}		
		
		/**
		 * *领取累计离线经验奖励    
		 * @param leiJiType   几倍领取 返回
		 * @param p
		 * 
		 */
		private function lingQuLiXianXiuLianExpReturn(p:PacketSCGetLogOffExerciseExp):void{
			Lang.showMsg(Lang.getServerMsg(p.tag));
			if(p.tag==0){
				msgLiXianXiuLianSend();
			}else{
				
			}
		}
		
		/**
		 *	签到【补签】 
		 */
		private function qian(v:int=0,day:int=1):void{
			var client:PacketCSSignIn=new PacketCSSignIn();
			client.type=v;
			client.index=day;
			DataKey.instance.send(client);
		}
		private function qianReturn(p:PacketSCSignIn):void{
			Lang.showMsg(Lang.getServerMsg(p.tag));
			if(p.tag==0){
				show();
				mcHandler(mc["dbtn"+leiJiType]);
			}else{
				
			}
		}
		/**
		 *	领取累计奖励 
		 */
		private function lingQu(day:int=1):void{
			var client:PacketCSContinueAward=new PacketCSContinueAward();
			client.type=day;
			DataKey.instance.send(client);
		}
		private function lingQuReturn(p:PacketSCContinueAward):void{
			Lang.showMsg(Lang.getServerMsg(p.tag));
			if(p.tag==0){
				Data.huoDong.getQianDao().accumulatestate=p.accumulatestate;
				initMenu();
				mcHandler(mc["dbtn"+leiJiType]);
			}else{
				
			}
		}
		private var liXianDanbeiExp:int = 0;
		/**
		 *	获取离线修炼信息
		 */
		public function msgLiXianXiuLianSend():void{
			
			show();
			mc["max_level"].htmlText = ExpAdd.getInstance().getStringShiJieDengJi();
//			mc["max_level"].addEventListener(TextEvent.LINK,linkHandle);
			for(var t:int = 1;t<4;t++){
				if(t==1){
					mc["fuxuankuang"+t].selected = true;
					mc["txt_unit_rmb_coin2"].htmlText = jingyanDanArr[0];
				}else{
					mc["fuxuankuang"+t].selected = false;
				}
			}
			var client:PacketCSGetLogOffExerciseInfo=new PacketCSGetLogOffExerciseInfo();
			DataKey.instance.send(client);
		}
		private function lingQuLiXianXiuLianReturn(p:PacketSCGetLogOffExerciseInfo):void{
			Lang.showMsg(Lang.getServerMsg(p.tag));
			if(p.tag==0){
				//				Data.huoDong.getQianDao().accumulatestate=p.accumulatestate;
				var offLine:int=int(p.time/60);//离线时间
				liXianDanbeiExp = p.exp;
				mc["sanbeizhaohui"].htmlText = Lang.getLabel("5008_zhaoHuiSanBeiJingyan",[liXianDanbeiExp*3]);
				mc["txt_onlineminute"].htmlText =offLine.toString() ;
//				mc["txt_unit_rmb_coin"].htmlText = Lang.getLabel("50016_mianfeizhaoh")+liXianDanbeiExp.toString()+Lang.getLabel("10186_renwu");
				
				mc["txt_unit_rmb_coin"].htmlText = Lang.getLabel("5007_zhaoHuiLixianJingyan",[jingyanZhaoHuiArr[0],liXianDanbeiExp+""]);
				mc["txt_unit_rmb_coin2"].htmlText = jingyanDanArr[0];
			}else{
				
			}
		
		}
		
		/**
		 *	界面显示
		 */
		public function show():void{
			mc["scollrDuihuanBar"].visible = false;
			mc["spdes"].visible = false;
			Lang.addTip(mc["btnLingQu_lixian"],"10086_qian_dao",200);
			var isQianDao:Boolean=false;
			var isBuQian:Boolean=false;
			var dayIndex:int=Data.huoDong.getQianDao().dayIndex;
			for(i=1;i<=maxDay;i++){
				child=mc["dao"+i];
				if(child==null)continue;
				child["txt_point"].htmlText="<font color='#fa9615'>"+i+"</font>";
				child["txt_point"].mouseEnabled=false;
				isQianDao=Data.huoDong.getIsQianDaoByDay(i);
				isBuQian=Data.huoDong.getIsBuQianByDay(i);
				if(isQianDao&&i<=dayIndex){
					//已经签到
					child.gotoAndStop(3);
				}else if(isBuQian&&i<=dayIndex){
					//已经补签
					child.gotoAndStop(5);
				}else{
					if(i==dayIndex){
						//签到
						child["type"]=0;
						child.gotoAndStop(2);
					}else if(i<dayIndex){
						//补签
						child["type"]=1;
						child.gotoAndStop(4);
					}else{
						//时间未到
						child["txt_point"].htmlText="<font color='#76634c'>"+i+"</font>";
						child.gotoAndStop(1);
					}
				}
			}
			if(null != mc["txt_lian_xu_day"])
				mc["txt_lian_xu_day"].text=Data.huoDong.getQianDao().continuetimes;//DataCenter.huoDong.getLianXuTimes();
			if(null != mc["txt_lei_ji_day"])
				mc["txt_lei_ji_day"].text=Data.huoDong.getLeiJiTimes();
			
			
			
			//累计签到奖励
			initMenu();
			
		}
		private function linkHandle(te:TextEvent):void{
			//			Vip.getInstance().setData(0);
			ZhiZunVIPMain.getInstance().open(true);
		}
		/**
		 *	累计领取后，按钮变成已经领取
		 */
		private function initMenu():void{
			var menu:Object;
			
			for(i=1;i<=4;i++){
				menu=mc["dbtn"+i];
				if(menu==null)continue;
				if(Data.huoDong.getIsLingJiangByDay(i))menu.label=Lang.getLabel("10054_vip");
			}
			
		}
		/**
		 *	选中累计奖励按钮 
		 */
		private function selectMenu(target:Object):void{
			var menu:Object;
			for(i=1;i<=4;i++){
				menu=mc["dbtn"+i];
				if(menu==null)continue;
				menu.toggle= i==leiJiType;
				menu.mouseEnabled=i!=leiJiType;
			}
			//2011-12-23 修改不是按钮菜单点击触发
			if(target!=null&&!target.hasOwnProperty("toggle")&&mc["dbtn"+leiJiType]!=null)
				mc["dbtn"+leiJiType].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		/**
		 *	累计奖励物品列表 
		 */
		private function leiJiList(num:int=1):void{
			for(i=1;i<=4;i++){
				child=mc["pic"+i];
				if(child==null)continue;
				child["uil"].unload();
				child["txt_num"].text="";
			}
			
			var dropId:int=this.getLeiJiDrop(num);
			var vec:Vector.<Pub_DropResModel>=XmlManager.localres.getDropXml.getResPath2(dropId) as Vector.<Pub_DropResModel>;
			i=1;
			var bag:StructBagCell2=null;
			for each(var item:Pub_DropResModel in vec){
				child=mc["pic"+i];i++;
				if(child==null)continue;
				bag=new StructBagCell2();
				bag.itemid=item.drop_item_id;
				bag.num=item.drop_num;
				Data.beiBao.fillCahceData(bag);
				child.data=bag;
//				child["uil"].source=bag.icon;
				ImageUtils.replaceImage(child,child["uil"],bag.icon);
				child["txt_num"].text=VipGift.getInstance().getWan(bag.num);
				child.mouseChildren=false;
				CtrlFactory.getUIShow().addTip(child);
				ItemManager.instance().setEquipFace(child);
			}
			
			var isReceive:Boolean=Data.huoDong.getIsLingJiangByDay(leiJiType);
			//已经领取
			if(isReceive){
				mc["btnLingQu_lixian"].gotoAndStop(2);
			}else{
				
				if(null != mc["btnLingQu_lixian"])
					mc["btnLingQu_lixian"].gotoAndStop(1);
				
				if(null != mc["btnLingQu_lixian"])
//					mc["btnLingQu"]["mc_effect"].mouseEnabled=mc["btnLingQu"]["mc_effect"].mouseChildren=false;
				
				if(Data.huoDong.getLeiJiTimes()>=arrLeiJiDay[leiJiType]){
					//可以领取
					if(null != mc["btnLingQu_lixian"])
//						mc["btnLingQu"]["mc_effect"].visible=true;
					
					if(null != mc["btnLingQu_lixian"])
						CtrlFactory.getUIShow().setBtnEnabled(mc["btnLingQu_lixian"]["btnLingQu"],true);
					
				}else{
					//不可以领取
					if(null != mc["btnLingQu_lixian"])
//						mc["btnLingQu"]["mc_effect"].visible=false;
					
					if(null != mc["btnLingQu_lixian"])
						CtrlFactory.getUIShow().setBtnEnabled(mc["btnLingQu_lixian"]["btnLingQu"],false);
				}
			}
		}
		
		/**
		 *	获得累计奖励物品drop 
		 */
		private function getLeiJiDrop(num:int=1):int{
			switch(num){
				case 1:return 60100185;break;
				case 2:return 60100186;break;
				case 3:return 60100187;break;
				case 4:return 60100188;break;
				default :return 0;break;
			}
		}
		
		
		/**
		 *	是否有可领取的奖励 
		 */
		public function isHaveJiangLi():Boolean{
			var ret:Boolean=false;
			for(var h:int=1;h<=4;h++){
				var isReceive:Boolean=Data.huoDong.getIsLingJiangByDay(h);
				//已经领取
				if(isReceive){
					
				}else{
					if(Data.huoDong.getLeiJiTimes()>=arrLeiJiDay[leiJiType]){
						//可以领取
						ret=true;
						break;
					}else{
						//不可以领取
					}
				}
			}
			return ret;
		}
		////////////////////////////////////////////////////////////
		
		
		
		
	
	}
}
