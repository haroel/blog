package com.haroel.events
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class UIEventDispatcher extends EventDispatcher
	{
		public function UIEventDispatcher(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		static private var _instance:UIEventDispatcher = null;
		
		static public  function getInstance():UIEventDispatcher
		{
			if (_instance == null)
			{
				_instance = new UIEventDispatcher();
			}
			return _instance;
		}		
	}
}