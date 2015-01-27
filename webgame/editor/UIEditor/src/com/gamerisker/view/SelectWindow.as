package com.gamerisker.view
{
	import boomiui.manager.ComponentManager;
	
	import com.gamerisker.manager.ControlManager;
	import com.gamerisker.manager.FileManager;
	import com.gamerisker.manager.MouseManager;
	import com.gamerisker.manager.TexturesManager;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.core.IVisualElement;
	
	import spark.components.Button;
	import spark.components.Panel;
	import spark.components.TitleWindow;

	public class SelectWindow
	{
		public var panel:Panel;
		private static var _instance:SelectWindow;

		public static function get instance():SelectWindow
		{
			if (_instance == null)
			{
				_instance=new SelectWindow();
			}
			return _instance;
		}

		public function refreshCustom():void
		{
			FileManager.refreshCustomEditor();
			var mBtn:Button;
			var hCount:int=RookieEditor.getInstante().SelectComponet.numElements;
			while (hCount--)
			{
				mBtn=RookieEditor.getInstante().SelectComponet.getElementAt(hCount) as Button;
				if (mBtn && ComponentManager.customEditor[mBtn.label])
				{
					mBtn.removeEventListener(MouseEvent.CLICK, SelectWindow.instance.OnComponentClick);
					RookieEditor.getInstante().SelectComponet.removeElement(mBtn);
				}
			}
			hCount=1;
			for (var mStr:String in ComponentManager.customEditor)
			{
				mBtn=new Button();
				mBtn.name=mStr;
				RookieEditor.getInstante().SelectComponet.addElement(mBtn);
				mBtn.label=mStr;
				mBtn.x=RookieEditor.getInstante().btnClear.x;
				mBtn.y=RookieEditor.getInstante().btnClear.y + hCount * RookieEditor.getInstante().btnClear.height;
				mBtn.width=RookieEditor.getInstante().btnClear.width;
				mBtn.addEventListener(MouseEvent.CLICK, SelectWindow.instance.OnComponentClick);
				hCount++;
			}
		}

//		private function Init():void
//		{
//			statusBar.height = 3;
//			panel.titleDisplay.addEventListener(MouseEvent.MOUSE_DOWN,OnStartDrag);
//		}

		public function OnComponentToCustom(event:MouseEvent):void
		{
//			this.nativeWindow.startMove();
			if (ControlManager.getCurrentComponent() != null)
			{
				FileManager.saveXMLFile(true);
			}
			else
			{
				Alert.show("没有控制组件", "错误", Alert.OK, RookieEditor.getInstante().menubar);
			}
			refreshCustom();
		}

		public function OnComponentClick(event:MouseEvent,targetName:String=null):void
		{
			var bitmap:flash.display.Sprite=TexturesManager.getIcon(event.target.name);
			bitmap.mouseChildren=bitmap.mouseEnabled=false;
			bitmap.x=100;
			bitmap.y=100;
			MouseManager.AddBand(bitmap, event.target.name);
		}

		public function OnComponentRemove(event:MouseEvent):void
		{
			if (MouseManager.GetBand())
			{
				MouseManager.RemoveBand();
			}
		}
	}
}
