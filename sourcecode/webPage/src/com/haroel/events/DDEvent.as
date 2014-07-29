package com.haroel.events
{
	import flash.events.Event;
	
	public class DDEvent extends Event
	{
		private var _param:Object;
		
		public static const METRO_ITEM_CLICK:String = "METRO_ITEM_CLICK";
		public static const METRO_ITEM_REMOVE:String = "METRO_ITEM_REMOVE";

		public static const DOCK_ITEM_CLICK:String = "DOCK_ITEM_CLICK";

		
		public static const POPUPVIEW_REMOVE:String = "popup_view_remove";

		public static const MAIN_LOADER_REMOVE:String = "MAIN_LOADER_REMOVE";

		public static const RESMANAGER_START:String = "RESMANAGER_START";
		public static const RESMANAGER_PROGRESS:String = "RESMANAGER_PROGRESS";
		public static const RESMANAGER_COMPLETE:String = "RESMANAGER_COMPLETE";
		public static const RESMANAGER_ERROR:String = "RESMANAGER_ERROR";

		public function DDEvent(type:String, param:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_param = param;
		}
		override public function clone():Event
		{
			return new DDEvent(this.type,_param);
		}
		public function get param():Object
		{
			return _param;
		}
	}
}