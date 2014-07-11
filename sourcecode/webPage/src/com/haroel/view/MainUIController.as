package com.haroel.view
{
	import com.greensock.*;
	import com.haroel.ResManager;
	import com.haroel.events.DDEvent;
	import com.haroel.model.MenuItemVO;
	import com.haroel.model.ModelLocator;
	import com.haroel.util.Hash;
	import com.haroel.view.metro.UIMetroItem;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;

	public class MainUIController extends EventDispatcher
	{
		private var _root:Sprite;
		
		private var _material:MovieClip;

		private var _menuContainer:MovieClip;
		
		private var _popUpLayer:MovieClip;
		
		private var _menuItemHash:Hash = null;
		
		public function MainUIController(target:IEventDispatcher=null)
		{
			super(target);
		}
		public function setRoot(spt:Sprite):void
		{
			_root = spt;
		}
		public function initView():void
		{
			var cls:Class = ResManager.getResSwf("Webpage","MainUI");
			_material = new cls();
			_root.addChild(_material);
			
			_menuContainer = _material.m_mainContainer as MovieClip;
			_popUpLayer = _material.m_popUpLayer as MovieClip;
			
			createItems();
			
			_material.addEventListener(DDEvent.METRO_ITEM_CLICK,metroClickHandler);
		}
		
		public function createItems():void
		{
			if (_menuItemHash == null)
			{
				_menuItemHash = new Hash();
			}
			else
			{
				_menuItemHash.removeAllItems();
			}
			var arr:Array =  ModelLocator.getInstance().getMenuItemInfos();
			
			var gap:Number = 10;
			
			var startPoint:Point = new Point();
			startPoint.x = (Main.stageWidth - (210 *2 + gap * 3 + 100 *2)) /2;
			startPoint.y = (Main.stageHeight - 210) /2;

			for (var i:int = 0;i < arr.length;i++)
			{
				var info:MenuItemVO = arr[i];
				var item:UIMetroItem = new UIMetroItem();
				item.setInfo(info);
				
				item.playCreateAnimation(startPoint);
//				item.x = startPoint.x;
//				item.y = startPoint.y;
				
				_menuItemHash.addItem(info.id,item);
				
				if(i == 3)
				{
					startPoint.x = (Main.stageWidth - (210 *2 + gap * 3 + 100 *2)) /2;
					startPoint.y += (item.getMaterial().height + gap);
				}
				else
				{
					startPoint.x += (item.getMaterial().width + gap);
				}
				_menuContainer.addChild(item);
			}
		}
		
		private function metroClickHandler(evt:DDEvent):void
		{
			
		}
	}
}