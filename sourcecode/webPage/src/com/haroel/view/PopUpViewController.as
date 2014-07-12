package com.haroel.view
{
	import com.haroel.events.DDEvent;
	import com.haroel.events.UIEventDispatcher;
	import com.haroel.model.MenuItemVO;
	import com.haroel.util.Hash;
	
	import flash.display.Sprite;

	public class PopUpViewController
	{		
		private var _popUpLayer:Sprite;
		
		private var _viewHash:Hash = new Hash();
		
		public function PopUpViewController(parent:Sprite)
		{
			_popUpLayer = parent;
			init();
		}
		private function init():void
		{			
			UIEventDispatcher.getInstance().addEventListener(DDEvent.METRO_ITEM_CLICK,metroClickHandler);
		}
		private function metroClickHandler(evt:DDEvent):void
		{
			var panel:PopUpPanel = new PopUpPanel();
			panel.info = evt.param as MenuItemVO;
			this._popUpLayer.addChild(panel);
		}
	}
}