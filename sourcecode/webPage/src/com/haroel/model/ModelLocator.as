package com.haroel.model
{
	import com.haroel.util.Hash;
	
	public class ModelLocator 
	{
		private static var _instance:ModelLocator = null;
		
		private var _menuHash:Hash = null;
		private var rightMenuLabels:Array = [];
		
		public static var URL:String = "";
		public static var VERSION:String = "";
		public static var DEBUG_MODE:Boolean = false;
		
		public function ModelLocator(innerCls:InnerCls)
		{
			if (innerCls == null)
			{
				throw new Error("Singleton Class");
			}
		}

		public static function getInstance():ModelLocator
		{
			if(_instance == null)
			{
				_instance = new ModelLocator(new InnerCls());
				_instance.init();
			}
			return _instance;
		}

		public function getRightMenuLabels():Array
		{
			return rightMenuLabels;
		}
		
		public function getMenuItemInfos():Array
		{
			return _menuHash.getItems;
		}
		
		public function getMenuItemVOById(id:int):MenuItemVO
		{
			return _menuHash.getItem(id) as MenuItemVO;
		}
		
		private function init():void
		{
			_menuHash = new Hash()
		}
		
		public function parseXML(content:*):void
		{
			var configXML:XML=new XML(content);
			ModelLocator.URL = configXML.info.@url;
			ModelLocator.VERSION = configXML.info.@version;
			
			ModelLocator.DEBUG_MODE = configXML.info.@debug == "true";
			
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
			for each (var xml2:XML in configXML.rightmenu.item)
			{
				var obj:Object = new Object();
				obj.label = xml2.@label;
				obj.separatorBefore = (Boolean)(xml2.@separatorBefore== "true");
				obj.enabled = (Boolean)(xml2.@enabled == "true");
				rightMenuLabels.push(obj);
			}
			App.log.debug("gamesetting解析完成");

		}
	}
}
class InnerCls{}