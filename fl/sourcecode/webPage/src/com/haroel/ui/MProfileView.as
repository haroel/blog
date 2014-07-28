package com.haroel.ui
{
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	
	import morn.core.components.Image;
	import morn.core.components.LinkButton;
	import morn.core.components.View;
	import morn.core.handlers.Handler;
	
	public class MProfileView extends View
	{
		public var m_collBtn:LinkButton;
		public var m_avatar:Image;
		
		public function MProfileView()
		{
			super();
		}
		override protected function createChildren():void
		{			
			App.loader.loadTXT("uiXml/Profile.xml",new Handler(onComplete));
		}
		private function onComplete(content:String):void
		{
			var contentXml:XML = new XML(content);
			createView(contentXml);
			
			m_collBtn.addEventListener(MouseEvent.CLICK,clickHandler);
			this.m_avatar.url = "img/avtar.png";
		}
		private function clickHandler(evt:MouseEvent):void
		{
			var url:String = "http://www.wust.edu.cn";
			var request:URLRequest = new URLRequest(url);
			try
			{
				navigateToURL(request, '_blank');
			}
			catch(e:Error)
			{
				trace("Error occurred!");
			}
		}
		
		 override public function remove():void
		 {
			 m_collBtn.removeEventListener(MouseEvent.CLICK,clickHandler);
			 super.remove();
		 }
	}
}