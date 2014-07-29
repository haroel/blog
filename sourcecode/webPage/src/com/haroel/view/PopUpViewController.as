package com.haroel.view
{
	import com.haroel.events.DDEvent;
	import com.haroel.events.UIEventDispatcher;
	import com.haroel.model.ModelLocator;
	
	import flash.display.Sprite;

	public class PopUpViewController
	{		
		
		private var _popUpLayer:Sprite;
		private var _panel:PopUpPanel = null;
		
		public function PopUpViewController(parent:Sprite)
		{
			_popUpLayer = parent;
			
			init();
		}
		public function openPanel(value:int):void
		{
			if (_panel == null)
			{
				_panel	= new PopUpPanel();
				this._popUpLayer.addChild(_panel.material);
			}
			_panel.info = ModelLocator.getInstance().getMenuItemVOById(value);
		}
		public function playMoveIn():void
		{
			if(_panel != null)
			{
				_panel.playMoveInAction();
			}
		}
		public function playMoveOut():void
		{
			if(_panel != null)
			{
				_panel.playMoveOutAction();
			}
		}
		private function init():void
		{			
//			new DDEvent
			UIEventDispatcher.getInstance().addEventListener(DDEvent.POPUPVIEW_REMOVE,popUpRemoveHandler);
		}
		private function popUpRemoveHandler(evt:DDEvent):void
		{
			_panel = null;
		}
	}
}