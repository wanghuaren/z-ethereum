package com.bommie.role
{
	import com.bommie.def.ResDef;
	import com.bommie.role.struct.BitmapInfo;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;

	/**
	 * mc资源
	 * 初始化传入对应的位图组，释放时不对位图组释放，统一在外边释放
	 * @author  Bommie
	 */
	public class ResMc extends Sprite
	{
//		public static const DEFAULT_PLAY_TIME_PER_FRAME:int = 100;
//		private var movie:Vector.<BitmapInfo> = null;
		public var fpsTime:Number=0;
		public var delay:int;
		/**
		 * 当前动作 D1待机 D2 修炼
		 * D3 攻击1 D4 技能攻击
		 * D5 跑步 D6  走路 D7 死亡
		 * D8 采集
		 * D9 攻击2
		 * D10 坐骑待机 D11 坐骑行走
		 * D13 现在为受伤(受击)
		 */
		public var act:String="D1";
		public var dir:String="F1";
		public var lastDir:String=null;
		public var curBitmap:Image=null;
		public var mcName:String=null;
		public var xmlPath:String=null;
		public var needTurn:Boolean=false;
		public var frameName:String=null;
		public var isMove:Boolean=false;
		public var isPart:Boolean=false; //是否是部件，针对于坐骑、翅膀、武器以及技能
		public var layer:int=-1; //位置
		//=======================================
		public var _undisposed_:Boolean=true
		//=======================================
		private var _mattrix:Vector.<ResMc>=null;
		private var _listers:Dictionary;
		private var _rightHand:int=1;
		private var _beginIndex:int=0;
		private var _endIndex:int=0;
		private var _frameIndex:int=0;
		private var _isStopped:Boolean=true;
		private var _count:int=0;
		private var _playCount:int=0;
		private var _playOverAct:Function=null;
		private var m_nMidActionIndex:int=-1;
		private var m_nMidActionHandler:Function=null;
		private var _originX:int=0;
		private var _originY:int=0;
		private var _center:int=0;
		private var _centerToFoot:int=0;
		/** 0,翅膀     1,坐骑    2,人(不用指定) 3,武器 **/
		//------------------------ new codes ----------------------------
		public var tempPlayTime:int=0;
		public var isSpecial:Boolean=false;
		/**
		 * 当前动作执行的时间 默认为毫秒(可以精确到微秒)
		 */
		private var m_nActionTime:Number=0;
		/**
		 * 每一帧执行的频率
		 */
		private var m_nTick:Number=0;

		/**
		 * 当前帧执行的时间，单位：毫秒
		 */
		public function update():void
		{
			if (this.movie == null)
				return;
			m_nActionTime+=nTick;
			var actionIndex:int=int(m_nActionTime);
			if (m_nActionTime >= frames + 1)
			{
//				actionIndex = 0;
				if (loopFromFrame > 0)
				{
					m_nActionTime=loopFromFrame;
				}
				else
				{
					m_nActionTime=0;
				}
			}
			var currentActionIndex:int=_frameIndex - _beginIndex;
			if (this.currentTexture == null || this.currentTexture == ResDef.defautlBody || actionIndex != currentActionIndex)
			{
				this.nextFrame();
			}
		}

		public function stopAtBegin():void
		{
			stop();
			this._frameIndex=_beginIndex;
			this.setCurrentFrame();
		}

		public function stopAtEnd():void
		{
			stop();
			this._frameIndex=_endIndex;
			this.setCurrentFrame();
		}

		public function get isStoped():Boolean
		{
			return _isStopped;
		}

		//----------------------- end new codes ------------------------
		public function ResMc()
		{
			_listers=new Dictionary();
			_mattrix=new Vector.<ResMc>(4);

			curBitmap=new Image(ResDef.defautlBody);
			curBitmap.smoothing=TextureSmoothing.NONE;
			curBitmap.name="curBitmap";
			addChild(curBitmap);
			this.touchable=false;
			this.delay=(Math.random() * 30 >> 0);
		}
		private var _movies:Vector.<BitmapInfo>;

		public function get movie():Vector.<BitmapInfo>
		{
			if (this._movies)
			{
				return this._movies;
			}
			return null;
		}

		public function set movie(value:Vector.<BitmapInfo>):void
		{
			this._movies=value;
		}

//		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		override public function addEventListener(type:String, listener:Function):void
		{
			if (!_listers)
				return;
//			super.removeEventListener(type, listener, useCapture);
			super.removeEventListener(type, listener);
//			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			super.addEventListener(type, listener);
			_listers[type]={type: type, listener: listener};
		}

//		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		override public function removeEventListener(type:String, listener:Function):void
		{
			if (!_undisposed_)
				return;
//			super.removeEventListener(type, listener, useCapture);
			super.removeEventListener(type, listener);
			_listers.remove(type);
		}

		public function play(stop:Boolean=false):void
		{
			if (!_undisposed_)
				return;
			_isStopped=stop;
			ResMcMgr.instance.play(this);
		}

		public function stop():void
		{
			if (!_undisposed_)
				return;
			_isStopped=true;
			ResMcMgr.instance.stop(this);
		}
		private var m_delay:Number=0;

		public function gotoAndPlay(frame:String):void
		{
			play(false);
			goto(frame);
			for each (var child:ResMc in _mattrix)
			{
				if (child)
					child.goto(frame);
			}
			if (wing != null)
			{
				if (wing.frameName != frame)
				{
					layerSet();
				}
				wing.goto(frame);
			}
		}

		public function gotoAndStop(frame:String):void
		{
			stop();
			goto(frame);
			for each (var child:ResMc in _mattrix)
			{
				if (child)
					child.goto(frame);
			}
			if (wing != null)
			{
				if (wing.frameName != frame)
				{
					layerSet();
				}
				wing.goto(frame);
			}
		}

		private function goto(frame:String):void
		{
			if (!frame || !movie)
				return;
			playTime=-1;
			if (frameName != frame)
				getBeginEnd(frame);
			m_nActionTime=0;
			_frameIndex=_beginIndex;
			setCurrentFrame();
		}

		private function getBeginEnd(frame:String):void
		{
			if (!_undisposed_)
				return;
			var fPoint:int=frame.indexOf("F");
			act=frame.substring(0, fPoint);
			dir=frame.substring(fPoint, fPoint + 2);
			frameName=frame;
			needTurn=false;
			var label:String=frame;
			if (dir == "F6")
				label=frame.replace("F6", "F4");
			else if (dir == "F7")
				label=frame.replace("F7", "F3");
			else if (dir == "F8")
				label=frame.replace("F8", "F2");
			if (label != frame)
				needTurn=true;
			_beginIndex=0;
			_endIndex=0;
			var foundBegin:Boolean=false;
			var len:int=movie.length;
			var _bitmapInfo:BitmapInfo=null;
			var i:int=0;
			for (i=0; i < len; i++)
			{
				_bitmapInfo=movie[i];
				if (_bitmapInfo.mark == label)
				{
					if (!foundBegin)
					{
						_beginIndex=i;
						foundBegin=true;
					}
					if (i == len - 1)
					{
						_endIndex=i;
						break;
					}
				}
				else if (foundBegin)
				{
					_endIndex=i - 1;
					break;
				}
			}
			_bitmapInfo=movie[_beginIndex];
			_originX=_bitmapInfo.originX;
			_originY=_bitmapInfo.originY;
			_jumpFrame=_bitmapInfo.jumpFrame;
			_center=_bitmapInfo.center;
		}
		private var m_nResLoadedCache:Dictionary=new Dictionary();

		/**
		 * 资源是否加载完成
		 */
		public function get isResLoaded():Boolean
		{
			if (movie == null || movie.length == 0)
				return false;
			var _bitmapInfo:BitmapInfo=movie[_frameIndex];
			var m_nIsResLoaded:Boolean;
			var actStr:String=_bitmapInfo.act;
			if (m_nResLoadedCache[actStr] == null && _bitmapInfo)
			{
//				m_nIsResLoaded=ResMcMgr.isResLoadedInAct(mcName, _bitmapInfo.act);
				m_nIsResLoaded=ResMcMgr.instance.isResLoadedInAct(xmlPath, _bitmapInfo.act);
				if (m_nIsResLoaded)
				{
					m_nResLoadedCache[actStr]=1;
				}
				else
				{
					return false;
				}
			}
			return true;
		}

		private function canRenderRes():Boolean
		{
			//保证动画播放完整性，资源加载完后从第一帧开始播放时才出现
			var m_nCanRenderRes:Boolean=false;
			if (isPart == false) //主体
			{
				m_nCanRenderRes=true;
			}
			else
			{
				if (isResLoaded)
				{
					if (isEffect)
					{
						if (m_nCanEffectPlay)
						{
							m_nCanRenderRes=true;
						}
						else
						{
							if (_frameIndex == _beginIndex) //技能从第一帧开始i播放
							{
								m_nCanEffectPlay=true;
								m_nCanRenderRes=true;
							}
						}
					}
					else if (parent && (parent as ResMc).isResLoaded)
					{
						m_nCanRenderRes=true;
					}
				}
			}
			return m_nCanRenderRes;
		}

		private function setCurrentFrame():void
		{
			if (!_undisposed_)
				return;
			var _bitmapInfo:BitmapInfo;
			if (canRenderRes())
			{
				if (isResLoaded)
				{
					_bitmapInfo=movie[_frameIndex];
				}
				else
				{
					_bitmapInfo=movie[_beginIndex];
				}
				_centerToFoot=_bitmapInfo.centerToFoot;
				var _offsetX:int=0;
				var _offsetY:int=0;
				if (parent is ResMc)
				{ //是子mc
					_center=ResMc(parent)._center;
					_centerToFoot=ResMc(parent)._centerToFoot;
					_offsetX=this.originX - ResMc(parent).originX;
					_offsetY=this.originY - ResMc(parent).originY;
					var mOffset:Object=modifySpecialOffset();
					_offsetX+=mOffset.x;
					_offsetY+=mOffset.y;
				}
				if (needTurn)
				{
					curBitmap.scaleX=-1;
					curBitmap.x=-_bitmapInfo.x - _offsetX + _center;
				}
				else
				{
					curBitmap.scaleX=1;
					curBitmap.x=_bitmapInfo.x + _offsetX - _center;
				}
				curBitmap.y=_bitmapInfo.y + _offsetY - _centerToFoot;
				curBitmap.x+=offSetPoint.x;
				curBitmap.y+=offSetPoint.y;
				if (isFixMiddle)
					curBitmap.y+=_centerToFoot >> 1;
				if (isMonster && mcName.length > 12) //针对于使用人物模型资源的怪物，此处坐标不更新
				{
					curBitmap.x-=_bitmapInfo.footX * curBitmap.scaleX;
					curBitmap.y-=_bitmapInfo.footY;
				}
				if (isResLoaded)
				{
//					curBitmap.bitmapData=_bitmapInfo.bitmapData;
					curBitmap.texture=_bitmapInfo.texture;
					curBitmap.readjustSize();
				}
				else
				{
//					curBitmap.bitmapData=null;
					curBitmap.y=-120;
				}
			}
			else
			{
//				curBitmap.bitmapData=null;
			}
			var child:ResMc;
			var i:int=0;
			for (i=0; i < 4; i++)
			{
				child=_mattrix[i];
				if (child)
				{
					if (i == 1)
					{
						if (_frameIndex > 165)
						{
							child._frameIndex=_frameIndex - 166;
						}
						else
						{
							if (act == "D1") //则判断主体是否为坐骑动作
							{
								this.gotoAndPlay("D10" + dir);
								break;
							}
							else if (act == "D5" || act == "D6")
							{
								this.gotoAndPlay("D11" + dir);
								break;
							}
//							child._frameIndex = _frameIndex;//附属部件动作帧与主模型动作统一
						}
					}
					else
						child._frameIndex=_frameIndex; //附属部件动作帧与主模型动作统一
					if (child._frameIndex > child._endIndex)
						child._frameIndex=child._beginIndex;
					child.setCurrentFrame();
				}
			}
			if (wing != null) //翅膀特殊处理
			{
				wing._frameIndex=_frameIndex;
				if (wing._frameIndex > wing._endIndex)
					wing._frameIndex=wing._beginIndex;
				wing.setCurrentFrame();
			}
			//合法校验
			invalidate();
		}

		private function invalidate():void
		{
			var index:int=0;
			var len:int=numChildren;
			var dis:ResMc;
			while (index < len)
			{
				dis=this.getChildAt(index) as ResMc;
				if (dis && dis.layer == 1) //此处只处理坐骑；修改(if (dis && _mattrix[dis.layer]==null) todo;
				{
					if (_mattrix[1] == null)
					{
						removeChild(dis);
						break;
					}
				}
				index++;
			}
		}
		private var m_nMain_10604001Offset:Array=[0, [-15, 0], [-10, -5], [-15, -15], [-20, -10], [-15, -10], [-10, -10], [-15, -10], [-5, -10]];

		private function modifySpecialOffset():Object
		{
			var obj:Object={x: 0, y: 0};
			if (mcName.indexOf("Main_10604001") != -1)
			{
				var d:int=int(dir.replace("F", ""));
				var pos:Array=m_nMain_10604001Offset[d];
				obj.x=-pos[0];
				obj.y=-pos[1];
			}
			return obj;
		}

		public function nextFrame():Boolean
		{
			if (!_undisposed_)
				return false;
			if (_isStopped)
				return false;
			if (++_frameIndex > _endIndex)
			{
				_frameIndex=_beginIndex;
				if (_playCount > 0)
				{
					_count++;
					if (_playCount == _count)
					{
						_count=0;
						_playCount=0;
						_isStopped=true;
						_frameIndex=_endIndex > 0 ? _endIndex - 1 : 0;
						if (_playOverAct != null)
						{
							_playOverAct();
							_playOverAct=null;
						}
						_isStopped=true;
						return false;
					}
				}
				else
				{ //循环播放的清空下，额外加入循环播放的帧索引
					_frameIndex+=loopFromFrame;
				}
			}
			else // 中间帧
			{
				if (m_nMidActionIndex != -1)
				{
					if (_frameIndex - _beginIndex == m_nMidActionIndex) //如果当前帧为中间动作处理帧索引，则执行对应回调函数
					{
						if (m_nMidActionHandler != null)
						{
							m_nMidActionHandler();
						}
					}
				}
			}
			setCurrentFrame();
			return true;
		}
		private var offSetPoint:Point=new Point();

		public function setContentXY(p1:int, p2:int):void
		{
			offSetPoint.x=p1;
			offSetPoint.y=p2;
		}
		public var isFixMiddle:Boolean=false;

		public function get originX():int
		{
			return _originX;
		}

		public function get originY():int
		{
			return _originY;
		}

		public function get currentBitmapInfo():BitmapInfo
		{
			if (!_undisposed_)
				return null;
			if (movie != null && _frameIndex < movie.length)
				return movie[_frameIndex];
			return null;
		}

		public function get currentTexture():Texture
		{
			if (!_undisposed_)
				return null;
//			if (curBitmap != null && curBitmap.bitmapData != null)
			if (curBitmap != null && curBitmap.texture != null)
				return curBitmap.texture
//				return curBitmap.bitmapData;
			return null;
		}

		public function get frames():int
		{
			return _endIndex - _beginIndex;
		}

		public function close():void
		{
			if (!_undisposed_)
				return;
			this._undisposed_=false;
			_isStopped=true;
			ResMcMgr.instance.stop(this);
			ResMcMgr.instance.release(this);
			if (this.parent)
				this.parent.removeChild(this);
			for each (var m:ResMc in _mattrix)
			{
				if (m == null)
					continue;
				m.close();
				m=null;
			}
//			if (_mattrix)
//				_mattrix.length=0;
			_mattrix=new Vector.<ResMc>(4);
			//清除默认资源
			if (this._wing != null)
			{
				this._wing.close();
				this._wing=null;
			}
			while (numChildren)
			{
				var tar:DisplayObject=removeChildAt(numChildren - 1);
				if (tar as ResMc)
					ResMc(tar).close();
				tar=null;
			}
//			this.curBitmap.bitmapData=null;
//			curBitmap.texture.dispose()
			this.curBitmap=null;
			for (var key:Object in _listers)
			{
				var obj:Object=_listers[key];
				if (obj.hasOwnProperty('type'))
					this.removeEventListener(obj.type, obj.listener);
				_listers.remove(key);
			}
			//this._listers = null;
			this.m_nMidActionIndex=-1;
			this.m_nMidActionHandler=null;
			this.offSetPoint.x=0;
			this.offSetPoint.y=0;
			this.mcName=null;
			this.frameName=null;
			this.act="D1";
			this.dir="F1";
			this.m_nResLoadedCache=new Dictionary();
			this.m_nCanEffectPlay=false;
			this.m_nActionTime=0;
			this._beginIndex=0;
			this._endIndex=0;
			this._frameIndex=0;
			this.m_nTick=0;
			this.m_loopFromFrame=0;
			this.m_nPlayTime=-1;
			this.isSpecial=false;
			this.isEffect=false;
			this.isMine=false;
			this.isMonster=false;
			this.isMove=false;
			this.isPick=false;
			this.isPart=false;
			this.needTurn=false;
			this.isNPC=false;
			this.isOther=false;
			this.isPlayer=false;
			this._count=0;
			this._jumpFrame=1;
			this._playCount=0;
			this._playOverAct=null;
			//ResMcPool.recycle(this);
		}

		/**
		 * 0,翅膀
		 * 1,坐骑
		 * 2,人(不用指定)
		 * 3,武器
		 * */
		public function mattrix(value:ResMc, layer:int):void
		{
			if (!_undisposed_)
				return;
			layerSet();
			var target:ResMc=_mattrix[layer];
			if (value != null) //此处为异常处理做准备条件
			{
				value.layer=layer;
			}
			if (value && (target ? value.mcName != target.mcName : true))
			{
				value.isPart=layer != 2; //根据资源部位不同进行归类(主体 or 部件)
				if (layer == 0)
				{
					wing=value;
					wing.name="wing";
				}
				else
				{
					ResMcMgr.instance.stop(value);
					var len:int=_mattrix.length;
					if (target)
					{
						if (target != value)
						{
							target.close();
						}
						target=null;
						_mattrix[layer]=null;
					}
					while (--len > -1)
					{
						if (_mattrix[len] != null)
							this.checkExistAndAdd(_mattrix[len], len);
					}
					_mattrix[layer]=value;
					this.checkExistAndAdd(value, layer);
					var rm:ResMc;
					if (layer == 1)
					{
						value.name="horse";
						if (act == "D1")
							act="D10";
						if (act == "D5")
							act="D11";
//						setTimeout(value.goto, 33, frameName);
					}
//					else if (layer == 2)
//					{
//						//兼容蛋疼的skin更新代码，下帧执行
////						setTimeout(gotoAndPlay, 33, act + dir);
//					}
//					else
//					{
////						setTimeout(value.goto, 33, frameName);
//					}
					this.gotoAndPlay(act + dir);
//					setTimeout(gotoAndPlay, 33, act + dir);
				}
			}
			else if (value == null)
			{
				if (layer == 1)
				{
					//兼容蛋疼的skin
					var child:DisplayObject;
					for (var i:int=this.numChildren - 1; i > -1; i--)
					{
						child=this.getChildAt(i);
						if (child.name.indexOf("horse") > -1)
						{
							ResMc(child).close();
						}
					}
					if (act == "D10")
						act="D1";
					if (act == "D11")
						act="D5";
//					setTimeout(gotoAndPlay, 33, act + dir);
				}
				else if (layer == 0)
					wing=value;
				if (_mattrix[layer] != null)
				{
					ResMc(_mattrix[layer]).close();
				}
				_mattrix[layer]=null;
			}
		}
		private var m_loopFromFrame:int=0; //默认从零开始

		/**
		 * 设置循环播放的帧索引
		 */
		public function get loopFromFrame():int
		{
			return m_loopFromFrame;
		}

		public function set loopFromFrame(value:int):void
		{
			this.m_loopFromFrame=value;
		}
		private var _isUseHitArea:Boolean=true;

		public function set isUseHitArea(value:Boolean):void
		{
			_isUseHitArea=value;
		}

		/**
		 * 取得玩家职业
		 * 以前是判断玩家是否是左右手
		 * 现在要按职业来
		 * 1 天斗 2 玄道 3 仙羽
		 * */
		public function get rightHand():int
		{
			return _rightHand;
		}

		/**
		 * 设置角色职业
		 * 以前是判断玩家是否是左右手
		 * 现在要按职业来
		 * 1 天斗 2 玄道 3 仙羽
		 * */
		public function set rightHand(value:int):void
		{
			if (!_undisposed_)
				return;
			_rightHand=value;
			layerSet();
		}

		public function get nTick():Number
		{
			var fps:int=Math.ceil((1000 * (frames + 1) / playTime));
			//更新帧速率
			this.m_nTick=fps / 30;
			return m_nTick;
		}
		private var m_nPlayTime:int=-1; //初始值为200毫秒

		public function get playTime():int
		{
			return m_nPlayTime;
		}

		/**
		 * 设置动画播放时间
		 */
		public function set playTime(value:int):void
		{
			this.m_nPlayTime=value;
		}

		/**
		 * 同步更新子movie的播放速度(时间)
		 */
		private function syncChildrenPlayTime():void
		{
			if (_mattrix == null)
				return;
			var len:int=_mattrix.length;
			var childMovie:ResMc=null;
			while (--len > -1)
			{
				childMovie=_mattrix[len];
				if (childMovie != null)
					childMovie.playTime=this.playTime;
			}
		}
		/**
		 * 是否是第一次循环
		 */
		private var m_isFirstLoop:Boolean=true;

		public function get isFirstLoop():Boolean
		{
			return m_isFirstLoop;
		}

		public function set isFirstLoop(value:Boolean):void
		{
			m_isFirstLoop=value;
		}

		public function set playCount(value:int):void
		{
			_playCount=value;
		}

		public function get playCount():int
		{
			return _playCount;
		}

		public function set playOverAct(value:Function):void
		{
			_playOverAct=value;
		}

		public function set midActionIndex(value:int):void
		{
			m_nMidActionIndex=value;
		}

		public function set midActionHandler(value:Function):void
		{
			m_nMidActionHandler=value;
		}

		public function get midActionHandler():Function
		{
			return m_nMidActionHandler;
		}

		public function get beginIndex():int
		{
			return _beginIndex;
		}
		private var _isOther:Boolean=false;

		public function get isOther():Boolean
		{
			return _isOther;
		}

		public function set isOther(value:Boolean):void
		{
			_isOther=value;
		}
		private var _isPick:Boolean=false;

		public function get isPick():Boolean
		{
			return _isPick;
		}

		public function set isPick(value:Boolean):void
		{
			_isPick=value;
		}
		private var _isPlayer:Boolean=false;

		public function get isPlayer():Boolean
		{
			return _isPlayer;
		}

		public function set isPlayer(value:Boolean):void
		{
			_isPlayer=value;
		}
		private var _isMine:Boolean=false;

		public function get isMine():Boolean
		{
			return _isMine;
		}

		public function set isMine(value:Boolean):void
		{
			_isMine=value;
		}
		private var _isMonster:Boolean=false;

		public function get isMonster():Boolean
		{
			return _isMonster;
		}

		public function set isMonster(value:Boolean):void
		{
			_isMonster=value;
		}
		private var _isNPC:Boolean=false;

		public function get isNPC():Boolean
		{
			return _isNPC;
		}

		public function set isNPC(value:Boolean):void
		{
			_isNPC=value;
		}
		private var m_nCanEffectPlay:Boolean=false;
		private var m_nIsEffect:Boolean;

		public function get isEffect():Boolean
		{
			return m_nIsEffect;
		}

		public function set isEffect(value:Boolean):void
		{
			m_nIsEffect=value;
		}
		private var _width:Number=0;

		override public function get width():Number
		{
			try
			{
//				if (currentBitmapInfo != null && currentBitmapInfo.bitmapData != null)
//					return currentBitmapInfo.bitmapData.width;
				if (currentBitmapInfo != null && currentBitmapInfo.texture != null)
					return currentBitmapInfo.texture.width;
			}
			catch (e:Error)
			{
			}
			return 50;
		}
		private var _height:Number=0;
		private static const speciHeight:Dictionary=new Dictionary();
		speciHeight["Main_31000037"]=0;
		speciHeight["Main_31000074"]=180;
		speciHeight["Main_31010002M"]=0;
		speciHeight["Main_31010002W"]=0;
		speciHeight["Main_31000031"]=151;
		speciHeight["Main_31000032"]=186;
		speciHeight["Main_31000033"]=200;
		speciHeight["Main_30700034"]=130;
		speciHeight["Main_30120010"]=214;
		speciHeight["Main_30120006"]=153;
		speciHeight["Main_31000037"]=223;
		speciHeight["Main_30301001"]=180; //变异猪王

		/**
		 * 取高度
		 * 当此返回值为0时，走付翔定的NPC高度规则
		 * 即每个职业有统一的高度
		 * */
		override public function get height():Number
		{
			if (speciHeight[mcName] == undefined)
			{
//				if(isPlayer)
//					return 0;
			}
			else if (speciHeight[mcName] > 0)
			{
				return speciHeight[mcName];
			}
//			if (currentBitmapInfo != null && currentBitmapInfo.bitmapData)
//			{
//				return currentBitmapInfo.bitmapData.height;
//			}
			if (currentBitmapInfo != null && currentBitmapInfo.texture)
			{
				return currentBitmapInfo.texture.height;
			}
			return 120;
		}
		private var _jumpFrame:int=1;

		public function get jumpFrame():int
		{
			return _jumpFrame;
		}

		public function set jumpFrame(value:int):void
		{
			_jumpFrame=value;
		}
		private var _wing:ResMc;

		public function set wing(value:ResMc):void
		{
			if (!_undisposed_)
				return;
			if (_wing != value)
			{
				if (_wing != null)
				{
					_wing.close();
					_wing=null;
				}
			}
			if (value != null)
			{
				value.isWing=true;
				_wing=value;
				addWing();
			}
		}

		private function addWing():void
		{
			if (!_undisposed_)
				return;
			layerSet();
//			this.checkExistAndAdd(wing, 0);
//			wing.gotoAndPlay(act + dir);
			setTimeout(gotoAndPlay, 33, act + dir);
//			setTimeout(wing.goto, 33, frameName);
		}

		public function get wing():ResMc
		{
			return _wing;
		}
		private var _isWing:Boolean=false;

		public function set isWing(value:Boolean):void
		{
			_isWing=value;
		}

		public function get isWing():Boolean
		{
			return _isWing;
		}

		public function get skillPoint():Vector.<int>
		{
			if (currentBitmapInfo && currentBitmapInfo.skillPoint)
				return currentBitmapInfo.skillPoint;
			return null;
		}

		private function checkExistAndAdd(disObj:DisplayObject, index:int):void
		{
			if (disObj != null)
			{
				if (disObj.parent != null && disObj.parent == this)
				{
					if (this.getChildIndex(disObj) != index)
					{
						if (this.numChildren > index)
							this.setChildIndex(disObj, index);
						else
							this.addChild(disObj);
					}
				}
				else
				{
					if (this.numChildren > index)
						this.addChildAt(disObj, index);
					else
						this.addChild(disObj);
				}
			}
		}

		/**
		 * 1 天斗 2 玄道 3 仙羽
		 * 文档地址:svn\trunk\策划案\J.角色系统\M.模型层级\模型层级 .docx
		 * */
		private function layerSet():void
		{
			if (!_undisposed_)
				return;
			switch (dir)
			{
				case "F1":
				case "F2":
				case "F3":
				case "F7":
				case "F8":
					this.checkExistAndAdd(_mattrix[1], 0);
					this.checkExistAndAdd(wing, 1);
					this.checkExistAndAdd(curBitmap, 2);
					this.checkExistAndAdd(_mattrix[3], 3);
					break;
				case "F4":
				case "F5":
				case "F6":
					this.checkExistAndAdd(_mattrix[1], 0);
					this.checkExistAndAdd(curBitmap, 1);
					this.checkExistAndAdd(_mattrix[3], 2);
					this.checkExistAndAdd(wing, 3);
					break;
			}
		}

	/**
	 * 验证当前位图对象是否被点击，精确到像素级判定，如果alpha值为0，则无效
	 * @return
	 *
	 */
//		public function checkMovieClick():Boolean
//		{
//			if (!_undisposed_)
//				return false;
//			if (stage == null)
//				return false;
////			var mouseX:int=stage.mouseX;
////			var mouseY:int=stage.mouseY;
//			var mouseX:int=stage.pivotX;
//			var mouseY:int=stage.pivotY;
//			var p:Point=new Point();
//			p.x=mouseX;
//			p.y=mouseY;
//			p=this.curBitmap.globalToLocal(p);
////			if (this.curBitmap.bitmapData.rect.containsPoint(p))
//			if (this.curBitmap.texture.frame.containsPoint(p))
//			{
//				var pixelValue:int=this.curBitmap.bitmapData.getPixel32(p.x, p.y);
//				var alphaValue:uint=pixelValue >> 24 & 0xFF;
//				return alphaValue > 0;
//			}
//			return false;
//		}
	}
}
