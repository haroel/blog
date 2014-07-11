package com.haroel.view.metro
{
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.haroel.ResManager;
	import com.haroel.events.DDEvent;
	import com.haroel.model.MenuItemVO;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.text.TextField;

	public class UIMetroItem extends Sprite
	{
		private var _menuItemVO:MenuItemVO;
		
		private var _material:MovieClip;

		private var _labelPoint:Point = new Point();
		
		public function UIMetroItem()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,initHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE,removeHandler);
		}
		private function removeHandler(evt:Event):void
		{
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
					this.dispatchEvent(new DDEvent(DDEvent.METRO_ITEM_CLICK,_menuItemVO.id));
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
					TweenLite.to((TextField)(_material.m_label), 0.5, {y:_labelPoint.y - 6});
					break;
				}
			}
		}
		
		public function setInfo(value:MenuItemVO):void
		{
			_menuItemVO = value;
			
			var cls:Class = null;
			switch(_menuItemVO.style)
			{
				case 0:
				{
					cls = ResManager.getResSwf("Webpage","MetroItem");
					break;
				}
				case 1:
				{
					cls = ResManager.getResSwf("Webpage","MetroItemL");
					break;
				}
			}
			_material = new cls();
			this.addChild(_material);
			
			(TextField)(_material.m_label).text = _menuItemVO.label;
			
			var bitmapDataCls:Class = ResManager.getResSwf("Webpage",_menuItemVO.icon);
			var icon:Bitmap = new Bitmap(new bitmapDataCls(),"auto",true);
			icon.width = 64;
			icon.height = 64;
			(MovieClip)(_material.m_iconMC).addChild(icon);
			
			var colorTrans:ColorTransform  = (MovieClip)(_material.m_bg).transform.colorTransform;
			colorTrans.color = _menuItemVO.color;
			
			(MovieClip)(_material.m_bg).transform.colorTransform = colorTrans;
			_labelPoint.x = (TextField)(_material.m_label).x;
			_labelPoint.y = (TextField)(_material.m_label).y;

//			(TextField)(_material.m_label).
			_material.buttonMode = true;
			_material.mouseChildren = false;
//			_material.mouseEnabled = false;
		}
		
		public function getMaterial():MovieClip
		{
			return _material;
		}
		public function playCreateAnimation(p:Point):void
		{
			x = p.x;
			y = -300;
			
			TweenLite.to(this, 0.5, {delay:Math.random(),y:p.y});
		}
	}
}