package com.haroel.ui
{
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import morn.core.components.Image;
	import morn.core.components.LinkButton;
	import morn.core.components.View;
	import morn.core.events.UIEvent;
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
			m_avatar.visible = false;
			m_collBtn.addEventListener(MouseEvent.CLICK,clickHandler);
			m_avatar.addEventListener(UIEvent.IMAGE_LOADED,imgLoadedHandler);
			
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
		private function imgLoadedHandler(evt:UIEvent):void
		{
			if (m_avatar.bitmapData)
			{
				m_avatar.height = m_avatar.bitmapData.height * m_avatar.width/m_avatar.bitmapData.width;
				m_avatar.visible = true;
			}
		}
		 override public function remove():void
		 {
			 m_collBtn.removeEventListener(MouseEvent.CLICK,clickHandler);
			 m_avatar.removeEventListener(UIEvent.IMAGE_LOADED,imgLoadedHandler);
			 super.remove();
		 }
	}
}