package ui.view.view4.shenbing
{
	import common.config.Att;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_AchievementResModel;
	import common.config.xmlres.server.Pub_GodResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	import common.utils.bit.BitUtil;
	
	import display.components.CheckBoxStyle1;
	
	import engine.event.DispatchEvent;
	import engine.support.IPacket;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import model.chengjiu.ChengjiuModel;
	import model.guest.NewGuestModel;
	
	import netc.Data;
	import netc.DataKey;
	import netc.dataset.MyCharacterSet;
	
	import nets.packets.PacketCSGodUp;
	import nets.packets.PacketCSSetGodShow;
	import nets.packets.PacketSCArChange;
	import nets.packets.PacketSCGodUp;
	import nets.packets.PacketSCSetGodShow;
	import nets.packets.StructActRecInfo;
	
	import ui.base.jiaose.JiaoSe;
	import ui.frame.FontColor;
	import ui.frame.ImageUtils;
	import ui.frame.UIPanel;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	import world.FileManager;
	
	/**神兵   25级开启
	 * @author Administrator
	 */
	public class Shenbing extends UIWindow
	{
		private static var _instance:Shenbing;
		private var cbIdx:int = 1;
		/**神兵等级 * */
		private var m_level:int;
		
		private var shenbingXmlLen:int ;
		public function Shenbing(DO:DisplayObject=null)
			{
				super(this.getLink(WindowName.win_shen_bing));
			}
			
			public static function getInstance(reload:Boolean=false):Shenbing
			{
				if (_instance == null && reload == false)
				{
					_instance=new Shenbing();
				}
				return _instance;
			}
			private var m_cb_isP:CheckBoxStyle1 = null;
			override protected function init():void
			{
				mc["mc_success"].source=FileManager.instance.httpPre("System/shenbing/shenbing.swf");
				cbIdx =m_level=Data.myKing.godlvl;      
				if(cbIdx==0)cbIdx = 1;
				super.sysAddEvent(Data.myKing,MyCharacterSet.SUI_PIAN6_UPD, SUI_PIAN_UPD);
				super.uiRegister(PacketSCArChange.id, chengjiuSCArChange);
				Data.myKing.addEventListener(MyCharacterSet.GOD_UPDATA, _god_updata);
				shenbingXmlLen = XmlManager.localres.getGodXml.xmlLength;
				super.sysAddEvent(mc, MouseEvent.MOUSE_OVER, overHandle);
				super.sysAddEvent(mc, MouseEvent.MOUSE_OUT, overHandle);
				showshenbing();
				m_cb_isP = mc["mc_need"]["fuxuankuang"] as CheckBoxStyle1;
				m_cb_isP .selected = false;
				Lang.addTip(mc["ruhehuode"],"shenbingHowget",150);
				mc["mc_sb_name"].visible=false;
				mc["mc_jie"].visible=false;
				mc["mc_tip"].visible=false;
				if(cbIdx<10)
				{
					StringUtils.setUnEnable(mc['btnPrev']);
				}else if(cbIdx+10>shenbingXmlLen){
					StringUtils.setUnEnable(mc['btnNext']);
				}
				setJianTou();
				
				showTxtContent();
				NewGuestModel.getInstance().handleNewGuestEvent(1068,1,mc);
			}
			override public function mcHandler(target:Object):void
			{
				var name:String=target.name;
				switch (name)
				{
					case "btnPrev": //
						if(cbIdx>10){
							cbIdx-=10;
						}
						setJianTou();
						showshenbing();
						break;
					case "btnNext": //
						
						if(cbIdx+10<shenbingXmlLen){
							cbIdx+=10;
						}
						setJianTou();
						showshenbing();
						break;
					case "fuxuankuang":
						m_cb_isP.selected = !	m_cb_isP.selected;
						break;
					case "duanzao":
						shengjiShenbing();
						break;
					case "btnJiHuo":
						var showM:Pub_GodResModel=XmlManager.localres.getGodXml.getResPath(m_level) as Pub_GodResModel;
						var ar_id:int=0;
						if(showM!=null){
							var ar_id=showM.achievement_1;
							if(ar_id>0)
							ChengjiuModel.getInstance().getReward(ar_id);
							ar_id=showM.achievement_2;
							if(ar_id>0)
								ChengjiuModel.getInstance().getReward(ar_id);
							
							if(
								(showM.achievement_1==0||(showM.achievement_1>0&&mc["chk_jh1"].selected))&&
								(showM.achievement_2==0||(showM.achievement_2>0&&mc["chk_jh2"].selected))
							){
								Lang.showMsg({type:4,msg:"恭喜你成功激活，可继续锻造神兵！"});
							}
						}
						break;
					case "chk_hun":
						mc["chk_hun"].selected=!mc["chk_hun"].selected;
						isShowHun();
						break;
					
					default:
						break;
				}
				
			}
			
			/**
			 *设置神兵名字，战斗力 ，成功率 ，材料消耗txt 
			 * 
			 */
			private function showTxtContent():void
			{
				var showM:Pub_GodResModel=XmlManager.localres.getGodXml.getResPath(m_level) as Pub_GodResModel;
				if(m_level==0||showM==null){
					mc["mc_sb_name"].visible=true;
					mc["mc_sb_name"].gotoAndStop(1);
					mc["mc_jie"].visible=true;
					mc["txt_zhanDouLi"].htmlText = "";//
					//mc["tf_chenggonglv"].htmlText = showM.succeed_odd/100+"%";//成功率
				}else{
					mc["txt_zhanDouLi"].htmlText = "";//showM.grade_value;//
					var fight:Sprite=JiaoSe.getInstance().setFightValueIcon(showM.grade_value,"sb",25);
					fight.name="mc_zl_sb";
					fight.x=mc["txt_zhanDouLi"].x;
					fight.y=mc["txt_zhanDouLi"].y;
					if(mc.getChildByName("mc_zl_sb")!=null)
						mc.removeChild(mc.getChildByName("mc_zl_sb"));
					mc.addChild(fight);
					
					
					mc["mc_sb_name"].visible=true;
					mc["mc_jie"].visible=true;
					mc["mc_sb_name"].gotoAndStop(Math.ceil(m_level/10));
				}
				
				var showM2:Pub_GodResModel=XmlManager.localres.getGodXml.getResPath(m_level+1) as Pub_GodResModel;
				
				if(showM2!=null){
					mc["mc_need"]["tf_xiaohaoyuanbao"].htmlText =Lang.getLabel("5014_shenbingxhyb",[showM2.cost_coin3]);// "消耗"+showM2.cost_coin3+"元宝成功率100%";//消耗元宝
					var need:String="";
					need =FontColor.isEnough(showM2.need_exp+Lang.getLabel("5014_shentiesuipian"),Data.myKing.value6>=showM2.need_exp)+"  "; 
					need+=FontColor.isEnough(showM2.cost_coin1+Lang.getLabel("pub_yin_liang"),Data.myKing.coin1>=showM2.cost_coin1)+"  ";
					need+= "<font color='#24FF43'>成功率："+showM2.succeed_odd/100+"%</font>";//成功率
					if(showM2.succeed_odd/100==100){
						mc["mc_need"]["tf_xiaohaoyuanbao"].visible=false;
						mc["mc_need"]["fuxuankuang"].visible=false;
					}else{
						mc["mc_need"]["tf_xiaohaoyuanbao"].visible=true;
						mc["mc_need"]["fuxuankuang"].visible=true;
					}
					mc["mc_need"]["tf_xiaohao"].htmlText=need;
				}else{
					mc["mc_need"]["tf_xiaohao"].htmlText="";
				}
				mc["tf_num"].htmlText = Data.myKing.value6;
//				mc["tf_dengji_name"].htmlText = showM.god_name;
				mc["mc_jie"].gotoAndStop(Math.ceil(showM.god_lv/10));
				if(m_level+1>=shenbingXmlLen){
//					mc["tf_dengji_name"].htmlText = Lang.getLabel("5014_shentiemanji");//"已达满级";
					mc["mc_need"]["tf_xiaohao"].htmlText = "";
					
					StringUtils.setUnEnable(mc["duanzao"]);
				}
				//
				
				if(showM!=null&&showM.achievement_1>0&&m_level>1){
					checkJH(true);
					var jh1:int=0;
					var jh2:int=0;
					jh1=cj_status(1,showM.achievement_1);
					jh2=cj_status(2,showM.achievement_2);
					//是否激活
					if((showM.achievement_1==0||(showM.achievement_1>0&&jh1==2))&&
						(showM.achievement_2==0||(showM.achievement_2>0&&jh2==2))
					){
						checkJH(false);
					}
				}else{
					checkJH(false);
				}
				//展示属性
				_countAtt_curr();
				_countAtt_nextJie();
				//星
				var _10_ji:int = (m_level-1)%10+1;
				for(var i:int = 1;i<=10;i++)
				{
					if(i<=_10_ji)
					{
						mc["zuan"+i].gotoAndStop(2);
					}else{
						mc["zuan"+i].gotoAndStop(1);
					}
				}
				//左边展示 2014－11－17
				var jiHuoIndex:int=Math.ceil(m_level/10);
				var arrNeed:Array=[2,4,6,8,10];
				var minNeedJh:int;
				for(var p:int=1;p<=5;p++){
					child=mc["mc_left"+p];
					if(child==null)continue;
					mc["txt_jh_warning"+p].visible=false;
					if(jiHuoIndex>arrNeed[p-1] || (jiHuoIndex==arrNeed[p-1]&&mc["btnJiHuo"].visible==false )){
						
						CtrlFactory.getUIShow().setColor(child,1);
						//Lang.addTip(child,"sb_jhh"+p);
						child["jh"]=1;
					}else{
						CtrlFactory.getUIShow().setColor(child,2);
						//Lang.addTip(child,"sb_jh"+p);
						child["jh"]=0;
						if(minNeedJh==0){
							mc["txt_jh_warning"+p].visible=true;
							minNeedJh=p;
						}
					}
				}
				//是否显示武魂
				mc["chk_hun"].selected=BitUtil.getBitByPos(Data.myKing.SpecialFlag,6)==1;
				
				if(mc["mc_left1"]["jh"]==0){
					mc["chk_hun"].selected=false;
					mc["chk_hun"].mouseEnabled=false;
				}else{
					mc["chk_hun"].mouseEnabled=true;
				}
				//当神器是一阶时特殊显示，在锻造按钮上方，即元宝勾选框位置，居中显示橙色文字：锻造至二级神兵即可觉醒【武器之魂】。
				if(jiHuoIndex<=1){
					mc["mc_need"]["txt_hun"].visible=true;
				}else{
					mc["mc_need"]["txt_hun"].visible=false;
				}
			}

			/**
			 *改变神兵展示显示  名字 
			 * 
			 */
			private function showshenbing():void
			{
				
				var showM:Pub_GodResModel;
				showM=XmlManager.localres.getGodXml.getResPath(cbIdx) as Pub_GodResModel;
				shenbingXmlLen =XmlManager.localres.getGodXml.xmlLength;
				if(showM!=null){
					var path:String=FileManager.instance.getshenbingById(showM.res_id);
					mc["mcshenbing"].source=path;
					//					ImageUtils.replaceImage(mc,mc["mcshenbing"],path);
				}
			}
			private function setJianTou():void
			{
				if(cbIdx<=10)
				{
					StringUtils.setUnEnable(mc["btnPrev"]);
				}else{
					StringUtils.setEnable(mc["btnPrev"]);
				}
				if(cbIdx+10>=shenbingXmlLen)
				{
					StringUtils.setUnEnable(mc["btnNext"]);
				}else{
					StringUtils.setEnable(mc["btnNext"]);
				}
			}
			/**
			 * 激活条件 
			 * @param num
			 * @param ar_id
			 * @return 
			 * 
			 */			
			private function cj_status(num:int,ar_id:int):int{
				var ret:int=0;
				var cj:Pub_AchievementResModel=XmlManager.localres.AchievementXml.getResPath(ar_id) as Pub_AchievementResModel;
				if(cj!=null){
					var itemAct:StructActRecInfo=ChengjiuModel.getInstance().getArById(ar_id);
					mc["chk_jh"+num].visible=true;
					if (itemAct != null&&itemAct.para1 >= 1)
					{
						ret=itemAct.para1;
						mc["chk_jh"+num].selected=true;
						
					}else{
						mc["chk_jh"+num].selected=false;
					}
					
					mc["txt_jh"+num].htmlText=FontColor.isEnough(cj.target_desc,mc["chk_jh"+num].selected);
				}else{
					mc["chk_jh"+num].visible=false;
					mc["txt_jh"+num].text="";
				}
				return ret;
			}
			/**
			 * 检查激活 
			 * @param status
			 * 
			 */			
			private function checkJH(status:Boolean):void{
				if(status){
					mc["btnJiHuo"].visible=true;
					mc["txt_need_jh"].visible=true;
					mc["mc_jh_title"].visible=true;
					mc["mc_need"].visible=false;
				}else{
					mc["mc_need"].visible=true;
					mc["btnJiHuo"].visible=false;
					mc["txt_need_jh"].visible=false;
					mc["mc_jh_title"].visible=false;
					mc["txt_jh1"].text="";
					mc["txt_jh2"].text="";
					mc["chk_jh1"].visible=false;
					mc["chk_jh2"].visible=false;
				}
			}
			/**
			 *	鼠标悬浮
			 */
			private var mc_tip:MovieClip=null;
			private function overHandle(me:MouseEvent):void
			{
				var target:Object=me.target;
				var name:String=target.name;
				if(mc_tip==null){
					mc_tip=mc["mc_tip"];
					mc_tip.mouseEnabled=mc_tip.mouseChildren=false;
				}
				switch (me.type)
				{
					case MouseEvent.MOUSE_OVER:
						if (name=="mc_left1" ||name=="mc_left2" ||name=="mc_left3" ||name=="mc_left4" ||name=="mc_left5"
						){							
							mc_tip.visible=true;

							var leftIndex:int=int(name.replace("mc_left",""));
							mc_tip.gotoAndStop(leftIndex);
							
							if(target["jh"]==1){
								mc_tip["txt_level"].htmlText=FontColor.isEnough("已觉醒",true);
							}else{
								mc_tip["txt_level"].htmlText=FontColor.isEnough("未觉醒",false);;
							}
							//mc_tip.y=target.y+20;
						}
						else
						{
							
						}
						break;
					case MouseEvent.MOUSE_OUT:
						if (name=="mc_left1" ||name=="mc_left2" ||name=="mc_left3" ||name=="mc_left4" ||name=="mc_left5"
						){
							mc_tip.visible=false;
						}
						else
						{
							
						}
						break;
					default:
						break;
				}
				
			}
			/*********** 通讯  *************/
			/**
			 * 锻造【激活】
			 
			 */
			private function shengjiShenbing():void
			{
				
				DataKey.instance.register(PacketSCGodUp.id, chibangSCGodUp);
				var _p:PacketCSGodUp = new PacketCSGodUp();
				
				_p.isCoin3 = m_cb_isP.selected? 1:0;
				DataKey.instance.send(_p);
				
				NewGuestModel.getInstance().handleNewGuestEvent(1068,4,mc);
				NewGuestModel.getInstance().handleNewGuestEvent(1068,3,mc);
				NewGuestModel.getInstance().handleNewGuestEvent(1068,2,mc);
			}
			private function chibangSCGodUp(p:IPacket):void
			{
				var _p:PacketSCGodUp=p as PacketSCGodUp;
				
				if (super.showResult(_p))
				{
					showshenbing();
					//2014－11－24 显示特效
					if(mc["mc_success"].content!=null&&mc["mc_success"].content["effect"]!=null){
						
						mc["mc_success"].content["effect"].gotoAndStop(1);
						
						mc["mc_success"].content["effect"].gotoAndPlay(1);
					}
				}else{
				
				}
				
				
				
			}
			/**
			 * 展示武器之魂
			 */
			private function isShowHun():void
			{
				DataKey.instance.register(PacketSCSetGodShow.id, SCSetGodShow);
				var _p:PacketCSSetGodShow = new PacketCSSetGodShow();
				_p.value=mc["chk_hun"].selected?1:0;
				DataKey.instance.send(_p);
			}
			private function SCSetGodShow(p:IPacket):void
			{
				if(super.showResult(p)){
				
				}else{
				
				}
			}
			
		
			
			/**
			 *当前属性 
			 * @param level
			 * 
			 */
			private function _countAtt_curr():void
			{
				
				var _arrValues:Array=_countAtt(m_level);
				var n:int=1;
				var _str:String=null;
				for each (var va:* in _arrValues)
				{
					if (n > 6)
					{
						break;
					}
					mc['tf_currName_' + n].text=va.name+":";
					_str="";
					if (va.valueMin > 0 && va.valueMax > 0)
					{
						_str+=Att.getAttValuePercent(va.func, va.valueMin) + "-" + Att.getAttValuePercent(va.func, va.valueMax);
					}
					else if (va.valueMin > 0 && va.valueMax <= 0)
					{
						_str+=Att.getAttValuePercent(va.func, va.valueMin);
					}
					else
					{
						_str+=0;
					}
					mc['tf_curr_' + n].text=_str;
					++n;
				}
			}
			
			/**
			 *下一等级属性
			 */
			private function _countAtt_nextJie():void
			{
				var _arrValues:Array=_countAtt(m_level+1);
				var n:int=1;
				var _str:String=null;
				//			var _showName:Boolean=false;
				for each (var va:* in _arrValues)
				{
					if (n > 6)
					{
						break;
					}
					_str="";
					if (va.valueMin > 0 && va.valueMax > 0)
					{
						_str+=Att.getAttValuePercent(va.func, va.valueMin) + "-" + Att.getAttValuePercent(va.func, va.valueMax);
						//					mc['mcJianTou_' + n].visible=true;
					}
					else if (va.valueMin > 0 && va.valueMax <= 0)
					{
						_str+=Att.getAttValuePercent(va.func, va.valueMin);
					}
					else
					{
						
						_str+="";
						
					}
					mc['tf_next_' + n].text=_str;
					++n;
				}
			}
			private function _countAtt(level:int):Array
			{
				var _arrValues:Array=[];
				var _config:Pub_GodResModel=null; //
				var _values:Array=[];
				for (var i:int=level; i <= level; ++i)
				{
					_config=XmlManager.localres.getGodXml.getResPath(i) as Pub_GodResModel;
					if (null == _config)
					{
						continue;
					}
					if (_config.func1 > 0)
					{
						if (null == _values[_config.func1])
						{
							_values[_config.func1]={func: _config.func1, name: Att.getAttName(_config.func1), valueMin: _config.value1, valueMax: _config.value2};
						}
						else
						{
							_values[_config.func1].valueMin+=_config.value1;
							_values[_config.func1].valueMax+=_config.value2;
						}
					}
					if (_config.func3 > 0)
					{
						if (null == _values[_config.func3])
						{
							_values[_config.func3]={func: _config.func3, name: Att.getAttName(_config.func3), valueMin: _config.value3, valueMax: _config.value4};
						}
						else
						{
							_values[_config.func3].valueMin+=_config.value3;
							_values[_config.func3].valueMax+=_config.value4;
						}
					}
					if (_config.func5 > 0)
					{
						if (null == _values[_config.func5])
						{
							_values[_config.func5]={func: _config.func5, name: Att.getAttName(_config.func5), valueMin: _config.value5, valueMax: _config.value6};
						}
						else
						{
							_values[_config.func5].valueMin+=_config.value5;
							_values[_config.func5].valueMax+=_config.value6;
						}
					}
					if (_config.func7 > 0)
					{
						if (null == _values[_config.func7])
						{
							_values[_config.func7]={func: _config.func7, name: Att.getAttName(_config.func7), valueMin: _config.value7, valueMax: _config.value8};
						}
						else
						{
							_values[_config.func7].valueMin+=_config.value7;
							_values[_config.func7].valueMax+=_config.value8;
						}
					}
					if (_config.func9 > 0)
					{
						if (null == _values[_config.func9])
						{
							_values[_config.func9]={func: _config.func9, name: Att.getAttName(_config.func9), valueMin: _config.value9, valueMax: _config.value10};
						}
						else
						{
							_values[_config.func9].valueMin+=_config.value9;
							_values[_config.func9].valueMax+=_config.value10;
						}
					}
					//_values[1] = _values[1] + _config.
				}
				//19,21,23,22,24,
				for each (var v:* in _values)
				{
					switch (v.func)
					{
						case 19:
							_arrValues[0]=v;
							break;
						case 21:
							_arrValues[1]=v;
							break;
						case 23:
							_arrValues[2]=v;
							break;
						case 109:
							_arrValues[3]=v;
							break;
						case 37:
							_arrValues[4]=v;
							break;
						default:
							break;
					}
				}
				if (null == _arrValues[0])
				{
					_arrValues[0]={func: 0, name: Att.getAttName(19), valueMin: 0, valueMax: 0};
				}
				if (null == _arrValues[1])
				{
					_arrValues[1]={func: 0, name: Att.getAttName(21), valueMin: 0, valueMax: 0};
				}
				if (null == _arrValues[2])
				{
					_arrValues[2]={func: 0, name: Att.getAttName(23), valueMin: 0, valueMax: 0};
				}
				if (null == _arrValues[3])
				{
					_arrValues[3]={func: 0, name: Att.getAttName(109), valueMin: 0, valueMax: 0};
				}
				if (null == _arrValues[4])
				{
					_arrValues[4]={func: 0, name: Att.getAttName(37), valueMin: 0, valueMax: 0};
				}
				return _arrValues;
			}
			/**
			 *	碎片值有变化
			 */
			public function SUI_PIAN_UPD(e:DispatchEvent=null):void
			{
				mc["tf_num"].htmlText = Data.myKing.value6;
				showTxtContent();
			}
			private function chengjiuSCArChange(p:PacketSCArChange):void
			{
				showTxtContent();
			}
			private function _god_updata(e:DispatchEvent=null):void
			{
				cbIdx=m_level = Data.myKing.godlvl;

				showshenbing();
				showTxtContent();
			}
			
			
			
			/**
			 *角色界面悬浮 
			 * @param level
			 * 
			 */
			public function getCurAtt(level:int):String
			{
				
				var _arrValues:Array=_countAtt(level);
				var n:int=1;
				var _str:String="";
				for each (var va:* in _arrValues)
				{
					if (n > 6)
					{
						break;
					}
					_str+=va.name+"：";
	
					if (va.valueMin > 0 && va.valueMax > 0)
					{
						_str+=Att.getAttValuePercent(va.func, va.valueMin) + "-" + Att.getAttValuePercent(va.func, va.valueMax);
					}
					else if (va.valueMin > 0 && va.valueMax <= 0)
					{
						_str+=Att.getAttValuePercent(va.func, va.valueMin);
					}
					else
					{
						_str+=0;
					}
					_str+="<br/>";
					++n;
				}
				if(level==0)_str="";
				return _str;
			}
			
			override protected function windowClose():void
			{
				super.windowClose();
				NewGuestModel.getInstance().handleNewGuestEvent(1068,-1,null);
			}
			
			
		}
}