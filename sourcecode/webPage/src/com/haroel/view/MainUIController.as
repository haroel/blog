package com.haroel.view
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.haroel.events.DDEvent;
	import com.haroel.events.UIEventDispatcher;
	import com.haroel.model.MenuItemVO;
	import com.haroel.model.ModelLocator;
	import com.haroel.util.Hash;
	import com.haroel.view.metro.UIMetroItem;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	public class MainUIController extends EventDispatcher
	{
		private var _root:Sprite;
				
		private var _material:MovieClip;

		private var _menuContainer:MovieClip;
				
		private var _animaterLayer:MovieClip;
						
		//metro items group
		private var _menuItemHash:Hash = new Hash();
		//dock bar items group
		private var _dockItemHash:Hash = new Hash();
		
		private var _popUpController:PopUpViewController;

		private static const HOME_ID:int = 0;
		
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
			UIEventDispatcher.getInstance().addEventListener(DDEvent.METRO_ITEM_CLICK,metroClickHandler);
			UIEventDispatcher.getInstance().addEventListener(DDEvent.METRO_ITEM_REMOVE,metroItemRemoveHandler);
			UIEventDispatcher.getInstance().addEventListener(DDEvent.DOCK_ITEM_CLICK,dockItemClickHandler);

			if (App.asset.hasClass(ResourceConfig.CLS_MAINUI))
			{
				var cls:Class =App.asset.getClass(ResourceConfig.CLS_MAINUI);
				_material = new cls();
				(MovieClip)(_material.m_bg).alpha = 0;
				
				TweenLite.to(_material.m_bg,0.6,{alpha:1.0});
				
				_root.addChild(_material);
				
				_menuContainer = _material.m_mainContainer as MovieClip;
				_animaterLayer = _material.m_animateLayer as MovieClip;
				
				_popUpController = new PopUpViewController(_material.m_popUpLayer as MovieClip);
				App.log.debug("主界面初始化完成");			
				createMetroItems();
			}
		}
		
		private function metroClickHandler(evt:DDEvent):void
		{
			//metro item 点击
			var id:int = evt.param as int;
			_popUpController.openPanel(id);
				
			createDockItems(id);
		}
		private function dockItemClickHandler(evt:DDEvent):void		
		{
			var iconItem:IconItemRenderer = evt.param as IconItemRenderer;
			var selectedId:int = iconItem.id;
			
			if (selectedId == HOME_ID)
			{
				backToDestop();
			}
			else
			{
				//打开对应的popup界面
				var arr:Array = this._dockItemHash.getItems;
				for each(var itemNode:IconItemRenderer in arr)
				{
					if (itemNode.id == selectedId)
					{
						itemNode.setState(IconItemRenderer.SELECTED);
					}
					else
					{
						itemNode.setState(IconItemRenderer.UNSELECTED);
					}
				}
			}
		}
		
		private function backToDestop():void
		{
			//获得Home并删除之
			var homeItem:IconItemRenderer = _dockItemHash.getItem(HOME_ID) as IconItemRenderer;
			if (homeItem != null)
			{
				TweenLite.to(homeItem,1,{y:Main.stageHeight * 1.5,alpha:0,onComplete:removeHomeItem});
				function removeHomeItem():void
				{
					_animaterLayer.removeChild(homeItem);
				}
				_dockItemHash.removeItem(HOME_ID);
			}
			//
			_popUpController.playMoveOut();
			
			//隐藏 dock 背景并让dockitem禁用点击
			TweenLite.to((MovieClip)(_material.m_dockBg), 1,{y:Main.stageHeight, motionBlur:true, ease:Cubic.easeInOut,onComplete:dockRemoveOverHandler});
			function dockRemoveOverHandler():void
			{
				createMetroItems();	
			}
			var arr:Array = _dockItemHash.getItems;			
			for (var i:int = 0;i < arr.length;i++)
			{
				var iconItemC:IconItemRenderer = arr[i] as IconItemRenderer; 
				iconItemC.setState(IconItemRenderer.NORMAL);
			}
		}
		public function createDockItems(id:int):void
		{
			App.log.debug("创建dock");
			_dockItemHash.removeAllItems();
			
			var duration:Number = 1.0;
			
			// Home Icon Button
			var homeIconItem:IconItemRenderer = new IconItemRenderer();
			homeIconItem.setInfo("BCalendar",HOME_ID);
			homeIconItem.y = Main.stageHeight * 1.5;
			homeIconItem.x = (MovieClip)(_material.m_dockBg).x;
			_animaterLayer.addChild(homeIconItem);
			_dockItemHash.addItem(homeIconItem.id,homeIconItem);

			//播放iconitem 运动效果 并删除之前的metroitem
			var arr:Array = _menuItemHash.getItems;
			for each (var metroItem:UIMetroItem in arr)
			{				
				var iconItem:IconItemRenderer = metroItem.getIconItem();
				var globalPoint:Point = iconItem.localToGlobal(new Point(0,0));
				var animatePoint:Point = _animaterLayer.globalToLocal(globalPoint);
				iconItem.x = animatePoint.x;
				iconItem.y = animatePoint.y;
				_animaterLayer.addChild(iconItem);
				
				_dockItemHash.addItem(iconItem.id,iconItem);
				metroItem.removeNode();
			}		
			//dock栏出现
			TweenLite.to((MovieClip)(_material.m_dockBg), duration,
				{y:Main.stageHeight - (MovieClip)(_material.m_dockBg).height, motionBlur:true, ease:Cubic.easeInOut,onComplete:dockPlayOverHandler});
			
			function dockPlayOverHandler():void
			{
				var intervalId:uint = setTimeout(popUpIn,duration * 1000)
				function popUpIn():void
				{
					_popUpController.playMoveIn();
					clearTimeout(intervalId);
				}
				var arr:Array = _dockItemHash.getItems;
				var gap:Number = 10;
				
				for (var i:int = 0;i < arr.length;i++)
				{
					var iconItemC:IconItemRenderer = arr[i] as IconItemRenderer; 
					if(id == iconItemC.id)
					{
						iconItemC.setState(IconItemRenderer.SELECTED);
					}
					else
					{
						iconItemC.setState(IconItemRenderer.UNSELECTED);
					}
					TweenLite.to(iconItemC,0.7,{x:135 + iconItemC.width/2 + i * (iconItemC.width + gap),
						y:Main.stageHeight - iconItemC.height/2 - 4});
				}
			}
		}
		
		public function createMetroItems():void
		{
			_menuItemHash.removeAllItems();
			_menuContainer.removeChildren();
			var arr:Array =  ModelLocator.getInstance().getMenuItemInfos();
			
			var gap:Number = 10;
			
			var startPoint:Point = new Point();
			startPoint.x = (Main.stageWidth - (210 *2 + gap * 3 + 100 *2)) /2;
			startPoint.y = (Main.stageHeight - 210) /2;
			
			App.log.debug("创建" + arr.length + "个 metroitem");
			
			for (var i:int = 0;i < arr.length;i++)
			{
				var info:MenuItemVO = arr[i];
				var item:UIMetroItem = new UIMetroItem();
				
				if (_dockItemHash.hasItem(info.id))
				{
					item.setInfo(info,true);
					item.playFadeInAnimation(startPoint);

					_menuContainer.addChild(item);

					var globalPoint:Point = (MovieClip)(item.getMaterial().m_iconMC).localToGlobal(new Point(0,0));
					var animatePoint:Point = _animaterLayer.globalToLocal(globalPoint);
					
					var iconItem:IconItemRenderer = _dockItemHash.getItem(info.id) as IconItemRenderer;
					TweenLite.to(iconItem,0.6,{delay:0.5,x:animatePoint.x,y:animatePoint.y,onComplete:completeHandler,onCompleteParams:[item,iconItem]});
					function completeHandler(value1:UIMetroItem,value2:IconItemRenderer):void
					{
						value1.addIconItem(value2);
					}
//					iconItem.x = animatePoint.x;
//					iconItem.y = animatePoint.y;					
				}
				else
				{
					item.setInfo(info,false);
					item.playCreateAnimation(startPoint);
					_menuContainer.addChild(item);
				}

				_menuItemHash.addItem(info.id,item);
				if(i == 3)
				{
					startPoint.x = (Main.stageWidth - (210 *2 + gap * 3 + 100 *2)) /2;
					startPoint.y += (item.MHeight + gap);
				}
				else
				{
					startPoint.x += (item.MWidth + gap);
				}
			}
			_dockItemHash.removeAllItems();
		}		
		private function metroItemRemoveHandler(evt:DDEvent):void
		{
			_menuItemHash.removeItem(evt.param as int);
		}
	}
}