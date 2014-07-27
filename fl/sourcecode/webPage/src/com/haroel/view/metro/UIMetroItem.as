package com.haroel.view.metro
{
	import com.greensock.TweenLite;
	import com.haroel.events.DDEvent;
	import com.haroel.events.UIEventDispatcher;
	import com.haroel.model.MenuItemVO;
	import com.haroel.view.IconItemRenderer;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import morn.core.handlers.Handler;

	public class UIMetroItem extends Sprite
	{
		private var _menuItemVO:MenuItemVO;
		
		private var _material:MovieClip;

		private var _iconItem:IconItemRenderer = null;
		
		private var _labelPoint:Point = new Point();
		
		private var _mWidth:Number = 100;
		
		private var _mHeight:Number = 100;
		
		public function UIMetroItem()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,initHandler);
		}
		private function removeHandler(evt:Event):void
		{
			UIEventDispatcher.getInstance().dispatchEvent(new DDEvent(DDEvent.METRO_ITEM_REMOVE,_menuItemVO.id));
			
			_material.removeEventListener(MouseEvent.CLICK,mouseHandler);
			_material.removeEventListener(MouseEvent.MOUSE_DOWN,mouseHandler);
			_material.removeEventListener(MouseEvent.MOUSE_UP,mouseHandler);
			_material.removeEventListener(MouseEvent.ROLL_OUT,mouseHandler);
			_material.removeEventListener(MouseEvent.ROLL_OVER,mouseHandler);
			
			this.removeEventListener(Event.ADDED_TO_STAGE, initHandler);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, removeHandler);

		}
		private function initHandler(evt:Event):void
		{
			if (this.hasEventListener(Event.ADDED_TO_STAGE))
			{
				this.removeEventListener(Event.ADDED_TO_STAGE, initHandler);
			}
			this.addEventListener(Event.REMOVED_FROM_STAGE,removeHandler);

			_material.addEventListener(MouseEvent.CLICK,mouseHandler);

			_material.addEventListener(MouseEvent.MOUSE_DOWN,mouseHandler);
			_material.addEventListener(MouseEvent.MOUSE_UP,mouseHandler);

			_material.addEventListener(MouseEvent.ROLL_OUT,mouseHandler);
			_material.addEventListener(MouseEvent.ROLL_OVER,mouseHandler);
		}
		private function mouseHandler(evt:MouseEvent):void
		{
			switch(evt.type)
			{
				case MouseEvent.CLICK:
				{
					var arr:Array = TweenLite.getTweensOf(this);
					if (arr.length < 1)
					{
						UIEventDispatcher.getInstance().dispatchEvent(new DDEvent(DDEvent.METRO_ITEM_CLICK,_menuItemVO.id));
					}
					break;
				}
				case MouseEvent.MOUSE_DOWN:
				{
					
					break;
				}
				case MouseEvent.MOUSE_UP:
				{
					
					break;
				}
				case MouseEvent.ROLL_OUT:
				{
					TweenLite.to((TextField)(_material.m_label), 0.5, {y:_labelPoint.y});
					break;
				}
				case MouseEvent.ROLL_OVER:
				{
					TweenLite.to((TextField)(_material.m_label), 0.5, {y:_labelPoint.y - 8});
					break;
				}
			}
		}
		
		public function setInfo(value:MenuItemVO,hasIcon:Boolean = false):void
		{
			_menuItemVO = value;
			
			var cls:Class = null;
			switch(_menuItemVO.style)
			{
				case 0:
				{
					cls = App.asset.getClass(ResourceConfig.CLS_METRO_ITEM);
					break;
				}
				case 1:
				{
					cls = App.asset.getClass(ResourceConfig.CLS_METRO_ITEML);
					break;
				}
			}
			_material = new cls();
			this.addChild(_material);
			_mWidth = _material.width;
			_mHeight = _material.height;
			
			(TextField)(_material.m_label).text = _menuItemVO.label;

			var colorTrans:ColorTransform  = (MovieClip)(_material.m_bg).transform.colorTransform;
			colorTrans.color = _menuItemVO.color;
			
			(MovieClip)(_material.m_bg).transform.colorTransform = colorTrans;
			_labelPoint.x = (TextField)(_material.m_label).x;
			_labelPoint.y = (TextField)(_material.m_label).y;
			
			if (!hasIcon)
			{
				_iconItem = new IconItemRenderer();
				_iconItem.setInfo(_menuItemVO.icon,_menuItemVO.id);
				(MovieClip)(_material.m_iconMC).addChild(_iconItem);
			}
			else
			{
				_iconItem = null;
			}
			_material.buttonMode = true;
			_material.mouseChildren = false;
//			_material.mouseEnabled = false;
		}
		public function removeNode():void
		{
			TweenLite.to(this,0.2,{alpha:0.3,onComplete:playComplete,onCompleteParams:[this]});
			function playComplete(value:Sprite):void
			{
				value.parent.removeChild(value);
			}
		}

		public function getIconItem():IconItemRenderer
		{
			return _iconItem;
		}
		public function getMaterial():MovieClip
		{
			return _material;
		}
		public function get menuItemInfo():MenuItemVO
		{
			return this._menuItemVO;
		}
		public function get MWidth():Number
		{
			return _mWidth;
		}
		public function get MHeight():Number
		{
			return _mHeight;
		}
		public function addIconItem(iconItem:IconItemRenderer):void
		{
			_iconItem = iconItem;
			_iconItem.x = 0;
			_iconItem.y = 0;
			(MovieClip)(_material.m_iconMC).addChild(_iconItem);
		}
		
		public function playCreateAnimation(p:Point):void
		{
			x = p.x;
			y = -300;
			
			TweenLite.to(this, 0.5, {delay:Math.random() * 0.8,y:p.y});
		}
		public function playFadeInAnimation(p:Point):void
		{
			trace("playFadeInAnimation x:" + p.x +"***y:"+ p.y);
			x = p.x;
			y = p.y;
			this.alpha = 0;
			TweenLite.to(this, 0.5, {delay: 0.1,alpha:1});
		}
	}
}