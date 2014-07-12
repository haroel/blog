package com.haroel.view
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Bounce;
	import com.haroel.events.DDEvent;
	
	import flash.events.Event;
	
	public class MainResLoader extends MainLoader
	{
		private static const MAINRESLOADER:String = "MainResLoader";
		
		public function MainResLoader()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
		public function init(evt:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,init);
			this.name = MAINRESLOADER;
			
			this.progressBar.width = 0;
			this.progressLabel.text = "0%";
		}
		public function setProgress(value:int):void
		{
			progressLabel.text = value.toString() + "%";
			progressBar.scaleX = 1.0 * value/100;
		}

		public function removeLoader():void
		{
			TweenMax.to(this, 0.3, {alpha:0.1, ease:Bounce.easeInOut, onComplete:removeNode});
		}
		private function removeNode():void
		{
			parent.dispatchEvent(new DDEvent(DDEvent.MAIN_LOADER_REMOVE,null));
			parent.removeChild(this);
		}
	}
}