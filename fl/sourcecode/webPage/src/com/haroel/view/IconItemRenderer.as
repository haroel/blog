package com.haroel.view
{
	import com.greensock.TweenLite;
	import com.haroel.events.DDEvent;
	import com.haroel.events.UIEventDispatcher;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextField;
	
	public class IconItemRenderer extends Sprite
	{
		private var _material:MovieClip = null;
		
		public static const NORMAL:int = 0;
		
		public static const SELECTED:int = 1;

		public static const UNSELECTED:int = 2;
		
		private var _state:int = NORMAL;
		
		private var _id:uint = 0;
		private var _icon:String = "";
		
		public function IconItemRenderer()
		{
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
		private function init(evt:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,init);
			
			var cls:Class = App.asset.getClass(ResourceConfig.CLS_BOTTOM_BTN_NODE);
			_material = new cls();
			
			var bitmapDataCls:Class = App.asset.getClass(_icon);
			var _iconBitmap:Bitmap = new Bitmap(new bitmapDataCls(),"auto",true);
			_iconBitmap.width = 64;
			_iconBitmap.height = 64;
			_iconBitmap.x = (_material.width - _iconBitmap.width)/2;
			_iconBitmap.name = "icon";
			(MovieClip)(_material.m_iconMC).addChild(_iconBitmap);
			
			this.addChild(_material);
			
			this.width = _material.width;
			this.height = _material.height;
			
			this.setState(_state,true);
		}
		public function setInfo(icon:String,id:uint):void
		{
			_icon = icon;
			_id = id;
		}
		
		public function setState(value:uint,isforce:Boolean = false):void
		{
			if (_material == null)
			{
				_state = value;
				return;
			}
			if (_state == value && isforce == false)
			{
				return;
			}
			_state = value;
			
			switch (_state)
			{
				case NORMAL:
				{
//					this.removeReflection();
					TweenLite.to((MovieClip)(_material.m_inditor), 0.3, {alpha:0});

//					(MovieClip)(_material.m_inditor).visible = false;					
					_material.removeEventListener(MouseEvent.CLICK,mouseHandler);
					_material.removeEventListener(MouseEvent.ROLL_OUT,mouseHandler);
					_material.removeEventListener(MouseEvent.ROLL_OVER,mouseHandler);
					break;
				}
				case SELECTED:
				{

//					var bitmapDataCls:Class = App.asset.getClass(_icon);
//					var _iconBitmap:Bitmap = (MovieClip)(_material.m_iconMC).getChildByName("icon") as Bitmap;
//					this.addReflection(_iconBitmap.bitmapData,
//									   (MovieClip)(_material.m_iconMC),
//									   new Point(_iconBitmap.x,_iconBitmap.y + _iconBitmap.height));
//					
					TweenLite.to((MovieClip)(_material.m_inditor), 0.3, {alpha:1});
//					(MovieClip)(_material.m_inditor).visible = true;
					_material.removeEventListener(MouseEvent.CLICK,mouseHandler);
					_material.addEventListener(MouseEvent.ROLL_OUT,mouseHandler);
					_material.addEventListener(MouseEvent.ROLL_OVER,mouseHandler);

					break;
				}
				case UNSELECTED:
				{
//					this.removeReflection();
//					(MovieClip)(_material.m_inditor).visible = false;
					TweenLite.to((MovieClip)(_material.m_inditor), 0.3, {alpha:0});

					_material.addEventListener(MouseEvent.CLICK,mouseHandler);
					_material.addEventListener(MouseEvent.ROLL_OUT,mouseHandler);
					_material.addEventListener(MouseEvent.ROLL_OVER,mouseHandler);
					break;
				}
				default:
				{
					this.setState(NORMAL);
					break;
				}
			}
			
		}
		private function removeReflection():void
		{
			var displayObject:DisplayObject = (MovieClip)(_material.m_iconMC).getChildByName("ref");
			if (displayObject)
			{
				(MovieClip)(_material.m_iconMC).removeChild(displayObject);
			}
		}
		
		private function addReflection(picSource:BitmapData,parent:DisplayObjectContainer,postion:Point):void
		{
			// 倒置
			var bd:BitmapData = new BitmapData(picSource.width, picSource.height, true, 0x12346f);
			var mtx:Matrix = new Matrix();
			mtx.d = -1;
			mtx.ty = bd.height;
			bd.draw(picSource, mtx);
			// 添加渐变遮罩
			var width:int = bd.width;
			var height:int = bd.height;
			mtx = new Matrix();
			mtx.createGradientBox(width, height, 0.5 * Math.PI);
			var shape:Shape = new Shape();
//			new GradientType;
			shape.graphics.beginGradientFill(GradientType.LINEAR, [0, 0], [0.9, 0.2], [0, 0xFF], mtx);
			shape.graphics.drawRect(0, 0, width, height);
			shape.graphics.endFill();
			var mask_bd:BitmapData = new BitmapData(width, height, true, 0);
			mask_bd.draw(shape);
			// 生成最终效果
//			new Point;
			bd.copyPixels(bd, bd.rect, new Point(0, 0), mask_bd, new Point(0, 0), false);
			// 将倒影放置于图片下方
			var ref:Bitmap = new Bitmap();
			ref.bitmapData = bd;
			ref.x = postion.x;
			ref.y = postion.y;
			ref.name = "ref";
			parent.addChild(ref);
		}
		
		public function get id():int
		{
			return _id;
		}
		private function mouseHandler(evt:MouseEvent):void
		{
			switch(evt.type)
			{
				case MouseEvent.CLICK:
				{
					var arr:Array = TweenLite.getTweensOf(_material);
					if (arr.length < 1)
					{
						UIEventDispatcher.getInstance().dispatchEvent(new DDEvent(DDEvent.DOCK_ITEM_CLICK,this));
					}
					break;
				}
				case MouseEvent.ROLL_OUT:
				{
					TweenLite.to(_material, 0.1, {scaleX:1,scaleY:1});
					break;
				}
				case MouseEvent.ROLL_OVER:
				{
					TweenLite.to(_material, 0.1, {scaleX:1.05,scaleY:1.05});
					break;
				}
			}
		}
	}
}