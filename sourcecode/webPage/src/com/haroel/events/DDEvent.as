package com.haroel.events
{
	import flash.events.Event;
	
	public class DDEvent extends Event
	{
		private var _param:Object;
		
		public static const METRO_ITEM_CLICK = "METRO_ITEM_CLICK";
		
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