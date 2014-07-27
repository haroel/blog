package com.haroel.view
{
	import flash.display.Shape;
	import flash.events.Event;
	
	public class ResLoaderPointer extends Shape
	{
		public function ResLoaderPointer()
		{
			super();
//			this.addEventListener(Event.ADDED_TO_STAGE,init);
		}
		private function init(evt:Event):void
		{
			
		}
		public function setInfo(color:uint,radius:Number):void
		{
			this.graphics.clear();
			this.graphics.beginFill(color,1.0);
			this.graphics.drawCircle(0,0,radius);
			this.graphics.endFill();
		}
	}
}