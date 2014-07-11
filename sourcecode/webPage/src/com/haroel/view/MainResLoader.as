package com.haroel.view
{
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class MainResLoader
	{
		private var _loader:MainLoader;
		private var _parent:Sprite;
		
		public function MainResLoader(container:Sprite)
		{
			super();
			_parent = container;
		}
		
		public function init():void
		{
			_loader = new MainLoader();
			_loader.x = (Main.stageWidth - _loader.width)/2;
			_loader.y = (Main.stageHeight - _loader.height)/2;
			_loader.progressBar.scaleX = 0;
			_loader.progressLabel.text = "0%";
			_parent.addChild(_loader);
		}
		public function setProgress(value:int):void
		{
			_loader.progressLabel.text = value.toString() + "%";
			_loader.progressBar.scaleX = 1.0 * value/100;
		}

		public function get mainLoader():MainLoader
		{
			return _loader;
		}
		public function cleanLoader():void
		{
			TweenMax.to(_loader, 0.4, {alpha:0.1, ease:Bounce.easeInOut, onComplete:removeNode});
		}
		private function removeNode():void
		{
			_parent.dispatchEvent(new Event("MainResLoader_remove"));
			while (_parent.numChildren > 0)
			{
				_parent.removeChildAt(0);
			}
			
		}
	}
}