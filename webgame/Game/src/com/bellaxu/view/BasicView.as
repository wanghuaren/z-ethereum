package com.bellaxu.view
{
	import com.bellaxu.def.LayerDef;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * 带有初始属性(这些属性可能随后会发生变化，故保存下来)的显示视图
	 * 继承自Sprite，如果fla中的界面是多帧的MC，则需先将多帧MC放入另一个MC，作为Sprite
	 * @author BellaXu
	 */
	public class BasicView extends Sprite
	{
		public var gameLine:*;//数据线
		
		protected var isInitialized:Boolean;
		private var _autoResize:Boolean;
		private var _originalWidth:uint;//初始宽
		private var _originalHeight:uint;//初始高
		
		public function BasicView(autoResize:Boolean = true)
		{
			_autoResize = autoResize;
			stage ? onAddedToStage() : addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			loaderInfo ? loaderInfo.addEventListener(Event.COMPLETE, onComplete) : isInitialized = true;
			
			initView();
		}
		
		protected function initView():void
		{
			
		}
		
		public function get parentLayer():DisplayObjectContainer
		{
			return LayerDef.uiLayer;
		}
		
		public function show():void
		{
			this.visible = true;
			if(!parent)
				parentLayer.addChild(this);
		}
		
		public function hide():void
		{
			this.visible = false;
			if(parent)
				parent.removeChild(this);
		}
		
		protected function afterAddedToStage():void
		{
			//此处添加到舞台后的规则
		}
		
		protected function afterRemovedFromStage():void
		{
			//此处添加移出舞台后的规则
		}
		
		protected function afterResized():void
		{
			//此处添加自适应规则
		}
		
		protected function afterResized2():void
		{
			//此处供FullScreenView覆盖，防止其他子类没有调用FullScreenView的afterResize方法
		}
		
		private var _needAddedToStage:Boolean = false;
		
		private function onAddedToStage(e:Event = null):void
		{
			//判断显示对象是否构建完毕，若否则在显示对象构建完毕后再执行
			if(!isInitialized)
			{
				_needAddedToStage = true;
				return;
			}
			
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			afterAddedToStage();
			stage.addEventListener(Event.RESIZE, onResize);
			onResize();
		}
		
		private function onRemovedFromStage(e:Event):void
		{
			_needAddedToStage = false;
			gameLine = null; //清掉gameline
			//移出舞台自动销毁
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			stage.removeEventListener(Event.RESIZE, onResize);
			afterRemovedFromStage();
		}
		
		private function onResize(e:Event = null):void
		{
			if(_autoResize)
			{
				x = !originalWidth ? 0 : stage.stageWidth - originalWidth >> 1;
				y = !originalHeight ? 0 : stage.stageHeight - originalHeight >> 1;
			}
			afterResized();
			afterResized2();
		}
		
		private function onComplete(e:Event):void
		{
			loaderInfo.removeEventListener(Event.COMPLETE, onComplete);
			_originalWidth = this.width;
			_originalHeight = this.height;
			isInitialized = true; //初始化完毕
			if(_needAddedToStage)
				onAddedToStage();
		}
		
		/**
		 * 初始宽
		 */
		public function get originalWidth():uint
		{
			return _originalWidth;
		}
		
		/**
		 * 初始高
		 */
		public function get originalHeight():uint
		{
			return _originalHeight;
		}
	}
}