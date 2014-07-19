package com.haroel.view
{
	import com.haroel.events.DDEvent;
	import com.haroel.events.UIEventDispatcher;
	import com.haroel.model.MenuItemVO;
	import com.haroel.model.ModelLocator;
	import com.haroel.util.Hash;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;

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
			panel.info = ModelLocator.getInstance().getMenuItemVOById(evt.param as int);
//			var m:MovieClip = panel.material;
//			var bitmapData:BitmapData = new BitmapData(m.width,m.height,true,0);
//			
//			var gobalPos:Point =  _popUpLayer.localToGlobal(new Point(panel.x,panel.y));
//
//			var rect:Rectangle = new Rectangle(gobalPos.x,gobalPos.y,m.width,m.height);
//			bitmapData.draw(MainUIController.MainUIMaterial,null,null,null,null);
//			
			//new MainUIController;
			this._popUpLayer.addChild(panel);
			
//			var bitmap:Bitmap = new Bitmap(bitmapData);
////			bitmap.x = 11;
//			bitmap.y = 40;
//			bitmap.alpha = 1;
//			_popUpLayer.addChild(bitmap);
		}
	}
}