package ui.view.view1.guaji
{
	import common.config.PubData;
	import common.utils.CtrlFactory;
	
	import display.components.CheckBoxStyle1;
	import display.components.CmbArrange;
	import display.components.RadioButtonGreen;
	
	import engine.event.DispatchEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	
	import netc.Data;
	import netc.dataset.SkillShortSet;
	import netc.packets2.StructShortKey2;
	import netc.packets2.StructSkillItem2;
	
	import scene.action.hangup.GamePlugIns;
	import scene.skill2.SkillEffectManager;
	
	import ui.base.jineng.SkillShort;
	import ui.component.XHComboBox;
	import ui.frame.ImageUtils;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.skill.SkillSelecter;
	
	import world.FileManager;

	/**
	 * 游戏辅助功能交互窗口 (老版本的挂机功能的改版)
	 * @author steven guo
	 *
	 **/
	public class GamePlugInsWindow extends UIWindow
	{
		private var m_model:GamePlugIns=null;

		public function GamePlugInsWindow()
		{
			super(getLink(WindowName.win_gua_ji));
			m_model=GamePlugIns.getInstance();
		}
		private static var m_instance:GamePlugInsWindow=null;

		public static function getInstance():GamePlugInsWindow
		{
			if (null == m_instance)
			{
				m_instance=new GamePlugInsWindow();
			}
			return m_instance;
		}

		public function updata():void
		{
			_repaint();
		}

		override protected function init():void
		{
			super.init();
			Data.skillShort.addEventListener(SkillShortSet.SKILLSHORTCHANGE, skillShortChange);
			_initCom();
			_repaint();
			this.initHotKeys();
			mc["mc_hotKey"].addEventListener(MouseEvent.CLICK, thisUI_MOUSE_DOWN);
			m_model.requestPacketCSAutoConfig();
			if (SkillShort.StructShortKeyEvent != null)
			{
				skillShortChange(SkillShort.StructShortKeyEvent);
			}
		}

		//技能数据变化
		private function skillShortChange(e:DispatchEvent):void
		{
			var vec:Vector.<StructShortKey2>;
			vec=Data.skillShort.contentList;
			var len:int=vec.length;
			var uilMC:MovieClip;
			var lock:int=Data.myKing.ShortKeyLock;
			for (var i:int=0; i < len; i++)
			{
				var pos:int=vec[i].pos;
				//				pos = pos<8?pos+8:pos;
				//if((pos>0&&pos<5)||pos==9||pos==10){
				//if((pos>0&&pos<5)){
				if ((pos >= SkillShort.LIMIT && pos < SkillShort.LIMIT_GUA_JI))
				{
					if (!vec[i].del && vec[i].id != 0)
					{
						uilMC=mc["mc_hotKey"]["itjinengBox" + pos]["item_hotKey" + pos];
						uilMC["uil"].unload();
						SkillShort.IconKey.put(pos, vec[i].id);
						if (1 == vec[i].type)
						{
						}
						else
						{
							//技能
							//var __gjIcon:String = FileManager.instance.getSkillIconSById(vec[i].id);
//							uilMC["uil"].source=vec[i].icon;
							ImageUtils.replaceImage(uilMC,uilMC["uil"],vec[i].icon);
							uilMC.data=Data.skill.getSkill(vec[i].id);
							if (null != Data.myKing.king)
								SkillEffectManager.instance.preLoad(vec[i].id, Data.myKing.king.sex);
						}
						CtrlFactory.getUIShow().addTip(uilMC);
							//						if (lock==false)
							//							MainDrag.getInstance().regDrag(uilMC);
					}
					else
					{
						SkillShort.IconKey.remove(pos);
						vec[i].isNew=false;
						if (mc["mc_hotKey"]["itjinengBox" + pos] == null)
							continue;
						uilMC=mc["mc_hotKey"]["itjinengBox" + pos]["item_hotKey" + pos];
						uilMC["uil"].unload();
						uilMC.data=null;
						uilMC["txt_num"].text="";
						CtrlFactory.getUIShow().removeTip(uilMC);
							//						MainDrag.getInstance().unregDrag(uilMC);
					}
					uilMC["lengque"].visible=false;
					uilMC["shijian"].text="";
				}
			}
		}

		/**
		 * 初始化快捷键引用
		 */
		private function initHotKeys():void
		{
			//hotkey 中下部快捷键
			var i:int=SkillShort.LIMIT;
			var target:*=mc["mc_hotKey"];
			var key:*;
			for (; i < SkillShort.LIMIT_GUA_JI; i++)
			{
				if (target["itjinengBox" + i] == null)
					continue;
				key=target["itjinengBox" + i]["item_hotKey" + i];
				key.mouseChildren=false;
				key["lengque"].visible=false;
				key.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				key.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			}
		}

		private function onMouseOver(e:MouseEvent):void
		{
			var key:Object=e.target;
			if (key["data"] == null)
			{
				key["overState"].gotoAndStop(2);
			}
			else
			{
				key["overState"].gotoAndStop(3);
			}
		}

		private function onMouseOut(e:MouseEvent):void
		{
			var key:Object=e.target;
			if (key["data"] != null)
			{
				if (key["overState"].currentFrame != 1)
					key["overState"].gotoAndStop(1);
			}
			else
			{
				key["overState"].gotoAndStop(1);
			}
		}

		private function thisUI_MOUSE_DOWN(e:MouseEvent):void
		{
			if (e.target.name.indexOf("item_hotKey") == 0)
			{
				var pos:int=int(e.target.name.replace("item_hotKey", ""));
				//点击弹出技能选择界面
				this.resetAllHotKeyStates();
				SkillSelecter.replacePos=pos;
				if (mc["mc_hotKey"]["itjinengBox" + pos] != null)
				{
					var uilMC:MovieClip=mc["mc_hotKey"]["itjinengBox" + pos]["item_hotKey" + pos];
					uilMC["mc_selected"].gotoAndStop(2);
					SkillSelecter.replaceId=-1;
					if (uilMC.data != null)
					{
						if (uilMC.data is StructSkillItem2)
						{
							SkillSelecter.replaceId=StructSkillItem2(uilMC.data).skill_id;
							SkillSelecter.replaceType=0;
						}
					}
				}
				SkillSelecter.getInstance().open(true);
				SkillSelecter.getInstance().renderSkill(pos == 15);
				SkillSelecter.getInstance().addEventListener(MouseEvent.CLICK, onChooseSkill);
				PubData.mainUI.stage.addEventListener(MouseEvent.MOUSE_DOWN, onChooseSkill);
					//this.renderSkillShortDataProvider();
			}
		}

		private function onChooseSkill(e:MouseEvent):void
		{
			if (SkillSelecter.getInstance().isOpen)
			{
				if (e.target.parent == mc["mc_hotKey"] && e.target.name.indexOf("item_hotKey") == 0)
					return;
				SkillSelecter.getInstance().winClose();
				this.resetAllHotKeyStates();
			}
			else
			{
				return;
			}
			SkillSelecter.getInstance().chooseSkill(e.target);
		}

		private function resetAllHotKeyStates():void
		{
			var i:int=SkillShort.LIMIT;
			var target:*=mc["mc_hotKey"];
			var key:*;
			for (; i < SkillShort.LIMIT_GUA_JI; i++)
			{
				if (target["itjinengBox" + i] == null)
					continue;
				key=target["itjinengBox" + i]["item_hotKey" + i];
				key["mc_selected"].gotoAndStop(1);
			}
		}

		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			switch (target.name)
			{
				case "submit":
					_save();
					break;
				case "btnDefault":
					_setDefault();
					break;
				case "cb_isAutoHP":
					m_cb_isAutoHP.selected=!m_cb_isAutoHP.selected;
					break;
				case "cb_isAutoMP":
					m_cb_isAutoMP.selected=!m_cb_isAutoMP.selected;
					break;
				case "cb_isPickUpEquip":
					m_cb_isPickUpEquip.selected=!m_cb_isPickUpEquip.selected;
					break;
				case "cb_isPickUpMedicine":
					m_cb_isPickUpMedicine.selected=!m_cb_isPickUpMedicine.selected;
					break;
				case "cb_isPickUpMaterial":
					m_cb_isPickUpMaterial.selected=!m_cb_isPickUpMaterial.selected;
					break;
				case "cb_isPickUpOthers":
					m_cb_isPickUpOthers.selected=!m_cb_isPickUpOthers.selected;
					break;
				case "cb_isUnShift":
					m_cb_isUnShift.selected=!m_cb_isUnShift.selected;
					break;
				case "cb_isCallAnimals":
					m_cb_isCallAnimals.selected=!m_cb_isCallAnimals.selected;
					if (m_cb_isCallAnimals.selected && m_cb_isCallSkeleton.selected)
					{
						m_cb_isCallSkeleton.selected=false;
					}
					break;
				case "cb_isCallSkeleton":
					m_cb_isCallSkeleton.selected=!m_cb_isCallSkeleton.selected;
					if (m_cb_isCallAnimals.selected && m_cb_isCallSkeleton.selected)
					{
						m_cb_isCallAnimals.selected=false;
					}
					break;
				case "cb_isMono":
					m_cb_isMono.selected=!m_cb_isMono.selected;
					break;
				case "cb_isAOE":
					m_cb_isAOE.selected=!m_cb_isAOE.selected;
					break;
				case "cb_isAIFire":
					m_cb_isAIFire.selected=!m_cb_isAIFire.selected;
					break;
				case "cb_isMigicLock":
					m_cb_isMigicLock.selected=!m_cb_isMigicLock.selected;
					break;
				case "cb_isAutoShield":
					m_cb_isAutoShield.selected=!m_cb_isAutoShield.selected;
					break;
				case "cb_isProtect":
					m_cb_isProtect.selected=!m_cb_isProtect.selected;
					break;
				default:
					break;
			}
		}

		private function _onTextInput(e:TextEvent=null):void
		{
			var _name:String=e.target.name;
			switch (_name)
			{
				case "":
					break;
				case "":
					break;
				default:
					break;
			}
		}

		private function _save():void
		{
			//自动吃药
			m_model.isAutoHP=m_cb_isAutoHP.selected;
			m_model.autoPerHP=int(m_tf_autoPerHP.text);
			var _value:int=0;
			_value=int(m_tf_autoTimeHP.text);
			if (_value < 500)
			{
				_value=500;
				m_tf_autoTimeHP.text="" + _value;
			}
			m_model.autoTimeHP=_value;
			m_model.isAutoMP=m_cb_isAutoMP.selected;
			m_model.autoPerMP=int(m_tf_autoPerMP.text);
			_value=int(m_tf_autoTimeMP.text);
			if (_value < 500)
			{
				_value=500;
				m_tf_autoTimeMP.text="" + _value;
			}
			m_model.autoTimeMP=_value;
			m_model.autoIdxHP=int(m_cmb_autoIdxHP.curData);
			m_model.autoIdxMP=int(m_cmb_autoIdxMP.curData);
			//拾取过滤
			m_model.isPickUpEquip=m_cb_isPickUpEquip.selected;
			m_model.minLevelPickUpEquip=int(m_tf_minLevelPickUpEquip.text);
			m_model.isPickUpMedicine=m_cb_isPickUpMedicine.selected;
			m_model.isPickUpMaterial=m_cb_isPickUpMaterial.selected;
			m_model.isPickUpOthers=m_cb_isPickUpOthers.selected;
			m_model.pickUpOthersLevel=int(m_cmb_pickUpOthersLevel.curData);
			//战斗设定
			//0
			m_model.withoutShiftKey=m_cb_isUnShift.selected;
			//1
			m_model.autoLieHuo=m_cb_isAIFire.selected;
			//2
			m_model.autoSummonDevil=m_cb_isCallAnimals.selected;
			m_model.magicLock=m_cb_isMigicLock.selected;
			//3
			m_model.autoPretext=m_cb_isAutoShield.selected;
			//4
			m_model.autoSummonSkeleton=m_cb_isCallSkeleton.selected;
			//5
			m_model.isMono=m_cb_isMono.selected;
			//6
			m_model.isAOE=m_cb_isAOE.selected;
			//战斗设定
			if (m_rb_scope_1.selected)
			{
				m_model.scope=1;
			}
			else if (m_rb_scope_2.selected)
			{
				m_model.scope=2;
			}
			else if (m_rb_scope_3.selected)
			{
				m_model.scope=3;
			}
			//战斗保护
			m_model.isProtect=m_cb_isProtect.selected;
			m_model.protectPer=int(m_tf_protectPer.text);
			m_model.protectPropIdx=int(m_cmb_protectPropIdx.curData);
			m_model.requestPacketCSSetAutoConfig();
		}

		/**
		 * 恢复到默认设置
		 *
		 */
		private function _setDefault():void
		{
			//自动吃药
			m_cb_isAutoHP.selected=true;
			m_tf_autoPerHP.text=80 + "";
			m_tf_autoTimeHP.text=500 + "";
			m_cb_isAutoMP.selected=true;
			m_tf_autoPerMP.text=80 + "";
			m_tf_autoTimeMP.text=500 + "";
			m_cmb_autoIdxHP.changeSelected(0);
			m_cmb_autoIdxMP.changeSelected(0);
			//拾取过滤
			m_cb_isPickUpEquip.selected=true;
			m_tf_minLevelPickUpEquip.text=40 + "";
			m_cb_isPickUpMedicine.selected=true;
			m_cb_isPickUpMaterial.selected=true;
			m_cb_isPickUpOthers.selected=true;
			m_cmb_pickUpOthersLevel.changeSelected(1);
			//战斗设定
			m_cb_isUnShift.selected=true;
			m_cb_isMigicLock.selected=true;
			m_cb_isAIFire.selected=true;
			m_cb_isAutoShield.selected=true;
			m_cb_isCallSkeleton.selected=true;
			m_cb_isCallAnimals.selected=false;
			m_cb_isMono.selected=true;
			m_cb_isAOE.selected=true;
			//战斗设定
			switch (2)
			{
				case 1:
					m_rb_scope_1.selected=true;
					m_rb_scope_2.selected=false;
					m_rb_scope_3.selected=false;
					break;
				case 2:
					m_rb_scope_1.selected=false;
					m_rb_scope_2.selected=true;
					m_rb_scope_3.selected=false;
					break;
				case 3:
					m_rb_scope_1.selected=false;
					m_rb_scope_2.selected=false;
					m_rb_scope_3.selected=true;
					break;
				default:
					break;
			}
			//战斗保护
			m_cb_isProtect.selected=false;
			m_tf_protectPer.text=50 + "";
			m_cmb_protectPropIdx.changeSelected(0);
		}

		private function _repaint():void
		{
			//自动吃药
			m_cb_isAutoHP.selected=m_model.isAutoHP;
			m_tf_autoPerHP.text=m_model.autoPerHP.toString();
			m_tf_autoTimeHP.text=m_model.autoTimeHP.toString();
			m_cb_isAutoMP.selected=m_model.isAutoMP;
			m_tf_autoPerMP.text=m_model.autoPerMP.toString();
			m_tf_autoTimeMP.text=m_model.autoTimeMP.toString();
			m_cmb_autoIdxHP.changeSelected(m_model.autoIdxHP);
			m_cmb_autoIdxMP.changeSelected(m_model.autoIdxMP);
			//拾取过滤
			m_cb_isPickUpEquip.selected=m_model.isPickUpEquip;
			m_tf_minLevelPickUpEquip.text=m_model.minLevelPickUpEquip.toString();
			m_cb_isPickUpMedicine.selected=m_model.isPickUpMedicine;
			m_cb_isPickUpMaterial.selected=m_model.isPickUpMaterial;
			m_cb_isPickUpOthers.selected=m_model.isPickUpOthers;
			if (m_model.pickUpOthersLevel <= 0)
			{
				m_model.pickUpOthersLevel=1;
			}
			m_cmb_pickUpOthersLevel.changeSelected(m_model.pickUpOthersLevel - 1);
			//战斗设定
			m_cb_isUnShift.selected=m_model.withoutShiftKey;
			m_cb_isCallAnimals.selected=m_model.autoSummonDevil;
			m_cb_isCallSkeleton.selected=m_model.autoSummonSkeleton;
			m_cb_isMono.selected=m_model.isMono;
			m_cb_isAOE.selected=m_model.isAOE;
			m_cb_isAIFire.selected=m_model.autoLieHuo;
			m_cb_isMigicLock.selected=m_model.magicLock;
			m_cb_isAutoShield.selected=m_model.autoPretext;
			//战斗设定
			switch (m_model.scope)
			{
				case 1:
					m_rb_scope_1.selected=true;
					m_rb_scope_2.selected=false;
					m_rb_scope_3.selected=false;
					break;
				case 2:
					m_rb_scope_1.selected=false;
					m_rb_scope_2.selected=true;
					m_rb_scope_3.selected=false;
					break;
				case 3:
					m_rb_scope_1.selected=false;
					m_rb_scope_2.selected=false;
					m_rb_scope_3.selected=true;
					break;
				default:
					break;
			}
			//战斗保护
			m_cb_isProtect.selected=m_model.isProtect;
			m_tf_protectPer.text=m_model.protectPer.toString();
			if (m_model.protectPropIdx <= 0)
			{
				m_model.protectPropIdx=1;
			}
			m_cmb_protectPropIdx.changeSelected(m_model.protectPropIdx - 1);
		}

		private function _onCmb_autoIdxHP(ds:DispatchEvent):void
		{
		}

		private function _onCmb_autoIdxMP(ds:DispatchEvent):void
		{
		}

		private function _onCmb_pickUpOthersLevel(ds:DispatchEvent):void
		{
		}
		private var m_hasInitCom:Boolean=false;

		private function _initCom():void
		{
			if (null == mc)
				return;
			if (m_hasInitCom)
				return;
			m_hasInitCom=true;
//			m_cb_test = new XHComboBox(mc['cb_test']);
//			m_cb_test.items = [{label:"　仙灵露",data:0},{label:"　梵音玉露",data:1},{label:"　瑶山清风露",data:2}];
//			
			//自动吃药
			m_cb_isAutoHP=mc['cb_isAutoHP'] as CheckBoxStyle1;
			m_tf_autoPerHP=mc['tf_autoPerHP'] as TextField;
			//m_tf_autoPerHP.addEventListener(TextEvent.TEXT_INPUT,_onTextInput);
			m_tf_autoPerHP.maxChars=2;
			m_tf_autoPerHP.restrict="0-9";
			m_tf_autoTimeHP=mc['tf_autoTimeHP'] as TextField;
			m_tf_autoTimeHP.maxChars=4;
			m_tf_autoTimeHP.restrict="0-9";
			//m_tf_autoTimeHP.addEventListener(Event.CHANGE,_on_tf_autoTimeHP_Change);
			m_cb_isAutoMP=mc['cb_isAutoMP'] as CheckBoxStyle1;
			m_tf_autoPerMP=mc['tf_autoPerMP'] as TextField;
			m_tf_autoPerMP.maxChars=2;
			m_tf_autoPerMP.restrict="0-9";
			m_tf_autoTimeMP=mc['tf_autoTimeMP'] as TextField;
			m_tf_autoTimeMP.maxChars=4;
			m_tf_autoTimeMP.restrict="0-9";
			//m_tf_autoTimeMP.addEventListener(Event.CHANGE,_on_tf_autoTimeMP_Change);
			m_cmb_autoIdxHP=mc['cmb_autoIdxHP'] as CmbArrange;
//			m_cmb_autoIdxHP.rowCount=3;
//			m_cmb_autoIdxHP.addItems=[{label: "　太阳水", data: 0}, {label: "　梵音玉露", data: 1}, {label: "　瑶山清风露", data: 2}];
			m_cmb_autoIdxHP.rowCount=1;
			m_cmb_autoIdxHP.addItems=[{label: "　太阳水", data: 0}];
			m_cmb_autoIdxHP.addEventListener(DispatchEvent.EVENT_COMB_CLICK, _onCmb_autoIdxHP);
			m_cmb_autoIdxMP=mc['cmb_autoIdxMP'] as CmbArrange;
//			m_cmb_autoIdxMP.rowCount=3;
//			m_cmb_autoIdxMP.addItems=[{label: "　太阳水", data: 0}, {label: "　梵音玉露", data: 1}, {label: "　瑶山清风露", data: 2}];
			m_cmb_autoIdxMP.rowCount=1;
			m_cmb_autoIdxMP.addItems=[{label: "　太阳水", data: 0}];
			m_cmb_autoIdxMP.addEventListener(DispatchEvent.EVENT_COMB_CLICK, _onCmb_autoIdxMP);
			//拾取过滤
			m_cb_isPickUpEquip=mc['cb_isPickUpEquip'] as CheckBoxStyle1;
			m_tf_minLevelPickUpEquip=mc['tf_minLevelPickUpEquip'] as TextField;
			m_tf_minLevelPickUpEquip.maxChars=2;
			m_tf_minLevelPickUpEquip.restrict="0-9";
			m_cb_isPickUpMedicine=mc['cb_isPickUpMedicine'] as CheckBoxStyle1;
			m_cb_isPickUpMaterial=mc['cb_isPickUpMaterial'] as CheckBoxStyle1;
			m_cb_isPickUpOthers=mc['cb_isPickUpOthers'] as CheckBoxStyle1;
			m_cmb_pickUpOthersLevel=mc['cmb_pickUpOthersLevel'] as CmbArrange;
			m_cmb_pickUpOthersLevel.rowCount=5;
			m_cmb_pickUpOthersLevel.addItems=[{label: "　白色", data: 1}, {label: "　黄色", data: 2}, {label: "　绿色", data: 3}, {label: "　蓝色", data: 4}, {label: "　紫色", data: 5}, {label: "　橙色", data: 6}];
			m_cmb_pickUpOthersLevel.addEventListener(DispatchEvent.EVENT_COMB_CLICK, _onCmb_pickUpOthersLevel);
			//战斗设定
			m_cb_isUnShift=mc['cb_isUnShift'] as CheckBoxStyle1;
			m_cb_isCallAnimals=mc['cb_isCallAnimals'] as CheckBoxStyle1;
			m_cb_isMono=mc['cb_isMono'] as CheckBoxStyle1;
			m_cb_isAIFire=mc['cb_isAIFire'] as CheckBoxStyle1;
			m_cb_isAutoShield=mc['cb_isAutoShield'] as CheckBoxStyle1;
			m_cb_isAOE=mc['cb_isAOE'] as CheckBoxStyle1;
			m_cb_isMigicLock=mc['cb_isMigicLock'] as CheckBoxStyle1;
			m_cb_isCallSkeleton=mc['cb_isCallSkeleton'] as CheckBoxStyle1;
			//定点打怪
			m_rb_scope_1=mc['rb_scope_1'] as RadioButtonGreen;
			m_rb_scope_2=mc['rb_scope_2'] as RadioButtonGreen;
			m_rb_scope_3=mc['rb_scope_3'] as RadioButtonGreen;
			//战斗保护
			m_cb_isProtect=mc['cb_isProtect'] as CheckBoxStyle1;
			m_tf_protectPer=mc['tf_protectPer'] as TextField;
			m_tf_protectPer.maxChars=2;
			m_tf_protectPer.restrict="0-9";
			m_cmb_protectPropIdx=mc['cmb_protectPropIdx'] as CmbArrange;
			m_cmb_protectPropIdx.rowCount=1;
			m_cmb_protectPropIdx.addItems=[{label: "　回城卷轴", data: 1}];
		}
		private var m_cb_test:XHComboBox=null;
		//自动吃药
		private var m_cb_isAutoHP:CheckBoxStyle1=null;
		private var m_tf_autoPerHP:TextField=null;
		private var m_cmb_autoIdxHP:CmbArrange=null;
		private var m_tf_autoTimeHP:TextField=null;
		private var m_cb_isAutoMP:CheckBoxStyle1=null;
		private var m_tf_autoPerMP:TextField=null;
		private var m_cmb_autoIdxMP:CmbArrange=null;
		private var m_tf_autoTimeMP:TextField=null;
		//拾取过滤
		private var m_cb_isPickUpEquip:CheckBoxStyle1=null;
		private var m_tf_minLevelPickUpEquip:TextField=null;
		private var m_cb_isPickUpMedicine:CheckBoxStyle1=null;
		private var m_cb_isPickUpMaterial:CheckBoxStyle1=null;
		private var m_cb_isPickUpOthers:CheckBoxStyle1=null;
		private var m_cmb_pickUpOthersLevel:CmbArrange=null;
		//战斗设定
		private var m_cb_isUnShift:CheckBoxStyle1=null;
		private var m_cb_isAIFire:CheckBoxStyle1=null;
		private var m_cb_isCallAnimals:CheckBoxStyle1=null;
		private var m_cb_isMigicLock:CheckBoxStyle1=null;
		private var m_cb_isAutoShield:CheckBoxStyle1=null;
		private var m_cb_isCallSkeleton:CheckBoxStyle1=null;
		private var m_cb_isMono:CheckBoxStyle1=null;
		private var m_cb_isAOE:CheckBoxStyle1=null;
		//定点打怪
		private var m_rb_scope_1:RadioButtonGreen=null;
		private var m_rb_scope_2:RadioButtonGreen=null;
		private var m_rb_scope_3:RadioButtonGreen=null;
		//战斗保护
		private var m_cb_isProtect:CheckBoxStyle1=null;
		private var m_tf_protectPer:TextField=null;
		private var m_cmb_protectPropIdx:CmbArrange=null;

		override public function get width():Number
		{
			return 480;
		}

		override public function get height():Number
		{
			return 455;
		}
	}
}
