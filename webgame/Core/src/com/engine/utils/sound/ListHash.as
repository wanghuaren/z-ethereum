package com.engine.utils.sound
{
	import com.engine.utils.ObjectUtils;
	
	import flash.system.System;
	import flash.utils.Dictionary;
	

	
	public class ListHash
	{
		
		protected var $dic:Dictionary;
		protected var $values:Vector.<MusiceVo>;
		protected var $currentChain:MusiceVo
		protected var $currentIndex:int
		
		public function ListHash()
		{
			initialize()
			
		}
		
		/**
		 * 获取下一个 
		 * @return 
		 * 
		 */		
		public function get next():MusiceVo
		{
			this.$currentIndex++;
			if(this.$currentIndex<this.values.length-1)
			{
				this.$currentChain=this.values[this.currentIndex]
				return 	this.$currentChain
			}else {
				this.$currentIndex=this.values.length
			}
			return null
		}
		/**
		 * 获取前一个 
		 * @return 
		 * 
		 */		
		public function get prve():MusiceVo
		{
			this.$currentIndex--;
			if(this.$currentIndex>0)
			{
				this.$currentChain=this.values[this.currentIndex]
			 return 	this.$currentChain
			}else {
				this.$currentIndex=0
			}
			return null
		};
		/**
		 * 获取或设置当前vo 
		 * @return 
		 * 
		 */		
		public function get currentChain():MusiceVo
		{
			return this.$currentChain
		}
		public function set currentChain(value:MusiceVo):void
		{
			this.$currentChain=value
		}
		/**
		 * 返回当前列表的长度 
		 * @return 
		 * 
		 */		
		public function get length():int
		{
			return this.values.length
		}
		/**
		 * 获取或设置当前选择的索引 
		 * @return 
		 * 
		 */		
		public function get currentIndex():int
		{
			return this.$currentIndex
		}
		public function set currentIndex(value:int):void
		{
			this.$currentIndex=value
		}
		/**
		 *初始化 
		 * 
		 */		
		public function initialize():void
		{
			this.$dic=new Dictionary
			this.$values=new Vector.<MusiceVo>;
			this.$currentIndex=0
		}
		/**
		 *注销 
		 * 
		 */		
		public function unload():void
		{
			for(var i:String in this.$dic)
			{
				delete this.$dic[i]
			}
			for(var j:String in this.$values)
			{
				delete this.$values[j]
			}
			this.$dic=null
			this.$values=null
			 System.gc();
			 System.gc();
				  
		}
		/**
		 *添加一个元素 
		 * @param value
		 * @return 
		 * 
		 */			
		public function put(value:MusiceVo):Boolean
		{
			if(this.$dic[value.id]==null){
				this.$dic[value.id]=value;
				this.$values.push(value);
				return true
			}
			return false
		}
		/**
		 * 插入
		 * 但插入对象已在列表中时只会修改该对象的位置索引 
		 * @param value 实现MusiceVo接口的实例
		 * @param insertIndex 要插入的位置 超过或==-1时插入到最后一位
		 * @return 
		 * 
		 */		
		public function insert(value:MusiceVo,insertIndex:int):Boolean
		{
			
			if(this.has(value.id)){
				var item:MusiceVo=this.values.splice(value.level,1) as MusiceVo
				if(insertIndex==-1||insertIndex>this.$values.length-1){
					this.$values.push(item);
					return true;
				}else if(insertIndex==0||insertIndex<-1){
					this.$values.unshift(item);
					return true;
				} else {
					this.$values.splice(insertIndex,0,item)
					return true;
				}
				
			}else {
				if(insertIndex==-1||insertIndex>this.$values.length-1){
					this.$values.push(value);
					return true;
				}else if(insertIndex==0||insertIndex<-1){
					this.$values.unshift(value);
					return true;
				}else {
					this.$values.splice(insertIndex,0,value)
					return true;
				}
			}
			
			return false
		}
		/**
		 * 根据一个id获取一个元素 
		 * @param key
		 * @return 对象存在返回该对象，否则返回null
		 * 
		 */		
		public function take(key:String):MusiceVo
		{
			return this.$dic[key]
		}
		/**
		 * 根据一个索引获取一个元素 
		 * @param key
		 * @return 对象存在返回该对象，否则返回null
		 * 
		 */		
		public function takeAt(index:int):MusiceVo
		{
			try{
			return this.$values[index]
			}catch(e:Error){}
			return null
		}
		/**
		 * 根据一个id判断一个对象是否存在 
		 * @param key
		 * @return 存在返回true 否则返回false
		 * 
		 */		
		public function has(key:String):Boolean
		{ 
			if(this.$dic[key])return true;
			return false
		}
		/**
		 * 根据一个id删除一个元素 
		 * @param key
		 * @return 操作成功返回true 否则返回false
		 * 
		 */		
		public function remove(key:String):Boolean
		{
			if(this.has(key))
			{
				var index:uint=this.$dic[key].level
				this.$values.splice(index,1)
				delete this.$dic[key];
				return true
			}
			return false
		}
		
		/**
		 * 根据一个索引删除一个元素 
		 * @param index
		 * @return 操作成功返回true 否则返回false
		 * 
		 */		
		public function removeAt(index:int):MusiceVo
		{
			var item:MusiceVo=this.values[index]
			this.values.splice(index,1)
			if(item){
				
				delete this.$dic[item.id]
				return item
			}
			return null
		}
		/**
		 *根据一个属性排序当前hashmap的顺序 
		 * @param pro
		 * 
		 */		
		public function sortOn(pro:String):void
		{
			this.$values
		}	
		/**
		 * 返回该hashmap的引用 
		 * @return 
		 * 
		 */		
		public function get map():Dictionary
		{
			return this.$dic
			
		}
		/**
		 * 返回一个拷贝当的hashmap 
		 * @return 
		 * 
		 */		
		public function copyMap():Dictionary
		{
				 
			return ObjectUtils.copy(this.$dic) as Dictionary
		}
		/**
		 * 返回当前hashmap数组形式的引用 
		 * @return 
		 * 
		 */		
		public function get values():Vector.<MusiceVo>
		{
			return this.$values
			
		}
		/**
		 * 返回当前hashmap数组形式的副本
		 * @return 
		 * 
		 */	
		public function copyValues():Vector.<MusiceVo>
		{
			return ObjectUtils.copy(this.$dic) as Vector.<MusiceVo>
		}
		
		
		
		
		
		
	}
}