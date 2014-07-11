package com.haroel.model
{
	import com.haroel.util.Hash;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class ModelLocator  extends EventDispatcher
	{
		public static var URL:String = "";
		public static var VERSION:String = "";
		
		public function ModelLocator(innerCls:InnerCls)
		{
			if (innerCls == null)
			{
				throw new Error("Singleton Class");
			}
		}
		private static var _instance:ModelLocator;
		public static function getInstance():ModelLocator
		{
			
			if(_instance == null)
			{
				_instance = new ModelLocator(new InnerCls());
				_instance.init();
			}
			return _instance;
		}

		private var _menuHash:Hash = new Hash();
		public function getMenuItemInfos():Array
		{
			return _menuHash.getItems;
		}
		
		private function init():void
		{
			var loader:URLLoader =new URLLoader();
			loader.addEventListener(Event.COMPLETE,completeHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS,httpHandler);
			loader.load(new URLRequest("gameSetting.xml"));
		}	
		private function completeHandler(e:Event):void
		{
			var loader:URLLoader=e.target as URLLoader;
			loader.removeEventListener(Event.COMPLETE,completeHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS,httpHandler);

			var configXML:XML=new XML(loader.data);
			
			ModelLocator.URL = configXML.info.@url;
			ModelLocator.VERSION = configXML.info.@version;
			for each (var xml:XML in configXML.menus.item)
			{
				var itemVO:MenuItemVO = new MenuItemVO();
				itemVO.id = xml.@id;
				itemVO.icon = xml.@icon;
				itemVO.label = xml.@label;
				itemVO.style = xml.@style;
				itemVO.color = xml.@color;
				_menuHash.addItem(itemVO.id,itemVO);
			}
			
			loader = null;
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		private function ioErrorHandler(evt:IOErrorEvent):void
		{
			trace("error");
		}
		private function httpHandler(evt:HTTPStatusEvent):void
		{
		}
	}
}
class InnerCls{}