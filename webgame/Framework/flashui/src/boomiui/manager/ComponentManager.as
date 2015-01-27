package boomiui.manager
{
	import boomiui.editor.ButtonEditor;
	import boomiui.editor.CheckBoxEditor;
	import boomiui.editor.Editor;
	import boomiui.editor.GroupedListEditor;
	import boomiui.editor.LabelEditor;
	import boomiui.editor.ListEditor;
	import boomiui.editor.NumericStepperEditor;
	import boomiui.editor.PageIndicatorEditor;
	import boomiui.editor.PickerListEditor;
	import boomiui.editor.ProgressBarEditor;
	import boomiui.editor.RadioButtonEditor;
	import boomiui.editor.ScrollContainerEditor;
	import boomiui.editor.ScrollTextEditor;
	import boomiui.editor.SkinImageEditor;
//	import boomiui.editor.SkinMovieEditor;
	import boomiui.editor.SliderEditor;
	import boomiui.editor.TabBarEditor;
	import boomiui.editor.TextInputEditor;
	import boomiui.editor.TitleWindowEditor;
	
	import feathers.core.IFeathersControl;
	
	import flash.utils.Dictionary;
	
	import mx.controls.Alert;
	
	import spark.components.supportClasses.Skin;
	
	import starling.events.TouchPhase;

	public class ComponentManager
	{

		/**
		 *	根据XML生成组件
		 * @param xml
		 * @return
		 *
		 */
		public static function setComponentByXML(xml:XML, addEventFunc:Function=null, eventCallBackClick:Function=null, eventCallBackMove:Function=null):Editor
		{
			var name:String=xml.localName();
			var editor:Editor=getComponentByClass(name);
			if (editor)
			{
				editor.xmlToComponent(xml);

				var child:Editor;
				for each (var item:XML in xml.elements())
				{
					child=setComponentByXML(item, addEventFunc, eventCallBackClick, eventCallBackMove);

					if (child)
					{
						editor.addEditor(child);
					}
				}
				if (addEventFunc != null)
				{
					addEventFunc(TouchPhase.BEGAN, editor, eventCallBackClick);
					addEventFunc(TouchPhase.HOVER, editor, eventCallBackMove);
				}
			}
			return editor
		}

		/**
		 *	根据组件名获取组件
		 * @param className
		 * @return
		 *
		 */
		public static function getComponentByClass(className:String):Editor
		{
			if (className == null)
				return null;

			switch (className)
			{
				case "Button":
					return new ButtonEditor;
				case "TitleWindow":
					return new TitleWindowEditor;
				case "CheckBox":
					return new CheckBoxEditor;
				case "RadioButton":
					return new RadioButtonEditor;
				case "Label":
					return new LabelEditor;
				case "Slider":
					return new SliderEditor;
				case "SkinImage":
					return new SkinImageEditor;
//				case "SkinMovieClip":
//					return new SkinMovieEditor;
				case "List":
					return new ListEditor;
				case "TabBar":
					return new TabBarEditor;
				case "TextInput":
					return new TextInputEditor;
				case "ScrollText":
					return new ScrollTextEditor;
				case "GroupedList":
					return new GroupedListEditor;
				case "NumericStepper":
					return new NumericStepperEditor;
				case "PageIndicator":
					return new PageIndicatorEditor;
				case "PickerList":
					return new PickerListEditor;
				case "ProgressBar":
					return new ProgressBarEditor;
				case "ScrollContainer":
					return new ScrollContainerEditor;
			}
//			Alert.show("ComponentManager : 没有找到组件" + className, "错误", 4);
			return null;
		}
		private static var _customEditor:Dictionary;

		public static function get customEditor():Dictionary
		{
			return _customEditor;
		}

		public static function set customEditor(value:Dictionary):void
		{
			_customEditor=value;
		}

		public static function getCustomComponentByName(editorName:String, addEventFunc:Function=null, eventCallBackClick:Function=null, eventCallBackMove:Function=null):Editor
		{
			if (_customEditor)
			{
				if (_customEditor[editorName] is XML)
				{
					_customEditor[editorName]=setComponentByXML(_customEditor[editorName],addEventFunc,eventCallBackClick,eventCallBackMove);
				}
				return _customEditor[editorName];
			}
			return null;
		}
	}
}
