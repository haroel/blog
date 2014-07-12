package com.haroel.view
{
	import com.haroel.ResManager;
	import com.haroel.model.MenuItemVO;
	import com.haroel.model.ResourceConfig;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class PopUpPanel extends Sprite
	{
		private var _material:MovieClip;
		
		public function PopUpPanel()
		{
			super();
			init();
		}
		private function init():void
		{
			var cls:Class = ResManager.getResSwf(ResourceConfig.RES_FILE_NAME,"MPanel");
			_material = new cls();
			_material.x = (Main.stageWidth - _material.width)/2;
			_material.y = (Main.stageHeight - _material.height)/2;
			
			(SimpleButton)(_material.m_closeBtn).addEventListener(MouseEvent.CLICK,closePanel);
			this.addChild(_material);
		}
		public function set info(value:MenuItemVO):void
		{
//			new TextField;
			(TextField)(_material.m_label).text = value.label;
			
		}
		
		private function closePanel(evt:MouseEvent):void
		{
			(SimpleButton)(_material.m_closeBtn).removeEventListener(MouseEvent.CLICK,closePanel);

			this.parent.removeChild(this);
		}
	}
}